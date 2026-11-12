import uuid
import os
import re
import json
import math
import struct
import shutil
import zipfile
import urllib.request
import subprocess
from pathlib import Path
from typing import Dict, Any, List
from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

app = FastAPI(title="Hardware Forge")
app.mount("/static", StaticFiles(directory="/app/static"), name="static")

GENERATORS_DIR = Path("/generators")
OUTPUT_DIR = Path("/output")
LIBRARY_DIR = Path("/library/Hardware_Forge")
PRESETS_FILE = OUTPUT_DIR / "saved_presets.json"

OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

SCAD_ENV = os.environ.copy()
SCAD_ENV["OPENSCADPATH"] = "/usr/share/openscad/libraries:/usr/share/openscad-nightly/libraries:/root/.local/share/OpenSCAD/libraries"
SCAD_BIN = "openscad-nightly" if shutil.which("openscad-nightly") else "openscad"

class RenderRequest(BaseModel):
    generator: str
    params: Dict[str, Any]
    custom_name: str = ""

class KitItem(BaseModel):
    generator: str
    params: Dict[str, Any]
    qty: int = 1
    label: str = ""

class KitRequest(BaseModel):
    items: List[KitItem]
    spacing: float = 4.0
    kit_name: str = "Hardware_Kit"

class MoonrakerRequest(BaseModel):
    printer_ip: str = "192.168.86.134"
    mode: str = "single" # "single" or "kit"
    filename: str = "Hardware_Forge_Part.stl"

class PresetSaveRequest(BaseModel):
    name: str
    preset_type: str # "part" or "kit"
    generator: str = ""
    params: Dict[str, Any] = {}
    items: List[Dict[str, Any]] = []

def parse_scad_parameters(filepath: Path):
    params = []
    current_group = "Parameters"
    pending_comments = []

    group_re = re.compile(r'^\s*/\*\s*\[(.*?)\]\s*\*/')
    comment_re = re.compile(r'^\s*//\s*(.*)$')
    var_re = re.compile(r'^\s*([a-zA-Z0-9_]+)\s*=\s*([^;]+);\s*(?://\s*(.*))?$')

    with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            stripped = line.strip()
            if not stripped:
                continue

            g_match = group_re.match(line)
            if g_match:
                grp = g_match.group(1).strip()
                current_group = "Hidden" if grp.lower() in ["hidden", "global"] else grp
                pending_comments = []
                continue

            if current_group == "Hidden":
                continue

            c_match = comment_re.match(line)
            if c_match:
                pending_comments.append(c_match.group(1).strip())
                continue

            v_match = var_re.match(line)
            if v_match:
                name, raw_val, inline_comment = v_match.groups()
                if name.startswith("$"):
                    pending_comments = []
                    continue

                raw_val = raw_val.strip()
                full_comment = " ".join(pending_comments + ([inline_comment.strip()] if inline_comment else [])).strip()
                pending_comments = []

                if raw_val.startswith('"') and raw_val.endswith('"'):
                    val_type = "string"
                    default = raw_val.strip('"')
                elif raw_val.lower() in ["true", "false"]:
                    val_type = "bool"
                    default = raw_val.lower() == "true"
                else:
                    try:
                        default = float(raw_val) if "." in raw_val else int(raw_val)
                        val_type = "number"
                    except ValueError:
                        continue

                show_if = None
                show_match = re.search(r'@show_if\((.*?)\)', full_comment)
                if show_match:
                    show_if = {}
                    for cond in show_match.group(1).split(","):
                        if "=" in cond:
                            k, v = cond.split("=", 1)
                            show_if[k.strip()] = [x.strip() for x in v.split("|")]
                    full_comment = re.sub(r'@show_if\(.*?\)', '', full_comment).strip()

                bracket_match = re.search(r'\[(.*?)\]', full_comment)
                desc = re.sub(r'\[.*?\]', '', full_comment).strip(" -:")
                label = desc if desc else name.replace("_", " ").title()

                control = {
                    "name": name,
                    "label": label,
                    "group": current_group,
                    "type": val_type,
                    "default": default,
                    "ui": "input",
                    "show_if": show_if
                }

                if val_type == "bool":
                    control["ui"] = "select"
                    control["options"] = [
                        {"value": "true", "label": "Yes (Enabled)"},
                        {"value": "false", "label": "No (Disabled)"}
                    ]
                elif bracket_match:
                    inner = bracket_match.group(1).strip()
                    if "," in inner:
                        control["ui"] = "select"
                        options = []
                        for item in inner.split(","):
                            item = item.strip().strip('"').strip("'")
                            if ":" in item:
                                val_part, lbl_part = item.split(":", 1)
                                v_clean = val_part.strip().strip('"').strip("'")
                                if val_type == "number":
                                    try:
                                        v_clean = float(v_clean) if "." in v_clean else int(v_clean)
                                    except ValueError:
                                        pass
                                options.append({"value": v_clean, "label": lbl_part.strip()})
                            else:
                                v_clean = item
                                if val_type == "number":
                                    try:
                                        v_clean = float(v_clean) if "." in v_clean else int(v_clean)
                                    except ValueError:
                                        pass
                                options.append({"value": v_clean, "label": str(v_clean)})
                        control["options"] = options
                    elif ":" in inner and val_type == "number":
                        parts = [float(p) if "." in p else int(p) for p in inner.split(":")]
                        control["ui"] = "slider"
                        if len(parts) == 2:
                            control["min"], control["max"] = parts[0], parts[1]
                            control["step"] = 1 if isinstance(default, int) else 0.1
                        elif len(parts) == 3:
                            control["min"], control["step"], control["max"] = parts[0], parts[1], parts[2]

                params.append(control)
            else:
                pending_comments = []
    return params

def run_openscad_to_file(generator_name: str, params: Dict[str, Any], out_stl: Path):
    scad_path = GENERATORS_DIR / generator_name
    if not scad_path.exists():
        raise HTTPException(status_code=404, detail=f"Generator {generator_name} not found")
    if out_stl.exists():
        out_stl.unlink()

    cmd = [SCAD_BIN, "-o", str(out_stl)]
    help_out = subprocess.run([SCAD_BIN, "--help"], capture_output=True, text=True, env=SCAD_ENV).stdout
    if "Manifold" in help_out or "--backend" in help_out:
        cmd.extend(["--backend=Manifold", "--export-format=binstl"])

    for k, v in params.items():
        if isinstance(v, bool):
            cmd.extend(["-D", f"{k}={'true' if v else 'false'}"])
        elif isinstance(v, (int, float)):
            cmd.extend(["-D", f"{k}={v}"])
        else:
            escaped = str(v).replace('"', '\\"')
            cmd.extend(["-D", f'{k}="{escaped}"'])

    cmd.append(str(scad_path))
    proc = subprocess.run(cmd, capture_output=True, text=True, env=SCAD_ENV)
    if proc.returncode != 0 or not out_stl.exists():
        raise HTTPException(status_code=500, detail=f"OpenSCAD Error:\n{proc.stderr}")
    return proc

def read_stl_triangles(stl_path: Path):
    data = stl_path.read_bytes()
    triangles = []
    if len(data) >= 84:
        tri_count = struct.unpack("<I", data[80:84])[0]
        if 84 + (tri_count * 50) == len(data):
            offset = 84
            for _ in range(tri_count):
                vals = struct.unpack("<12fH", data[offset:offset+50])
                n = vals[0:3]
                v1, v2, v3 = vals[3:6], vals[6:9], vals[9:12]
                triangles.append((n, [list(v1), list(v2), list(v3)]))
                offset += 50
            return triangles

    text = data.decode("utf-8", errors="ignore")
    curr_n = (0.0, 0.0, 0.0)
    curr_v = []
    for line in text.splitlines():
        parts = line.strip().split()
        if not parts:
            continue
        if parts[0] == "facet" and len(parts) >= 5:
            curr_n = (float(parts[2]), float(parts[3]), float(parts[4]))
            curr_v = []
        elif parts[0] == "vertex" and len(parts) >= 4:
            curr_v.append([float(parts[1]), float(parts[2]), float(parts[3])])
            if len(curr_v) == 3:
                triangles.append((curr_n, curr_v))
    return triangles

def get_bounds_and_normalize(triangles):
    if not triangles:
        return [], 0, 0, 0
    min_x = min_y = min_z = float("inf")
    max_x = max_y = max_z = float("-inf")
    for _, verts in triangles:
        for vx, vy, vz in verts:
            if vx < min_x: min_x = vx
            if vx > max_x: max_x = vx
            if vy < min_y: min_y = vy
            if vy > max_y: max_y = vy
            if vz < min_z: min_z = vz
            if vz > max_z: max_z = vz

    cx = (min_x + max_x) / 2.0
    cy = (min_y + max_y) / 2.0
    norm_tris = []
    for n, verts in triangles:
        new_v = [[vx - cx, vy - cy, vz - min_z] for vx, vy, vz in verts]
        norm_tris.append((n, new_v))

    return norm_tris, (max_x - min_x), (max_y - min_y), (max_z - min_z)

def write_binary_stl(out_path: Path, triangles):
    with open(out_path, "wb") as f:
        header = b"Hardware Forge Combined Kit STL".ljust(80, b"\x00")
        f.write(header)
        f.write(struct.pack("<I", len(triangles)))
        for n, verts in triangles:
            v1, v2, v3 = verts
            f.write(struct.pack("<12fH",
                n[0], n[1], n[2],
                v1[0], v1[1], v1[2],
                v2[0], v2[1], v2[2],
                v3[0], v3[1], v3[2],
                0
            ))

# Native Multi-Object .3MF Archive Generator (Each Kit Part Remains Separate & Selectable in OrcaSlicer!)
def write_multi_object_3mf(out_3mf_path: Path, placed_objects):
    content_types = """<?xml version="1.0" encoding="UTF-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/>
</Types>"""
    rels = """<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Target="/3D/3dmodel.model" Id="rel0" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/>
</Relationships>"""

    resources_xml = []
    build_xml = []

    for obj_id, obj in enumerate(placed_objects, start=1):
        v_map = {}
        v_list = []
        t_list = []
        for _, verts in obj["tris"]:
            idxs = []
            for vx, vy, vz in verts:
                key = (round(vx, 4), round(vy, 4), round(vz, 4))
                if key not in v_map:
                    v_map[key] = len(v_list)
                    v_list.append(key)
                idxs.append(v_map[key])
            t_list.append(idxs)

        v_str = "\n".join(f'          <vertex x="{x}" y="{y}" z="{z}"/>' for x, y, z in v_list)
        t_str = "\n".join(f'          <triangle v1="{a}" v2="{b}" v3="{c}"/>' for a, b, c in t_list)
        safe_name = re.sub(r'[^a-zA-Z0-9_\-]', '_', obj["name"])
        resources_xml.append(f"""    <object id="{obj_id}" name="{safe_name}" type="model">
      <mesh>
        <vertices>
{v_str}
        </vertices>
        <triangles>
{t_str}
        </triangles>
      </mesh>
    </object>""")
        build_xml.append(f'    <item objectid="{obj_id}" transform="1 0 0 0 1 0 0 0 1 {obj["tx"]:.3f} {obj["ty"]:.3f} 0"/>')

    model_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<model unit="millimeter" xml:lang="en-US" xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02">
  <resources>
{chr(10).join(resources_xml)}
  </resources>
  <build>
{chr(10).join(build_xml)}
  </build>
</model>"""

    with zipfile.ZipFile(out_3mf_path, "w", zipfile.ZIP_DEFLATED) as zf:
        zf.writestr("[Content_Types].xml", content_types)
        zf.writestr("_rels/.rels", rels)
        zf.writestr("3D/3dmodel.model", model_xml)

def pack_kit_meshes(items: List[KitItem], spacing: float):
    instances = []
    individual_files = []

    for idx, item in enumerate(items):
        tmp_stl = OUTPUT_DIR / f"kit_item_{idx}.stl"
        run_openscad_to_file(item.generator, item.params, tmp_stl)
        raw_tris = read_stl_triangles(tmp_stl)
        norm_tris, sx, sy, sz = get_bounds_and_normalize(raw_tris)

        clean_fname = build_filename(item.generator, item.params, item.label)
        individual_files.append((clean_fname, tmp_stl, max(1, item.qty)))

        for q_i in range(max(1, item.qty)):
            instances.append({
                "name": f"{Path(clean_fname).stem}_{q_i+1}",
                "tris": norm_tris,
                "w": sx,
                "d": sy,
                "h": sz
            })

    instances.sort(key=lambda x: max(x["w"], x["d"]), reverse=True)
    total_area = sum((inst["w"] + spacing) * (inst["d"] + spacing) for inst in instances)
    target_row_width = max(
        max((inst["w"] for inst in instances), default=40.0),
        math.sqrt(total_area) * 1.15
    )

    placed_tris = []
    placed_objects_3mf = []
    curr_x = 0.0
    curr_y = 0.0
    row_depth = 0.0

    for inst in instances:
        w, d = inst["w"], inst["d"]
        if curr_x > 0 and (curr_x + w) > target_row_width:
            curr_x = 0.0
            curr_y += row_depth + spacing
            row_depth = 0.0

        px = curr_x + (w / 2.0)
        py = curr_y + (d / 2.0)

        for n, verts in inst["tris"]:
            shifted = [[vx + px, vy + py, vz] for vx, vy, vz in verts]
            placed_tris.append((n, shifted))

        placed_objects_3mf.append({
            "name": inst["name"],
            "tris": inst["tris"],
            "tx": px,
            "ty": py
        })

        curr_x += w + spacing
        if d > row_depth:
            row_depth = d

    final_tris, plate_x, plate_y, plate_z = get_bounds_and_normalize(placed_tris)
    kit_stl_path = OUTPUT_DIR / "kit_preview.stl"
    write_binary_stl(kit_stl_path, final_tris)

    kit_3mf_path = OUTPUT_DIR / "kit_multi_object.3mf"
    write_multi_object_3mf(kit_3mf_path, placed_objects_3mf)

    zip_path = OUTPUT_DIR / "kit_bundle.zip"
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
        zf.write(kit_3mf_path, arcname="00_Multi_Object_Build_Plate_Kit.3mf")
        zf.write(kit_stl_path, arcname="00_Combined_Build_Plate_Kit.stl")
        for fname, fpath, qty in individual_files:
            stem = Path(fname).stem
            arc = f"{stem}_x{qty}.stl" if qty > 1 else fname
            zf.write(fpath, arcname=arc)

    return kit_stl_path, kit_3mf_path, zip_path, len(instances), (plate_x, plate_y, plate_z)

@app.get("/", response_class=HTMLResponse)
def index():
    with open("/app/templates/index.html", "r", encoding="utf-8") as f:
        return f.read()

@app.get("/api/generators")
def list_generators():
    if not GENERATORS_DIR.exists():
        return []
    files = sorted(GENERATORS_DIR.glob("*.scad"))
    result = []
    for f in files:
        try:
            clean_title = re.sub(r'^\d+_', '', f.stem).replace("_", " ").title()
            result.append({
                "filename": f.name,
                "title": clean_title,
                "parameters": parse_scad_parameters(f)
            })
        except Exception as e:
            print(f"Error parsing {f.name}: {e}")
    return result

def build_filename(gen_name: str, params: Dict[str, Any], custom_name: str = "") -> str:
    if custom_name.strip():
        safe = re.sub(r'[^a-zA-Z0-9_\-\.]', '_', custom_name.strip())
        return safe if safe.endswith(".stl") else f"{safe}.stl"
    base = re.sub(r'^\d+_', '', Path(gen_name).stem)
    summary_parts = [base]
    for k, v in list(params.items())[:4]:
        clean_v = str(v).replace("/", "-").replace(" ", "")
        summary_parts.append(f"{clean_v}")
    safe_summary = re.sub(r'[^a-zA-Z0-9_\-\.]', '_', "_".join(summary_parts))
    return f"{safe_summary}.stl"

@app.post("/api/render")
def render_model(req: RenderRequest):
    out_stl = OUTPUT_DIR / "preview.stl"
    proc = run_openscad_to_file(req.generator, req.params, out_stl)

    specs = []
    for line in (proc.stderr + "\n" + proc.stdout).splitlines():
        m = re.search(r'ECHO:\s*"\[SPEC\]\s*(.*?)"', line)
        if m:
            specs.append(m.group(1))

    suggested_name = build_filename(req.generator, req.params, req.custom_name)
    return {
        "status": "ok",
        "preview_url": f"/api/preview.stl?t={os.path.getmtime(out_stl)}",
        "suggested_filename": suggested_name,
        "specs": "  |  ".join(specs),
        "logs": proc.stderr
    }

@app.get("/api/preview.stl")
def get_preview_stl(download_name: str = ""):
    out_stl = OUTPUT_DIR / "preview.stl"
    if not out_stl.exists():
        raise HTTPException(status_code=404, detail="No model rendered yet")
    if download_name:
        return FileResponse(out_stl, media_type="application/octet-stream", filename=download_name)
    return FileResponse(out_stl, media_type="application/octet-stream")

@app.post("/api/save_to_library")
def save_to_library(req: RenderRequest):
    out_stl = OUTPUT_DIR / "preview.stl"
    if not out_stl.exists():
        raise HTTPException(status_code=400, detail="Render a model first before saving.")
    
    filename = build_filename(req.generator, req.params, req.custom_name)
    try:
        category = re.sub(r'^\d+_', '', Path(req.generator).stem).replace("_", " ").title()
        target_dir = LIBRARY_DIR / category
        target_dir.mkdir(parents=True, exist_ok=True)
        dest = target_dir / filename
        shutil.copy2(out_stl, dest)
        return {"status": "saved", "path": f"/media/lucas/NewPlex/3d Prints/Hardware_Forge/{category}/{filename}"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/render_kit")
def render_kit(req: KitRequest):
    if not req.items:
        raise HTTPException(status_code=400, detail="Kit cart is empty")
    kit_stl, _, _, total_parts, dims = pack_kit_meshes(req.items, req.spacing)
    safe_name = re.sub(r'[^a-zA-Z0-9_\-]', '_', req.kit_name.strip() or "Hardware_Kit") + ".stl"
    return {
        "status": "ok",
        "preview_url": f"/api/kit_preview.stl?t={os.path.getmtime(kit_stl)}",
        "suggested_filename": safe_name,
        "total_parts": total_parts,
        "specs": f"Combined Build Plate Kit: {total_parts} Total Parts ({len(req.items)} Unique Types)  |  Footprint: {dims[0]:.1f} × {dims[1]:.1f} × {dims[2]:.1f} mm"
    }

@app.get("/api/kit_preview.stl")
def get_kit_preview_stl(download_name: str = ""):
    kit_stl = OUTPUT_DIR / "kit_preview.stl"
    if not kit_stl.exists():
        raise HTTPException(status_code=404, detail="No kit rendered yet")
    if download_name:
        return FileResponse(kit_stl, media_type="application/octet-stream", filename=download_name)
    return FileResponse(kit_stl, media_type="application/octet-stream")

@app.get("/api/kit_multi_object.3mf")
def get_kit_3mf(download_name: str = "Hardware_Kit.3mf"):
    kit_3mf = OUTPUT_DIR / "kit_multi_object.3mf"
    if not kit_3mf.exists():
        raise HTTPException(status_code=404, detail="Render the kit first")
    return FileResponse(kit_3mf, media_type="application/vnd.ms-package.3dmanufacturing-3dmodel+xml", filename=download_name)

@app.get("/api/kit_bundle.zip")
def get_kit_zip(download_name: str = "Hardware_Kit_Pack.zip"):
    zip_path = OUTPUT_DIR / "kit_bundle.zip"
    if not zip_path.exists():
        raise HTTPException(status_code=404, detail="Render the kit first")
    return FileResponse(zip_path, media_type="application/zip", filename=download_name)

@app.post("/api/save_kit_to_library")
def save_kit_to_library(req: KitRequest):
    kit_stl, kit_3mf, zip_path, total_parts, _ = pack_kit_meshes(req.items, req.spacing)
    base_name = re.sub(r'[^a-zA-Z0-9_\-]', '_', req.kit_name.strip() or "Hardware_Kit")
    try:
        target_dir = LIBRARY_DIR / "Kits"
        target_dir.mkdir(parents=True, exist_ok=True)
        stl_dest = target_dir / f"{base_name}_{total_parts}pcs.stl"
        threemf_dest = target_dir / f"{base_name}_{total_parts}pcs.3mf"
        zip_dest = target_dir / f"{base_name}_{total_parts}pcs_Pack.zip"
        shutil.copy2(kit_stl, stl_dest)
        shutil.copy2(kit_3mf, threemf_dest)
        shutil.copy2(zip_path, zip_dest)
        return {
            "status": "saved",
            "path": f"/media/lucas/NewPlex/3d Prints/Hardware_Forge/Kits/{threemf_dest.name} (+ .STL & .ZIP)"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Saved Part & Kit Presets API
@app.get("/api/presets")
def get_presets():
    if not PRESETS_FILE.exists():
        return []
    try:
        return json.loads(PRESETS_FILE.read_text(encoding="utf-8"))
    except Exception:
        return []

@app.post("/api/presets")
def save_preset(req: PresetSaveRequest):
    presets = get_presets()
    presets = [p for p in presets if p.get("name") != req.name]
    presets.append(req.dict())
    PRESETS_FILE.write_text(json.dumps(presets, indent=2), encoding="utf-8")
    return {"status": "saved", "presets": presets}

@app.delete("/api/presets/{preset_name}")
def delete_preset(preset_name: str):
    presets = [p for p in get_presets() if p.get("name") != preset_name]
    PRESETS_FILE.write_text(json.dumps(presets, indent=2), encoding="utf-8")
    return {"status": "deleted", "presets": presets}

# Direct Push to Klipper / Moonraker (FlashForge Creator 5 Pro @ 192.168.86.134)
@app.post("/api/send_to_moonraker")
def send_to_moonraker(req: MoonrakerRequest):
    src_file = (OUTPUT_DIR / "kit_multi_object.3mf") if req.mode == "kit" else (OUTPUT_DIR / "preview.stl")
    if not src_file.exists():
        raise HTTPException(status_code=400, detail="Render the model or kit first before sending.")

    boundary = "----HardwareForgeBoundary7MA4YWxkTrZu0gW"
    file_bytes = src_file.read_bytes()
    fname = re.sub(r'[^a-zA-Z0-9_\-\.]', '_', req.filename)

    body = (
        f"--{boundary}\r\n"
        f'Content-Disposition: form-data; name="root"\r\n\r\ngcodes\r\n'
        f"--{boundary}\r\n"
        f'Content-Disposition: form-data; name="file"; filename="{fname}"\r\n'
        f"Content-Type: application/octet-stream\r\n\r\n"
    ).encode("utf-8") + file_bytes + f"\r\n--{boundary}--\r\n".encode("utf-8")

    url = f"http://{req.printer_ip.strip()}/server/files/upload"
    http_req = urllib.request.Request(url, data=body, method="POST")
    http_req.add_header("Content-Type", f"multipart/form-data; boundary={boundary}")
    try:
        with urllib.request.urlopen(http_req, timeout=8) as resp:
            return {"status": "uploaded", "printer": req.printer_ip, "filename": fname}
    except urllib.error.HTTPError as he:
        err_body = he.read().decode("utf-8", errors="ignore")
        raise HTTPException(
            status_code=502,
            detail=f"Printer rejected {fname} (HTTP {he.code}). Note: Klipper/Moonraker only accepts sliced .gcode files, not raw .stl/.3mf meshes! Slice in OrcaSlicer first. ({err_body[:120]})"
        )
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Connection to {req.printer_ip} failed: {e}")


@app.get("/api/export/single/{filename}")
def export_single_clean(filename: str):
    out_stl = OUTPUT_DIR / "preview.stl"
    if not out_stl.exists():
        raise HTTPException(status_code=404, detail="No model rendered yet")
    safe_name = re.sub(r'[^a-zA-Z0-9_\-\.]', '_', filename)
    return FileResponse(
        out_stl,
        media_type="application/octet-stream",
        filename=safe_name,
        headers={"Content-Disposition": f'attachment; filename="{safe_name}"'}
    )

@app.get("/api/export/kit/{filename}")
def export_kit_clean(filename: str):
    safe_name = re.sub(r'[^a-zA-Z0-9_\-\.]', '_', filename)
    if safe_name.lower().endswith(".3mf"):
        target = OUTPUT_DIR / "kit_multi_object.3mf"
    elif safe_name.lower().endswith(".zip"):
        target = OUTPUT_DIR / "kit_bundle.zip"
    else:
        target = OUTPUT_DIR / "kit_preview.stl"
    if not target.exists():
        raise HTTPException(status_code=404, detail="Render kit first")
    return FileResponse(
        target,
        media_type="application/octet-stream",
        filename=safe_name,
        headers={"Content-Disposition": f'attachment; filename="{safe_name}"'}
    )


import struct, zipfile, xml.etree.ElementTree as ET

def parse_binary_or_ascii_stl(stl_path):
    """Returns (vertices_list, triangles_list) from an OpenSCAD STL file."""
    with open(stl_path, "rb") as f:
        data = f.read()
    verts = []
    tris = []
    v_map = {}
    def get_vid(pt):
        key = (round(pt[0], 4), round(pt[1], 4), round(pt[2], 4))
        if key not in v_map:
            v_map[key] = len(verts)
            verts.append(key)
        return v_map[key]

    # Check if ASCII STL
    if data[:5] == b"solid" and b"facet" in data[:500]:
        text = data.decode("utf-8", errors="ignore")
        cur_tri = []
        for line in text.splitlines():
            line = line.strip()
            if line.startswith("vertex "):
                parts = line.split()
                pt = (float(parts[1]), float(parts[2]), float(parts[3]))
                cur_tri.append(get_vid(pt))
                if len(cur_tri) == 3:
                    tris.append((cur_tri[0], cur_tri[1], cur_tri[2]))
                    cur_tri = []
    else:
        num_tris = struct.unpack("<I", data[80:84])[0]
        offset = 84
        for _ in range(num_tris):
            if offset + 50 > len(data):
                break
            vals = struct.unpack("<12fH", data[offset:offset+50])
            v1 = get_vid((vals[3], vals[4], vals[5]))
            v2 = get_vid((vals[6], vals[7], vals[8]))
            v3 = get_vid((vals[9], vals[10], vals[11]))
            tris.append((v1, v2, v3))
            offset += 50
    return verts, tris

@app.post("/api/export_multicolor_3mf")
async def export_multicolor_3mf(req: dict):
    """Compiles 1_Box_Body, 2_Lid_Frame, and 3_Lid_Text into a single grouped 3-Object .3MF file for OrcaSlicer!"""
    gen_name = req.get("generator", "06_boxes_organizers.scad")
    params = dict(req.get("params", {}))
    colors = req.get("colors", {"box": "#1e293b", "frame": "#f59e0b", "text": "#38bdf8"})
    open_in_orca = req.get("open_in_orca", False)

    scad_path = os.path.join(GENERATORS_DIR, gen_name)
    ts = int(time.time() * 1000)
    r_main = params.get("render_part", "both")
    if r_main in ("inlay_text_only", "inlay_frame_only"):
        r_main = "both"
    parts_to_build = [
        ("1_Box_And_Lid_Body", r_main, colors.get("box", "#1e293b")),
    ]
    if params.get("lid_label_mode") == "multicolor_inlay" and params.get("render_part") != "base":
        if params.get("lid_frame_style", "rounded_box") != "none":
            parts_to_build.append(("2_Lid_Border_Frame", "inlay_frame_only", colors.get("frame", "#f59e0b")))
        if str(params.get("lid_text_line1", "")).strip() or str(params.get("lid_text_line2", "")).strip():
            parts_to_build.append(("3_Lid_Wording_Text", "inlay_text_only", colors.get("text", "#38bdf8")))

    mesh_objects = []
    for idx, (obj_label, r_mode, hex_col) in enumerate(parts_to_build, start=1):
        sub_p = dict(params)
        sub_p["render_part"] = r_mode
        if idx == 1 and sub_p.get("lid_label_mode") == "multicolor_inlay":
            sub_p["lid_label_mode"] = "debossed"
        stl_tmp = os.path.join(OUTPUT_DIR, f"tmp_{ts}_{idx}.stl")
        cmd = ["openscad", "-o", stl_tmp]
        for k, v in sub_p.items():
            if isinstance(v, bool):
                cmd += ["-D", f"{k}={'true' if v else 'false'}"]
            elif isinstance(v, (int, float)):
                cmd += ["-D", f"{k}={v}"]
            else:
                esc = str(v).replace('"', '\"')
                cmd += ["-D", f'{k}="{esc}"']
        cmd.append(scad_path)
        subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if os.path.exists(stl_tmp):
            v_list, t_list = parse_binary_or_ascii_stl(stl_tmp)
            os.remove(stl_tmp)
            if v_list and t_list:
                mesh_objects.append((idx, obj_label, hex_col, v_list, t_list))

    out_3mf_name = f"hardware_forge_multicolor_{ts}.3mf"
    out_3mf_path = os.path.join(OUTPUT_DIR, out_3mf_name)

    # Build 3MF XML model with a single Assembly Object containing 3 pre-aligned sub-objects (so OrcaSlicer keeps them locked in place AND grouped by color!)
    model_xml = ['<?xml version="1.0" encoding="UTF-8"?>']
    model_xml.append('<model unit="millimeter" xml:lang="en-US" xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02" xmlns:BambuStudio="http://schemas.bambulab.com/package/2021">')
    model_xml.append('  <resources>')

    comp_refs = []
    for oid, olabel, hcol, v_list, t_list in mesh_objects:
        model_xml.append(f'    <object id="{oid}" name="{olabel}" type="model">')
        model_xml.append('      <mesh>')
        model_xml.append('        <vertices>')
        for vx, vy, vz in v_list:
            model_xml.append(f'          <vertex x="{vx}" y="{vy}" z="{vz}" />')
        model_xml.append('        </vertices>')
        model_xml.append('        <triangles>')
        for v1, v2, v3 in t_list:
            model_xml.append(f'          <triangle v1="{v1}" v2="{v2}" v3="{v3}" />')
        model_xml.append('        </triangles>')
        model_xml.append('      </mesh>')
        model_xml.append('    </object>')
        comp_refs.append((oid, olabel))

    # Parent assembly object (ID 99) so OrcaSlicer loads all 3 parts as a single aligned multi-part object!
    model_xml.append('    <object id="99" name="Hardware_Forge_MultiColor_Box" type="model">')
    model_xml.append('      <components>')
    for oid, _ in comp_refs:
        model_xml.append(f'        <component objectid="{oid}" transform="1 0 0 0 1 0 0 0 1 0 0 0" />')
    model_xml.append('      </components>')
    model_xml.append('    </object>')
    model_xml.append('  </resources>')
    model_xml.append('  <build>')
    model_xml.append('    <item objectid="99" />')
    model_xml.append('  </build>')
    model_xml.append('</model>')

    rels_xml = """<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Target="/3D/3dmodel.model" Id="rel0" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel" />
</Relationships>"""

    ctypes_xml = """<?xml version="1.0" encoding="UTF-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml" />
  <Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml" />
</Types>"""

    # Also include Bambu/OrcaSlicer model_settings.config so each part's name & extruder slot (1, 2, 3) is pre-assigned in Orca's Objects list!
    settings_xml = ['<?xml version="1.0" encoding="UTF-8"?>', '<config>', '  <object id="99">', '    <metadata key="name" value="Hardware_Forge_MultiColor_Box"/>']
    for oid, olabel in comp_refs:
        ext_num = 1 if oid == 1 else 2
        settings_xml.append(f'    <part id="{oid}" subtype="normal_part">')
        settings_xml.append(f'      <metadata key="name" value="{olabel}"/>')
        settings_xml.append(f'      <metadata key="extruder" value="{ext_num}"/>')
        settings_xml.append('    </part>')
    settings_xml.append('  </object>')
    settings_xml.append('</config>')

    with zipfile.ZipFile(out_3mf_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        zf.writestr("[Content_Types].xml", ctypes_xml)
        zf.writestr("_rels/.rels", rels_xml)
        zf.writestr("3D/3dmodel.model", "\n".join(model_xml))
        zf.writestr("Metadata/model_settings.config", "\n".join(settings_xml))

    return {"url": f"/output/{out_3mf_name}", "filename": out_3mf_name}

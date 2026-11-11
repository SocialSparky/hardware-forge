import os
import re
import math
import struct
import shutil
import zipfile
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

# Pure Python Binary/ASCII STL Reader + 2D Auto-Platter Packer (Zero extra dependencies!)
def read_stl_triangles(stl_path: Path):
    data = stl_path.read_bytes()
    triangles = []
    # Check if binary STL (80-byte header + 4-byte uint32 count + 50 bytes per triangle)
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

    # Fallback ASCII STL parser
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
    """Centers mesh on X/Y=0 and puts bottom flush on Z=0. Returns (normalized_tris, size_x, size_y, size_z)."""
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

def pack_kit_meshes(items: List[KitItem], spacing: float):
    """Renders each unique cart item, duplicates by qty, packs on 2D build plate, and writes kit_preview.stl & kit.zip."""
    instances = []
    individual_files = []

    for idx, item in enumerate(items):
        tmp_stl = OUTPUT_DIR / f"kit_item_{idx}.stl"
        run_openscad_to_file(item.generator, item.params, tmp_stl)
        raw_tris = read_stl_triangles(tmp_stl)
        norm_tris, sx, sy, sz = get_bounds_and_normalize(raw_tris)

        clean_fname = build_filename(item.generator, item.params, item.label)
        individual_files.append((clean_fname, tmp_stl, max(1, item.qty)))

        for _ in range(max(1, item.qty)):
            instances.append({
                "tris": norm_tris,
                "w": sx,
                "d": sy,
                "h": sz,
                "area": sx * sy
            })

    # Sort largest footprint to smallest for clean shelf packing
    instances.sort(key=lambda x: max(x["w"], x["d"]), reverse=True)

    total_area = sum((inst["w"] + spacing) * (inst["d"] + spacing) for inst in instances)
    target_row_width = max(
        max((inst["w"] for inst in instances), default=40.0),
        math.sqrt(total_area) * 1.15
    )

    placed_tris = []
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

        curr_x += w + spacing
        if d > row_depth:
            row_depth = d

    # Re-center entire packed build plate around (0,0,0)
    final_tris, plate_x, plate_y, plate_z = get_bounds_and_normalize(placed_tris)
    kit_stl_path = OUTPUT_DIR / "kit_preview.stl"
    write_binary_stl(kit_stl_path, final_tris)

    # Also build a ZIP containing individual STLs + the combined plate STL
    zip_path = OUTPUT_DIR / "kit_bundle.zip"
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
        zf.write(kit_stl_path, arcname="00_Combined_Build_Plate_Kit.stl")
        for fname, fpath, qty in individual_files:
            stem = Path(fname).stem
            arc = f"{stem}_x{qty}.stl" if qty > 1 else fname
            zf.write(fpath, arcname=arc)

    return kit_stl_path, zip_path, len(instances), (plate_x, plate_y, plate_z)

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
        return FileResponse(out_stl, media_type="application/sla", filename=download_name)
    return FileResponse(out_stl, media_type="application/sla")

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
    kit_stl, _, total_parts, dims = pack_kit_meshes(req.items, req.spacing)
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
        return FileResponse(kit_stl, media_type="application/sla", filename=download_name)
    return FileResponse(kit_stl, media_type="application/sla")

@app.get("/api/kit_bundle.zip")
def get_kit_zip(download_name: str = "Hardware_Kit_Pack.zip"):
    zip_path = OUTPUT_DIR / "kit_bundle.zip"
    if not zip_path.exists():
        raise HTTPException(status_code=404, detail="Render the kit first")
    return FileResponse(zip_path, media_type="application/zip", filename=download_name)

@app.post("/api/save_kit_to_library")
def save_kit_to_library(req: KitRequest):
    kit_stl, zip_path, total_parts, _ = pack_kit_meshes(req.items, req.spacing)
    base_name = re.sub(r'[^a-zA-Z0-9_\-]', '_', req.kit_name.strip() or "Hardware_Kit")
    try:
        target_dir = LIBRARY_DIR / "Kits"
        target_dir.mkdir(parents=True, exist_ok=True)
        stl_dest = target_dir / f"{base_name}_{total_parts}pcs.stl"
        zip_dest = target_dir / f"{base_name}_{total_parts}pcs_Pack.zip"
        shutil.copy2(kit_stl, stl_dest)
        shutil.copy2(zip_path, zip_dest)
        return {
            "status": "saved",
            "path": f"/media/lucas/NewPlex/3d Prints/Hardware_Forge/Kits/{stl_dest.name} (+ ZIP Pack)"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

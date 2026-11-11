# ⚙️ Hardware Forge

A 100% offline, self-hosted Docker web application for generating parametric 3D-printable mechanical hardware, fasteners, gears, bearings, standoffs, installation tools, storage organizers, clamps, brackets, knobs, enclosures, shop gauges, and gaskets.

## 🚀 Key Platform Features
- **Zero Cloud Dependencies:** Bundles headless `openscad-nightly` (with multi-core `Manifold` engine), the **BOSL2** library, FastAPI, and local `Three.js` WebGL preview.
- **12 Parametric Hardware Categories:**
  1. `01_fasteners.scad` — Metric & Imperial bolts, hex/jam/thick nuts, washers, threaded rods, positive-stop flush-nut shoulder bolts, and horizontal D-cut high-strength mode.
  2. `02_gears.scad` — Spur, helical, herringbone, internal ring gears, and linear racks.
  3. `03_bearings.scad` — Print-in-place captive ball bearings, roller bearings, and flanged sleeve bushings.
  4. `04_spacers_standoffs.scad` — Round/hex unthreaded spacers, female threaded standoffs, and male-female hex standoffs.
  5. `05_install_tools.scad` — Stamped combination wrenches, adjustable spanners, 1/4" hex insert bits, fluted screwdrivers, T-handles, L-keys, and nut drivers.
  6. `06_boxes_organizers.scad` — Snap-hinge utility cases, modular multi-drawer cabinets, parts organizer trays, and fluted gift boxes.
  7. `07_clamps_mounts.scad` — Round & square/rectangular tube worm/band clamps, C-clamps, 2-hole saddle straps, split-ear P-clips, split pillow blocks, and snap-in conduit clips.
  8. `08_brackets_joinery.scad` — Ribbed L-brackets, flat L/T joining plates (with squared, filleted, or triangled 90° corners), 3-way box corners, and 2020/4040 extrusion gussets.
  9. `09_knobs_handles.scad` — Star clamping knobs, knurled thumbwheels, wing nuts, and U-pull equipment handles.
  10. `10_enclosures_plates.scad` — Vented electronics project boxes (with PCB standoffs & cable glands) and 35mm DIN-rail snap clips.
  11. `11_gauges_jigs.scad` — 5-slot printer tolerance calibration matrix, Metric/SAE bolt & nut gauge card, and 90° V-block center-drilling jig.
  12. `12_gaskets_seals.scad` — Bolt-circle flange gaskets, rectangular enclosure seals, O-rings, NEMA electrical box gaskets, and panel knockout grommets.
- **Interactive 2D Visual Schematic Designers:** Drag-and-slide 2D layout canvases for variable box/drawer cubbies, structural brackets, and electronics enclosures.
- **Build Plate Kit Cart & Multi-Object `.3MF` Export:** Queue multiple parts and quantities onto an auto-arranged build plate and export as a **Multi-Object `.3MF`** (keeping every part individually selectable in OrcaSlicer), combined `.STL`, or `.ZIP` bundle.
- **One-Click Slicer Launch & 3D Cutaway X-Ray:** Launch kits or single parts straight into OrcaSlicer via native `orcaslicer://` links, save reusable part/kit presets, and inspect internal thread clearances with the live 3D cross-section slider.

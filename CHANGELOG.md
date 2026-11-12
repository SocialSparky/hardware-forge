# Changelog

All notable changes to **Hardware Forge** are documented in this file.

## [v1.2.1] - 2026-11-12
### Added & Fixed
- **Universal 9-Category 2D Interactive Schematic Suite (`box_designer.js`):** Self-initializing DOM `MutationObserver` hooks providing live 2D blueprints and interactive sliders across Boxes (`06`), Fasteners (`01`), Standoffs (`04`), Clamps (`07`), Brackets (`08`), Knobs (`09`), Enclosures (`10`), Gauges (`11`), and Gaskets (`12`).
- **Slide-On Dovetail Track Cover Box (`06_boxes_organizers.scad`):** Added `slide_box` container style featuring 45° self-supporting dovetail rails, positive detent click-lock bumps, thumb-push grip grooves, and flush anti-mix compartment sealing.
- **Zero-Fulcrum Hinged Case Clearances & Anti-Mix Lid Dividers (`06_boxes_organizers.scad`):** Added Y-mirrored compartment dividers inside the hinged lid (`flush_seal`) and carved opposing knuckle swing-clearance pockets into the rear walls while keeping the inward snap-locking cones 100% intact.
- **Balanced Thread Fit & Clamp Hardware Replacement Modes (`01_fasteners.scad`, `07_clamps_mounts.scad`):** Tuned `standard` thread bite to smooth hand-threading tolerances and added `Bolt & Nut Only` / `Nut Only` render options to band clamps.
- **Shop Calibration Gauge 3-Fit Guide (`11_gauges_jigs.scad`):** Added interactive instructions explaining Press-Fit (`.08`), Daily-Driver Thread/Tool Fit (`.12`), and Free-Sliding Fit (`.16+`).

## [v1.2.0] - 2026-11-11
### Added
- **6 New Hardware Generator Categories (`07` through `12`):**
  - `07_clamps_mounts.scad`: Round pipe and square/rectangular tube tangential band clamps, C-clamps, 2-hole saddle straps, split-ear P-clips, 2-piece split blocks, and auto-widening snap-in clips with unobstructed countersink bores.
  - `08_brackets_joinery.scad`: Heavy-duty gusseted L-brackets, flat L/T plates with selectable `Triangled 45°`, `Rounded Fillet`, or `Squared 90°` interior corners, independent Arm 1 / Arm 2 countersink side controls, 3-way corner brackets, and 2020/4040 extrusion gussets.
  - `09_knobs_handles.scad`: 3-to-8 lobe star knobs, knurled thumbwheels, wing knobs, and U-pull handles with top/bottom hex traps or printed threads.
  - `10_enclosures_plates.scad`: Vented electronics project enclosures with PCB standoffs and 35mm DIN-rail snap-on clips.
  - `11_gauges_jigs.scad`: Printer fit-slop calibration matrix (`0.08mm`–`0.25mm`), bolt/nut sizer card, and self-centering V-block pipe drill jig.
  - `12_gaskets_seals.scad`: Bolt-circle pipe flange gaskets, rectangular enclosure seals, D-profile O-rings, 1-gang/2-gang/4x4 weatherproof electrical box gaskets, and panel knockout grommets.
- **Multi-Object `.3MF` Kit Exporter:** Exports packed build plates as standard `.3mf` archives where every part remains a distinct, selectable object in OrcaSlicer.
- **Zero-Config `/api/export/` Downloads & Native `orcaslicer://` Launch:** Clean filename routes eliminate browser security warnings and launch directly in OrcaSlicer without custom scripts.
- **Interactive 2D Visual Bracket & Enclosure Designers:** Live 2D schematic canvas for brackets and enclosures alongside the 2D cubby designer.
- **3D Cutaway X-Ray Slider & Saved Presets Manager:** Real-time Three.js clipping plane for inspecting internal threads/sockets and JSON preset storage for parts and kit recipes.
- **Horizontal D-Cut Bolt Mode (`01_fasteners.scad`):** Optional flat-sided horizontal printing orientation for 4x–5x higher tensile strength.

## [v1.1.0] - 2026-11-11
### Added
- **Interactive 2D Visual Cubby & Divider Designer (`box_designer.js`):** Click-and-drag 2D canvas and multi-sliders for custom column widths, independent row counts per column, and automatic remainder calculation on the final cubby.
- **3D Stamped Tool Size Markings (`05_install_tools.scad`):** Automatic Metric (`10mm`, `5mm`) and SAE fraction (`7/16"`, `3/16"`, `T30`, `PH2`) engraved or embossed text across all wrenches, hex bits, L-keys, nut drivers, and handles.
- **Exact Unthreaded Shoulder Grip + Positive Nut-Stop (`01_fasteners.scad`):** Added `partial_grip` mode with an integrated thread-stop collar and embedded thread lead-in so nuts stop at the exact specified grip length with zero back-side bolt protrusion.
- **Post-Print Snap-Together Box Hinge & Cantilever Clasp (`06_boxes_organizers.scad`):** Flex-slotted detent knuckle hinge and positive-locking cantilever front hook clasp.

## [v1.0.0] - Initial Release
- Offline FastAPI + Headless `openscad-nightly` (Manifold) + BOSL2 + Three.js Docker stack.
- Parametric Fasteners, Gears, Bearings, Spacers/Standoffs, and Install Tools.
- Build Plate Kit Cart with automated 2D bin-packing and `.stl` / `.zip` export.
- Universal custom decimal and SAE fraction-to-mm input converter.

# Changelog

All notable changes to **Hardware Forge** are documented in this file.

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

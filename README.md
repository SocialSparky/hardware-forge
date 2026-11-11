# ⚙️ Hardware Forge

A 100% offline, self-hosted Docker web application for generating parametric 3D-printable mechanical hardware, fasteners, gears, print-in-place bearings, standoffs, and matching installation tools.

## Features
- **Zero Cloud Dependencies:** Bundles headless `openscad-nightly` (with multi-core `Manifold` engine), the **BOSL2** library, FastAPI, and local `Three.js` WebGL preview.
- **Drop-In Plugin Architecture:** Automatically parses OpenSCAD Customizer files in `/generators` into dynamic dropdowns, conditional menus (`@show_if`), and custom decimal/SAE fraction inputs.
- **Build Plate Kit Cart:** Queue multiple bolts, nuts, washers, and matching tools into a unified kit and export a single auto-arranged build plate `.stl` or `.zip` bundle.
- **Direct Library Export:** One-click save directly into a local 3D print library folder (e.g., Manyfold watch directory).

// =====================================================================
//  13_FAN_LOUVER_GRILL.SCAD — Parametric Louvered Fan Grill & Vent Hood
// =====================================================================

/* [1. Fan & Plate Dimensions] */
// Standard Fan Frame Size [40:40 mm Fan, 50:50 mm Fan, 60:60 mm Fan, 70:70 mm Fan, 80:80 mm Fan, 92:92 mm Fan, 120:120 mm Standard Fan, 140:140 mm Large Fan]
fan_size = 120;

// Custom Plate Size Override in mm (0 = Use Standard Fan Size Above)
custom_size = 0;

// Custom Screw Hole Spacing in mm (0 = Standard Fan Spacing)
custom_hole_spacing = 0;

/* [2. Mounting Screw Holes & Corners] */
// Cut 4 Corner Mounting Screw Holes
screw_holes = true;

// Screw Hole Diameter in mm (0 = Auto: 3.4mm for <=70mm fans, 4.4mm for larger) [0:Auto Size (3.4mm / 4.4mm), 3.2:3.2 mm (M3), 3.4:3.4 mm (M3 Loose), 4.4:4.4 mm (M4 / Standard PC Fan Screw), 5.2:5.2 mm (M5)]
screw_hole_d = 0;

// Plate Outer Corner Radius (mm) [2:2 mm, 4:4 mm (Standard), 6:6 mm, 8:8 mm]
corner_radius = 4;

/* [3. Louver Hood Configuration] */
// Number of Louvers (Auto-Reduced if Needed to Fit) [1:1 Louver, 2:2 Louvers, 3:3 Louvers, 4:4 Louvers (Standard), 5:5 Louvers, 6:6 Louvers, 8:8 Louvers, 10:10 Louvers, 12:12 Louvers]
louver_count = 4;

// Auto-Size Hood Radius to Maximize Airflow for Louver Count
auto_size = true;

// Manual Hood Outer Radius in mm (When Auto-Size is Off) [8:8 mm, 12:12 mm, 15:15 mm, 20:20 mm, 25:25 mm] @show_if(auto_size=false)
hood_r = 15;

// Max Automatic Hood Radius Limit (mm) [15:15 mm, 20:20 mm, 25:25 mm, 30:30 mm (Default), 40:40 mm] @show_if(auto_size=true)
max_hood_r = 30;

// Solid Plate Strip Between Neighboring Louvers (mm) [2:2 mm, 3.5:3.5 mm, 5:5 mm (Default), 8:8 mm]
louver_gap = 5;

// Louver Length Along Slots in mm (0 = Full Width of Vent Area)
louver_length = 0;

// Vent Margin from Plate Edge in mm (0 = Auto Clear of Screws)
vent_margin = 0;

// Hood-to-Plate Root Fillet Radius (mm) [1:1.0 mm, 2:2.0 mm (Default), 3:3.0 mm, 4:4.0 mm, 6:6.0 mm]
fillet_size = 2;

/* [4. Louver Orientation] */
// Rotate Louver Pattern Around Center (Degrees) [0:0° (Horizontal), 30:30°, 45:45° (Diagonal), 60:60°, 90:90° (Vertical), 180:180° (Inverted)]
louver_rotation = 0;

// Hood Facing Direction [0:All Facing Same Direction, 1:Split Facing Outward from Center]
hood_direction = 0;

/* [Hidden] */
$fn = 96;
plate_thick = 2;
wall        = 2;
fillet_out  = max(fillet_size, 0.5);
min_hood_r  = 4;
screw_clear = 3;
min_margin  = 2;
eps         = 0.05;
seam        = 0.01;
steps       = 40;

function std_spacing(s) =
    s == 40  ? 32   :
    s == 50  ? 40   :
    s == 60  ? 50   :
    s == 70  ? 60   :
    s == 80  ? 71.5 :
    s == 92  ? 82.5 :
    s == 120 ? 105  :
    s == 140 ? 124.5 :
    s * 0.875;

size     = custom_size > 0 ? custom_size : fan_size;
spacing  = custom_hole_spacing > 0 ? custom_hole_spacing : std_spacing(size);
hole_d   = screw_hole_d > 0 ? screw_hole_d : (size <= 70 ? 3.4 : 4.4);
edge_m   = (size - spacing) / 2;
corner_r = min(corner_radius, edge_m);

margin_auto = screw_holes ? edge_m + hole_d / 2 + screw_clear : 4;
margin      = max(vent_margin > 0 ? vent_margin : margin_auto, min_margin);
vent        = size - 2 * margin;

function depth_of_r(r) = sqrt(pow(r + fillet_out, 2) - pow(fillet_out, 2));
function r_of_depth(d) = sqrt(d * d + fillet_out * fillet_out) - fillet_out;
function d_fit(n) = min((vent - (n - 1) * louver_gap) / n, vent / 2);
function fit_r(n) = d_fit(n) <= 0 ? -1 : r_of_depth(d_fit(n));
function pick_n(n) = (n <= 1 || fit_r(n) >= min_hood_r) ? max(n, 1) : pick_n(n - 1);

n_eff = pick_n(louver_count);
r_fit = fit_r(n_eff);
R     = auto_size ? min(r_fit, max_hood_r) : min(hood_r, r_fit);

hood_in   = R - wall;
fillet_in = fillet_out + wall;
arc_cz    = plate_thick;
fc_z      = plate_thick + fillet_out;
fc_r      = depth_of_r(R);
tan_a     = atan2(fc_z - arc_cz, fc_r);

D = fc_r;
total_h = n_eff * D + (n_eff - 1) * louver_gap;

rot_a = abs(cos(louver_rotation));
rot_b = abs(sin(louver_rotation));

function louver_y0(i) = -total_h / 2 + i * (D + louver_gap);

function louver_len(i) =
    let (y0 = louver_y0(i),
         m  = max(abs(y0), abs(y0 + D)),
         wa = rot_a > 1e-6 ? (vent / 2 - m * rot_b) / rot_a : 1e9,
         wb = rot_b > 1e-6 ? (vent / 2 - m * rot_a) / rot_b : 1e9,
         w_full = 2 * min(wa, wb),
         l_fit  = max(0, w_full - 2 * D))
    louver_length > 0 ? min(louver_length, l_fit) : l_fit;

function arc_pts(cx, cz, r, a0, a1, n = steps) =
    [for (i = [0 : n]) let (a = a0 + (a1 - a0) * i / n)
        [cx + r * cos(a), cz + r * sin(a)]];

function profile() = concat(
    arc_pts(0, arc_cz, R, 90, tan_a),
    arc_pts(fc_r, fc_z, fillet_out, 180 + tan_a, 270),
    [[fc_r + eps, plate_thick - eps], [fc_r + eps, eps]],
    arc_pts(fc_r, fc_z, fillet_in, 270, 180 + tan_a),
    arc_pts(0, arc_cz, hood_in, tan_a, 90)
);

module hood_profile() { polygon(profile()); }

module hood(len) {
    h = len / 2;
    if (len > 0.01)
        rotate([90, 0, 90])
            linear_extrude(height = len + 2 * seam, center = true)
                hood_profile();
    translate([h, 0, 0])
        rotate_extrude(angle = 90) hood_profile();
    translate([-h, 0, 0])
        mirror([1, 0, 0])
            rotate_extrude(angle = 90) hood_profile();
}

function arc2d(cx, cy, r, a0, a1, n) =
    [for (i = [0 : n]) let (a = a0 + (a1 - a0) * i / n)
        [cx + r * cos(a), cy + r * sin(a)]];

cut_n = max(ceil($fn / 4), 6);

module opening_cut(len) {
    h = len / 2;
    translate([0, 0, -1])
        linear_extrude(height = plate_thick + 2)
            polygon(concat(
                arc2d( h, 0, fc_r,  0,  90, cut_n),
                arc2d(-h, 0, fc_r, 90, 180, cut_n)
            ));
}

function is_flipped(i, n) =
    hood_direction == 1 ? (i > (n - 1) / 2) : false;

module place_louver(i) {
    y0 = louver_y0(i);
    rotate([0, 0, louver_rotation]) {
        if (is_flipped(i, n_eff))
            translate([0, y0 + D, 0]) rotate([0, 0, 180]) children();
        else
            translate([0, y0, 0]) children();
    }
}

module plate() {
    linear_extrude(height = plate_thick)
        difference() {
            offset(r = corner_r)
                square(size - 2 * corner_r, center = true);
            if (screw_holes)
                for (sx = [-1, 1], sy = [-1, 1])
                    translate([sx * spacing / 2, sy * spacing / 2])
                        circle(d = hole_d, $fn = 48);
        }
}

module grill() {
    assert(r_fit >= min_hood_r,
        str("Louvers do not fit: fan too small for the settings (best hood radius ",
            r_fit, " mm, need ", min_hood_r, " mm). Reduce louver_gap/vent_margin."));
    union() {
        difference() {
            plate();
            for (i = [0 : n_eff - 1])
                place_louver(i) opening_cut(louver_len(i));
        }
        for (i = [0 : n_eff - 1])
            place_louver(i) hood(louver_len(i));
    }
}

echo(str("[SPEC] Fan Grill: ", size, "×", size, " mm | Screw Spacing: ", spacing, " mm | Louvers: ", n_eff, " (R=", round(R*10)/10, " mm)"));
grill();

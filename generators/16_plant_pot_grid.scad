// ============================================================
//  16_PLANT_POT_GRID.SCAD — Plant Pot Soil Guard & Cat-Proof Grid
// ============================================================

/* [1. Main Dimensions & Split Parts] */
// View / Export Layout [spread:Spread Out for Printing, assembled:Assembled Preview, part1:Part 1 Only, part2:Part 2 Only, part3:Part 3 Only, part4:Part 4 Only]
view = "spread";

// Pot Inner Diameter / Grid Outer Diameter (mm) [80:80 mm (~3"), 100:100 mm (~4"), 120:120 mm (~4.7"), 150:150 mm (~6" Default), 180:180 mm (~7"), 200:200 mm (~8"), 250:250 mm (~10")]
outer_d = 150;

// Center Plant Stem Hole Diameter in mm (0 = Solid Center) [0:0 mm (No Center Hole), 20:20 mm, 30:30 mm (Default), 45:45 mm, 60:60 mm, 80:80 mm]
center_d = 30;

// Pattern Plate Thickness (mm) [1.6:1.6 mm, 2.0:2.0 mm (Standard), 3.0:3.0 mm (Heavy), 4.0:4.0 mm]
plate_t = 2;

// Split Grid into Sectors (For Fitting Around Existing Plants!) [1:1 Piece (Whole Disc), 2:2 Halves ( Clam-Shell Around Stem!), 3:3 Sectors, 4:4 Quadrants]
parts = 2;

/* [2. Grid Pattern & Cell Sizing] */
// Cutout Pattern Style [honeycomb:Honeycomb Hex Mesh, gyroid:Gyroid Wavy Lattice, hex:Staggered Hex Holes, round:Staggered Round Holes, slots:Oblong Slots, slits:Radial Slits]
pattern = "honeycomb";

// Cell Size (mm — Bigger = Larger Openings) [6:6 mm, 8:8 mm, 10:10 mm (Default), 14:14 mm, 18:18 mm, 25:25 mm]
cell_size = 10;

// Wall Thickness Between Cells (mm) [1.2:1.2 mm, 1.6:1.6 mm (Default), 2.0:2.0 mm, 2.8:2.8 mm]
grid_wall = 1.6;

// Hole Size Ratio (% of Cell for Hex & Round) [50:50%, 60:60%, 70:70% (Default), 80:80%]
hole_ratio = 70;

// Pattern Rotation Angle (deg) [0:0°, 15:15°, 30:30°, 45:45°, 90:90°]
pattern_angle = 0;

/* [3. Rims, Spokes & Stem Slot] */
// Outer Rim Width (mm) [2:2 mm, 3:3 mm (Default), 5:5 mm, 8:8 mm]
rim_w = 3;

// Center Hole Rim Width (mm) [2:2 mm, 3:3 mm (Default), 5:5 mm, 8:8 mm]
inner_rim_w = 3;

// Rim Height (mm) [2:2 mm, 3:3 mm (Default), 5:5 mm, 8:8 mm]
rim_h = 3;

// Radial Reinforcing Spokes [0:0 (None), 2:2 Spokes, 4:4 Spokes, 6:6 Spokes, 8:8 Spokes]
spokes_count = 0;

// Cut Side Stem Slot (For 1-Piece Grids Sliding Around a Stem)
stem_slot = false;

// Stem Slot Width (mm) @show_if(stem_slot=true)
stem_slot_w = 8;

// Outer Fit Clearance (mm) [0.2:0.2 mm, 0.5:0.5 mm (Default), 1.0:1.0 mm]
fit_clear = 0.5;

/* [4. Soil Anchor Pegs] */
// Rim-Mounted Soil Anchor Pegs [none:No Pegs (Flat Grid), outer:Outer Rim Pegs Only, inner:Center Rim Pegs Only, both:Both Outer & Center Rim Pegs]
feet_mode = "none";

// Pegs per Part per Rim [2:2 Pegs, 3:3 Pegs (Default), 4:4 Pegs, 6:6 Pegs] @show_if(feet_mode=outer|inner|both)
feet_per_part = 3;

// Soil Peg Length (mm) [20:20 mm, 30:30 mm, 40:40 mm (Default), 60:60 mm, 80:80 mm] @show_if(feet_mode=outer|inner|both)
feet_length = 40;

// Soil Peg Diameter (mm) [2.5:2.5 mm, 3.0:3.0 mm, 4.0:4.0 mm (Default), 6.0:6.0 mm] @show_if(feet_mode=outer|inner|both)
feet_d = 4;

/* [Hidden] */
$fn = 96;
slot_len = 3;
slit_count = 24;
slit_rows = 1;
slit_len_pct = 70;
slit_w = 1.2;
slit_tilt = 0;
spoke_w = 3;
spoke_h = 2;
spoke_angle = 0;
alt_orient = false;
stem_slot_angle = 0;
split_gap = 0.4;
split_edge_w = 1.6;
spread_dist = 8;
feet_tip = 50;
feet_tilt = 0;

R      = outer_d / 2 - fit_clear;
rc     = center_d / 2;
rimH   = max(rim_h, plate_t);
r_in   = rc > 0 ? rc + inner_rim_w : 0;
r_out  = R - rim_w;
span   = 360 / parts;
eps    = 0.01;

assert(r_out > r_in + cell_size / 2, "Rims/center hole too large for outer diameter");
echo(str("[SPEC] Plant Pot Grid: Ø", outer_d, " mm (Stem Hole Ø", center_d, " mm) | Pattern: ", pattern, " | Parts: ", parts));

module ring2d(r1, r2) {
    difference() {
        circle(r = r2);
        if (r1 > 0) circle(r = r1);
    }
}

module stagger_grid() {
    dx = cell_size * sqrt(3) / 2;
    dy = cell_size;
    nx = ceil(R / dx) + 1;
    ny = ceil(R / dy) + 1;
    for (i = [-nx : nx]) for (j = [-ny : ny]) {
        x = i * dx;
        y = j * dy + (abs(i) % 2) * dy / 2;
        if (x * x + y * y < (R + cell_size) * (R + cell_size))
            translate([x, y]) children();
    }
}

module wave_family() {
    p    = cell_size;
    lam  = cell_size * 2;
    amp  = cell_size * 0.35;
    n    = ceil(R / p) + 2;
    step = lam / 16;
    for (k = [-n : n]) {
        y0 = k * p;
        ph = (abs(k) % 2) * 180;
        up = [for (x = [-R - p : step : R + p]) [x, y0 + amp * sin(360 * x / lam + ph) + grid_wall / 2]];
        lo = [for (x = [R + p : -step : -R - p]) [x, y0 + amp * sin(360 * x / lam + ph) - grid_wall / 2]];
        polygon(concat(up, lo));
    }
}

module stadium(L, w) {
    hull() {
        translate([-(L - w) / 2, 0]) circle(d = w, $fn = 24);
        translate([(L - w) / 2, 0]) circle(d = w, $fn = 24);
    }
}

module slot_grid() {
    px = cell_size * slot_len + grid_wall;
    py = cell_size + grid_wall;
    nx = ceil(R / px) + 1;
    ny = ceil(R / py) + 1;
    for (j = [-ny : ny]) for (i = [-nx : nx]) {
        x = i * px + (abs(j) % 2) * px / 2;
        y = j * py;
        if (x * x + y * y < (R + cell_size) * (R + cell_size))
            translate([x, y]) stadium(cell_size * slot_len, cell_size);
    }
}

module slits2d() {
    rh = (r_out - r_in) / slit_rows;
    L  = max(rh * slit_len_pct / 100, slit_w + 0.1);
    for (row = [0 : slit_rows - 1]) {
        rm  = r_in + rh * (row + 0.5);
        off = (row % 2) * 180 / slit_count;
        for (k = [0 : slit_count - 1])
            rotate(k * 360 / slit_count + off) translate([rm, 0]) rotate(slit_tilt) stadium(L, slit_w);
    }
}

module spokes2d() {
    if (spokes_count > 0)
        intersection() {
            ring2d(max(0, r_in - eps), r_out + eps);
            for (k = [0 : spokes_count - 1])
                rotate(spoke_angle + k * 360 / spokes_count)
                    translate([0, -spoke_w / 2]) square([2 * R, spoke_w]);
        }
}

module stem_cut() {
    if (stem_slot)
        rotate(stem_slot_angle) translate([0, -stem_slot_w / 2]) square([2 * R, stem_slot_w]);
}

function angd(a, b) = abs(((a - b) % 360 + 540) % 360 - 180);

module pattern_solid() {
    rotate(pattern_angle) {
        if (pattern == "honeycomb") {
            difference() {
                circle(r = R + cell_size);
                stagger_grid() circle(r = (cell_size - grid_wall) / sqrt(3), $fn = 6);
            }
        } else if (pattern == "hex") {
            difference() {
                circle(r = R + cell_size);
                stagger_grid() rotate(30) circle(r = cell_size / sqrt(3) * hole_ratio / 100, $fn = 6);
            }
        } else if (pattern == "round") {
            difference() {
                circle(r = R + cell_size);
                stagger_grid() circle(d = cell_size * hole_ratio / 100, $fn = 32);
            }
        } else if (pattern == "slots") {
            difference() {
                circle(r = R + cell_size);
                slot_grid();
            }
        } else if (pattern == "slits") {
            difference() {
                circle(r = R + cell_size);
                slits2d();
            }
        } else {
            union() {
                wave_family();
                rotate(90) wave_family();
            }
        }
    }
}

module pattern_plate() {
    intersection() {
        ring2d(max(0, r_in - eps), r_out + eps);
        if (alt_orient && spokes_count > 1)
            union() {
                for (s = [0 : spokes_count - 1])
                    intersection() {
                        wedge_gen(spoke_angle + s * 360 / spokes_count, 360 / spokes_count);
                        rotate((s % 2) * 90) pattern_solid();
                    }
            }
        else pattern_solid();
    }
}

module rims2d() {
    ring2d(R - rim_w, R);
    if (rc > 0) ring2d(rc, rc + inner_rim_w);
}

module wedge_gen(a0, sp) {
    n = ceil(sp / 5);
    polygon(concat([[0, 0]], [for (t = [0 : n]) let (a = a0 + sp * t / n) [2 * R * cos(a), 2 * R * sin(a)]]));
}

module wedge2d(i) { wedge_gen(i * span, span); }

module gap_cuts(i) {
    if (split_gap > 0)
        for (a = [i * span, i * span + span])
            rotate(a) translate([0, -split_gap / 2]) square([2 * R, split_gap]);
}

module clip2d(i) {
    difference() {
        if (parts == 1) children();
        else difference() {
            intersection() { children(); wedge2d(i); }
            gap_cuts(i);
        }
        stem_cut();
    }
}

module edge_strips(i) {
    if (parts > 1 && split_edge_w > 0)
        intersection() {
            ring2d(max(0, r_in - eps), r_out + eps);
            union() {
                rotate(i * span) translate([0, split_gap / 2]) square([2 * R, split_edge_w]);
                rotate(i * span + span) translate([0, -split_gap / 2 - split_edge_w]) square([2 * R, split_edge_w]);
            }
        }
}

module peg(fd, tilt) {
    rotate([0, tilt, 0])
        cylinder(d1 = fd, d2 = fd * feet_tip / 100, h = feet_length, $fn = 32);
}

module ring_pegs(i, r, fd, tilt) {
    m = parts > 1 ? asin(min(1, (fd / 2 + split_gap / 2 + split_edge_w + 0.3) / r)) : 0;
    for (k = [0 : feet_per_part - 1]) {
        a = i * span + m + (span - 2 * m) * (k + 0.5) / feet_per_part;
        blocked = stem_slot && angd(a, stem_slot_angle) < asin(min(1, (stem_slot_w / 2 + fd / 2 + 0.5) / r));
        if (!blocked) rotate([0, 0, a]) translate([r, 0, rimH / 2]) peg(fd, tilt);
    }
}

module pegs(i) {
    if (feet_mode == "outer" || feet_mode == "both")
        ring_pegs(i, R - rim_w / 2, min(feet_d, rim_w), feet_tilt);
    if ((feet_mode == "inner" || feet_mode == "both") && rc > 0)
        ring_pegs(i, rc + inner_rim_w / 2, min(feet_d, inner_rim_w), 0);
}

module part(i) {
    union() {
        linear_extrude(plate_t)
            clip2d(i) union() { pattern_plate(); edge_strips(i); }
        if (spokes_count > 0)
            linear_extrude(max(spoke_h, plate_t)) clip2d(i) spokes2d();
        linear_extrude(rimH)
            clip2d(i) rims2d();
        pegs(i);
    }
}

module layout() {
    if (view == "assembled") {
        for (i = [0 : parts - 1]) part(i);
    } else if (view == "spread") {
        for (i = [0 : parts - 1]) {
            mid = (i + 0.5) * span;
            d = parts > 1 ? spread_dist : 0;
            translate([d * cos(mid), d * sin(mid), 0]) part(i);
        }
    } else {
        idx = view == "part1" ? 0 : view == "part2" ? 1 : view == "part3" ? 2 : 3;
        if (idx < parts) part(idx);
    }
}

layout();

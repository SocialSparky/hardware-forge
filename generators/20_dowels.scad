// =====================================================================
//  20_DOWELS.SCAD — Parametric Split-Half Flat-Printed Dowel Generator
//  Prints flat on the build plate for maximum XY shear/bending strength!
// =====================================================================

/* [1. Dowel Style & Surface Grip] */
// Print Orientation & Split Style [split_loose:Split Halves (Two Separate Flat-Printed Pieces — Default), solid_flat:One-Piece Flat-Sided (Flattened Top & Bottom)]
dowel_style = "split_loose";

// Shaft Grip / Surface Profile [crush_ribs:Longitudinal Crush Ribs (Tightens Joint!), fluted:Fluted Glue Grooves (Classic Wood Dowel), smooth:Smooth Cylindrical Shaft]
surface_style = "crush_ribs";

// Measurement System [metric:Metric (mm), imperial:Imperial / SAE (Inches)]
unit_system = "metric";

/* [2. Diameter & Length] */
// Metric Dowel Diameter (mm) [4:4 mm, 5:5 mm, 6:6 mm (Standard Small), 8:8 mm (Standard Furniture), 10:10 mm (Heavy), 12:12 mm, 16:16 mm] @show_if(unit_system=metric)
metric_dia = 8;

// Imperial Dowel Diameter [4.7625:3/16" (4.76 mm), 6.35:1/4" (6.35 mm), 7.9375:5/16" (7.94 mm), 9.525:3/8" (9.53 mm), 12.7:1/2" (12.70 mm), 15.875:5/8" (15.88 mm)] @show_if(unit_system=imperial)
imperial_dia = 6.35;

// Custom Diameter Override in mm (0 = Use Preset Above)
custom_dia = 0;

// Total Dowel Length (mm) [15:15 mm, 20:20 mm, 25:25 mm (~1"), 30:30 mm (Standard), 35:35 mm, 40:40 mm (~1.5"), 50:50 mm (~2"), 60:60 mm, 75:75 mm (~3"), 100:100 mm (~4")]
dowel_length = 35;

// Beveled 45° Insertion Tips on Both Ends
bevel_tips = true;

/* [3. Rib / Groove & Fit Tuning] */
// Crush Rib Count Around Circumference [6:6 Ribs, 8:8 Ribs (Default), 10:10 Ribs, 12:12 Ribs] @show_if(surface_style=crush_ribs|fluted)
rib_count = 8;

// Crush Rib Interference (How Far Ribs Stand Proud of Hole Diameter, mm) [0.15:0.15 mm (Light Snug), 0.25:0.25 mm (Standard Press-Fit), 0.35:0.35 mm (Firm Hammer-In), 0.45:0.45 mm (Extra Tight)] @show_if(surface_style=crush_ribs)
rib_interference = 0.25;

// Base Shaft Clearance (Shrinks Core Below Hole Diameter for Easy Start, mm) [0.05:0.05 mm (Tight), 0.15:0.15 mm (Standard), 0.25:0.25 mm (Loose)]
fit_clearance = 0.15;

/* [4. Split-Half & Batch Layout] */
// Flatten Top of Split Halves (% of Diameter — Removes Top-Layer Blobs) [0:0% (Full Round), 8:8% (Recommended), 12:12%] @show_if(dowel_style=split_loose)
split_top_cut = 8;

// Quantity of Dowels to Print on Plate [1:1 Dowel, 2:2 Dowels, 4:4 Dowels, 6:6 Dowels, 8:8 Dowels, 12:12 Dowels]
quantity = 1;

/* [Hidden] */
$fn = 64;
eps = 0.01;

D_nom = (custom_dia > 0) ? custom_dia : ((unit_system == "metric") ? metric_dia : imperial_dia);
L     = max(10, dowel_length);
D_core = max(2.0, D_nom - fit_clearance * 2);
R_core = D_core / 2;
bevel_h = bevel_tips ? min(2.2, max(0.8, D_nom * 0.18)) : 0;

rib_w     = max(0.7, min(1.4, D_nom * 0.13));
rib_r_out = (D_nom + rib_interference) / 2;
flute_r   = max(0.4, min(1.0, D_nom * 0.08));

echo(str("[SPEC] Dowel: Ø", round(D_nom * 100) / 100, " mm × ", L, " mm | Style: ", dowel_style, " | Surface: ", surface_style, " | Qty: ", quantity));

module dowel_3d_along_x() {
    taper_end = max(bevel_h + 1.2, 2.5);

    rotate([0, 90, 0])
    difference() {
        union() {
            if (bevel_tips) {
                cylinder(r1 = R_core - bevel_h * 0.75, r2 = R_core, h = bevel_h);
                translate([0, 0, bevel_h - eps])
                    cylinder(r = R_core, h = L - 2 * bevel_h + 2 * eps);
                translate([0, 0, L - bevel_h])
                    cylinder(r1 = R_core, r2 = R_core - bevel_h * 0.75, h = bevel_h);
            } else {
                cylinder(r = R_core, h = L);
            }

            if (surface_style == "crush_ribs") {
                for (i = [0 : rib_count - 1]) {
                    ang = (i + 0.5) * (360 / rib_count);
                    rotate([0, 0, ang])
                    rotate([90, 0, 0])
                    linear_extrude(height = rib_w, center = true)
                        polygon([
                            [R_core - 0.3, bevel_h],
                            [R_core - 0.1, bevel_h],
                            [rib_r_out,    taper_end],
                            [rib_r_out,    L - taper_end],
                            [R_core - 0.1, L - bevel_h],
                            [R_core - 0.3, L - bevel_h]
                        ]);
                }
            }
        }

        if (surface_style == "fluted") {
            for (i = [0 : rib_count - 1]) {
                ang = (i + 0.5) * (360 / rib_count);
                rotate([0, 0, ang])
                translate([R_core, 0, bevel_h * 0.5])
                    cylinder(r = flute_r, h = L - bevel_h, $fn = 16);
            }
        }
    }
}

module single_dowel_printable() {
    max_r   = (surface_style == "crush_ribs") ? rib_r_out : R_core;
    skim    = 0.03;
    half_h  = max_r - (D_nom * split_top_cut / 100);
    h_gap   = 3.5;
    split_y = max_r + h_gap / 2;
    big     = max(L, D_nom) * 2 + 10;

    if (dowel_style == "solid_flat") {
        flat_t = D_nom * 0.76;
        translate([0, 0, flat_t / 2])
        intersection() {
            dowel_3d_along_x();
            translate([-1, -big / 2, -flat_t / 2])
                cube([L + 2, big, flat_t]);
        }
    } else {
        // Upper Half (Z >= skim)
        translate([0, -split_y, -skim])
        intersection() {
            dowel_3d_along_x();
            translate([-1, -big / 2, skim])
                cube([L + 2, big, half_h]);
        }

        // Lower Half (Z <= -skim flipped 180° around X)
        translate([0, split_y, -skim])
        rotate([180, 0, 0])
        intersection() {
            dowel_3d_along_x();
            translate([-1, -big / 2, -half_h - skim])
                cube([L + 2, big, half_h]);
        }
    }
}

max_d = (surface_style == "crush_ribs") ? (rib_r_out * 2) : D_nom;
cell_w = L + 8;
cell_d = (dowel_style == "solid_flat") ? (max_d + 6) : (max_d * 2 + 9);
cols = max(1, ceil(sqrt(quantity * cell_d / cell_w)));

for (i = [0 : quantity - 1]) {
    cx = (i % cols) * cell_w;
    cy = floor(i / cols) * cell_d;
    translate([cx, cy, 0])
        single_dowel_printable();
}

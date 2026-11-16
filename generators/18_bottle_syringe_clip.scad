// =====================================================================
//  18_BOTTLE_SYRINGE_CLIP.SCAD — Grip-Nub Bottle & Syringe Clip Holder
// =====================================================================

/* [1. Target Inner Diameters (mm)] */
// Main Bottle Neck Diameter (mm) [18:18 mm, 20:20 mm, 22:22 mm, 23:23.0 mm (Default Bottle Neck), 25:25 mm, 28:28 mm (P38 / Standard Cap), 32:32 mm]
bottle_neck_dia = 23.0;

// Primary Syringe Barrel Outer Diameter (mm) [10:10 mm (1mL–3mL Syringe), 12.5:12.5 mm (5mL Syringe), 14.5:14.5 mm, 16.0:16.0 mm (10mL Oral Syringe — Default), 18.5:18.5 mm (20mL Syringe)]
syringe_outer_dia = 16.0;

// Secondary / Plunger or Smaller Syringe Diameter (mm) [8:8 mm, 10.5:10.5 mm, 12.0:12.0 mm, 13.5:13.5 mm (Default), 15.0:15.0 mm]
syringe_inner_dia = 13.5;

/* [2. Clip Band & Grip Nub Settings] */
// Clip Height / Band Thickness (mm) [6:6 mm, 8:8.0 mm (Default), 10:10 mm, 12:12 mm]
part_height = 8.0;

// Clip Ring Wall Thickness (mm) [2.6:2.6 mm (Flexible), 3.4:3.4 mm (Default), 4.2:4.2 mm (Stiff)]
wall_thickness = 3.4;

// Internal Grip Nub Protrusion (mm) [0.4:0.4 mm (Gentle), 0.8:0.8 mm (Standard Grip), 1.2:1.2 mm (Tight Snap)]
nub_protrusion = 0.8;

// Grip Nub Radius (mm) [1.0:1.0 mm, 1.4:1.4 mm (Default), 1.8:1.8 mm]
nub_radius = 1.4;

// Bottle Clip Mouth Opening Angle (deg) [95:95° (Tight), 115:115° (Default), 130:130° (Easy Clip)]
bottle_open_deg = 115;

// Syringe Clip Mouth Opening Angle (deg) [95:95°, 110:110° (Default), 125:125°]
syringe_open_deg = 110;

/* [3. Bridge Arms & Layout] */
// Primary Arm Length (mm) [8:8 mm, 12:12.0 mm (Default), 16:16 mm, 20:20 mm]
outer_arm_length = 12.0;

// Secondary Arm Length (mm) [8:8 mm, 11:11.0 mm (Default), 15:15 mm, 20:20 mm]
inner_arm_length = 11.0;

// Primary Arm Width (mm)
outer_arm_width = 8.5;

// Secondary Arm Width (mm)
inner_arm_width = 7.5;

// Secondary Clip Branch Angle (deg) [35:35°, 45:45° (Default), 60:60°, 90:90°]
right_clip_angle = 45;

// Webbing Fillet Radius (mm)
fillet_radius = 3.5;

/* [Hidden] */
$fn = 80;

r_bottle_in = (bottle_neck_dia / 2) + nub_protrusion;
r_outer_in  = (syringe_outer_dia / 2) + nub_protrusion;
r_inner_in  = (syringe_inner_dia / 2) + nub_protrusion;

dist_outer = r_bottle_in + wall_thickness + outer_arm_length + r_outer_in;
dist_inner = r_bottle_in + wall_thickness + inner_arm_length + r_inner_in;

echo(str("[SPEC] Bottle & Syringe Clip: Bottle Ø", bottle_neck_dia, " mm | Syringes Ø", syringe_outer_dia, " mm & Ø", syringe_inner_dia, " mm | Height: ", part_height, " mm"));

union() {
    difference() {
        linear_extrude(height = part_height) {
            offset(r = -fillet_radius) {
                offset(r = fillet_radius) {
                    union() {
                        circle(r = r_bottle_in + wall_thickness);

                        translate([0, dist_outer])
                            circle(r = r_outer_in + wall_thickness);
                        translate([-outer_arm_width / 2, 0])
                            square([outer_arm_width, dist_outer]);

                        rotate([0, 0, -right_clip_angle]) {
                            translate([0, dist_inner])
                                circle(r = r_inner_in + wall_thickness);
                            translate([-inner_arm_width / 2, 0])
                                square([inner_arm_width, dist_inner]);
                        }
                    }
                }
            }
        }

        translate([0, 0, -1]) {
            clip_cutout_3d(r_bottle_in, wall_thickness, part_height + 2, bottle_open_deg, -90);

            translate([0, dist_outer, 0])
                clip_cutout_3d(r_outer_in, wall_thickness, part_height + 2, syringe_open_deg, 90);

            rotate([0, 0, -right_clip_angle])
                translate([0, dist_inner, 0])
                    clip_cutout_3d(r_inner_in, wall_thickness, part_height + 2, syringe_open_deg, 90);
        }
    }

    clip_details_3d(r_bottle_in, wall_thickness, part_height, bottle_open_deg, -90, 7, nub_radius, nub_protrusion);

    translate([0, dist_outer, 0])
        clip_details_3d(r_outer_in, wall_thickness, part_height, syringe_open_deg, 90, 5, nub_radius * 0.85, nub_protrusion * 0.85);

    rotate([0, 0, -right_clip_angle])
        translate([0, dist_inner, 0])
            clip_details_3d(r_inner_in, wall_thickness, part_height, syringe_open_deg, 90, 5, nub_radius * 0.8, nub_protrusion * 0.8);
}

module clip_cutout_3d(r_in, wall, h, open_deg, dir_deg) {
    r_out = r_in + wall + 2;
    a1 = open_deg / 2;
    a2 = 360 - a1;
    cx = 0; cy = 0;

    rotate([0, 0, dir_deg]) {
        linear_extrude(height = h) {
            union() {
                circle(r = r_in);
                polygon([
                    [cx, cy],
                    [r_out * 2 * cos(a1), r_out * 2 * sin(a1)],
                    [r_out * 2, r_out * 2],
                    [r_out * 2, -r_out * 2],
                    [r_out * 2 * cos(a2), r_out * 2 * sin(a2)]
                ]);
            }
        }
    }
}

module clip_details_3d(r_in, wall, h, open_deg, dir_deg, num_nubs, n_rad, n_prot) {
    mid_r = r_in + wall / 2;
    a1 = open_deg / 2;
    a2 = 360 - a1;

    rotate([0, 0, dir_deg]) {
        for (a = [a1, a2]) {
            translate([mid_r * cos(a), mid_r * sin(a), 0])
                cylinder(r = wall / 2, h = h);
        }

        nub_margin = 18;
        start_nub = a1 + nub_margin;
        end_nub = a2 - nub_margin;
        step = (end_nub - start_nub) / (num_nubs - 1);

        for (i = [0 : num_nubs - 1]) {
            ang = start_nub + i * step;
            nub_dist = r_in + n_rad - n_prot;
            translate([nub_dist * cos(ang), nub_dist * sin(ang), 0])
                cylinder(r = n_rad, h = h);
        }
    }
}

// =====================================================================
//  15_SLOTTED_CABLE_DUCT.SCAD — Slotted Finger Wiring Duct + Snap Lid
// =====================================================================

/* [1. Output & Render Mode] */
// Which Part(s) to Render [both:Print Plate (Tray + Snap Lid + Bowtie Keys), tray:Slotted Duct Tray Only, lid:Snap-On Lid Only, key:Bowtie Splice Key Only, assembly:Assembled 3D Preview]
part = "both";

/* [2. Duct Dimensions] */
// Duct Section Length (mm) [100:100 mm (~4"), 150:150 mm (~6"), 200:200 mm (~8"), 220:220 mm, 248:248 mm (Full Bed Run), 300:300 mm (~12")]
duct_length = 200;

// Usable Inner Width (mm) [20:20 mm, 25:25 mm (1"), 30:30 mm (Default), 40:40 mm (1.5"), 50:50 mm (2"), 60:60 mm, 80:80 mm]
inner_width = 30;

// Usable Inner Height — Floor to Finger Tips (mm) [20:20 mm, 25:25 mm (1"), 30:30 mm (Default), 40:40 mm (1.5"), 50:50 mm (2"), 60:60 mm]
inner_height = 30;

// Side Wall Thickness (mm) [1.6:1.6 mm, 2.0:2.0 mm (Standard), 2.4:2.4 mm (Heavy), 3.0:3.0 mm]
wall_thickness = 2;

// Floor Thickness (mm) [2.0:2.0 mm, 3.0:3.0 mm (Standard — Fits Splice Key), 4.0:4.0 mm]
floor_thickness = 3;

/* [3. End Styles & Bowtie Splicing] */
// Left End (X = 0) Style [splice:Bowtie Splice Pocket (Chains to Next Duct!), wall:Closed End Cap Wall, open:Plain Open End]
left_end = "splice";

// Right End (X = Length) Style [splice:Bowtie Splice Pocket (Chains to Next Duct!), wall:Closed End Cap Wall, open:Plain Open End]
right_end = "splice";

/* [4. Side Fingers & Slots] */
// Solid Finger Width (mm) [5:5 mm, 6:6 mm, 8:8 mm (Standard), 10:10 mm, 12:12 mm]
finger_width = 8;

// Cable Slot Gap Width (mm) [4:4 mm (Thin Wires), 6:6 mm (Standard), 8:8 mm (Cat6 / Thick Cords), 10:10 mm]
gap_width = 6;

// Solid Base Rail Height Below Slots (mm) [4:4 mm, 6:6 mm (Standard), 8:8 mm, 10:10 mm]
base_rail_height = 6;

/* [5. Mounting Holes & Zip-Tie Floor Anchors] */
// Countersunk Floor Mounting Holes Along Length [0:0 (No Holes), 2:2 Holes, 3:3 Holes (Standard), 4:4 Holes, 5:5 Holes]
mounting_hole_count = 3;

// Mounting Hole Rows Across Width [1:1 Center Row, 2:2 Dual Side Rows]
mounting_hole_rows = 1;

// Internal Zip-Tie / Ty-Wrap Floor Arches Along Length [0:0 (None), 2:2 Arches (Standard), 3:3 Arches, 4:4 Arches]
anchor_count = 2;

// Zip-Tie Arch Rows Across Width [1:1 Row, 2:2 Rows]
anchor_rows = 1;

/* [6. Hardware & Fit Clearance] */
// Mounting Screw Nominal Diameter (mm) [3:3.0 mm (M3 / #4), 3.5:3.5 mm (#6), 4:4.0 mm (M4 / #8 — Standard), 5:5.0 mm (M5 / #10)]
screw_diameter = 4;

// Snap-On Lid Thickness (mm) [1.6:1.6 mm, 2.0:2.0 mm (Standard), 2.4:2.4 mm]
lid_thickness = 2;

// Snap Lid & Splice Key Clearance (mm) [0.08:0.08 mm (Tight), 0.10:0.10 mm (Standard), 0.15:0.15 mm (Easy Snap), 0.20:0.20 mm (Loose)]
fit_clearance = 0.1;

/* [Hidden] */
$fn = 48;
eps = 0.01;

screw_hole_diameter = screw_diameter + 0.5;
screw_head_diameter = screw_diameter * 2;

key_length      = 16;
key_tip_width   = 17;
key_waist_width = 5;
key_pocket      = 1.8;
key_sink        = 0.15;
key_relief      = 0.3;
key_relief_high = 0.4;
key_clearance   = fit_clearance * 0.5;

anchor_opening = 8;
anchor_band    = 2.4;
anchor_depth   = 6;

snap_depth    = 0.6;
barb_height   = 2.0;
leg_thickness = max(1.2, lid_thickness * 0.8);
leg_length    = max(6, lid_thickness * 3);

outer_width  = inner_width + 2 * wall_thickness;
outer_height = floor_thickness + inner_height;
inner_face   = inner_width / 2;
top          = outer_height;

left_wall  = (left_end  == "wall");
right_wall = (right_end == "wall");
left_key   = (left_end  == "splice");
right_key  = (right_end == "splice");

pocket_depth = min(key_pocket, max(0.6, floor_thickness - 1));
countersink_diameter =
    min(screw_head_diameter,
        screw_hole_diameter + 2 * max(0, floor_thickness - 0.8));

slot_x0 = left_wall  ? wall_thickness : 0;
slot_x1 = duct_length - (right_wall ? wall_thickness : 0);
slot_span   = slot_x1 - slot_x0;
finger_step = finger_width + gap_width;
slot_count  = (slot_span >= finger_step)
            ? floor((slot_span - finger_width) / finger_step) : 0;
pattern_length = slot_count * finger_step + finger_width;
pattern_start  = slot_x0 + (slot_span - pattern_length) / 2;

lid_x0     = left_wall  ? wall_thickness + fit_clearance : 0;
lid_x1     = duct_length - (right_wall ? wall_thickness + fit_clearance : 0);
lid_length = lid_x1 - lid_x0;
leg_face   = inner_face - snap_depth - fit_clearance;
leg_tip    = inner_face - fit_clearance;
leg_apex   = -(barb_height + snap_depth - fit_clearance);

anchor_radius = (anchor_opening + anchor_band) / 2;
anchor_length = anchor_opening + 2 * anchor_band;
min_gap = (countersink_diameter + anchor_length) / 2 + 1;

hole_positions = mounting_hole_count > 0
    ? [for (i = [0 : mounting_hole_count - 1])
          duct_length * (i + 0.5) / mounting_hole_count] : [];

hole_span = max(0, inner_width - countersink_diameter - 2);
hole_rows_y = mounting_hole_rows < 1 ? []
    : mounting_hole_rows == 1 ? [0]
    : [for (i = [0 : mounting_hole_rows - 1])
          -hole_span / 2 + i * hole_span / (mounting_hole_rows - 1)];

anchor_rows_y = anchor_rows < 1 ? []
    : [for (i = [0 : anchor_rows - 1])
          inner_width * (i + 0.5) / anchor_rows - inner_width / 2];

rows_overlap = len([for (hy = hole_rows_y, ay = anchor_rows_y)
    if (abs(hy - ay) < (countersink_diameter + anchor_depth) / 2 + 1) 1]) > 0;

function hole_clash(x) = !rows_overlap ? [] :
    [for (h = hole_positions) if (abs(x - h) < min_gap) h];

function nudge(x) =
    let (c = hole_clash(x))
    len(c) == 0 ? x
    : (x >= c[0] ? min(duct_length - anchor_length / 2 - 1, c[0] + min_gap)
                 : max(anchor_length / 2 + 1, c[0] - min_gap));

anchor_positions = anchor_count > 0
    ? [for (i = [0 : anchor_count - 1])
          nudge(duct_length * (i + 1) / (anchor_count + 1))] : [];

keys_needed = (left_key ? 1 : 0) + (right_key ? 1 : 0);

echo(str("[SPEC] Slotted Cable Duct: ", duct_length, "×", outer_width, "×", outer_height, " mm | Slots: ", slot_count, " | Keys: ", keys_needed));

module both_sides() { children(); mirror([0, 1, 0]) children(); }
module along_x(len) { rotate([90, 0, 90]) linear_extrude(len) children(); }

module barb_ridge() {
    along_x(duct_length)
        polygon([[inner_face, top],
                 [inner_face - snap_depth, top - barb_height],
                 [inner_face, top - barb_height - snap_depth]]);
}

module ty_anchor() {
    fillet = min(anchor_band, anchor_depth) / 2 - 0.01;
    rotate([90, 0, 0])
        rotate_extrude(angle = 180)
            translate([anchor_radius, 0])
                offset(r = fillet, $fn = 16)
                    square([anchor_band  - 2 * fillet,
                            anchor_depth - 2 * fillet], center = true);
}

module key_outline_2d() {
    polygon([[-key_length / 2, -key_tip_width / 2],
             [0, -key_waist_width / 2],
             [ key_length / 2, -key_tip_width / 2],
             [ key_length / 2,  key_tip_width / 2],
             [0,  key_waist_width / 2],
             [-key_length / 2,  key_tip_width / 2]]);
}

module key_pocket_2d() { offset(delta = key_clearance) key_outline_2d(); }

module key() {
    body = pocket_depth - key_sink;
    union() {
        translate([0, 0, key_relief_high])
            linear_extrude(body - key_relief_high) key_outline_2d();
        linear_extrude(key_relief_high)
            offset(delta = -key_relief) key_outline_2d();
    }
}

module mounting_holes() {
    for (x = hole_positions, y = hole_rows_y)
        translate([x, y, 0]) {
            translate([0, 0, -1])
                cylinder(d = screw_hole_diameter, h = floor_thickness + 2);
            depth = (countersink_diameter - screw_hole_diameter) / 2;
            translate([0, 0, floor_thickness - depth])
                cylinder(d1 = screw_hole_diameter,
                         d2 = countersink_diameter, h = depth + eps);
        }
}

module tray() {
    difference() {
        union() {
            translate([0, -outer_width / 2, 0])
                cube([duct_length, outer_width, floor_thickness]);
            both_sides() {
                translate([0, inner_face, 0])
                    cube([duct_length, wall_thickness, outer_height]);
                barb_ridge();
            }
            if (left_wall)
                translate([0, -outer_width / 2, 0])
                    cube([wall_thickness, outer_width, outer_height]);
            if (right_wall)
                translate([duct_length - wall_thickness, -outer_width / 2, 0])
                    cube([wall_thickness, outer_width, outer_height]);
            for (x = anchor_positions, y = anchor_rows_y)
                translate([x, y, floor_thickness - eps]) ty_anchor();
        }
        if (slot_count > 0)
            for (i = [0 : slot_count - 1])
                both_sides()
                    translate([pattern_start + finger_width + i * finger_step,
                               inner_face - snap_depth - eps,
                               floor_thickness + base_rail_height])
                        cube([gap_width,
                              wall_thickness + snap_depth + 2 * eps,
                              outer_height]);
        if (left_key)
            translate([0, 0, floor_thickness - pocket_depth])
                linear_extrude(pocket_depth + 1) key_pocket_2d();
        if (right_key)
            translate([duct_length, 0, floor_thickness - pocket_depth])
                linear_extrude(pocket_depth + 1) key_pocket_2d();
        mounting_holes();
    }
}

module lid_leg() {
    along_x(lid_length)
        polygon([[leg_face, 0],
                 [leg_face, leg_apex + snap_depth],
                 [leg_tip,  leg_apex],
                 [leg_face, -leg_length],
                 [leg_face - leg_thickness, -leg_length],
                 [leg_face - leg_thickness, 0]]);
}

module lid() {
    translate([0, -outer_width / 2, 0])
        cube([lid_length, outer_width, lid_thickness]);
    both_sides() lid_leg();
}

module lid_printable() {
    translate([0, 0, lid_thickness]) rotate([180, 0, 0]) lid();
}

if (part == "tray")
    tray();
else if (part == "lid")
    lid_printable();
else if (part == "key")
    key();
else if (part == "assembly") {
    tray();
    translate([lid_x0, 0, outer_height]) lid();
} else {
    tray();
    translate([0, outer_width + 12, 0]) lid_printable();
    if (keys_needed > 0)
        for (i = [0 : keys_needed - 1])
            translate([key_length,
                       outer_width * 1.5 + 26 + i * (key_tip_width + 4), 0])
                key();
}

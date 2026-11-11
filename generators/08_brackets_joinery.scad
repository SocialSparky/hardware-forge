include <BOSL2/std.scad>

/* [1. Bracket / Joinery Style] */
// Select Structural Bracket Type [l_ribbed:Heavy-Duty L-Bracket with Side Gusset Ribs, l_flat:Flat Plate L-Bracket (90° Corner), t_plate:Flat T-Junction Joining Plate, corner_3way:3-Way 90° Box / Frame Corner Bracket, extrusion_gusset:2020 / 4040 Aluminum Extrusion Corner Gusset]
bracket_type = "l_ribbed";

// Interior 90° Corner Reinforcement Style [triangled:Triangled 45° Web Chamfer (Strongest!), rounded:Rounded Concave Stress-Relief Fillet, squared:Crisp 90° Squared Inside Corner] @show_if(bracket_type=t_plate|l_flat)
inside_corner_style = "triangled";

// Interior Corner Fillet / Triangle Size [5:5 mm (Small), 8:8 mm (Standard), 12:12 mm (Medium), 16:16 mm (Large Heavy Web), 22:22 mm (Extra Large)] @show_if(bracket_type=t_plate|l_flat, inside_corner_style=triangled|rounded)
corner_web_size = 10;

/* [2. Bracket Arm Dimensions (Or Use Visual 2D Designer Above!)] */
// Arm 1 Length - X Axis [20:20 mm, 30:30 mm, 40:40 mm (~1.5"), 50:50 mm (~2"), 60:60 mm, 75:75 mm (~3"), 100:100 mm (~4"), 125:125 mm (~5")]
arm_x = 50;

// Arm 2 Length - Y/Z Axis [20:20 mm, 30:30 mm, 40:40 mm (~1.5"), 50:50 mm (~2"), 60:60 mm, 75:75 mm (~3"), 100:100 mm (~4"), 125:125 mm (~5")]
arm_y = 50;

// Bracket Width [15:15 mm, 20:20 mm (2020 Profile), 25:25 mm (~1"), 30:30 mm, 40:40 mm (4040 Profile), 50:50 mm (~2"), 60:60 mm]
width = 25;

// Plate Wall Thickness [3.0:3.0 mm (Light), 4.0:4.0 mm (Standard), 5.0:5.0 mm (Heavy Duty), 6.0:6.0 mm (Structural), 8.0:8.0 mm (Extra Heavy)]
thick = 4.0;

// Side Gusset Ribs (For 3D L-Bracket) [both:Dual Side Gussets (Maximum Strength), center:Single Center Web Gusset, none:No Gusset] @show_if(bracket_type=l_ribbed)
gusset_style = "both";

/* [3. Mounting Holes & Independent Countersink Side Controls] */
// Screw Hole Size [3.2:M3 (3.2 mm), 4.2:M4 / #8 Screw (4.2 mm), 5.2:M5 / #10 Screw (5.2 mm), 6.4:M6 / 1/4" Bolt (6.4 mm), 8.4:M8 / 5/16" Bolt (8.4 mm), 10.5:M10 / 3/8" Bolt (10.5 mm)]
hole_diam = 5.2;

// Holes per Arm [1:1 Hole / Slot per Arm, 2:2 Holes per Arm, 3:3 Holes per Arm, 4:4 Holes per Arm (2x2 Grid)]
holes_per_arm = 2;

// Hole Shape [round:Standard Round Holes, slotted:Elongated Adjustment Slots]
hole_shape = "round";

// Arm 1 (Horizontal X) Countersink Side [inside:Inside / Top Face (+Z), outside:Outside / Bottom Face (-Z), both:Both Faces (Double Countersunk), none:No Countersink (Flat Through-Hole)]
csk_side_arm1 = "inside";

// Arm 2 (Vertical Z / Stem Y) Countersink Side [inside:Inside Face (Facing Interior of L), outside:Outside Back Face, both:Both Faces (Double Countersunk), none:No Countersink (Flat Through-Hole)]
csk_side_arm2 = "inside";

/* [Hidden] */
$fn = 48;

L1 = max(15, arm_x);
L2 = max(15, arm_y);
W  = max(10, width);
T  = max(2.0, thick);
HD = max(2.0, hole_diam);
web_sz = min(corner_web_size, min(L1, L2) - W * 0.6);

echo(str("[SPEC] Bracket: ", bracket_type, "  |  Size: ", L1, "×", L2, "×", W, " mm  |  Arm1 CSK: ", csk_side_arm1, " / Arm2 CSK: ", csk_side_arm2));

// Universal Plate Hole Cutout running from Z=0 (Outside/Bottom Face) to Z=depth (Inside/Top Face)
module plate_hole(depth, csk_mode) {
    slot_l = (hole_shape == "slotted") ? HD * 1.8 : 0.01;
    csk_h  = min(depth * 0.55, HD * 0.52);
    csk_od = HD * 1.95;

    // Through hole/slot
    hull() {
        for (s = [-slot_l/2, slot_l/2])
            translate([s, 0, -0.1])
                cylinder(d = HD, h = depth + 0.2);
    }
    // Inside / Top Face Countersink (at Z = depth)
    if (csk_mode == "inside" || csk_mode == "both") {
        hull() {
            for (s = [-slot_l/2, slot_l/2])
                translate([s, 0, depth - csk_h])
                    cylinder(d1 = HD, d2 = csk_od, h = csk_h + 0.1);
        }
    }
    // Outside / Bottom Face Countersink (at Z = 0)
    if (csk_mode == "outside" || csk_mode == "both") {
        hull() {
            for (s = [-slot_l/2, slot_l/2])
                translate([s, 0, -0.1])
                    cylinder(d1 = csk_od, d2 = HD, h = csk_h + 0.1);
        }
    }
}

module arm_hole_pattern(arm_len, arm_w, plate_t, csk_mode) {
    usable = max(8, arm_len - plate_t - 6);
    if (holes_per_arm == 1) {
        translate([plate_t + usable * 0.55, 0, 0])
            plate_hole(plate_t, csk_mode);
    } else if (holes_per_arm == 2) {
        for (f = [0.30, 0.75])
            translate([plate_t + usable * f, 0, 0])
                plate_hole(plate_t, csk_mode);
    } else if (holes_per_arm == 3) {
        for (f = [0.22, 0.52, 0.82])
            translate([plate_t + usable * f, 0, 0])
                plate_hole(plate_t, csk_mode);
    } else {
        for (f = [0.32, 0.76])
            for (sy = [-arm_w * 0.24, arm_w * 0.24])
                translate([plate_t + usable * f, sy, 0])
                    plate_hole(plate_t, csk_mode);
    }
}

if (bracket_type == "l_ribbed") {
    difference() {
        union() {
            // Horizontal Arm 1 along +X (Z=0 is Outside Bottom, Z=T is Inside Top)
            translate([L1/2, 0, T/2])
                cuboid([L1, W, T], rounding = 2, edges = [TOP+RIGHT, BOTTOM+RIGHT]);
            // Vertical Arm 2 along +Z (X=0 is Outside Back, X=T is Inside Face)
            translate([T/2, 0, L2/2])
                cuboid([T, W, L2], rounding = 2, edges = [TOP+LEFT, TOP+RIGHT]);

            if (gusset_style != "none") {
                rib_t = max(2.8, T * 0.75);
                y_positions = (gusset_style == "both") ? [-W/2 + rib_t/2, W/2 - rib_t/2] : [0];
                for (ry = y_positions) {
                    translate([0, ry, 0])
                        rotate([90, 0, 0])
                            linear_extrude(height = rib_t, center = true)
                                polygon([[T, T], [L1 - 2, T], [T, L2 - 2]]);
                }
            }
        }
        // Holes on Horizontal Arm 1 (+X): local Z=0 is bottom outside, Z=T is top inside
        arm_hole_pattern(L1, W, T, csk_side_arm1);

        // Holes on Vertical Arm 2 (+Z):
        // Rotate([0, -90, 0]) maps local +X -> +Z (up the vertical arm), and local +Z -> -X!
        // So to map local Z=0 to X=0 (Outside Back) and local Z=T to X=T (Inside Face), we mirror Z before rotating!
        translate([0, 0, 0])
            rotate([0, -90, 0])
                mirror([0, 0, 1])
                    arm_hole_pattern(L2, W, T, csk_side_arm2);
    }

} else if (bracket_type == "l_flat") {
    // Flat Plate L-Bracket (lying flat on XY plane) with Squared, Rounded Concave Fillet, or Triangled 45° Web Corner!
    difference() {
        linear_extrude(height = T) {
            union() {
                // Horizontal bar along +X (0..L1, 0..W)
                offset(r = 2) offset(r = -2)
                union() {
                    square([L1, W]);
                    square([W, L2]);
                }
                // Interior 90° Corner Reinforcement at (W, W)
                if (inside_corner_style == "triangled" && web_sz > 0) {
                    translate([W - 0.1, W - 0.1])
                        polygon([[0, 0], [web_sz, 0], [0, web_sz]]);
                } else if (inside_corner_style == "rounded" && web_sz > 0) {
                    translate([W - 0.1, W - 0.1])
                        difference() {
                            square([web_sz, web_sz]);
                            translate([web_sz, web_sz]) circle(r = web_sz);
                        }
                }
            }
        }
        // Arm 1 Holes (along X)
        translate([0, W/2, 0])
            arm_hole_pattern(L1, W, T, csk_side_arm1);
        // Arm 2 Holes (along Y)
        translate([W/2, 0, 0])
            rotate([0, 0, 90])
                arm_hole_pattern(L2, W, T, csk_side_arm2);
    }

} else if (bracket_type == "t_plate") {
    // Flat T-Junction Joining Plate with Crisp Squared 90°, Concave Rounded Fillet, or Triangled 45° Corner Webs!
    difference() {
        linear_extrude(height = T) {
            union() {
                // Sharp union of crossbar and stem (only outer tips rounded, so interior 90° corners never pinch!)
                hull() {
                    translate([-L1 + 3, 0]) circle(r = 3);
                    translate([ L1 - 3, 0]) circle(r = 3);
                    translate([-L1 + 3, -W + 6]) circle(r = 3);
                    translate([ L1 - 3, -W + 6]) circle(r = 3);
                }
                // Ensure exact crossbar from Y = -W/2 to +W/2
                translate([-L1, -W/2]) square([L1 * 2, W]);
                // Stem extending up +Y from 0 to W/2 + L2
                translate([-W/2, 0]) square([W, W/2 + L2]);

                // Both Interior 90° Armpits at (X = ±W/2, Y = +W/2)
                if (inside_corner_style == "triangled" && web_sz > 0) {
                    for (side = [-1, 1])
                        scale([side, 1])
                            translate([W/2 - 0.1, W/2 - 0.1])
                                polygon([[0, 0], [web_sz, 0], [0, web_sz]]);
                } else if (inside_corner_style == "rounded" && web_sz > 0) {
                    for (side = [-1, 1])
                        scale([side, 1])
                            translate([W/2 - 0.1, W/2 - 0.1])
                                difference() {
                                    square([web_sz, web_sz]);
                                    translate([web_sz, web_sz]) circle(r = web_sz);
                                }
                }
            }
        }
        // Crossbar Holes (Arm 1 CSK)
        for (sx = [-L1 * 0.72, -L1 * 0.34, L1 * 0.34, L1 * 0.72])
            translate([sx, 0, 0]) plate_hole(T, csk_side_arm1);
        // Stem Holes (Arm 2 CSK)
        for (sy = [W * 0.85, W/2 + L2 * 0.68])
            translate([0, sy, 0]) plate_hole(T, csk_side_arm2);
    }

} else if (bracket_type == "corner_3way") {
    difference() {
        union() {
            cuboid([L1, W, T], rounding = 2, edges = "Z", anchor = BOTTOM+LEFT+FRONT);
            cuboid([W, L1, T], rounding = 2, edges = "Z", anchor = BOTTOM+LEFT+FRONT);
            cuboid([T, W, L2], rounding = 2, edges = "Y", anchor = BOTTOM+LEFT+FRONT);
            cuboid([W, T, L2], rounding = 2, edges = "X", anchor = BOTTOM+LEFT+FRONT);
        }
        translate([L1 * 0.65, W/2, 0]) plate_hole(T, csk_side_arm1);
        translate([W/2, L1 * 0.65, 0]) plate_hole(T, csk_side_arm1);
        translate([0, W/2, L2 * 0.65]) rotate([0, -90, 0]) mirror([0, 0, 1]) plate_hole(T, csk_side_arm2);
        translate([W/2, 0, L2 * 0.65]) rotate([90, 0, 0]) plate_hole(T, csk_side_arm2);
    }

} else if (bracket_type == "extrusion_gusset") {
    slot_tab_w = (W >= 35) ? 7.8 : 5.8;
    slot_tab_h = 2.2;
    difference() {
        union() {
            linear_extrude(height = W)
                polygon([[0, 0], [L1, 0], [L1, T], [T, L2], [0, L2]]);
            translate([L1/2, -slot_tab_h/2, W/2])
                cuboid([L1 * 0.6, slot_tab_h, slot_tab_w], chamfer = 0.5);
            translate([-slot_tab_h/2, L2/2, W/2])
                cuboid([slot_tab_h, L2 * 0.6, slot_tab_w], chamfer = 0.5);
        }
        translate([L1 * 0.55, 0, W/2])
            rotate([-90, 0, 0]) {
                cylinder(d = HD, h = L2 + 10);
                translate([0, 0, T]) cylinder(d = HD * 2.2, h = L2);
            }
        translate([0, L2 * 0.55, W/2])
            rotate([0, 90, 0]) {
                cylinder(d = HD, h = L1 + 10);
                translate([0, 0, T]) cylinder(d = HD * 2.2, h = L1);
            }
    }
}

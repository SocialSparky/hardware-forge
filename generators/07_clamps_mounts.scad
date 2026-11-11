include <BOSL2/std.scad>
include <BOSL2/screws.scad>

/* [1. Profile Shape & Clamp Style] */
// 1. Cross-Section Profile Shape [round:Round Pipe / Conduit / Hose, square:Square / Rectangular Tube or Strut]
profile_shape = "round";

// 2. Select Clamp / Mount Style [worm_band:Adjustable Tangential Band Clamp (Pinch Bolt + Nut), saddle_2hole:2-Hole Conduit / Tube Saddle Strap, p_clip_1hole:1-Hole Split-Ear P-Clip (Spreads Open & Tightens with Screw), snap_clip:Open Snap-In Conduit / Tube Clip, split_block:2-Piece Bolted Split Clamp Block, c_clamp:Heavy-Duty Threaded G-Clamp / C-Clamp]
clamp_type = "worm_band";

/* [2. Pipe or Tube Dimensions] */
// Round Pipe / Hose Outer Diameter [6:6 mm (1/4" Tube/Cable), 8:8 mm (5/16"), 10:10 mm (3/8"), 12.7:12.7 mm (1/2" OD Tube), 16:16 mm (5/8"), 17.9:17.9 mm (1/2" EMT Conduit), 20:20 mm (~3/4"), 21.3:21.3 mm (1/2" PVC Sch40), 23.4:23.4 mm (3/4" EMT Conduit), 25.4:25.4 mm (1" OD Tube), 26.7:26.7 mm (3/4" PVC Sch40), 29.5:29.5 mm (1" EMT Conduit), 32:32 mm (1-1/4" Vacuum Hose), 33.4:33.4 mm (1" PVC Sch40), 40:40 mm (~1-1/2"), 45:45 mm (1-3/4" Shop Vac), 50.8:50.8 mm (2" OD Pipe), 60:60 mm (2-3/8" Dust Hose), 75:75 mm (~3" Pipe)] @show_if(profile_shape=round)
round_od = 25.4;

// Square / Rectangular Tube Width - X Axis [10:10 mm Square, 12.7:1/2" Square Tube (12.7 mm), 15:15 mm (1515 Extrusion), 19.05:3/4" Square Tube (19.05 mm), 20:20 mm (2020 Extrusion), 25.4:1" Square Tube (25.4 mm), 30:30 mm (3030 Extrusion), 31.75:1-1/4" Square Tube (31.75 mm), 38.1:1-1/2" Square Tube (38.1 mm), 40:40 mm (4040 Extrusion), 41.3:1-5/8" Unistrut Channel (41.3 mm), 50.8:2" Square Tube (50.8 mm), 76.2:3" Square Tube (76.2 mm)] @show_if(profile_shape=square)
square_width = 25.4;

// Square / Rectangular Tube Height - Y Axis [0:Same as Width (True Square Tube), 10:10 mm, 12.7:1/2" (12.7 mm), 19.05:3/4" (19.05 mm), 20:20 mm, 20.6:13/16" Shallow Unistrut (20.6 mm), 25.4:1" (25.4 mm), 31.75:1-1/4" (31.75 mm), 38.1:1-1/2" (38.1 mm), 40:40 mm, 41.3:1-5/8" Standard Unistrut (41.3 mm), 50.8:2" (50.8 mm)] @show_if(profile_shape=square)
square_height = 0;

/* [3. Strap Width, Wall Thickness & Hardware] */
// Band / Strap Width (Auto-Widens if Mounting Screw is Larger!) [8:8 mm (Narrow), 12:12 mm (Standard), 16:16 mm (Wide), 20:20 mm (Heavy Duty), 25:25 mm (Extra Wide), 30:30 mm]
band_width = 14;

// Wall / Band Thickness [1.6:1.6 mm (Flexible Band - 4 Walls), 2.0:2.0 mm (Standard Strap), 2.8:2.8 mm (Rigid Saddle), 4.0:4.0 mm (Heavy Structural)]
wall_thick = 2.4;

// Mounting / Clamping Screw Size [M3:M3 (3.2mm Bore), M4:M4 (4.2mm Bore / #8 Screw), M5:M5 (5.2mm Bore / #10 Screw), M6:M6 (6.3mm Bore / 1/4" Bolt), M8:M8 (8.4mm Bore / 5/16" Bolt)] @show_if(clamp_type=worm_band|saddle_2hole|p_clip_1hole|split_block|snap_clip)
screw_spec = "M5";

// Include Printed Tightening Bolt & Nut on Build Plate (For Band/Split Clamps) @show_if(clamp_type=worm_band|split_block)
include_hardware = true;

// Countersink Mounting Screw Holes @show_if(clamp_type=saddle_2hole|p_clip_1hole|snap_clip)
countersink_holes = true;

/* [4. C-Clamp Specific Options] */
// C-Clamp Throat Depth [20:20 mm, 30:30 mm, 40:40 mm, 50:50 mm, 65:65 mm, 80:80 mm] @show_if(clamp_type=c_clamp)
throat_depth = 35;

// C-Clamp Frame Thickness [8:8 mm (Compact), 12:12 mm (Standard), 16:16 mm (Heavy Duty), 20:20 mm (Beast Mode)] @show_if(clamp_type=c_clamp)
c_frame_thick = 12;

/* [5. 3D Print Clearance] */
// Printer Clearance / Fit Slop [0.12:0.12 mm (Snug), 0.16:0.16 mm (Standard PLA/PETG), 0.22:0.22 mm (Easy Fit)]
printer_slop = 0.16;

/* [Hidden] */
$fn = 64;
$slop = printer_slop;

s_info = screw_info(screw_spec);
s_diam = struct_val(s_info, "diameter");
hole_d = s_diam + (printer_slop * 2.5);
csk_d  = hole_d * 2.0;
csk_h  = hole_d * 0.52;
n_info = nut_info(screw_spec, shape = "hex", thickness = "normal");
nut_af = struct_val(n_info, "width") + (printer_slop * 1.5);
nut_h  = struct_val(n_info, "thickness") + 0.4;

// Strictly separate Round vs Square dimensions
D  = (profile_shape == "square") ? max(4, square_width) : max(4, round_od);
HY = (profile_shape == "square") ? ((square_height > 0) ? max(4, square_height) : D) : D;
T  = max(1.2, wall_thick);

min_required_w = (clamp_type == "snap_clip" || clamp_type == "saddle_2hole" || clamp_type == "p_clip_1hole")
                 ? ((countersink_holes ? csk_d : hole_d) + 6.4)
                 : 6.0;
W = max(band_width, ceil(min_required_w));

width_note = (W > band_width) ? str(" (Auto-Widened to ", W, "mm for ", screw_spec, ")") : str(" (", W, "mm Wide)");
shape_note = (profile_shape == "square" && clamp_type != "c_clamp") ? str(D, "×", HY, " mm Square/Rect") : str(D, " mm Round");
echo(str("[SPEC] ", clamp_type, "  |  Profile: ", shape_note, width_note, "  |  Screw: ", screw_spec));

module drill_mounting_hole(pos_x, top_y, z_mid, depth_down) {
    translate([pos_x, top_y, z_mid]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h = depth_down + 4);
            if (countersink_holes) {
                cylinder(d1 = csk_d, d2 = hole_d, h = csk_h + 0.05);
            }
        }
        rotate([-90, 0, 0])
            cylinder(d = countersink_holes ? (csk_d + 0.4) : (hole_d + 0.4), h = max(D, HY) * 0.45);
    }
}

if (clamp_type == "worm_band") {
    // Supports BOTH Round Pipe/Hose AND Square/Rectangular Tube!
    flex_t = min(T, max(1.6, min(D, HY) * 0.07));
    gap_span = max(3.5, D * 0.14);
    lug_l = max(12, s_diam * 2.4);
    lug_d = max(10, s_diam * 2.2);
    top_y = HY / 2;

    difference() {
        union() {
            linear_extrude(height = W) {
                if (profile_shape == "square") {
                    // Square / Rectangular Band with rounded outer corners and corner flex-relief notches so it cinches around square stock!
                    difference() {
                        offset(r = flex_t * 1.2)
                            square([D, HY], center = true);
                        square([D, HY], center = true);
                        // Open top clamping gap (+Y wall)
                        translate([0, top_y + flex_t])
                            square([gap_span, flex_t * 4], center = true);
                        // Small inner corner relief radii (1.2mm) so sharp square tube corners seat cleanly and the band flexes at the corners
                        for (sx = [-D/2, D/2])
                            for (sy = [-HY/2, HY/2])
                                translate([sx, sy])
                                    circle(r = 1.0, $fn = 20);
                    }
                } else {
                    // Round Band
                    difference() {
                        circle(d = D + flex_t * 2);
                        circle(d = D);
                        translate([0, D/2 + flex_t])
                            square([gap_span, D * 0.65], center = true);
                    }
                }
            }

            // Left & Right Tangential Pinch Lugs at Top (+Y)
            for (side = [-1, 1]) {
                translate([side * (gap_span/2 + lug_l/2 - 0.5), top_y + lug_d/2 - flex_t/2, W/2])
                    cuboid([lug_l, lug_d, W], rounding = 2.0, edges = "Z");
            }
        }

        // Tangential Pinch Bolt Bore
        translate([0, top_y + lug_d/2, W/2])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = gap_span + lug_l * 2 + 10, center = true);

        // Captive Hex Nut Trap in Left Lug (-X)
        translate([-(gap_span/2 + lug_l - nut_h/2 + 0.2), top_y + lug_d/2, W/2])
            rotate([0, 90, 0])
                linear_extrude(height = nut_h + 1, center = true)
                    hexagon(id = nut_af);
    }

    if (include_hardware) {
        bolt_len = round(gap_span + lug_l * 2 + 6);
        hw_x = D/2 + lug_l + 16;
        translate([hw_x, 0, 0]) {
            cylinder(d = s_diam * 2.4, h = 6, chamfer = 0.6, anchor = BOTTOM);
            for (a = [0 : 30 : 330])
                rotate([0, 0, a])
                translate([s_diam * 1.2, 0, 3])
                    cylinder(d = 1.6, h = 5.2, center = true, $fn = 16);
            up(6)
                screw(spec = screw_spec, head = "none", length = bolt_len, bevel = true, anchor = BOTTOM, orient = UP);
        }
        translate([hw_x, 22, 0])
            nut(spec = screw_spec, shape = "hex", thickness = "normal", bevel = true, anchor = BOTTOM);
    }

} else if (clamp_type == "c_clamp") {
    jaw_open = max(15, D);
    throat   = max(15, throat_depth);
    beam_w   = max(14, jaw_open * 0.28 + 10);
    thick    = max(8, c_frame_thick);
    c_screw  = (thick >= 14) ? "M12" : "M10";

    outer_h = jaw_open + beam_w * 2;
    outer_w = throat + beam_w + 10;

    difference() {
        union() {
            linear_extrude(height = thick)
                difference() {
                    offset(r = 5) square([outer_w - 10, outer_h - 10], center = true);
                    translate([beam_w/2 + 2, 0])
                        offset(r = 3) square([throat + 4, jaw_open], center = true);
                }
            translate([outer_w/2 - 9, jaw_open/2 + beam_w/2, thick/2])
                rotate([-90, 0, 0])
                    cylinder(d = thick * 1.35, h = beam_w, center = true);
        }
        translate([outer_w/2 - 9, jaw_open/2 + beam_w/2, thick/2])
            rotate([90, 0, 0])
                screw(spec = c_screw, head = "none", length = beam_w + 4, thread = true, bevel = false, anchor = CENTER);
    }

    screw_len = jaw_open + beam_w + 6;
    translate([outer_w/2 + 24, 0, 0]) {
        cylinder(d = 26, h = 12, chamfer = 1.2, anchor = BOTTOM);
        for (a = [0 : 20 : 340])
            rotate([0, 0, a])
            translate([13, 0, 6])
                cylinder(d = 2.2, h = 10, center = true, $fn = 16);
        up(12)
            screw(spec = c_screw, head = "none", length = screw_len, bevel = true, anchor = BOTTOM, orient = UP);
    }

} else if (clamp_type == "saddle_2hole") {
    ear_len = max(14, hole_d * 2.8);
    foot_t  = max(T * 1.25, csk_h + 1.2);

    difference() {
        linear_extrude(height = W) {
            if (profile_shape == "square") {
                union() {
                    difference() {
                        translate([-D/2 - T, 0])
                            offset(r = 2) offset(r = -2)
                            square([D + 2*T, HY + T]);
                        translate([-D/2, -1])
                            square([D, HY + 1]);
                    }
                    translate([-(D/2 + T + ear_len), 0]) square([ear_len + T, foot_t]);
                    translate([D/2, 0]) square([ear_len + T, foot_t]);
                }
            } else {
                r_in = D / 2;
                r_out = r_in + T;
                translate([0, r_in])
                union() {
                    difference() {
                        circle(r = r_out);
                        circle(r = r_in);
                        translate([0, -r_out]) square([r_out * 2.5, r_out * 2], center = true);
                    }
                    translate([-r_out, -r_in]) square([T, r_in]);
                    translate([ r_in,  -r_in]) square([T, r_in]);
                    translate([r_in, -r_in]) square([ear_len + T, foot_t]);
                    translate([-(r_out + ear_len), -r_in]) square([ear_len + T, foot_t]);
                }
            }
        }

        for (side = [-1, 1]) {
            hx = side * (D/2 + T + ear_len * 0.52);
            drill_mounting_hole(hx, foot_t, W/2, foot_t + 2);
        }
    }

} else if (clamp_type == "p_clip_1hole") {
    ear_len   = max(15, hole_d * 2.8);
    split_gap = max(2.0, min(4.0, D * 0.08));
    foot_t    = max(T * 1.25, csk_h + 1.2);

    difference() {
        linear_extrude(height = W) {
            if (profile_shape == "square") {
                union() {
                    difference() {
                        translate([-D/2 - T, 0])
                            offset(r = 2) offset(r = -2)
                            square([D + 2*T, HY + foot_t + T]);
                        translate([-D/2, foot_t])
                            square([D, HY]);
                        translate([D/2 - 1, foot_t])
                            square([T + 4, split_gap]);
                    }
                    translate([0, 0])
                        square([D/2 + T + ear_len, foot_t]);
                    translate([D/2, foot_t + split_gap])
                        square([T + ear_len, foot_t]);
                }
            } else {
                r_in  = D / 2;
                r_out = r_in + T;
                translate([0, r_out])
                union() {
                    difference() {
                        circle(r = r_out);
                        circle(r = r_in);
                        translate([r_in * 0.85, -r_in * 0.55])
                            square([r_out * 1.2, r_in * 1.1], center = true);
                    }
                    translate([0, -r_out])
                        square([r_out + ear_len, foot_t]);
                    upper_ear_y = -r_out + foot_t + split_gap;
                    translate([r_in, upper_ear_y])
                        square([T, abs(upper_ear_y) + 0.5]);
                    translate([r_in, upper_ear_y])
                        square([ear_len + T, foot_t]);
                }
            }
        }

        hx = D/2 + T + ear_len * 0.52;
        upper_top_y = foot_t * 2 + split_gap;
        drill_mounting_hole(hx, upper_top_y, W/2, upper_top_y + 2);
    }

} else if (clamp_type == "split_block") {
    block_w = D + (hole_d * 3.4) + 14;
    half_h  = HY/2 + T * 2.0;
    clamp_gap = 0.8;

    for (part = [0, 1]) {
        y_off = part * (W + 10);
        translate([0, y_off, 0])
        difference() {
            cuboid([block_w, W, half_h - clamp_gap/2], rounding = 2.0, edges = "Z", anchor = BOTTOM);
            if (profile_shape == "square") {
                translate([0, 0, half_h - clamp_gap/2])
                    cuboid([D + printer_slop, W + 4, HY + printer_slop], anchor = CENTER);
            } else {
                translate([0, 0, half_h - clamp_gap/2])
                    rotate([90, 0, 0])
                        cylinder(d = D + printer_slop, h = W + 4, center = true);
            }
            for (side = [-1, 1]) {
                bx = side * (D/2 + hole_d * 0.95 + 3.5);
                translate([bx, 0, -0.1])
                    cylinder(d = hole_d, h = half_h + 2, anchor = BOTTOM);
                if (part == 0) {
                    translate([bx, 0, -0.1])
                        linear_extrude(height = nut_h)
                            hexagon(id = nut_af);
                }
            }
        }
    }

} else if (clamp_type == "snap_clip") {
    base_h = max(5.5, csk_h + 2.8);
    arm_t  = T * 1.35;

    difference() {
        linear_extrude(height = W) {
            if (profile_shape == "square") {
                snap_lip = min(2.2, D * 0.08);
                throat_w = D - (snap_lip * 2);
                difference() {
                    union() {
                        translate([-(D/2 + arm_t), 0])
                            offset(r = 1.8) offset(r = -1.8)
                            square([D + arm_t * 2, base_h + HY + arm_t]);
                    }
                    translate([-D/2, base_h])
                        square([D, HY]);
                    translate([-throat_w/2, base_h + HY - 0.1])
                        square([throat_w, arm_t + 2]);
                    polygon([
                        [-throat_w/2, base_h + HY + 0.5],
                        [ throat_w/2, base_h + HY + 0.5],
                        [ D/2 + 1.0,  base_h + HY + arm_t + 0.5],
                        [-D/2 - 1.0,  base_h + HY + arm_t + 0.5]
                    ]);
                }
            } else {
                r_in  = D / 2;
                r_out = r_in + arm_t;
                difference() {
                    union() {
                        translate([0, base_h + r_in]) circle(r = r_out);
                        translate([0, (base_h + r_in * 0.35)/2])
                            square([max(D * 0.85, csk_d + 6), base_h + r_in * 0.35], center = true);
                    }
                    translate([0, base_h + r_in]) circle(r = r_in);
                    translate([0, base_h + r_in + r_out * 0.95])
                        rotate([0, 0, 45])
                            square([r_out * 1.35, r_out * 1.35], center = true);
                }
            }
        }

        drill_mounting_hole(0, base_h, W/2, base_h + 2);
    }
}

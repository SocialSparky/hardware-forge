include <BOSL2/std.scad>
include <BOSL2/screws.scad>

/* [1. Knob / Handle Type & Fastener Size] */
// Select Knob or Handle Style [star_knob:Ergonomic Star Clamping Knob (4 to 8 Lobes), knurled_wheel:Knurled Thumbwheel / Finger Rosette Cap, t_wing_knob:Wing / Butterfly Thumb Nut Knob, u_handle:Heavy-Duty U-Pull Equipment / Enclosure Handle]
knob_type = "star_knob";

// Measurement System [metric:Metric (M3 – M12), imperial:Imperial (#6 – 1/2")]
unit_system = "metric";

// Metric Bolt / Nut Size [M3:M3 (5.5mm Hex), M4:M4 (7.0mm Hex), M5:M5 (8.0mm Hex), M6:M6 (10.0mm Hex), M8:M8 (13.0mm Hex), M10:M10 (16.0mm Hex), M12:M12 (18.0mm Hex)] @show_if(unit_system=metric)
metric_spec = "M6";

// Imperial Bolt / Nut Size [#6-32:#6-32 (5/16" Hex), #8-32:#8-32 (11/32" Hex), #10-24:#10-24 (3/8" Hex), 1/4-20:1/4"-20 (7/16" Hex), 5/16-18:5/16"-18 (1/2" Hex), 3/8-16:3/8"-16 (9/16" Hex), 1/2-13:1/2"-13 (3/4" Hex)] @show_if(unit_system=imperial)
imperial_spec = "1/4-20";

// Fastener Connection Style [hex_trap_top:Press-Fit Hex Nut / Bolt Head Trap on Top, hex_trap_bottom:Press-Fit Hex Trap on Bottom (Flush Top), printed_threads:Direct 3D-Printed Female Threads Inside Knob] @show_if(knob_type=star_knob|knurled_wheel|t_wing_knob)
insert_mode = "hex_trap_top";

/* [2. Knob & Handle Dimensions] */
// Knob Outer Diameter / Handle Hole-to-Hole Span [25:25 mm (~1"), 32:32 mm (~1-1/4"), 40:40 mm (~1-1/2"), 50:50 mm (~2"), 65:65 mm (~2-1/2"), 80:80 mm (~3"), 100:100 mm (~4" Handle), 120:120 mm (~4-3/4" Handle)]
outer_size = 40;

// Number of Star Lobes [3:3-Lobe Triangular Knob, 4:4-Lobe Cross Knob, 5:5-Lobe Star Knob, 6:6-Lobe Classic Star Knob, 8:8-Lobe Rosette Knob] @show_if(knob_type=star_knob)
lobes = 5;

// Neck / Standoff Collar Height [0:0 mm (No Collar), 4:4 mm, 8:8 mm (Standard Collar), 12:12 mm (Tall Standoff Collar), 18:18 mm] @show_if(knob_type=star_knob|knurled_wheel|t_wing_knob)
collar_h = 8;

// Grip Head Thickness [10:10 mm, 12:12 mm, 15:15 mm, 18:18 mm, 22:22 mm]
grip_h = 14;

/* [3. 3D Print Clearance] */
// Hex Trap / Thread Fit Clearance [0.08:0.08 mm (Tight Press Fit), 0.14:0.14 mm (Standard Snug Fit), 0.20:0.20 mm (Easy Drop-In Fit)]
printer_slop = 0.14;

/* [Hidden] */
$fn = 64;
$slop = printer_slop;

spec_str = (unit_system == "metric") ? metric_spec : imperial_spec;
s_info = screw_info(spec_str);
nom_d = struct_val(s_info, "diameter");
n_info = nut_info(spec_str, shape = "hex", thickness = "normal");
nut_af = struct_val(n_info, "width") + (printer_slop * 1.4);
nut_h  = struct_val(n_info, "thickness") + 0.6;

OD = max(20, outer_size);
total_h = collar_h + grip_h;

echo(str("[SPEC] Knob/Handle: ", knob_type, "  |  Fastener: ", spec_str, " (", round(nut_af*10)/10, " mm Hex Trap)  |  Size: ", OD, " mm"));

module center_fastener_cut() {
    if (insert_mode == "printed_threads") {
        down(0.1)
            screw(spec = spec_str, head = "none", length = total_h + 0.2, thread = true, bevel = true, anchor = BOTTOM);
    } else {
        // Through clearance hole for bolt shaft
        down(0.1)
            cylinder(d = nom_d + printer_slop * 2.5, h = total_h + 0.2, anchor = BOTTOM);
        // Hex Nut / Hex Bolt Head Pocket
        if (insert_mode == "hex_trap_top") {
            up(total_h - nut_h)
                linear_extrude(height = nut_h + 1)
                    hexagon(id = nut_af);
        } else {
            down(0.1)
                linear_extrude(height = nut_h + 0.1)
                    hexagon(id = nut_af);
        }
    }
}

if (knob_type == "star_knob") {
    lobe_r = OD * 0.16;
    valley_r = OD * 0.13;
    ring_r = (OD / 2) - lobe_r;

    difference() {
        union() {
            if (collar_h > 0) {
                cylinder(d = max(nut_af * 1.45, OD * 0.45), h = collar_h + 1, chamfer1 = 0.6, anchor = BOTTOM);
            }
            up(collar_h)
            linear_extrude(height = grip_h) {
                offset(r = valley_r) offset(r = -valley_r) {
                    union() {
                        circle(r = ring_r * 0.82);
                        for (i = [0 : lobes - 1]) {
                            rotate([0, 0, i * (360 / lobes)])
                                translate([ring_r, 0])
                                    circle(r = lobe_r);
                        }
                    }
                }
            }
        }
        center_fastener_cut();
    }

} else if (knob_type == "knurled_wheel") {
    difference() {
        union() {
            if (collar_h > 0)
                cylinder(d = max(nut_af * 1.45, OD * 0.48), h = collar_h + 1, chamfer1 = 0.6, anchor = BOTTOM);
            up(collar_h) {
                cylinder(d = OD, h = grip_h, chamfer = 1.0, anchor = BOTTOM);
                for (a = [0 : 12 : 348])
                    rotate([0, 0, a])
                    translate([OD/2, 0, grip_h/2])
                        cylinder(d = 2.0, h = grip_h - 1.6, center = true, $fn = 16);
            }
        }
        center_fastener_cut();
    }

} else if (knob_type == "t_wing_knob") {
    difference() {
        union() {
            cylinder(d = max(nut_af * 1.5, 16), h = total_h, chamfer1 = 0.6, anchor = BOTTOM);
            up(collar_h)
                cuboid([OD, max(12, nut_af * 1.25), grip_h], rounding = 4, edges = "Z", anchor = BOTTOM);
        }
        center_fastener_cut();
    }

} else if (knob_type == "u_handle") {
    // Prints flat on XY bed for maximum pull strength, with recessed M-bolt / Nut pockets in both feet!
    span = max(50, OD);
    bar_d = max(12, grip_h);
    clearance_h = max(28, span * 0.35);

    difference() {
        union() {
            hull() {
                translate([-span/2, clearance_h, 0]) cylinder(d = bar_d, h = bar_d, chamfer = 1.5, anchor = BOTTOM);
                translate([ span/2, clearance_h, 0]) cylinder(d = bar_d, h = bar_d, chamfer = 1.5, anchor = BOTTOM);
            }
            for (sx = [-span/2, span/2]) {
                hull() {
                    translate([sx, 0, 0]) cylinder(d = bar_d * 1.25, h = bar_d, chamfer = 1.0, anchor = BOTTOM);
                    translate([sx, clearance_h, 0]) cylinder(d = bar_d, h = bar_d, chamfer = 1.5, anchor = BOTTOM);
                }
            }
        }
        for (sx = [-span/2, span/2]) {
            translate([sx, -1, bar_d/2])
                rotate([-90, 0, 0]) {
                    cylinder(d = nom_d + printer_slop * 2.5, h = clearance_h + bar_d + 4);
                    translate([0, 0, 12])
                        cylinder(d = nut_af * 1.25, h = clearance_h + bar_d);
                }
        }
    }
}

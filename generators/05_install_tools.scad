include <BOSL2/std.scad>
include <BOSL2/screws.scad>

/* [1. Tool Type & Measurement System] */
// Select Printable Tool or Master Bit System [master_screwdriver:Master 1/4" Bit-Holding Screwdriver Handle, master_thandle:Master 1/4" Bit-Holding T-Handle Driver, hex_bit:1/4" Hex Insert Bit (Allen / Torx / Phillips / Flat), screwdriver_direct:One-Piece Fluted Screwdriver (Allen / Torx / Phillips / Flat), t_driver:One-Piece Ergonomic T-Handle Driver, l_key:Classic 90° L-Key (Mitered Bend - Prints Flat), wrench_combo:Combination Open + 12-Pt Box Wrench, wrench_adjustable:Adjustable Spanner Wrench (Sliding Jaw + Lock Nut), nut_driver:Knurled Finger Nut Driver Socket, bit_socket:1/4" Hex-Shank Nut Driver Socket Bit]
tool_category = "master_screwdriver";

// Measurement System (For Hex & Wrench Sizes) [metric:Metric (mm), imperial:Imperial (Inches)]
unit_system = "metric";

/* [2. Driver Tip Profile & Size (For Bits, Screwdrivers, T-Handles & L-Keys)] */
// Driver Tip Type [hex:Allen / Hex Key Tip, torx:Torx 6-Point Star Tip, phillips:Phillips 4-Wing Cross Tip, slot:Flat Slotted Blade Tip] @show_if(tool_category=hex_bit|screwdriver_direct|t_driver|l_key)
tip_type = "torx";

// Metric Allen Key Tip Size [1.3:1.3 mm (M2 Button), 1.5:1.5 mm (M2 Socket), 2.0:2.0 mm (M2.5 Socket / M3 Button), 2.5:2.5 mm (M3 Socket / M4 Button), 3.0:3.0 mm (M4 Socket / M5 Button), 4.0:4.0 mm (M5 Socket / M6 Button), 5.0:5.0 mm (M6 Socket / M8 Button), 6.0:6.0 mm (M8 Socket), 8.0:8.0 mm (M10 Socket), 10.0:10.0 mm (M12 Socket), 12.0:12.0 mm (M14 Socket)] @show_if(tool_category=hex_bit|screwdriver_direct|t_driver|l_key, tip_type=hex, unit_system=metric)
metric_allen_tip = 5.0;

// Imperial Allen Key Tip Size [1.5875:1/16" (1.59 mm), 1.9844:5/64" (1.98 mm), 2.38125:3/32" (2.38 mm - #4 Socket), 2.7781:7/64" (2.78 mm - #6 Socket), 3.175:1/8" (3.18 mm), 3.5719:9/64" (3.57 mm - #8 Socket), 3.96875:5/32" (3.97 mm - #10 Socket), 4.7625:3/16" (4.76 mm - 1/4" Socket), 5.55625:7/32" (5.56 mm), 6.35:1/4" (6.35 mm - 5/16" Socket), 7.9375:5/16" (7.94 mm - 3/8" Socket), 9.525:3/8" (9.53 mm - 1/2" Socket)] @show_if(tool_category=hex_bit|screwdriver_direct|t_driver|l_key, tip_type=hex, unit_system=imperial)
imperial_allen_tip = 4.7625;

// Torx Star Tip Size [T6:T6 Torx (1.70 mm OD - M2), T8:T8 Torx (2.31 mm OD - M2.5), T10:T10 Torx (2.74 mm OD - M3 / #4), T15:T15 Torx (3.27 mm OD - #6), T20:T20 Torx (3.86 mm OD - M4 / #8), T25:T25 Torx (4.43 mm OD - M5 / #10), T27:T27 Torx (4.99 mm OD), T30:T30 Torx (5.52 mm OD - M6 / 1/4"), T40:T40 Torx (6.65 mm OD - M8 / 5/16"), T45:T45 Torx (7.82 mm OD - M8 / 3/8"), T50:T50 Torx (8.83 mm OD - M10 / 7/16"), T55:T55 Torx (11.22 mm OD - M12 / 1/2"), T60:T60 Torx (13.25 mm OD - M14 / 5/8")] @show_if(tool_category=hex_bit|screwdriver_direct|t_driver|l_key, tip_type=torx)
torx_tip_code = "T30";

// Phillips Cross Tip Size [PH0:PH0 (Micro - M2), PH1:PH1 (Small - M2.5/M3/#4), PH2:PH2 (Standard - M4/M5/#6-#10), PH3:PH3 (Large - M6/M8/1/4"/5/16"), PH4:PH4 (Heavy - M10+/3/8"+)] @show_if(tool_category=hex_bit|screwdriver_direct|t_driver|l_key, tip_type=phillips)
phillips_tip_code = "PH2";

// Slotted Blade Thickness [0.8:0.8 mm Fine Blade, 1.0:1.0 mm Blade, 1.2:1.2 mm Standard Blade, 1.6:1.6 mm Medium Blade, 2.0:2.0 mm Wide Blade, 2.5:2.5 mm Heavy Blade] @show_if(tool_category=hex_bit|screwdriver_direct|t_driver|l_key, tip_type=slot)
slot_blade_thick = 1.2;

// Slotted Blade Width [3.0:3.0 mm Wide, 4.0:4.0 mm Wide, 5.0:5.0 mm Wide, 6.0:6.0 mm Wide, 8.0:8.0 mm Wide, 10.0:10.0 mm Wide] @show_if(tool_category=hex_bit|screwdriver_direct|t_driver|l_key, tip_type=slot)
slot_blade_span = 5.0;

/* [3. Handle & Shaft Dimensions] */
// Handle Size Class [compact:Compact / Precision (75 mm Handle), standard:Standard Workshop (95 mm Handle), heavy:Heavy High-Torque (115 mm Handle)] @show_if(tool_category=master_screwdriver|master_thandle|screwdriver_direct|t_driver)
handle_size = "standard";

// Blade / Bit Tip Reach Length [12:12 mm (Stubby Bit), 20:20 mm (Standard Bit), 35:35 mm (Extended Bit / Short Blade), 55:55 mm (Standard Screwdriver Blade), 80:80 mm (Long Reach Blade)] @show_if(tool_category=hex_bit|screwdriver_direct|t_driver|l_key)
shaft_len = 20;

/* [4. Wrench & Nut Socket Sizing] */
// Metric Wrench / Socket Across-Flats Size [4.0:4.0 mm (M2 Hex), 5.0:5.0 mm (M2.5 Hex), 5.5:5.5 mm (M3 Hex), 7.0:7.0 mm (M4 Hex), 8.0:8.0 mm (M5 Hex), 10.0:10.0 mm (M6 Hex), 13.0:13.0 mm (M8 Hex), 15.0:15.0 mm (M10 Alt), 16.0:16.0 mm (M10 ISO), 17.0:17.0 mm (M10 DIN), 18.0:18.0 mm (M12 ISO), 19.0:19.0 mm (M12 DIN), 21.0:21.0 mm (M14 Hex), 24.0:24.0 mm (M16 Hex), 30.0:30.0 mm (M20 Hex)] @show_if(tool_category=wrench_combo|nut_driver|bit_socket, unit_system=metric)
metric_wrench_af = 10.0;

// Imperial Wrench / Socket Across-Flats Size [6.35:1/4" (6.35 mm - #4 Hex), 7.9375:5/16" (7.94 mm - #6 Hex), 8.73125:11/32" (8.73 mm - #8 Hex), 9.525:3/8" (9.53 mm - #10 Hex), 11.1125:7/16" (11.11 mm - 1/4" Hex), 12.7:1/2" (12.70 mm - 5/16" Hex), 14.2875:9/16" (14.29 mm - 3/8" Hex), 15.875:5/8" (15.88 mm - 7/16" Hex), 19.05:3/4" (19.05 mm - 1/2" Hex), 23.8125:15/16" (23.81 mm - 5/8" Hex), 28.575:1-1/8" (28.58 mm - 3/4" Hex)] @show_if(tool_category=wrench_combo|nut_driver|bit_socket, unit_system=imperial)
imperial_wrench_af = 11.1125;

// Adjustable Wrench Size Class [compact:Compact (0–18 mm / 0–3/4" Jaw Capacity), standard:Standard (0–28 mm / 0–1-1/8" Jaw Capacity), heavy:Heavy Duty (0–40 mm / 0–1-1/2" Jaw Capacity)] @show_if(tool_category=wrench_adjustable)
adj_size_class = "standard";

/* [5. 3D Print Clearance] */
// Tool Fit Clearance [0.08:Tight Fit (0.08 mm), 0.12:Fine Fit (0.12 mm), 0.16:Standard PLA/PETG Fit (0.16 mm), 0.22:Loose / Easy Fit (0.22 mm)]
printer_slop = 0.16;

/* [Hidden] */
$fn = 64;
$slop = printer_slop;

target_af = (unit_system == "metric") ? metric_wrench_af : imperial_wrench_af;
jaw_af = target_af + (printer_slop * 2.0);
hex_tip_sz = (unit_system == "metric") ? metric_allen_tip : imperial_allen_tip;

function torx_od_lookup(t_code) =
    (t_code == "T6")  ? 1.70 :
    (t_code == "T8")  ? 2.31 :
    (t_code == "T10") ? 2.74 :
    (t_code == "T15") ? 3.27 :
    (t_code == "T20") ? 3.86 :
    (t_code == "T25") ? 4.43 :
    (t_code == "T27") ? 4.99 :
    (t_code == "T30") ? 5.52 :
    (t_code == "T40") ? 6.65 :
    (t_code == "T45") ? 7.82 :
    (t_code == "T50") ? 8.83 :
    (t_code == "T55") ? 11.22 : 13.25;

// True 6-Lobe Hexalobular Torx 2D Profile
module custom_torx_2d(od) {
    R_out = od / 2;
    R_in  = R_out * 0.715;
    lobe_d = R_out * 0.37;
    flute_d = R_out * 0.31;
    difference() {
        union() {
            circle(r = R_in, $fn = 48);
            for (a = [0 : 60 : 300])
                rotate([0, 0, a])
                    translate([R_out - lobe_d/2, 0])
                        circle(d = lobe_d, $fn = 32);
        }
        for (a = [30 : 60 : 330])
            rotate([0, 0, a])
                translate([R_in + flute_d * 0.33, 0])
                    circle(d = flute_d, $fn = 32);
    }
}

// 2D Cross-Section for Allen & Torx (used in L-Key miter bend & linear extrusions)
module driver_tip_2d() {
    if (tip_type == "torx") {
        t_od = max(1.2, torx_od_lookup(torx_tip_code) - (printer_slop * 0.85));
        custom_torx_2d(t_od);
    } else if (tip_type == "slot") {
        square([slot_blade_span - printer_slop, max(0.5, slot_blade_thick - printer_slop * 0.6)], center = true);
    } else if (tip_type == "phillips") {
        span = ((phillips_tip_code == "PH0") ? 2.0 :
                (phillips_tip_code == "PH1") ? 3.0 :
                (phillips_tip_code == "PH2") ? 4.6 :
                (phillips_tip_code == "PH3") ? 6.2 : 7.8) - (printer_slop * 0.8);
        arm_w = max(0.6, span * 0.23 - printer_slop * 0.5);
        union() {
            square([span, arm_w], center = true);
            square([arm_w, span], center = true);
            rotate([0, 0, 45]) square([arm_w * 1.35, arm_w * 1.35], center = true);
        }
    } else {
        hexagon(id = max(1.0, hex_tip_sz - printer_slop * 0.85));
    }
}

// Full 3D Male Driver Shaft + Tip (Supports tapered Phillips, wedged Slotted, 6-lobe Torx, and Hex!)
module driver_shaft_3d(len) {
    if (tip_type == "phillips") {
        span = ((phillips_tip_code == "PH0") ? 2.0 :
                (phillips_tip_code == "PH1") ? 3.0 :
                (phillips_tip_code == "PH2") ? 4.6 :
                (phillips_tip_code == "PH3") ? 6.2 : 7.8) - (printer_slop * 0.8);
        arm_w = max(0.6, span * 0.23 - printer_slop * 0.5);
        taper_h = min(len * 0.45, span * 1.3);
        stem_h = max(1, len - taper_h);

        // Round reinforced shaft up to the 4-wing Phillips tip
        cylinder(d = span, h = stem_h, anchor = BOTTOM);
        up(stem_h) {
            // 4-wing tapered Phillips male point (No pyramid!)
            hull() {
                linear_extrude(height = 0.1) square([span, arm_w], center = true);
                up(taper_h) linear_extrude(height = 0.1) square([span * 0.30, arm_w * 0.55], center = true);
            }
            hull() {
                linear_extrude(height = 0.1) square([arm_w, span], center = true);
                up(taper_h) linear_extrude(height = 0.1) square([arm_w * 0.55, span * 0.30], center = true);
            }
            rotate([0, 0, 45])
            hull() {
                linear_extrude(height = 0.1) square([arm_w * 1.4, arm_w * 1.4], center = true);
                up(taper_h * 0.88) linear_extrude(height = 0.1) square([arm_w * 0.5, arm_w * 0.5], center = true);
            }
        }
    } else if (tip_type == "slot") {
        w = slot_blade_span - printer_slop;
        t = max(0.6, slot_blade_thick - printer_slop * 0.6);
        wedge_h = min(len * 0.5, w * 1.5);
        stem_h = max(1, len - wedge_h);
        cylinder(d = w, h = stem_h, anchor = BOTTOM);
        up(stem_h)
        hull() {
            linear_extrude(height = 0.1) circle(d = w);
            up(wedge_h) linear_extrude(height = 0.1) square([w, t], center = true);
        }
    } else {
        linear_extrude(height = len)
            driver_tip_2d();
    }
}

// Fluted Ergonomic Screwdriver Handle Module (Prints standing upright with zero supports)
module fluted_screwdriver_handle(h_scale = 1.0, hex_socket_top = false) {
    h_len = 92 * h_scale;
    h_od  = 28 * h_scale;
    neck_od = 16 * h_scale;
    ferrule_od = 18 * h_scale;

    difference() {
        union() {
            // Domed base + main grip barrel
            cylinder(d1 = h_od * 0.72, d2 = h_od, h = h_len * 0.15, anchor = BOTTOM);
            up(h_len * 0.15)
                cylinder(d = h_od, h = h_len * 0.48, anchor = BOTTOM);
            // Tapered finger neck
            up(h_len * 0.63)
                cylinder(d1 = h_od, d2 = neck_od, h = h_len * 0.20, anchor = BOTTOM);
            // Flared top bolster / ferrule
            up(h_len * 0.83)
                cylinder(d1 = neck_od, d2 = ferrule_od, h = h_len * 0.17, chamfer2 = 1.0, anchor = BOTTOM);
        }

        // 6 Ergonomic Thumb/Finger Flutes around main barrel
        for (a = [0 : 60 : 300]) {
            rotate([0, 0, a])
            translate([h_od * 0.58, 0, h_len * 0.39])
                cylinder(d = h_od * 0.42, h = h_len * 0.46, center = true, chamfer = 2.0);
        }

        // If Master 1/4" Bit Holder: Cut 1/4" (6.35mm) hex socket + internal friction ribs
        if (hex_socket_top) {
            sock_af = 6.35 + (printer_slop * 1.5);
            sock_depth = 20;
            up(h_len - sock_depth)
                linear_extrude(height = sock_depth + 1)
                    hexagon(id = sock_af);
        }
    }

    // Add 3 tiny print-in-place crush/friction ribs inside the 1/4" socket so bits don't fall out!
    if (hex_socket_top) {
        sock_af = 6.35 + (printer_slop * 1.5);
        for (a = [0 : 120 : 240]) {
            rotate([0, 0, a])
            translate([sock_af/2 - 0.12, 0, h_len - 10])
                cylinder(d = 0.6, h = 14, center = true, $fn = 16);
        }
    }
}

// Ergonomic T-Handle Body Module
module ergonomic_thandle(h_scale = 1.0, hex_socket_top = false) {
    handle_w = 72 * h_scale;
    handle_d = 16 * h_scale;
    handle_h = 14 * h_scale;
    col_od   = 17 * h_scale;
    col_h    = 26 * h_scale;

    difference() {
        union() {
            cuboid([handle_w, handle_d, handle_h], rounding = 4 * h_scale, edges = "Z", anchor = BOTTOM);
            cylinder(d = col_od, h = handle_h + col_h, chamfer2 = 1.2, anchor = BOTTOM);
        }
        if (hex_socket_top) {
            sock_af = 6.35 + (printer_slop * 1.5);
            sock_depth = 20;
            up(handle_h + col_h - sock_depth)
                linear_extrude(height = sock_depth + 1)
                    hexagon(id = sock_af);
        }
    }
    if (hex_socket_top) {
        sock_af = 6.35 + (printer_slop * 1.5);
        for (a = [0 : 120 : 240]) {
            rotate([0, 0, a])
            translate([sock_af/2 - 0.12, 0, handle_h + col_h - 10])
                cylinder(d = 0.6, h = 14, center = true, $fn = 16);
        }
    }
}

h_mult = (handle_size == "compact") ? 0.78 : (handle_size == "heavy") ? 1.22 : 1.0;

echo(str("[SPEC] Tool: ", tool_category, "  |  Tip: ", tip_type, "  |  Clearance: ±", printer_slop, " mm"));

if (tool_category == "master_screwdriver") {
    fluted_screwdriver_handle(h_mult, hex_socket_top = true);
} else if (tool_category == "master_thandle") {
    ergonomic_thandle(h_mult, hex_socket_top = true);
} else if (tool_category == "hex_bit") {
    // 1/4" (6.35mm) Hex Insert Bit with retention notch + selected driver tip on top
    shank_af = 6.35 - (printer_slop * 0.5);
    linear_extrude(height = 18)
        hexagon(id = shank_af);
    up(18)
        cylinder(d = shank_af, h = 2, anchor = BOTTOM);
    up(20)
        driver_shaft_3d(shaft_len);
} else if (tool_category == "screwdriver_direct") {
    h_len = 92 * h_mult;
    fluted_screwdriver_handle(h_mult, hex_socket_top = false);
    up(h_len)
        driver_shaft_3d(shaft_len);
} else if (tool_category == "t_driver") {
    top_z = (14 + 26) * h_mult;
    ergonomic_thandle(h_mult, hex_socket_top = false);
    up(top_z)
        driver_shaft_3d(shaft_len);
} else if (tool_category == "l_key") {
    // True Mitered 90-Degree L-Key lying flat on XY bed (Zero mismatched ball joint!)
    long_arm  = max(45, shaft_len * 2.0);
    short_arm = max(18, shaft_len * 0.85);
    tip_r = (tip_type == "torx") ? (torx_od_lookup(torx_tip_code) / 2) :
            (tip_type == "hex")  ? (hex_tip_sz / 1.732) : 3.0;

    // Lift by tip radius so the entire L-key rests cleanly on Z=0
    up(tip_r) {
        // Long arm along +Y
        rotate([-90, 0, 0])
            driver_shaft_3d(long_arm);
        // Short arm along +X
        rotate([0, 90, 0])
            driver_shaft_3d(short_arm);
        // Exact Mitered Corner Intersection
        hull() {
            rotate([-90, 0, 0]) linear_extrude(height = 0.2) driver_tip_2d();
            rotate([0, 90, 0])  linear_extrude(height = 0.2) driver_tip_2d();
        }
    }
} else if (tool_category == "wrench_combo") {
    w_thick = max(5, min(10, target_af * 0.65));
    head_od = jaw_af * 1.75;
    handle_l = max(65, target_af * 6.5);
    handle_w = max(8, jaw_af * 0.85);

    linear_extrude(height = w_thick) {
        difference() {
            union() {
                translate([-handle_l/2, 0]) circle(d = head_od);
                translate([ handle_l/2, 0]) circle(d = head_od * 1.08);
                square([handle_l, handle_w], center = true);
            }
            translate([-handle_l/2, 0]) {
                hexagon(id = jaw_af);
                rotate([0, 0, 30]) hexagon(id = jaw_af);
            }
            translate([handle_l/2, 0])
                rotate([0, 0, 15]) {
                    hexagon(id = jaw_af);
                    translate([jaw_af * 0.6, 0])
                        square([head_od, jaw_af], center = true);
                }
        }
    }
} else if (tool_category == "wrench_adjustable") {
    scale_f = (adj_size_class == "compact") ? 0.75 : (adj_size_class == "heavy") ? 1.35 : 1.0;
    bar_l = 115 * scale_f;
    bar_w = 16 * scale_f;
    bar_h = 8 * scale_f;
    jaw_depth = 26 * scale_f;
    jaw_thick = 10 * scale_f;

    translate([0, -20 * scale_f, 0]) {
        difference() {
            union() {
                cuboid([bar_l, bar_w, bar_h], rounding = 2, edges = "Z", anchor = BOTTOM);
                translate([-bar_l/2 + jaw_thick/2, bar_w/2 + jaw_depth/2 - 1, 0])
                    cuboid([jaw_thick, jaw_depth + 2, bar_h], rounding = 2, edges = "Z", anchor = BOTTOM);
            }
            translate([0, 0, -0.1])
                cuboid([bar_l * 0.55, 6.4, bar_h + 1], rounding = 3, edges = "Z", anchor = BOTTOM);
            translate([bar_l/2 - 10 * scale_f, 0, -0.1])
                cylinder(d = 6 * scale_f, h = bar_h + 1, anchor = BOTTOM);
        }
    }

    translate([-15 * scale_f, 22 * scale_f, 0]) {
        cuboid([jaw_thick * 1.15, jaw_depth + bar_w + 6, bar_h], rounding = 2, edges = "Z", anchor = BOTTOM);
        translate([0, -jaw_depth/2, bar_h])
            screw(spec = "M6", head = "none", length = bar_h + 8, bevel = true, anchor = BOTTOM, orient = UP);
    }

    translate([25 * scale_f, 22 * scale_f, 0]) {
        difference() {
            union() {
                cylinder(d = 20 * scale_f, h = 7, chamfer = 0.8, anchor = BOTTOM);
                for (a = [0 : 20 : 340]) {
                    rotate([0, 0, a])
                    translate([10 * scale_f, 0, 3.5])
                        cylinder(d = 2.0, h = 6, center = true);
                }
            }
            down(0.1)
                nut(spec = "M6", shape = "hex", width = 18 * scale_f, thickness = 7.2, bevel = true, anchor = BOTTOM);
        }
        nut(spec = "M6", shape = "hex", width = 14 * scale_f, thickness = 7, bevel = true, anchor = BOTTOM);
    }
} else if (tool_category == "nut_driver") {
    sock_od = jaw_af * 1.65;
    sock_h = max(18, target_af * 1.8);
    difference() {
        union() {
            cylinder(d = sock_od, h = sock_h, chamfer = 0.8, anchor = BOTTOM);
            for (a = [0 : 15 : 345]) {
                rotate([0, 0, a])
                translate([sock_od/2, 0, sock_h/2])
                     cylinder(d = 1.6, h = sock_h - 2, center = true, $fn = 16);
            }
        }
        up(3)
            linear_extrude(height = sock_h)
                hexagon(id = jaw_af);
        down(0.1)
            cylinder(d = target_af * 0.72, h = sock_h + 1, anchor = BOTTOM);
    }
} else if (tool_category == "bit_socket") {
    shank_id = 6.35 - (printer_slop * 0.5);
    sock_od = jaw_af * 1.55;
    sock_depth = max(8, target_af * 0.9);
    linear_extrude(height = 18)
        hexagon(id = shank_id);
    up(18)
        cylinder(d1 = max(8, shank_id * 1.15), d2 = sock_od, h = 5, anchor = BOTTOM);
    up(23)
        difference() {
            cylinder(d = sock_od, h = sock_depth + 3, chamfer2 = 0.6, anchor = BOTTOM);
            up(3)
                linear_extrude(height = sock_depth + 1)
                    hexagon(id = jaw_af);
        }
}

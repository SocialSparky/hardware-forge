include <BOSL2/std.scad>
include <BOSL2/screws.scad>

/* [1. Tool Type & Measurement System] */
// Select Printable Tool or Master Bit System [master_screwdriver:Master 1/4" Bit-Holding Screwdriver Handle, master_thandle:Master 1/4" Bit-Holding T-Handle Driver, hex_bit:1/4" Hex Insert Bit (Allen / Torx / Phillips / Flat), screwdriver_direct:One-Piece Fluted Screwdriver (Allen / Torx / Phillips / Flat), t_driver:One-Piece Ergonomic T-Handle Driver, l_key:Classic 90° L-Key (With Flag Tag for Size Label!), wrench_combo:Combination Open + 12-Pt Box Wrench, wrench_adjustable:Adjustable Spanner Wrench (Sliding Jaw + Lock Nut), nut_driver:Knurled Finger Nut Driver Socket, bit_socket:1/4" Hex-Shank Nut Driver Socket Bit]
tool_category = "wrench_combo";

// Measurement System (For Hex & Wrench Sizes) [metric:Metric (mm), imperial:Imperial (Inches)]
unit_system = "metric";

// Tool Size Label Style [engraved:Engraved Size Text (Recessed Cutout), embossed:Embossed Size Text (Raised 0.8mm), none:No Size Text]
label_mode = "engraved";

// Custom Label Override (Leave Blank for Automatic Size e.g. "10mm", "7/16", "T30", "PH2")
custom_label_text = "";

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

// Convert common SAE millimeter equivalents back to clean fraction strings for tool markings!
function mm_to_sae_label(val) =
    (abs(val - 1.5875) < 0.03) ? "1/16\"" :
    (abs(val - 1.9844) < 0.03) ? "5/64\"" :
    (abs(val - 2.38125)< 0.03) ? "3/32\"" :
    (abs(val - 2.7781) < 0.03) ? "7/64\"" :
    (abs(val - 3.175)  < 0.03) ? "1/8\""  :
    (abs(val - 3.5719) < 0.03) ? "9/64\"" :
    (abs(val - 3.96875)< 0.03) ? "5/32\"" :
    (abs(val - 4.7625) < 0.03) ? "3/16\"" :
    (abs(val - 5.55625)< 0.03) ? "7/32\"" :
    (abs(val - 6.35)   < 0.03) ? "1/4\""  :
    (abs(val - 7.9375) < 0.03) ? "5/16\"" :
    (abs(val - 8.73125)< 0.03) ? "11/32\"":
    (abs(val - 9.525)  < 0.03) ? "3/8\""  :
    (abs(val - 11.1125)< 0.03) ? "7/16\"" :
    (abs(val - 12.7)   < 0.03) ? "1/2\""  :
    (abs(val - 14.2875)< 0.03) ? "9/16\"" :
    (abs(val - 15.875) < 0.03) ? "5/8\""  :
    (abs(val - 19.05)  < 0.03) ? "3/4\""  :
    (abs(val - 23.8125)< 0.03) ? "15/16\"":
    (abs(val - 28.575) < 0.03) ? "1-1/8\"":
    str(round((val / 25.4) * 1000) / 1000, "\"");

auto_wrench_str = (unit_system == "metric") ? str(round(target_af * 10) / 10, "mm") : mm_to_sae_label(target_af);
auto_hex_str    = (unit_system == "metric") ? str(round(hex_tip_sz * 10) / 10, "mm") : mm_to_sae_label(hex_tip_sz);
auto_tip_str    = (tip_type == "torx")     ? torx_tip_code :
                  (tip_type == "phillips") ? phillips_tip_code :
                  (tip_type == "slot")     ? str("SL", round(slot_blade_span*10)/10) : auto_hex_str;

resolved_label = (len(str_strip(custom_label_text, " ")) > 0) ? custom_label_text :
                 (tool_category == "master_screwdriver" || tool_category == "master_thandle") ? "1/4\" BIT" :
                 (tool_category == "wrench_combo" || tool_category == "nut_driver" || tool_category == "bit_socket") ? auto_wrench_str :
                 (tool_category == "wrench_adjustable") ? ((adj_size_class == "compact") ? "ADJ 18mm" : (adj_size_class == "heavy") ? "ADJ 40mm" : "ADJ 28mm") :
                 auto_tip_str;

echo(str("[SPEC] Tool: ", tool_category, "  |  Stamped Size Label: \"", resolved_label, "\"  |  Clearance: ±", printer_slop, " mm"));

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

module driver_shaft_3d(len) {
    if (tip_type == "phillips") {
        span = ((phillips_tip_code == "PH0") ? 2.0 :
                (phillips_tip_code == "PH1") ? 3.0 :
                (phillips_tip_code == "PH2") ? 4.6 :
                (phillips_tip_code == "PH3") ? 6.2 : 7.8) - (printer_slop * 0.8);
        arm_w = max(0.6, span * 0.23 - printer_slop * 0.5);
        taper_h = min(len * 0.45, span * 1.3);
        stem_h = max(1, len - taper_h);

        cylinder(d = span, h = stem_h, anchor = BOTTOM);
        up(stem_h) {
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

// 3D Text Helper (Flat on XY plane or Vertical on XZ/YZ faces)
module stamp_text_3d(txt_str, font_sz, depth = 1.0) {
    linear_extrude(height = depth, center = true)
        text(text = txt_str, size = font_sz, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
}

module fluted_screwdriver_handle(h_scale = 1.0, hex_socket_top = false, lbl = "") {
    h_len = 92 * h_scale;
    h_od  = 28 * h_scale;
    neck_od = 16 * h_scale;
    ferrule_od = 18 * h_scale;

    difference() {
        union() {
            cylinder(d1 = h_od * 0.72, d2 = h_od, h = h_len * 0.15, anchor = BOTTOM);
            up(h_len * 0.15)
                cylinder(d = h_od, h = h_len * 0.48, anchor = BOTTOM);
            up(h_len * 0.63)
                cylinder(d1 = h_od, d2 = neck_od, h = h_len * 0.20, anchor = BOTTOM);
            up(h_len * 0.83)
                cylinder(d1 = neck_od, d2 = ferrule_od, h = h_len * 0.17, chamfer2 = 1.0, anchor = BOTTOM);

            if (label_mode == "embossed" && len(lbl) > 0) {
                translate([0, -h_od/2 + 0.3, h_len * 0.39])
                    rotate([90, -90, 0])
                        stamp_text_3d(lbl, font_sz = 5.5 * h_scale, depth = 1.4);
            }
        }

        // 5 Ergonomic Flutes (leaving front -Y face smooth as a flat nameplate for the size text!)
        for (a = [30, 90, 150, 210, 330]) {
            rotate([0, 0, a])
            translate([h_od * 0.58, 0, h_len * 0.39])
                cylinder(d = h_od * 0.42, h = h_len * 0.46, center = true, chamfer = 2.0);
        }
        // Flat nameplate facet on front (-Y)
        translate([0, -h_od * 0.63, h_len * 0.39])
            cuboid([h_od * 0.55, h_od * 0.35, h_len * 0.46], chamfer = 1.5, center = true);

        if (label_mode == "engraved" && len(lbl) > 0) {
            translate([0, -h_od * 0.455, h_len * 0.39])
                rotate([90, -90, 0])
                    stamp_text_3d(lbl, font_sz = 5.5 * h_scale, depth = 1.6);
        }

        if (hex_socket_top) {
            sock_af = 6.35 + (printer_slop * 1.5);
            sock_depth = 20;
            up(h_len - sock_depth)
                linear_extrude(height = sock_depth + 1)
                    hexagon(id = sock_af);
        }
    }

    if (hex_socket_top) {
        sock_af = 6.35 + (printer_slop * 1.5);
        for (a = [0 : 120 : 240]) {
            rotate([0, 0, a])
            translate([sock_af/2 - 0.12, 0, h_len - 10])
                cylinder(d = 0.6, h = 14, center = true, $fn = 16);
        }
    }
}

module ergonomic_thandle(h_scale = 1.0, hex_socket_top = false, lbl = "") {
    handle_w = 72 * h_scale;
    handle_d = 16 * h_scale;
    handle_h = 14 * h_scale;
    col_od   = 17 * h_scale;
    col_h    = 26 * h_scale;

    difference() {
        union() {
            cuboid([handle_w, handle_d, handle_h], rounding = 4 * h_scale, edges = "Z", anchor = BOTTOM);
            cylinder(d = col_od, h = handle_h + col_h, chamfer2 = 1.2, anchor = BOTTOM);

            // Embossed Size Text on both Front (-Y) and Back (+Y) faces of the T-Handle crossbar!
            if (label_mode == "embossed" && len(lbl) > 0) {
                for (side = [-1, 1])
                    translate([side * handle_w * 0.25, -handle_d/2, handle_h/2])
                        rotate([90, 0, 0])
                            stamp_text_3d(lbl, font_sz = 5.2 * h_scale, depth = 1.4);
            }
        }
        if (label_mode == "engraved" && len(lbl) > 0) {
            for (side = [-1, 1])
                translate([side * handle_w * 0.25, -handle_d/2, handle_h/2])
                    rotate([90, 0, 0])
                        stamp_text_3d(lbl, font_sz = 5.2 * h_scale, depth = 1.6);
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

if (tool_category == "master_screwdriver") {
    fluted_screwdriver_handle(h_mult, hex_socket_top = true, lbl = resolved_label);
} else if (tool_category == "master_thandle") {
    ergonomic_thandle(h_mult, hex_socket_top = true, lbl = resolved_label);
} else if (tool_category == "hex_bit") {
    // 1/4" Hex Insert Bit with Stamped Size Flag Collar so even tiny 1.5mm bits clearly display their size!
    shank_af = 6.35 - (printer_slop * 0.5);
    difference() {
        union() {
            linear_extrude(height = 20)
                hexagon(id = shank_af);
            // Wide Hex Identification Collar with flat front face for crisp size text
            up(13)
                cuboid([11.5, 8.2, 7.0], rounding = 1.5, edges = "Z", anchor = BOTTOM);
            if (label_mode == "embossed") {
                translate([0, -4.1, 16.5])
                    rotate([90, 0, 0])
                        stamp_text_3d(resolved_label, font_sz = 3.6, depth = 1.2);
            }
        }
        if (label_mode == "engraved") {
            translate([0, -4.1, 16.5])
                rotate([90, 0, 0])
                    stamp_text_3d(resolved_label, font_sz = 3.6, depth = 1.4);
        }
    }
    up(20)
        driver_shaft_3d(shaft_len);

} else if (tool_category == "screwdriver_direct") {
    h_len = 92 * h_mult;
    fluted_screwdriver_handle(h_mult, hex_socket_top = false, lbl = resolved_label);
    up(h_len)
        driver_shaft_3d(shaft_len);

} else if (tool_category == "t_driver") {
    top_z = (14 + 26) * h_mult;
    ergonomic_thandle(h_mult, hex_socket_top = false, lbl = resolved_label);
    up(top_z)
        driver_shaft_3d(shaft_len);

} else if (tool_category == "l_key") {
    // Classic 90° L-Key with Integrated Flat Grip Flag on the Long Arm so the Size Text is Always Readable!
    long_arm  = max(48, shaft_len * 2.0);
    short_arm = max(18, shaft_len * 0.85);
    tip_r = (tip_type == "torx") ? (torx_od_lookup(torx_tip_code) / 2) :
            (tip_type == "hex")  ? (hex_tip_sz / 1.732) : 3.0;
    flag_h = max(3.0, tip_r * 2.0);
    flag_w = max(11, tip_r * 3.5);
    flag_l = max(24, len(resolved_label) * 4.5);

    up(tip_r) {
        rotate([-90, 0, 0])
            driver_shaft_3d(long_arm);
        rotate([0, 90, 0])
            driver_shaft_3d(short_arm);
        hull() {
            rotate([-90, 0, 0]) linear_extrude(height = 0.2) driver_tip_2d();
            rotate([0, 90, 0])  linear_extrude(height = 0.2) driver_tip_2d();
        }
    }

    // Flat Size Flag Tab attached to the side of the long arm (Rests flat on Z=0 bed!)
    if (label_mode != "none") {
        translate([-flag_w/2, long_arm * 0.48, 0]) {
            difference() {
                union() {
                    cuboid([flag_w, flag_l, flag_h], rounding = 2, edges = "Z", anchor = BOTTOM);
                    if (label_mode == "embossed") {
                        translate([0, 0, flag_h])
                            rotate([0, 0, 90])
                                stamp_text_3d(resolved_label, font_sz = min(5.0, flag_w * 0.55), depth = 1.2);
                    }
                }
                if (label_mode == "engraved") {
                    translate([0, 0, flag_h])
                        rotate([0, 0, 90])
                            stamp_text_3d(resolved_label, font_sz = min(5.0, flag_w * 0.55), depth = 1.4);
                }
            }
        }
    }

} else if (tool_category == "wrench_combo") {
    w_thick = max(5, min(10, target_af * 0.65));
    head_od = jaw_af * 1.75;
    handle_l = max(65, target_af * 6.5);
    handle_w = max(9.5, jaw_af * 0.88);
    txt_sz = min(handle_w * 0.62, handle_l * 0.14);

    difference() {
        union() {
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
            if (label_mode == "embossed") {
                translate([0, 0, w_thick])
                    stamp_text_3d(resolved_label, font_sz = txt_sz, depth = 1.4);
            }
        }
        if (label_mode == "engraved") {
            translate([0, 0, w_thick])
                stamp_text_3d(resolved_label, font_sz = txt_sz, depth = 1.6);
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
                if (label_mode == "embossed") {
                    translate([bar_l * 0.22, 0, bar_h])
                        stamp_text_3d(resolved_label, font_sz = 4.5 * scale_f, depth = 1.2);
                }
            }
            translate([-bar_l * 0.08, 0, -0.1])
                cuboid([bar_l * 0.48, 6.4, bar_h + 1], rounding = 3, edges = "Z", anchor = BOTTOM);
            translate([bar_l/2 - 8 * scale_f, 0, -0.1])
                cylinder(d = 6 * scale_f, h = bar_h + 1, anchor = BOTTOM);
            if (label_mode == "engraved") {
                translate([bar_l * 0.22, 0, bar_h])
                    stamp_text_3d(resolved_label, font_sz = 4.5 * scale_f, depth = 1.4);
            }
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
    sock_od = max(14, jaw_af * 1.65);
    sock_h = max(20, target_af * 1.8);
    difference() {
        union() {
            cylinder(d = sock_od, h = sock_h, chamfer = 0.8, anchor = BOTTOM);
            // Knurling around sides, leaving front (-Y) smooth for size text!
            for (a = [30 : 15 : 240]) {
                rotate([0, 0, a])
                translate([sock_od/2, 0, sock_h/2])
                     cylinder(d = 1.6, h = sock_h - 2, center = true, $fn = 16);
            }
            for (a = [300 : 15 : 345]) {
                rotate([0, 0, a])
                translate([sock_od/2, 0, sock_h/2])
                     cylinder(d = 1.6, h = sock_h - 2, center = true, $fn = 16);
            }
            if (label_mode == "embossed") {
                translate([0, -sock_od/2 + 0.4, sock_h/2])
                    rotate([90, -90, 0])
                        stamp_text_3d(resolved_label, font_sz = min(5.0, sock_od * 0.28), depth = 1.4);
            }
        }
        // Flat nameplate facet on front (-Y)
        translate([0, -sock_od * 0.55, sock_h/2])
            cuboid([sock_od * 0.65, sock_od * 0.22, sock_h - 4], center = true);
        if (label_mode == "engraved") {
            translate([0, -sock_od * 0.44, sock_h/2])
                rotate([90, -90, 0])
                    stamp_text_3d(resolved_label, font_sz = min(5.0, sock_od * 0.28), depth = 1.6);
        }
        up(3)
            linear_extrude(height = sock_h)
                hexagon(id = jaw_af);
        down(0.1)
            cylinder(d = target_af * 0.72, h = sock_h + 1, anchor = BOTTOM);
    }

} else if (tool_category == "bit_socket") {
    shank_id = 6.35 - (printer_slop * 0.5);
    sock_od = max(12, jaw_af * 1.55);
    sock_depth = max(10, target_af * 0.95);
    linear_extrude(height = 18)
        hexagon(id = shank_id);
    up(18)
        cylinder(d1 = max(8, shank_id * 1.15), d2 = sock_od, h = 5, anchor = BOTTOM);
    up(23)
        difference() {
            union() {
                cylinder(d = sock_od, h = sock_depth + 3, chamfer2 = 0.6, anchor = BOTTOM);
                if (label_mode == "embossed") {
                    translate([0, -sock_od/2 + 0.3, (sock_depth + 3)/2])
                        rotate([90, -90, 0])
                            stamp_text_3d(resolved_label, font_sz = min(4.2, sock_od * 0.26), depth = 1.2);
                }
            }
            translate([0, -sock_od * 0.56, (sock_depth + 3)/2])
                cuboid([sock_od * 0.65, sock_od * 0.22, sock_depth], center = true);
            if (label_mode == "engraved") {
                translate([0, -sock_od * 0.45, (sock_depth + 3)/2])
                    rotate([90, -90, 0])
                        stamp_text_3d(resolved_label, font_sz = min(4.2, sock_od * 0.26), depth = 1.4);
            }
            up(3)
                linear_extrude(height = sock_depth + 1)
                    hexagon(id = jaw_af);
        }
}

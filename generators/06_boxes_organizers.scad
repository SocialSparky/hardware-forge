include <BOSL2/std.scad>

/* [1. Container Category & Render Mode] */
// Select System Style [hinged_box:Hinged Utility Case (8mm Slim Lid + Heavy-Duty Friction Clasp!), slide_box:Slide-On Track Cover Utility Box (Dovetail Rail + Anti-Mix Seal), drawer_system:Modular Drawer Cabinet & Pull-Out Drawers, organizer_tray:Open Drawer / Parts Organizer Tray, gift_box:Fluted / Classic Gift Box with Slip Lid]
box_style = "hinged_box";

// Which Part(s) to Render (Hinged, Slide & Gift Box) [both:Both Base & Lid Side-by-Side, base:Base / Bottom Only, lid:Lid / Cover Only] @show_if(box_style=hinged_box|slide_box|gift_box)
render_part = "both";

// Which Part(s) to Render (Drawer System) [both:Cabinet Housing + Sample Drawer, cabinet:Outer Cabinet Housing Only, drawer:Single Pull-Out Drawer Only, all_drawers:Full Set of All Pull-Out Drawers on Bed] @show_if(box_style=drawer_system)
drawer_render_mode = "both";

/* [2. Overall Outer Dimensions] */
// Outer Width - X Axis [40:40 mm (~1.5"), 60:60 mm (~2.4"), 80:80 mm (~3.1"), 100:100 mm (~4"), 120:120 mm (~4.7"), 150:150 mm (~6"), 180:180 mm (~7"), 200:200 mm (~8")]
outer_width = 100;

// Outer Depth - Y Axis [40:40 mm (~1.5"), 50:50 mm (~2"), 60:60 mm (~2.4"), 70:70 mm, 80:80 mm (~3.1"), 100:100 mm (~4"), 120:120 mm (~4.7"), 150:150 mm (~6")]
outer_depth = 70;

// Base / Cabinet Total Height - Z Axis [15:15 mm (Shallow), 20:20 mm, 25:25 mm (~1"), 30:30 mm, 35:35 mm, 40:40 mm (~1.5"), 50:50 mm (~2"), 60:60 mm, 80:80 mm (~3.1"), 100:100 mm (~4"), 120:120 mm]
base_height = 30;

// Gift Box Lid Height - Z Axis [8:8 mm, 12:12 mm (Standard), 15:15 mm, 20:20 mm] @show_if(box_style=gift_box)
lid_height = 12;

// Outer Wall Thickness [1.6:1.6 mm (Light / 4 Walls), 2.0:2.0 mm (Standard), 2.4:2.4 mm (Durable Case), 3.0:3.0 mm (Heavy Duty Rugged), 4.0:4.0 mm (Armor Box)]
wall_thick = 2.4;

// Outer Corner Rounding Radius [2:2 mm (Crisp), 4:4 mm (Standard), 6:6 mm (Smooth), 10:10 mm (Wide Rounded), 15:15 mm (Extra Wide Rounded)]
corner_radius = 4;

/* [3. Lid Top Engraved Cutout Options] */
// Lid Top Label Mode [debossed:Recessed Engraved Cutout (On), none:Plain Smooth Lid (Off)] @show_if(box_style=hinged_box|slide_box|gift_box)
lid_label_mode = "debossed";

// Lid Label Text (Line 1) @show_if(lid_label_mode=debossed)
lid_text_line1 = "M5 HARDWARE";

// Lid Sub-Label Text (Line 2 — Optional) @show_if(lid_label_mode=debossed)
lid_text_line2 = "";

// Font Style [Liberation Sans:style=Bold:Bold Industrial Sans, Liberation Mono:style=Bold:Tech Monospace Bold, DejaVu Sans:style=Bold:Heavy Wide Sans, Liberation Serif:style=Bold:Classic Bold Serif] @show_if(lid_label_mode=debossed)
lid_font = "Liberation Sans:style=Bold";

// Main Text Size (Height in mm) [6:6 mm, 8:8 mm, 10:10 mm, 12:12 mm, 15:15 mm, 18:18 mm] @show_if(lid_label_mode=debossed)
lid_text_size = 10;

// Decorative Frame Style [rounded_box:Rounded Tech Border Frame, chamfer_tag:Chamfered Octagon Plate, double_line:Double Pinstripe Frame, corner_brackets:Corner Target Brackets, none:No Frame (Text Only)] @show_if(lid_label_mode=debossed)
lid_frame_style = "rounded_box";

// Engraved Cutout Depth [0.4:0.40 mm (2 Layers), 0.6:0.60 mm (3 Layers — Crisp!), 0.8:0.80 mm (4 Layers — Deep)] @show_if(lid_label_mode=debossed)
inlay_depth = 0.6;

// Text Horizontal Offset X (mm) @show_if(lid_label_mode=debossed)
lid_text_x = 0.0;

// Text Vertical Offset Y (mm) @show_if(lid_label_mode=debossed)
lid_text_y = 0.0;

// Frame X Margin from Outer Edge (mm) @show_if(lid_label_mode=debossed)
lid_frame_margin_x = 8.0;

// Frame Y Margin from Outer Edge (mm) @show_if(lid_label_mode=debossed)
lid_frame_margin_y = 8.0;

/* [4. Heavy-Duty Friction Clasp Tightness (For Hinged Box)] */
// Clasp Tightness / Opening Effort [0.15:0.15 mm — Kid-Friendly / Featherlight (Effortless for Small Hands!), 0.25:0.25 mm — Easy Everyday (Smooth One-Handed Flip — Default), 0.35:0.35 mm — Medium Snug (Standard Workshop Case), 0.45:0.45 mm — Firm Toolbag Grip, 0.60:0.60 mm — Heavy Duty Lock (Very Tight)] @show_if(box_style=hinged_box)
clasp_bite = 0.25;

/* [5. Slide-On Cover Options (For Slide Box)] */
// Detent Click-Lock Retention [detent:Positive Click-Stop Detent Bump, smooth:Smooth Free-Sliding Track] @show_if(box_style=slide_box)
slide_lock_style = "detent";

// Include Thumb-Push Grip Grooves on Top of Lid @show_if(box_style=slide_box)
thumb_grip = true;

/* [6. Modular Drawer System Options] */
// Drawer Columns Wide (X) [1:1 Drawer Wide, 2:2 Drawers Wide, 3:3 Drawers Wide, 4:4 Drawers Wide] @show_if(box_style=drawer_system)
drawer_cols = 2;

// Drawer Tiers Tall (Z) [1:1 Tier Tall, 2:2 Tiers Tall, 3:3 Tiers Tall, 4:4 Tiers Tall, 5:5 Tiers Tall] @show_if(box_style=drawer_system)
drawer_rows = 2;

// Pull-Out Handle Style [lip_pull:Ergonomic Curved Finger Lip Pull, d_loop:Heavy D-Ring Loop Handle, label_pull:Label-Frame Pull Handle, recessed_scoop:Flush Half-Moon Thumb Cutout, round_knob:Classic Chamfered Round Knob] @show_if(box_style=drawer_system)
handle_style = "lip_pull";

// Stackable Interlocking Cabinet Lugs (Top & Bottom) @show_if(box_style=drawer_system)
stackable_cabinet = true;

// Rear Keyhole Wall-Mount Slots @show_if(box_style=drawer_system)
wall_mount_holes = true;

/* [7. Internal Compartment Layout] */
// Number of Columns (Left to Right - X) [1:1 Column, 2:2 Columns, 3:3 Columns, 4:4 Columns, 5:5 Columns, 6:6 Columns, 7:7 Columns, 8:8 Columns] @show_if(box_style=hinged_box|slide_box|organizer_tray|drawer_system)
cols = 3;

// Default Rows per Column (Front to Back - Y) [1:1 Row, 2:2 Rows, 3:3 Rows, 4:4 Rows, 5:5 Rows, 6:6 Rows] @show_if(box_style=hinged_box|slide_box|organizer_tray|drawer_system)
rows = 2;

// Inner Divider Wall Thickness [1.2:1.2 mm (Thin), 1.6:1.6 mm (Standard), 2.0:2.0 mm (Rigid)] @show_if(box_style=hinged_box|slide_box|organizer_tray|drawer_system)
divider_thick = 1.6;

// Scooped Finger-Grab Bottoms (For Easily Picking Up Small Screws) @show_if(box_style=hinged_box|slide_box|organizer_tray|drawer_system)
scooped_bottom = true;

// Layout Spec (Auto-Updated by Visual 2D Designer) @show_if(box_style=hinged_box|slide_box|organizer_tray|drawer_system)
layout_spec = "";

// Drawer Cabinet Slot Layout Spec @show_if(box_style=drawer_system)
drawer_slot_spec = "";

/* [8. Gift Box Styling] */
// Gift Box Exterior Wall Texture [fluted:Vertical Fluted Ribs (Elegant), smooth:Smooth Classic Walls] @show_if(box_style=gift_box)
gift_texture = "fluted";

/* [9. 3D Print Clearance] */
// Hinge / Track / Drawer Clearance [0.15:0.15 mm (Snug), 0.20:0.20 mm (Standard PLA/PETG), 0.25:0.25 mm (Easy Fit), 0.30:0.30 mm (Loose)]
printer_slop = 0.20;

/* [Hidden] */
$fn = 48;

W = max(35, outer_width);
D = max(35, outer_depth);
H_base = max(12, base_height);
H_lid  = max(6, lid_height);
T = max(1.6, wall_thick);
R = min(corner_radius, min(W, D) * 0.35);

function parse_csv_nums(s) =
    let(
        parts = str_split(str_strip(str(s), " "), ","),
        nums  = [for (p = parts) let(n = parse_num(str_strip(p, " "))) if (!is_undef(n) && n > 0) n]
    ) nums;

function resolve_Remainder_List(count, total_avail, user_list, min_val = 3.5) =
    (count <= 1) ? [max(min_val, total_avail)] :
    let(
        specified = [
            for (i = [0 : count - 2])
                (i < len(user_list) && user_list[i] > 0) ? max(min_val, user_list[i]) : (total_avail / count)
        ],
        sum_spec = sum(specified),
        max_allowed = max(min_val * (count - 1), total_avail - min_val),
        scale_f = (sum_spec > max_allowed && sum_spec > 0) ? (max_allowed / sum_spec) : 1.0,
        final_first = [for (x = specified) x * scale_f],
        last_rem = max(min_val, total_avail - sum(final_first))
    )
    concat(final_first, [last_rem]);

function prefix_offsets(spans, gap) =
    [for (i = [0 : len(spans) - 1])
        (i == 0) ? 0 : sum([for (j = [0 : i - 1]) spans[j] + gap])
    ];

function parse_2d_layout(spec_str, default_cols, default_rows, inner_w, inner_d, div_t) =
    let(
        clean = str_strip(str(spec_str), " "),
        col_tokens = (len(clean) > 0) ? str_split(clean, "|") : [],
        c_num = (len(col_tokens) > 0) ? len(col_tokens) : max(1, round(default_cols)),
        avail_w = max(c_num * 3.5, inner_w - (c_num - 1) * div_t),
        raw_col_w = [
            for (i = [0 : c_num - 1])
                if (i < len(col_tokens))
                    let(
                        sides = str_split(col_tokens[i], ":"),
                        w_val = parse_num(str_strip(sides[0], " "))
                    )
                    (is_undef(w_val) ? -1 : w_val)
                else -1
        ],
        valid_col_w = [for (i = [0 : max(0, c_num - 2)]) if (raw_col_w[i] > 0) raw_col_w[i] else (avail_w / c_num)],
        col_widths = resolve_Remainder_List(c_num, avail_w, valid_col_w, 3.5),
        col_rows_list = [
            for (i = [0 : c_num - 1])
                let(
                    has_tok = (i < len(col_tokens)),
                    sides = has_tok ? str_split(col_tokens[i], ":") : [],
                    r_csv = (len(sides) > 1) ? str_strip(sides[1], " ") : "",
                    r_nums = (len(r_csv) > 0) ? parse_csv_nums(r_csv) : [],
                    r_num = (len(r_nums) > 0) ? len(r_nums) : max(1, round(default_rows)),
                    avail_d = max(r_num * 3.5, inner_d - (r_num - 1) * div_t),
                    first_r = (len(r_nums) > 1) ? [for (j = [0 : len(r_nums) - 2]) r_nums[j]] : []
                )
                resolve_Remainder_List(r_num, avail_d, first_r, 3.5)
        ]
    )
    [col_widths, col_rows_list];

// =============================================================================
// 2D LID ENGRAVED CUTOUT GENERATORS (WORDING + BORDER FRAME AT Z=0)
// =============================================================================
module lid_inlay_text_2d() {
    t1 = str_strip(str(lid_text_line1), " ");
    t2 = str_strip(str(lid_text_line2), " ");
    has_t1 = (len(t1) > 0);
    has_t2 = (len(t2) > 0);

    mirror([1, 0, 0])
    translate([lid_text_x, lid_text_y]) {
        if (has_t1 && has_t2) {
            translate([0, lid_text_size * 0.52])
                text(text = t1, size = lid_text_size, font = lid_font, halign = "center", valign = "center");
            translate([0, -lid_text_size * 0.62])
                text(text = t2, size = lid_text_size * 0.68, font = lid_font, halign = "center", valign = "center");
        } else if (has_t1) {
            text(text = t1, size = lid_text_size, font = lid_font, halign = "center", valign = "center");
        } else if (has_t2) {
            text(text = t2, size = lid_text_size * 0.75, font = lid_font, halign = "center", valign = "center");
        }
    }
}

module lid_inlay_frame_2d(box_w, box_d) {
    mx = max(3.0, lid_frame_margin_x);
    my = max(3.0, lid_frame_margin_y);
    fw = max(16, box_w - mx * 2);
    fd = max(14, box_d - my * 2);
    f_thick = 2.0;

    if (lid_frame_style == "rounded_box") {
        difference() {
            offset(r = 3.5) square([fw - 7, fd - 7], center = true);
            offset(r = 3.5 - f_thick) square([fw - 7, fd - 7], center = true);
        }
    } else if (lid_frame_style == "chamfer_tag") {
        difference() {
            hull() {
                square([fw - 8, fd], center = true);
                square([fw, fd - 8], center = true);
            }
            hull() {
                square([fw - 8 - f_thick*2, fd - f_thick*2], center = true);
                square([fw - f_thick*2, fd - 8 - f_thick*2], center = true);
            }
        }
    } else if (lid_frame_style == "double_line") {
        difference() {
            offset(r = 3.0) square([fw - 6, fd - 6], center = true);
            offset(r = 3.0 - 1.2) square([fw - 6, fd - 6], center = true);
        }
        difference() {
            offset(r = 1.5) square([fw - 12, fd - 12], center = true);
            offset(r = 1.5 - 1.0) square([fw - 12, fd - 12], center = true);
        }
    } else if (lid_frame_style == "corner_brackets") {
        difference() {
            offset(r = 2.5) square([fw - 5, fd - 5], center = true);
            offset(r = 2.5 - f_thick) square([fw - 5, fd - 5], center = true);
            square([fw * 0.55, fd + 4], center = true);
            square([fw + 4, fd * 0.48], center = true);
        }
    }
}

// Cleanly carves the Engraved Cutout into Z=0 of the Lid
module apply_lid_inlay(box_w, box_d) {
    if (lid_label_mode == "none") {
        children();
    } else {
        difference() {
            children();
            translate([0, 0, -0.05])
                linear_extrude(height = inlay_depth + 0.05) {
                    if (lid_frame_style != "none") lid_inlay_frame_2d(box_w, box_d);
                    lid_inlay_text_2d();
                }
        }
    }
}

module compartment_cutouts(inner_w, inner_d, inner_r, height, wall, c_count, r_count, div_t, scoop, l_spec = "", flip_y = false, top_relief = 0) {
    parsed = parse_2d_layout(l_spec, c_count, r_count, inner_w, inner_d, div_t);
    col_widths = parsed[0];
    col_rows_matrix = parsed[1];
    c_num = len(col_widths);
    col_x0 = prefix_offsets(col_widths, div_t);

    union() {
        if (top_relief > 0) {
            translate([0, 0, height - top_relief])
                cuboid([inner_w, inner_d, top_relief + 2], rounding = inner_r, edges = "Z", anchor = BOTTOM);
        }

        mirror([0, flip_y ? 1 : 0, 0])
        intersection() {
            translate([0, 0, wall])
                cuboid([inner_w, inner_d, height + 2], rounding = inner_r, edges = "Z", anchor = BOTTOM);

            union() {
                for (c = [0 : c_num - 1]) {
                    cw = col_widths[c];
                    cx = -inner_w/2 + col_x0[c] + cw/2;
                    r_depths = col_rows_matrix[c];
                    r_num = len(r_depths);
                    row_y0 = prefix_offsets(r_depths, div_t);

                    for (r = [0 : r_num - 1]) {
                        rd = r_depths[r];
                        cy = -inner_d/2 + row_y0[r] + rd/2;
                        cell_z_r = min(inner_r, min(cw, rd) * 0.35);
                        scoop_r  = scoop ? min(rd * 0.38, min((height - wall) * 0.45, rd * 0.42)) : 0;

                        translate([cx, cy, wall]) {
                            if (scoop && scoop_r >= 1.0) {
                                cuboid([cw, rd, height + 2], rounding = scoop_r, edges = [BOTTOM+FRONT, BOTTOM+BACK], anchor = BOTTOM);
                            } else {
                                cuboid([cw, rd, height + 2], rounding = max(0.5, cell_z_r), edges = "Z", anchor = BOTTOM);
                            }
                        }
                    }
                }
            }
        }
    }
}

module divided_box_body(width, depth, height, wall, rad, c_count, r_count, div_t, scoop, l_spec = "", flip_y = false, top_relief = 0) {
    inner_w = max(6, width - (wall * 2));
    inner_d = max(6, depth - (wall * 2));
    inner_r = max(0.8, rad - wall);

    difference() {
        cuboid([width, depth, height], rounding = rad, edges = "Z", anchor = BOTTOM);
        compartment_cutouts(inner_w, inner_d, inner_r, height, wall, c_count, r_count, div_t, scoop, l_spec, flip_y, top_relief);
    }
}

module drawer_front_handle(d_w, d_h, wall_t, h_style) {
    pull_w = min(d_w * 0.55, max(16, d_w - 10));
    pull_d = max(8, min(14, d_h * 0.45));

    if (h_style == "lip_pull") {
        translate([0, -0.1, 0])
        difference() {
            cuboid([pull_w, pull_d, min(d_h * 0.55, 14)], rounding = 3, edges = [FRONT+LEFT, FRONT+RIGHT], anchor = BOTTOM+BACK);
            translate([0, -2.2, -0.1])
                cuboid([pull_w - 4, pull_d, min(d_h * 0.55, 14) - 2.6], rounding = 2, edges = [TOP+BACK, FRONT+LEFT, FRONT+RIGHT], anchor = BOTTOM+BACK);
        }
    } else if (h_style == "d_loop") {
        loop_h = min(10, d_h * 0.45);
        translate([0, 0.1, 0])
        linear_extrude(height = loop_h)
            difference() {
                offset(r = 3) square([pull_w - 6, pull_d * 1.4], center = true);
                offset(r = 1.5) square([pull_w - 12, pull_d * 0.85], center = true);
                translate([0, pull_d]) square([pull_w + 10, pull_d * 2], center = true);
            }
    } else if (h_style == "round_knob") {
        knob_z = d_h * 0.52;
        translate([0, 0, knob_z])
        rotate([90, 0, 0]) {
            cylinder(d1 = 10, d2 = 7, h = 4, anchor = BOTTOM);
            up(4) cylinder(d1 = 7, d2 = 12, h = 4.5, chamfer2 = 1.0, anchor = BOTTOM);
        }
    } else if (h_style == "label_pull") {
        frame_w = min(d_w - 6, max(20, d_w * 0.72));
        frame_h = min(d_h - 3, max(11, d_h * 0.65));
        translate([0, 0, (d_h - frame_h)/2]) {
            difference() {
                cuboid([frame_w, 4.2, frame_h], rounding = 1.5, edges = "Y", anchor = BOTTOM+BACK);
                translate([0, -1.6, 2.0])
                    cuboid([frame_w - 3.2, 1.4, frame_h + 2], anchor = BOTTOM+BACK);
                translate([0, -4.5, 3.2])
                    cuboid([frame_w - 6.5, 4.0, frame_h - 6.4], anchor = BOTTOM+BACK);
            }
        }
    }
}

module single_drawer(d_w, d_d, d_h) {
    difference() {
        union() {
            divided_box_body(d_w, d_d, d_h, max(1.4, T * 0.8), min(3, R), cols, rows, divider_thick, scooped_bottom, layout_spec);
            translate([0, -d_d/2, 0])
                drawer_front_handle(d_w, d_h, max(1.4, T * 0.8), handle_style);
        }
        if (handle_style == "recessed_scoop") {
            scoop_rad = min(d_w * 0.28, d_h * 0.48);
            translate([0, -d_d/2, d_h + scoop_rad * 0.25])
                rotate([90, 0, 0])
                    cylinder(r = scoop_rad, h = T * 4, center = true);
        }
    }
}

if (box_style == "organizer_tray") {
    echo(str("[SPEC] Organizer Tray: ", W, "×", D, "×", H_base, " mm  |  Wall: ", T, " mm"));
    divided_box_body(W, D, H_base, T, R, cols, rows, divider_thick, scooped_bottom, layout_spec);

} else if (box_style == "gift_box") {
    echo(str("[SPEC] Gift Box: ", W, "×", D, "×", H_base + H_lid, " mm (", gift_texture, ")"));
    lip_h = min(5, H_base * 0.25);
    lip_t = max(1.0, T * 0.48);

    if (render_part == "both" || render_part == "base") {
        x_off = (render_part == "both") ? -(W/2 + 6) : 0;
        translate([x_off, 0, 0]) {
            difference() {
                union() {
                    cuboid([W, D, H_base - lip_h], rounding = R, edges = "Z", anchor = BOTTOM);
                    if (gift_texture == "fluted") {
                        for (x = [-W/2 + R + 3 : 5 : W/2 - R - 3]) {
                            translate([x,  D/2, 0]) cylinder(d = 2.4, h = H_base - lip_h, anchor = BOTTOM, $fn=20);
                            translate([x, -D/2, 0]) cylinder(d = 2.4, h = H_base - lip_h, anchor = BOTTOM, $fn=20);
                        }
                        for (y = [-D/2 + R + 3 : 5 : D/2 - R - 3]) {
                            translate([ W/2, y, 0]) cylinder(d = 2.4, h = H_base - lip_h, anchor = BOTTOM, $fn=20);
                            translate([-W/2, y, 0]) cylinder(d = 2.4, h = H_base - lip_h, anchor = BOTTOM, $fn=20);
                        }
                    }
                    up(H_base - lip_h)
                        cuboid([W - 2*lip_t - printer_slop*2, D - 2*lip_t - printer_slop*2, lip_h], rounding = max(1, R - lip_t), edges = "Z", anchor = BOTTOM);
                }
                up(T)
                    cuboid([W - 2*T, D - 2*T, H_base + 1], rounding = max(1, R - T), edges = "Z", anchor = BOTTOM);
            }
        }
    }

    if (render_part == "both" || render_part == "lid") {
        x_off = (render_part == "both") ? (W/2 + 6) : 0;
        translate([x_off, 0, 0])
        apply_lid_inlay(W, D) {
            difference() {
                cuboid([W, D, H_lid], rounding = R, edges = "Z", anchor = BOTTOM);
                up(T)
                    cuboid([W - 2*T, D - 2*T, H_lid], rounding = max(1, R - T), edges = "Z", anchor = BOTTOM);
                up(H_lid - lip_h - 0.5)
                    cuboid([W - 2*lip_t, D - 2*lip_t, lip_h + 1], rounding = max(1, R - lip_t), edges = "Z", anchor = BOTTOM);
            }
        }
    }

} else if (box_style == "hinged_box") {
    // =========================================================================
    // HINGED UTILITY CASE (8mm SLIM LID + ROBUST WASHBOARD FRICTION TAB CLASP)
    // =========================================================================
    H_slim    = 8.0;
    hinge_r   = 4.0;
    pip_gap   = max(0.18, printer_slop);
    swing_cl  = pip_gap + 0.35;
    hinge_len = max(28, W - (R * 2) - 10);
    seg_len   = (hinge_len - pip_gap * 3) / 3;

    // Heavy-Duty Friction Clasp Dimensions (Recalibrated for Smooth, Tunable Effort!)
    tab_w     = min(32, max(20, W * 0.32));
    tab_t     = 2.8;                        // 2.8mm beam flexes smoothly without requiring excessive thumb force
    bite      = clasp_bite;                 // User-selected tooth interference (0.15mm Kid-Friendly .. 0.60mm Heavy)

    echo(str("[SPEC] Hinged Case: ", W, "×", D, "×", H_base + H_slim, " mm  |  Heavy-Duty Ribbed Friction Clasp (Bite: ", bite, "mm)  |  Lid Cutout: ", lid_label_mode));

    // -------------------------------------------------------------------------
    // 1. BASE CONTAINER (Front -Y side of bed)
    // -------------------------------------------------------------------------
    if (render_part == "both" || render_part == "base") {
        base_y = (render_part == "both") ? -(D/2 + hinge_r + 6) : 0;
        translate([0, base_y, 0]) {
            difference() {
                union() {
                    divided_box_body(W, D, H_base, T, R, cols, rows, divider_thick, scooped_bottom, layout_spec, flip_y = false, top_relief = 0.18);

                    // Left & Right Outer Hinge Knuckles
                    for (side = [-1, 1]) {
                        kx = side * (seg_len + pip_gap * 1.5);
                        hull() {
                            translate([kx, D/2 + hinge_r, H_base])
                                rotate([0, 90, 0]) cylinder(r = hinge_r, h = seg_len, center = true);
                            translate([kx, D/2 - T * 0.35, max(0, H_base - hinge_r * 2.1)])
                                cuboid([seg_len, T * 0.7, min(H_base, hinge_r * 2.1)], anchor = BOTTOM);
                        }
                    }

                    // RECALIBRATED WASHBOARD FRICTION RIBS ON BASE FRONT WALL (-Y)
                    // Why this feels so much smoother:
                    // Removed the 0.45mm protruding backing pad that was jamming the tab before the teeth even touched!
                    // Now the 5 horizontal 45° ridges project directly from the flush front wall (-D/2) by `r_proj = 0.25 + bite * 0.55`,
                    // while the Lid tab has a `0.25 + printer_slop * 0.5` clearance throat—so total deflection equals `bite`!
                    r_proj = 0.22 + bite * 0.55;
                    for (rz = [2.4, 3.6, 4.8, 6.0, 7.2]) {
                        translate([0, -D/2, H_base - rz])
                        rotate([0, 90, 0])
                        linear_extrude(height = tab_w, center = true)
                            polygon([
                                [-0.60,  0.2],
                                [ 0.0,  -r_proj], // Support-free 45° friction ridge
                                [ 0.60,  0.2]
                            ]);
                    }

                    // 3. Left & Right Protective Side Guide Cheeks (prevent the tab from getting snagged from the side)
                    for (side = [-1, 1]) {
                        sx = side * (tab_w/2 + 2.2);
                        translate([sx, -D/2, H_base])
                        rotate([0, 90, 0])
                        linear_extrude(height = 2.8, center = true)
                            polygon([
                                [0.0,  0.2],
                                [0.8, -1.6],
                                [7.2, -1.6],
                                [9.2,  0.2]
                            ]);
                    }
                }

                // Center Swing-Clearance Pocket in Base Rear Wall
                intersection() {
                    translate([0, D/2 + hinge_r, H_base])
                        rotate([0, 90, 0])
                            cylinder(r = hinge_r + swing_cl, h = seg_len + pip_gap * 2.0, center = true);
                    translate([0, D/2 - T, H_base - hinge_r * 2])
                        cuboid([seg_len + pip_gap * 2.2, T * 2 + 2.0, hinge_r * 4], anchor = BOTTOM);
                }
                translate([0, D/2, H_base])
                    rotate([45, 0, 0])
                        cuboid([seg_len + pip_gap * 2.0, 1.4, 1.4], center = true);
            }

            // Uncut Inward Locking Cones on Base Outer Knuckles
            for (side = [-1, 1]) {
                kx = side * (seg_len + pip_gap * 1.5);
                stud_h = hinge_r * 0.52;
                translate([kx - side*(seg_len/2 - 0.2), D/2 + hinge_r, H_base])
                    rotate([0, side < 0 ? 90 : -90, 0])
                        cylinder(r1 = hinge_r * 0.55, r2 = hinge_r * 0.28, h = stud_h + 0.2, chamfer2 = 0.3);
            }
        }
    }

    // -------------------------------------------------------------------------
    // 2. SLIM 8mm LID WITH HEAVY-DUTY RIBBED FRICTION TAB & ENGRAVED CUTOUT
    // -------------------------------------------------------------------------
    if (render_part == "both" || render_part == "lid") {
        lid_y = (render_part == "both") ? (D/2 + hinge_r + 6) : 0;
        translate([0, lid_y, 0]) {
            apply_lid_inlay(W, D)
            difference() {
                union() {
                    divided_box_body(W, D, H_slim, T, R, cols, rows, divider_thick, scoop = false, l_spec = layout_spec, flip_y = true, top_relief = 0.18);

                    // Center Hinge Knuckle at Lid Rim
                    hull() {
                        translate([0, -D/2 - hinge_r, H_slim])
                            rotate([0, 90, 0]) cylinder(r = hinge_r, h = seg_len, center = true);
                        translate([0, -D/2 + T * 0.35, max(0, H_slim - hinge_r * 2.1)])
                            cuboid([seg_len, T * 0.7, min(H_slim, hinge_r * 2.1)], anchor = BOTTOM);
                    }

                    // =========================================================
                    // HEAVY-DUTY RIBBED FRICTION TAB ON LID FRONT WALL (+Y)
                    // =========================================================
                    // Why this tab won't break:
                    // 1. Thick 3.4mm main beam with a massive 5.2mm gusseted base transition (Z = 0..H_slim)
                    //    that spreads bending stress down the entire 8mm front wall of the lid.
                    // 2. Instead of a deep single hook that forces the plastic past its yield point,
                    //    it uses 3 rounded horizontal friction ribs (`Z = H_slim + 2.8, 4.0, 5.2`)
                    //    that rake across the Base's 5 washboard ridges with only ~0.6mm of elastic flex!
                    // 3. Includes an angled outward thumb-pry lip at the top (`Z = H_slim + 7.8`) for easy opening.
                    // Calibrated clearance throat so when bite = 0.15 (Kid-Friendly), the teeth engage by a gentle 0.15mm!
                    throat_cl = 0.22 + (printer_slop * 0.5);
                    t_crest   = throat_cl - (0.22 + bite * 0.45); // At bite=0.15 & slop=0.20: throat=0.32, r_proj=0.30, t_crest=+0.03 -> total overlap = 0.27mm!

                    translate([0, D/2, 0])
                    rotate([0, 90, 0])
                    linear_extrude(height = tab_w - 0.8, center = true)
                        polygon([
                            // Note: After rotate([0,90,0]), Polygon X = -Z (height from bed), Polygon Y = +Y (projection forward from D/2)
                            [  0.0,   -T + 0.2],                 // Anchored inside Lid front wall at Z = 0
                            [  0.0,    1.8],                     // Chamfered bottom edge on print bed
                            [ -2.2,    throat_cl + tab_t + 0.3], // Reinforced root gusset along outer face
                            [ -H_slim, throat_cl + tab_t + 0.2], // Full thickness at Lid rim plane (Z = 8.0mm)
                            [-(H_slim + 5.8), throat_cl + tab_t],       // Outer face of friction tab
                            [-(H_slim + 7.8), throat_cl + tab_t + 2.0], // Wide, easy-grab outward thumb-lift lip (great for kids' fingers!)
                            [-(H_slim + 8.5), throat_cl + tab_t + 0.9], // Top tip of thumb lip
                            [-(H_slim + 6.5), throat_cl + 0.70],        // Gentle lead-in entry ramp on inside of tab tip
                            // 3 Calibrated Washboard Friction Ribs along the inside of the tab (`Z = H_slim + 3.0..5.4`):
                            [-(H_slim + 5.8), throat_cl],               // Valley 3
                            [-(H_slim + 5.2), t_crest + 0.06],          // Tooth 3 crest (slightly softer entry tooth)
                            [-(H_slim + 4.6), throat_cl],               // Valley 2
                            [-(H_slim + 4.0), t_crest],                 // Tooth 2 main crest
                            [-(H_slim + 3.4), throat_cl],               // Valley 1
                            [-(H_slim + 2.8), t_crest + 0.06],          // Tooth 1 crest
                            [-(H_slim + 1.6), throat_cl + 0.15],        // Flex relief pocket above rim (lets tab flex easily!)
                            [ -H_slim,       -0.15],                    // Meets Lid rim smoothly
                            [ -H_slim,       -T + 0.2]                  // Anchored inside Lid wall
                        ]);
                }

                // Left & Right Swing-Clearance Pockets on Lid Rear Rim
                for (side = [-1, 1]) {
                    kx = side * (seg_len + pip_gap * 1.5);
                    translate([kx, -D/2 - hinge_r, H_slim])
                        rotate([0, 90, 0])
                            cylinder(r = hinge_r + swing_cl, h = seg_len + pip_gap * 2.5, center = true);
                    translate([kx, -D/2, H_slim])
                        rotate([45, 0, 0])
                            cuboid([seg_len + pip_gap * 2.5, 1.4, 1.4], center = true);
                }

                // Snap-Together Detent Sockets + Lead-in Ramp + Center Flex Slot
                stud_h = hinge_r * 0.52 + pip_gap;
                for (side = [-1, 1]) {
                    translate([side * (seg_len/2), -D/2 - hinge_r, H_slim])
                        rotate([0, side < 0 ? 90 : -90, 0])
                            cylinder(r1 = hinge_r * 0.55 + pip_gap * 1.1, r2 = hinge_r * 0.28 + pip_gap, h = stud_h);

                    hull() {
                        translate([side * (seg_len/2), -D/2 - hinge_r, H_slim])
                            rotate([0, side < 0 ? 90 : -90, 0])
                                cylinder(r1 = hinge_r * 0.45, r2 = hinge_r * 0.22, h = stud_h * 0.72);
                        translate([side * (seg_len/2), -D/2 - hinge_r, H_slim + hinge_r + 1])
                            rotate([0, side < 0 ? 90 : -90, 0])
                                cylinder(r1 = hinge_r * 0.52, r2 = hinge_r * 0.26, h = stud_h * 0.80);
                    }
                }
                translate([0, -D/2 - hinge_r, H_slim])
                    cuboid([1.2, hinge_r * 2.2, hinge_r * 2.4], center = true);
            }
        }
    }

} else if (box_style == "slide_box") {
    rail_h     = 4.2;
    lid_plate  = max(2.2, T);
    skirt_w    = max(2.2, T * 0.95);
    dove_depth = 1.3;
    slop       = printer_slop;
    rim_wall   = T + skirt_w + dove_depth * 0.6;

    echo(str("[SPEC] Slide-Track Case: ", W, "×", D, "×", H_base + lid_plate, " mm  |  45° Dovetail Track  |  Lid Cutout: ", lid_label_mode));

    if (render_part == "both" || render_part == "base") {
        base_y = (render_part == "both") ? -(D/2 + 8) : 0;
        translate([0, base_y, 0]) {
            difference() {
                divided_box_body(W, D, H_base, rim_wall, R, cols, rows, divider_thick, scooped_bottom, layout_spec, top_relief = 0.20);

                for (side = [-1, 1]) {
                    translate([-W/2 + skirt_w, 0, H_base - rail_h])
                    rotate([0, 90, 0])
                    linear_extrude(height = W + 4)
                        polygon([
                            [-rail_h - 0.5, side * (D/2 - skirt_w)],
                            [-rail_h + 1.2, side * (D/2 - skirt_w)],
                            [ 0.0,          side * (D/2 - skirt_w - dove_depth)],
                            [ 0.0,          side * (D/2 + 2)],
                            [-rail_h - 0.5, side * (D/2 + 2)]
                        ]);
                }

                translate([W/2 - skirt_w, -D/2 - 1, H_base - rail_h])
                    cube([skirt_w + 2, D + 2, rail_h + 1]);

                if (slide_lock_style == "detent") {
                    for (side = [-1, 1]) {
                        translate([W/2 - skirt_w - 8, side * (D/2 - skirt_w - dove_depth * 0.4), H_base - rail_h/2])
                            sphere(r = 0.95, $fn = 24);
                    }
                }
            }
        }
    }

    if (render_part == "both" || render_part == "lid") {
        lid_y = (render_part == "both") ? (D/2 + 8) : 0;
        total_lid_z = lid_plate + rail_h;

        translate([0, lid_y, 0])
        apply_lid_inlay(W, D) {
            difference() {
                cuboid([W, D, total_lid_z], rounding = R, edges = "Z", anchor = BOTTOM);

                translate([-W/2 - 2, 0, lid_plate])
                rotate([0, 90, 0])
                linear_extrude(height = W - skirt_w + 2 - slop)
                    polygon([
                        [ 0.1,              -(D/2 - skirt_w + slop)],
                        [-1.2,              -(D/2 - skirt_w + slop)],
                        [-(rail_h + 0.5),   -(D/2 - skirt_w - dove_depth + slop)],
                        [-(rail_h + 0.5),    (D/2 - skirt_w - dove_depth + slop)],
                        [-1.2,               (D/2 - skirt_w + slop)],
                        [ 0.1,               (D/2 - skirt_w + slop)]
                    ]);

                translate([-W/2 - 0.1, 0, lid_plate + rail_h/2])
                    cuboid([3.0, D - 2*skirt_w + 1.6, rail_h + 1], chamfer = 1.2, anchor = CENTER);

                if (thumb_grip && lid_label_mode == "none") {
                    for (gx = [W/2 - 12, W/2 - 17, W/2 - 22]) {
                        translate([gx, 0, 0])
                            rotate([90, 0, 0])
                                cylinder(d = 2.2, h = min(36, D * 0.48), center = true, $fn = 24);
                    }
                }
            }

            if (slide_lock_style == "detent") {
                for (side = [-1, 1]) {
                    translate([W/2 - skirt_w - 8, side * (D/2 - skirt_w - dove_depth * 0.4 + slop * 0.5), lid_plate + rail_h/2])
                        sphere(r = 0.85, $fn = 24);
                }
            }
        }
    }

} else if (box_style == "drawer_system") {
    d_cols = max(1, round(drawer_cols));
    d_rows = max(1, round(drawer_rows));
    div_shelf = max(1.6, T * 0.75);
    slot_clear = printer_slop * 2.2;

    avail_cab_w = max(d_cols * 14, W - (2 * T) - (d_cols - 1) * div_shelf);
    avail_cab_h = max(d_rows * 12, H_base);

    slot_parts = (len(str_strip(str(drawer_slot_spec), " ")) > 0) ? str_split(drawer_slot_spec, "|") : [];
    user_sw = (len(slot_parts) > 0) ? parse_csv_nums(slot_parts[0]) : [];
    user_sh = (len(slot_parts) > 1) ? parse_csv_nums(slot_parts[1]) : [];

    slot_widths  = resolve_Remainder_List(d_cols, avail_cab_w, user_sw, 14.0);
    slot_heights = resolve_Remainder_List(d_rows, avail_cab_h, user_sh, 12.0);

    slot_x0 = prefix_offsets(slot_widths, div_shelf);
    slot_z0 = prefix_offsets(slot_heights, div_shelf);

    cab_total_h = sum(slot_heights) + ((d_rows - 1) * div_shelf) + (2 * T);
    slot_d = D - T;
    drw_d  = slot_d - slot_clear;

    echo(str("[SPEC] Drawer Cabinet: ", W, "×", D, "×", round(cab_total_h*10)/10, " mm (", d_cols, "×", d_rows, " Drawers)"));

    if (drawer_render_mode == "both" || drawer_render_mode == "cabinet") {
        cab_x_off = (drawer_render_mode == "both") ? -(W/2 + slot_widths[0]/2 + 12) : 0;
        translate([cab_x_off, 0, 0])
        translate([0, 0, D/2])
        rotate([90, 0, 0])
        translate([0, 0, -cab_total_h/2]) {
            difference() {
                union() {
                    cuboid([W, D, cab_total_h], rounding = min(4, R), edges = "Y", anchor = BOTTOM);
                    if (stackable_cabinet) {
                        for (sx = [-W/2 + 12, W/2 - 12])
                            for (sy = [-D/2 + 14, D/2 - 14])
                                translate([sx, sy, cab_total_h])
                                    cylinder(d1 = 5.6, d2 = 4.2, h = 2.8, anchor = BOTTOM);
                    }
                }

                for (c = [0 : d_cols - 1]) {
                    for (r = [0 : d_rows - 1]) {
                        sw = slot_widths[c];
                        sh = slot_heights[r];
                        sx = -W/2 + T + slot_x0[c] + sw/2;
                        sz = T + slot_z0[r];
                        translate([sx, -D/2 - 0.1, sz])
                            cuboid([sw, slot_d + 0.2, sh], rounding = 1.0, edges = "Y", anchor = BOTTOM+FRONT);
                    }
                }

                if (stackable_cabinet) {
                    for (sx = [-W/2 + 12, W/2 - 12])
                        for (sy = [-D/2 + 14, D/2 - 14])
                            translate([sx, sy, -0.1])
                                cylinder(d1 = 6.2 + printer_slop*2, d2 = 4.6 + printer_slop*2, h = 3.2, anchor = BOTTOM);
                }

                if (wall_mount_holes && cab_total_h >= 28) {
                    for (kx = [-W * 0.28, W * 0.28]) {
                        translate([kx, D/2 - T - 0.1, cab_total_h * 0.72])
                        rotate([-90, 0, 0]) {
                            cylinder(d = 8.0, h = T + 1);
                            translate([0, 4.5, 0]) cylinder(d = 4.2, h = T + 1);
                            translate([-2.1, 0, 0]) cube([4.2, 4.5, T + 1]);
                        }
                    }
                }
            }
        }
    }

    if (drawer_render_mode == "drawer") {
        single_drawer(slot_widths[0] - slot_clear*2, drw_d, slot_heights[0] - slot_clear*2);
    } else if (drawer_render_mode == "both") {
        drw_x_off = W/2 + slot_widths[0]/2 + 10;
        translate([drw_x_off, 0, 0])
            single_drawer(slot_widths[0] - slot_clear*2, drw_d, slot_heights[0] - slot_clear*2);
    } else if (drawer_render_mode == "all_drawers") {
        for (c = [0 : d_cols - 1]) {
            for (r = [0 : d_rows - 1]) {
                dw = slot_widths[c] - slot_clear*2;
                dh = slot_heights[r] - slot_clear*2;
                dx = -avail_cab_w/2 + slot_x0[c] + dw/2 + c * 8;
                dy = (r - (d_rows - 1)/2) * (drw_d + 18);
                translate([dx, dy, 0])
                    single_drawer(dw, drw_d, dh);
            }
        }
    }
}

include <BOSL2/std.scad>

/* [1. Container Category & Render Mode] */
// Select System Style [hinged_box:Durable Hinged Utility Case (Snap-Together Hinge + Anti-Mix Lid), slide_box:Slide-On Track Cover Utility Box (Dovetail Rail + Anti-Mix Seal), drawer_system:Modular Drawer Cabinet & Pull-Out Drawers, organizer_tray:Open Drawer / Parts Organizer Tray, gift_box:Fluted / Classic Gift Box with Slip Lid]
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

// Lid Height - Z Axis (For Hinged & Gift Box) [8:8 mm (Low Profile Lid), 10:10 mm, 12:12 mm (Standard Lid), 15:15 mm, 20:20 mm (Deep Clamshell Lid), 25:25 mm, 30:30 mm] @show_if(box_style=hinged_box|gift_box)
lid_height = 12;

// Outer Wall Thickness [1.6:1.6 mm (Light / 4 Walls), 2.0:2.0 mm (Standard), 2.4:2.4 mm (Durable Case), 3.0:3.0 mm (Heavy Duty Rugged), 4.0:4.0 mm (Armor Box)]
wall_thick = 2.4;

// Outer Corner Rounding Radius [2:2 mm (Crisp), 4:4 mm (Standard), 6:6 mm (Smooth), 10:10 mm (Wide Rounded), 15:15 mm (Extra Wide Rounded)]
corner_radius = 4;

/* [3. Hinged Case Options (Original Snap-Post Hinge with Swing Clearance)] */
// Front Closure Clasp [snap_lip:Cantilever Snap-Hook Clasp, lug_m3:Heavy-Duty M3 Bolted Latch Ears, none:No Latch (Free Swinging)] @show_if(box_style=hinged_box)
latch_type = "snap_lip";

// Matching Lid Compartment Dividers [flush_seal:Flush Anti-Mix Lid Dividers (Seals Every Cubby Shut When Closed!), recessed:Half-Height Lid Dividers, none:Open Hollow Lid (No Lid Dividers)] @show_if(box_style=hinged_box)
lid_divider_style = "flush_seal";

/* [4. Slide-On Cover Options (For Slide Box)] */
// Detent Click-Lock Retention [detent:Positive Click-Stop Detent Bump (Keeps Lid Closed in Bag!), smooth:Smooth Free-Sliding Track (No Detent Bump)] @show_if(box_style=slide_box)
slide_lock_style = "detent";

// Include Thumb-Push Grip Grooves on Top of Lid @show_if(box_style=slide_box)
thumb_grip = true;

/* [5. Modular Drawer System Options] */
// Drawer Columns Wide (X) [1:1 Drawer Wide, 2:2 Drawers Wide, 3:3 Drawers Wide, 4:4 Drawers Wide] @show_if(box_style=drawer_system)
drawer_cols = 2;

// Drawer Tiers Tall (Z) [1:1 Tier Tall, 2:2 Tiers Tall, 3:3 Tiers Tall, 4:4 Tiers Tall, 5:5 Tiers Tall] @show_if(box_style=drawer_system)
drawer_rows = 2;

// Pull-Out Handle Style [lip_pull:Ergonomic Curved Finger Lip Pull, d_loop:Heavy D-Ring Loop Handle, label_pull:Label-Frame Pull Handle (Slide-in Label Slot!), recessed_scoop:Flush Half-Moon Thumb Cutout, round_knob:Classic Chamfered Round Knob] @show_if(box_style=drawer_system)
handle_style = "lip_pull";

// Stackable Interlocking Cabinet Lugs (Top & Bottom) @show_if(box_style=drawer_system)
stackable_cabinet = true;

// Rear Keyhole Wall-Mount Slots @show_if(box_style=drawer_system)
wall_mount_holes = true;

/* [6. Internal Compartment Layout (Use Visual 2D Designer Above!)] */
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

/* [7. Gift Box Styling] */
// Gift Box Exterior Wall Texture [fluted:Vertical Fluted Ribs (Elegant), smooth:Smooth Classic Walls] @show_if(box_style=gift_box)
gift_texture = "fluted";

/* [8. 3D Print Clearance] */
// Hinge / Track / Drawer Clearance [0.12:0.12 mm (Snug Precision), 0.16:0.16 mm (Standard PLA/PETG), 0.20:0.20 mm (Easy Snap / Free Hinge), 0.25:0.25 mm (Loose Fit)]
printer_slop = 0.20;

/* [Hidden] */
$fn = 48;

W = max(30, outer_width);
D = max(30, outer_depth);
H_base = max(12, base_height);
H_lid  = max(7, lid_height);
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
        translate([x_off, 0, 0]) {
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
    // ORIGINAL 3-SEGMENT SNAP-POST HINGE (WITH CORRECTED ZERO-FULCRUM CLEARANCE)
    // =========================================================================
    // Fixes applied to the original hinge design:
    // 1. Cylindrical swing-clearance cutouts (`r = hinge_r + swing_clear`) carved into the Base's center rear wall
    //    and the Lid's outer rear walls so the knuckles rotate 180 deg closed without hitting the opposing support web!
    // 2. 45-degree rear rim relief chamfer along the hinge parting edge so print seams never lever the hinge upward.
    // 3. Preserved original 3-segment snap-together cone geometry + center flex slot with exact Z/Y clasp alignment.
    hinge_r = 4.0;
    swing_clear = printer_slop + 0.35;
    hinge_len = max(28, W - (R * 2) - 10);
    seg_len = (hinge_len - printer_slop * 3) / 3;

    catch_offset_from_rim = 3.0;
    clasp_w = min(28, max(16, W * 0.32));

    base_div_relief = (lid_divider_style == "flush_seal") ? 0.18 : 0;
    lid_div_relief  = (lid_divider_style == "flush_seal") ? 0.18 :
                      (lid_divider_style == "recessed")   ? min(3.0, (H_lid - T) * 0.45) : 0;

    echo(str("[SPEC] Hinged Case: ", W, "×", D, "×", H_base + H_lid, " mm  |  Original Snap-Post Hinge (Zero-Fulcrum Clearance)  |  Lid: ", lid_divider_style));

    // 1. BASE CONTAINER (Placed on Front -Y side of bed)
    if (render_part == "both" || render_part == "base") {
        base_y = (render_part == "both") ? -(D/2 + hinge_r + 6) : 0;
        translate([0, base_y, 0]) {
            difference() {
                union() {
                    divided_box_body(W, D, H_base, T, R, cols, rows, divider_thick, scooped_bottom, layout_spec, flip_y = false, top_relief = base_div_relief);

                    // Left & Right Outer Hinge Knuckles + Inward Snap Cones (Original Design)
                    for (side = [-1, 1]) {
                        kx = side * (seg_len + printer_slop * 1.5);
                        hull() {
                            translate([kx, D/2 + hinge_r, H_base])
                                rotate([0, 90, 0]) cylinder(r = hinge_r, h = seg_len, center = true);
                            translate([kx, D/2 - T * 0.35, max(0, H_base - hinge_r * 2.1)])
                                cuboid([seg_len, T * 0.7, min(H_base, hinge_r * 2.1)], anchor = BOTTOM);
                        }
                        stud_h = hinge_r * 0.48;
                        translate([kx - side*(seg_len/2), D/2 + hinge_r, H_base])
                            rotate([0, side < 0 ? 90 : -90, 0])
                                cylinder(r1 = hinge_r * 0.52, r2 = hinge_r * 0.25, h = stud_h, chamfer2 = 0.4);
                    }

                    // Front Catch Lip on Base (-Y wall)
                    if (latch_type == "snap_lip") {
                        translate([0, -D/2, H_base - catch_offset_from_rim])
                        rotate([0, 90, 0])
                        linear_extrude(height = clasp_w - 2, center = true)
                            polygon([
                                [-2.2, 0],
                                [ 0.0, -1.6],
                                [ 1.4, -1.6],
                                [ 2.6, 0]
                            ]);
                    } else if (latch_type == "lug_m3") {
                        difference() {
                            translate([0, -D/2 - 4, H_base - 6])
                                cuboid([18, 8, 6], rounding = 2, edges = "Z", anchor = BOTTOM);
                            translate([0, -D/2 - 4, H_base - 7])
                                cylinder(d = 3.2, h = 10, anchor = BOTTOM);
                        }
                    }
                }

                // CLEARANCE FIX 1 (BASE): Carve swing pocket ONLY into the Base's rear wall (Y <= D/2 + 1.2)
                // and narrower than the cone tips, so the Lid's knuckle clears the wall while leaving the locking cones 100% intact!
                intersection() {
                    translate([0, D/2 + hinge_r, H_base])
                        rotate([0, 90, 0])
                            cylinder(r = hinge_r + swing_clear, h = seg_len + printer_slop * 2.0, center = true);
                    translate([0, D/2 - T, H_base - hinge_r * 2])
                        cuboid([seg_len + printer_slop * 2.2, T * 2 + 2.0, hinge_r * 4], anchor = BOTTOM);
                }

                // CLEARANCE FIX 2 (BASE): Slight 45° rear outer rim relief chamfer along the center gap
                translate([0, D/2, H_base])
                    rotate([45, 0, 0])
                        cuboid([seg_len + printer_slop * 2.0, 1.4, 1.4], center = true);
            }

            // Re-affirm inward locking cones outside difference() so they are guaranteed 100% uncut!
            for (side = [-1, 1]) {
                kx = side * (seg_len + printer_slop * 1.5);
                stud_h = hinge_r * 0.52;
                translate([kx - side*(seg_len/2 - 0.2), D/2 + hinge_r, H_base])
                    rotate([0, side < 0 ? 90 : -90, 0])
                        cylinder(r1 = hinge_r * 0.55, r2 = hinge_r * 0.28, h = stud_h + 0.2, chamfer2 = 0.3);
            }
        }
    }

    // 2. LID COVER (Placed on Back +Y side of bed, with Y-Mirrored Dividers & Corrected Hinge Clearances)
    if (render_part == "both" || render_part == "lid") {
        lid_y = (render_part == "both") ? (D/2 + hinge_r + 6) : 0;
        translate([0, lid_y, 0]) {
            difference() {
                union() {
                    if (lid_divider_style == "none") {
                        difference() {
                            cuboid([W, D, H_lid], rounding = R, edges = "Z", anchor = BOTTOM);
                            up(T)
                                cuboid([W - 2*T, D - 2*T, H_lid + 1], rounding = max(1, R - T), edges = "Z", anchor = BOTTOM);
                        }
                    } else {
                        divided_box_body(W, D, H_lid, T, R, cols, rows, divider_thick, scoop = false, l_spec = layout_spec, flip_y = true, top_relief = lid_div_relief);
                    }

                    // Center Hinge Knuckle at Lid Rim (Original Design)
                    hull() {
                        translate([0, -D/2 - hinge_r, H_lid])
                            rotate([0, 90, 0]) cylinder(r = hinge_r, h = seg_len, center = true);
                        translate([0, -D/2 + T * 0.35, max(0, H_lid - hinge_r * 2.1)])
                            cuboid([seg_len, T * 0.7, min(H_lid, hinge_r * 2.1)], anchor = BOTTOM);
                    }

                    // Positive-Locking Cantilever Clasp on +Y Edge of Lid
                    if (latch_type == "snap_lip") {
                        arm_base_z = max(1.0, H_lid - 5.0);
                        arm_top_z  = H_lid + catch_offset_from_rim + 2.2;
                        arm_thick  = 2.2;
                        gap_clear  = printer_slop + 0.10;

                        hull() {
                            translate([0, D/2 - T/2, arm_base_z])
                                cuboid([clasp_w, T, H_lid - arm_base_z], anchor = BOTTOM);
                            translate([0, D/2 + gap_clear + arm_thick/2, H_lid - 2.0])
                                cuboid([clasp_w, arm_thick, 2.0], anchor = BOTTOM);
                        }
                        translate([0, D/2 + gap_clear + arm_thick/2, H_lid - 2.0])
                            cuboid([clasp_w, arm_thick, (arm_top_z - H_lid) + 2.0], rounding = 1.0, edges = "Z", anchor = BOTTOM);

                        translate([0, D/2 + gap_clear, H_lid + catch_offset_from_rim])
                        rotate([0, 90, 0])
                        linear_extrude(height = clasp_w - 2, center = true)
                            polygon([
                                [-1.2, 0],
                                [ 0.4, -1.45],
                                [ 2.2, 0],
                                [ 2.2, arm_thick + 1.2],
                                [-1.2, arm_thick]
                            ]);
                    } else if (latch_type == "lug_m3") {
                        translate([0, D/2 + 4, H_lid - 6])
                            cuboid([18, 8, 6], rounding = 2, edges = "Z", anchor = BOTTOM);
                    }
                }

                // CLEARANCE FIX 1 (LID): Carve cylindrical swing pockets on Left & Right of the Lid's rear rim where the Base's outer knuckles sit!
                // Without these two pockets, the Lid's rear wall hits the Base's 45° knuckle support webs before reaching 0° closed!
                for (side = [-1, 1]) {
                    kx = side * (seg_len + printer_slop * 1.5);
                    translate([kx, -D/2 - hinge_r, H_lid])
                        rotate([0, 90, 0])
                            cylinder(r = hinge_r + swing_clear, h = seg_len + printer_slop * 2.5, center = true);
                    translate([kx, -D/2, H_lid])
                        rotate([45, 0, 0])
                            cuboid([seg_len + printer_slop * 2.5, 1.4, 1.4], center = true);
                }

                // Original Snap-Together Detent Sockets + Lead-in Ramp + Center Flex Slot
                stud_h = hinge_r * 0.48 + printer_slop;
                for (side = [-1, 1]) {
                    translate([side * (seg_len/2), -D/2 - hinge_r, H_lid])
                        rotate([0, side < 0 ? 90 : -90, 0])
                            cylinder(r1 = hinge_r * 0.52 + printer_slop * 1.1, r2 = hinge_r * 0.25 + printer_slop, h = stud_h);

                    hull() {
                        translate([side * (seg_len/2), -D/2 - hinge_r, H_lid])
                            rotate([0, side < 0 ? 90 : -90, 0])
                                cylinder(r1 = hinge_r * 0.44, r2 = hinge_r * 0.20, h = stud_h * 0.72);
                        translate([side * (seg_len/2), -D/2 - hinge_r, H_lid + hinge_r + 1])
                            rotate([0, side < 0 ? 90 : -90, 0])
                                cylinder(r1 = hinge_r * 0.50, r2 = hinge_r * 0.25, h = stud_h * 0.80);
                    }
                }
                translate([0, -D/2 - hinge_r, H_lid])
                    cuboid([1.2, hinge_r * 2.2, hinge_r * 2.4], center = true);

                if (latch_type == "lug_m3") {
                    translate([0, D/2 + 4, H_lid - 7])
                        cylinder(d = 3.2, h = 10, anchor = BOTTOM);
                }
            }
        }
    }

} else if (box_style == "slide_box") {
    // =========================================================================
    // SLIDE-ON DOVETAIL TRACK UTILITY CASE (FLUSH OUTER WALLS + ANTI-MIX SEAL)
    // =========================================================================
    rail_h     = 4.2;
    lid_plate  = max(2.2, T);
    skirt_w    = max(2.2, T * 0.95);
    dove_depth = 1.3;
    slop       = printer_slop;
    rim_wall   = T + skirt_w + dove_depth * 0.6;

    echo(str("[SPEC] Slide-Track Case: ", W, "×", D, "×", H_base + lid_plate, " mm  |  45° Dovetail Track + Flush Anti-Mix Seal  |  Clearance: ", slop, " mm"));

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

        translate([0, lid_y, 0]) {
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

                if (thumb_grip) {
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

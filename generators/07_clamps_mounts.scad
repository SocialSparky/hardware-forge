include <BOSL2/std.scad>
include <BOSL2/screws.scad>

/* [1. Profile Shape & Clamp Style] */
// 1. Cross-Section Profile Shape [round:Round Pipe / Conduit / Hose, square:Square / Rectangular Tube or Strut]
profile_shape = "round";

// 2. Select Clamp / Mount Style [worm_band:Adjustable Tangential Band Clamp (Split & Fold Bolt + Nut!), saddle_2hole:2-Hole Conduit / Tube Saddle Strap, p_clip_1hole:1-Hole Split-Ear P-Clip (Spreads Open & Tightens with Screw), snap_clip:Open Snap-In Conduit / Tube Clip, split_block:2-Piece Bolted Split Clamp Block, c_clamp:Heavy-Duty Threaded G-Clamp / C-Clamp]
clamp_type = "worm_band";

// 3. Band Clamp Bolt Style [split:Split & Fold Bolt + Print-Thread Nut (Recommended — Super Strong!), flat:One-Piece Flat-Sided Bolt + Nut, ratchet_zip:Tool-Free Squeeze Ratchet Zip-Clip (No Bolt)] @show_if(clamp_type=worm_band)
worm_fastener_type = "split";

// 4. Thread Pitch Type [print:Coarse Print Thread (Recommended — Deep Teeth, Won't Strip!), iso:Standard ISO Metric Thread (Fits Metal Nuts)] @show_if(clamp_type=worm_band)
thread_type = "print";

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

// Bolt Head Style (Round Clamps Only — Square Clamps Auto-Use Socket Allen Head for Corner Clearance!) [knurled:Knurled Thumb Wheel (Hand Grip), hex:Hex Wrench Head, socket:Low-Profile Socket Head (Allen Key)] @show_if(profile_shape=round)
head_type = "knurled";

// Include Matching Installation Tool on Build Plate (Allen Key / Wrench — Optional!) @show_if(clamp_type=worm_band)
include_tool = false;

// What Parts to Render (For Band Clamps) [all:Clamp + Split-Fold Bolt & Nut, hw_only:Split-Fold Bolt & Nut Only (No Clamp!), nut_only:Replacement Hex Nut Only, bolt_only:Split-Fold Bolt Only, clamp_only:Clamp Body Only, tool_only:Matching Installation Tool Only] @show_if(clamp_type=worm_band)
worm_render_part = "all";

// Countersink Mounting Screw Holes @show_if(clamp_type=saddle_2hole|p_clip_1hole|snap_clip)
countersink_holes = true;

/* [4. Split & Fold Bolt Fine-Tuning] */
// Hinge Thickness on Split Bolt (mm) [0.4:0.4 mm (2 Layers - PLA), 0.6:0.6 mm (3 Layers - Default/PETG), 0.8:0.8 mm (Heavy)] @show_if(clamp_type=worm_band)
hinge_thickness = 0.6;

// Top Flatten % on Split Halves (Removes Top Layer Blobs!) [10:10%, 12:12% (Recommended), 15:15%] @show_if(clamp_type=worm_band)
split_top_cut = 12;

// Thread Fit Tweak (+ Looser, - Tighter) [-0.1:-0.10 mm (Tighter), 0:0.00 mm (Auto Calibrated — Default), 0.1:+0.10 mm (Looser)] @show_if(clamp_type=worm_band)
clearance_tweak = 0.0;

/* [5. C-Clamp Specific Options] */
// C-Clamp Throat Depth [20:20 mm, 30:30 mm, 40:40 mm, 50:50 mm, 65:65 mm, 80:80 mm] @show_if(clamp_type=c_clamp)
throat_depth = 35;

// C-Clamp Frame Thickness [8:8 mm (Compact), 12:12 mm (Standard), 16:16 mm (Heavy Duty), 20:20 mm (Beast Mode)] @show_if(clamp_type=c_clamp)
c_frame_thick = 12;

/* [6. 3D Print Clearance] */
// Printer Clearance / Fit Slop [0.12:0.12 mm (Snug), 0.16:0.16 mm (Standard PLA/PETG), 0.22:0.22 mm (Easy Fit)]
printer_slop = 0.16;

/* [Hidden] */
$fn = 64;
$slop = printer_slop;
eps = 0.01;

// =============================================================================
// EXACT "SPLIT & FOLD BOLT" ENGINE (WITH KNURLED, HEX, SOCKET & OPTIONAL TOOLS)
// =============================================================================
sf_table = [
  ["M3",  3,  0.5,  5.5,  2.4,  2.0,  2.5],
  ["M4",  4,  0.7,  7,    3.2,  2.8,  3  ],
  ["M5",  5,  0.8,  8,    4.7,  3.5,  4  ],
  ["M6",  6,  1.0,  10,   5.2,  4.0,  5  ],
  ["M8",  8,  1.25, 13,   6.8,  5.3,  6  ],
  ["M10", 10, 1.5,  16,   8.4,  6.4,  8  ],
  ["M12", 12, 1.75, 18,   10.8, 7.5,  10 ]
];

sf_idx = [for (i = [0:len(sf_table)-1]) if (sf_table[i][0] == screw_spec) i][0];
sf_row = sf_table[is_undef(sf_idx) ? 2 : sf_idx];

s_diam  = sf_row[1];
S_HEX   = sf_row[3];
NUT_H   = sf_row[4];
HEAD_K  = sf_row[5];
KEY_SZ  = sf_row[6];

// Enforce Socket Head (Allen Key) on Square Clamps so the head NEVER collides with the flat square tube shoulder!
eff_head_type = (profile_shape == "square") ? "socket" : head_type;
KNURL_D = max(12.0, s_diam * 2.4);
KNURL_H = max(5.5, HEAD_K * 1.4);

PRINT_THREAD = (thread_type == "print");
P_PRINT = max(1, round(s_diam * 0.25 * 4) / 4);
P_PITCH = PRINT_THREAD ? P_PRINT : sf_row[2];
T_DEPTH = PRINT_THREAD ? (0.45 * P_PITCH) : (0.5413 * P_PITCH);

AUTO_CL = max(0.15, min(0.6, 0.32 * P_PITCH));
BOLT_CL = max(0, AUTO_CL + clearance_tweak);
NUT_CL  = max(0, AUTO_CL + clearance_tweak);
N_QUAL  = 64;

hole_d = s_diam + (printer_slop * 2.5);
csk_d  = hole_d * 2.0;
csk_h  = hole_d * 0.52;
nut_af = S_HEX + (printer_slop * 1.5);
nut_h  = NUT_H + 0.4;

module sf_thread_ribbon(R, len) {
  r0 = R - T_DEPTH;
  ri = r0 - 0.1 * P_PITCH;
  prof = PRINT_THREAD ? [[ri, -0.37*P_PITCH], [R, -0.15*P_PITCH], [R, 0.15*P_PITCH], [ri, 0.37*P_PITCH]]
                      : [[ri, -0.375*P_PITCH], [R, -P_PITCH/16], [R, P_PITCH/16], [ri, 0.375*P_PITCH]];
  z0 = -P_PITCH;
  steps = ceil((len + 2*P_PITCH) / P_PITCH * N_QUAL);
  pts = [for (k = [0:steps])
           let (a = k * 360 / N_QUAL, z = z0 + k * P_PITCH / N_QUAL)
           for (p = prof) [p[0]*cos(a), p[0]*sin(a), p[1] + z]];
  faces = concat(
    [[3, 2, 1, 0]],
    [[steps*4, steps*4+1, steps*4+2, steps*4+3]],
    [for (k = [0:steps-1]) for (j = [0:3])
       let (a = k*4 + j, b = k*4 + (j+1)%4,
            c = (k+1)*4 + (j+1)%4, d = (k+1)*4 + j)
       each [[a, b, c], [a, c, d]]]
  );
  polyhedron(points = pts, faces = faces);
}

module sf_thread_raw(R, len) {
  union() {
    sf_thread_ribbon(R, len);
    translate([0, 0, -P_PITCH]) cylinder(r = R - T_DEPTH, h = len + 2*P_PITCH, $fn = N_QUAL);
  }
}

module sf_trim(R, len, chamfer_bottom, chamfer_top) {
  r0 = R - T_DEPTH;
  Rv = R + 0.5;
  c  = Rv - r0;
  bottom = chamfer_bottom ? [[r0, 0], [Rv, c]]          : [[Rv, 0]];
  top    = chamfer_top    ? [[Rv, len - c], [r0, len]]  : [[Rv, len]];
  rotate_extrude($fn = N_QUAL)
    polygon(concat([[0, 0]], bottom, top, [[0, len]]));
}

module sf_external_thread(R, len, chamfer_bottom, chamfer_top) {
  intersection() {
    sf_thread_raw(R, len);
    sf_trim(R, len, chamfer_bottom, chamfer_top);
  }
}

module sf_hex_body(s, h) {
  e  = s / cos(30);
  rc = 0.475 * s;
  E  = e/2 + 0.5;
  t  = (E - rc) * tan(30);
  intersection() {
    cylinder(d = e, h = h, $fn = 6);
    rotate_extrude($fn = N_QUAL)
      polygon([[0, 0], [rc, 0], [E, t], [E, h - t], [rc, h], [0, h]]);
  }
}

module sf_knurled_head(d_k, h_k) {
  union() {
    rotate_extrude($fn = N_QUAL)
      polygon([[0, 0], [d_k/2 - 0.6, 0], [d_k/2, 0.6],
               [d_k/2, h_k - 0.6], [d_k/2 - 0.6, h_k], [0, h_k]]);
    for (a = [0 : 24 : 336])
      rotate([0, 0, a])
      translate([d_k/2, 0, h_k/2])
        cylinder(d = 1.6, h = h_k - 1.0, center = true, $fn = 16);
  }
}

module sf_bolt_vertical(L_shank) {
  Rb = (s_diam - BOLT_CL) / 2;
  hh = (eff_head_type == "socket") ? s_diam : (eff_head_type == "knurled" ? KNURL_H : HEAD_K);
  union() {
    if (eff_head_type == "hex") {
      sf_hex_body(S_HEX, hh);
    } else if (eff_head_type == "knurled") {
      sf_knurled_head(KNURL_D, hh);
    } else {
      dh = 1.5 * s_diam;
      difference() {
        rotate_extrude($fn = N_QUAL)
          polygon([[0, 0], [dh/2 - 0.5, 0], [dh/2, 0.5],
                   [dh/2, hh - 0.5], [dh/2 - 0.5, hh], [0, hh]]);
        translate([0, 0, -eps])
          cylinder(d = (KEY_SZ + 0.22) / cos(30), h = 0.65 * s_diam + eps, $fn = 6);
      }
    }
    translate([0, 0, hh - 0.01])
      sf_external_thread(Rb, L_shank + 0.01, false, true);
  }
}

module sf_bolt_printed(L_shank, style_mode = "split") {
  hh        = (eff_head_type == "socket") ? s_diam : (eff_head_type == "knurled" ? KNURL_H : HEAD_K);
  bolt_l    = hh + L_shank;
  half_w    = (eff_head_type == "hex") ? (S_HEX / 2) : (eff_head_type == "knurled" ? (KNURL_D / 2 + 0.5) : (0.75 * s_diam));
  h_gap     = 2.0;
  split_off = half_w + h_gap / 2;
  half_h    = s_diam / 2 - s_diam * (split_top_cut / 100);
  flat_t    = s_diam * (1 - 2 * 0.15);
  big       = 2 * (KNURL_D + S_HEX + s_diam + bolt_l);

  if (style_mode == "flat") {
    translate([0, 0, flat_t / 2])
      intersection() {
        rotate([0, 90, 0]) sf_bolt_vertical(L_shank);
        translate([-1, -big / 2, -flat_t / 2]) cube([bolt_l + 2, big, flat_t]);
      }
  } else {
    // Upper half (z >= 0)
    translate([0, -split_off, 0])
      intersection() {
        rotate([0, 90, 0]) sf_bolt_vertical(L_shank);
        union() {
          translate([-1, -big / 2, 0]) cube([hh + 1, big, big]);
          translate([hh, -big / 2, 0]) cube([L_shank + 1, big, half_h]);
        }
      }
    // Lower half (z <= 0 rotated 180° around X)
    translate([0, split_off, 0])
      rotate([180, 0, 0])
      intersection() {
        rotate([0, 90, 0]) sf_bolt_vertical(L_shank);
        union() {
          translate([-1, -big / 2, -big]) cube([hh + 1, big, big]);
          translate([hh, -big / 2, -half_h]) cube([L_shank + 1, big, half_h]);
        }
      }
    // Living hinge strip between the two head halves
    hx0 = hh * 0.15;
    hx1 = hh * 0.85;
    ov  = (eff_head_type == "knurled") ? 1.5 : 0.8;
    translate([hx0, -h_gap / 2 - ov, 0])
      cube([max(1, hx1 - hx0), h_gap + 2 * ov, hinge_thickness]);
  }
}

module sf_nut() {
  Rn = (s_diam + NUT_CL) / 2;
  r0 = Rn - T_DEPTH;
  c  = Rn - r0 + 0.2;
  difference() {
    sf_hex_body(S_HEX, NUT_H);
    sf_thread_raw(Rn, NUT_H);
    translate([0, 0, -eps])
      cylinder(r1 = Rn + 0.2, r2 = r0 - 0.01, h = c, $fn = N_QUAL);
    translate([0, 0, NUT_H - c + eps])
      cylinder(r1 = r0 - 0.01, r2 = Rn + 0.2, h = c, $fn = N_QUAL);
  }
}

// =============================================================================
// OPTIONAL FLAT-PRINTED INSTALLATION TOOLS (ALLEN KEY / HEX WRENCH)
// Printed flat on the bed so perimeter loops follow the L-bend / wrench jaws
// for maximum torque without shearing!
// =============================================================================
module printable_allen_key(af_size) {

  k_af    = af_size - 0.12;
  k_rad   = (k_af / cos(30)) / 2;
  long_l  = max(45, af_size * 10);
  short_l = max(16, af_size * 3.8);
  
  // Calculate if it's a whole or half metric size for the notches
  whole_mm = floor(af_size + 0.01);
  rem_mm   = abs(af_size - whole_mm);
  is_metric_whole = (rem_mm < 0.05);
  is_metric_half  = (abs(rem_mm - 0.5) < 0.05);

  translate([0, 0, k_af / 2])
  difference() {
    union() {
      rotate([0, 90, 0]) rotate([0, 0, 30]) cylinder(r = k_rad, h = long_l, $fn = 6);
      hull() {
        rotate([0, 90, 0]) rotate([0, 0, 30]) cylinder(r = k_rad, h = 1.0, $fn = 6);
        rotate([90, 0, 0]) rotate([0, 0, 30]) cylinder(r = k_rad, h = 1.0, $fn = 6);
      }
      rotate([90, 0, 0]) rotate([0, 0, 30]) cylinder(r = k_rad, h = short_l, $fn = 6);
    }
    
    // Tactile Metric Sizing V-Notches along the +Y Side Edge
    if (is_metric_whole || is_metric_half) {
      notch_depth = min(0.9, k_af * 0.22);
      start_x     = long_l - 8.0;
      pitch_x     = 2.6;
      for (n = [0 : whole_mm - 1]) {
        nx = start_x - (n * pitch_x);
        if (nx > k_af * 2.5) {
          translate([nx, k_rad, 0]) rotate([0, 0, 45])
            cube([notch_depth * 1.414, notch_depth * 1.414, k_af + 2], center = true);
        }
      }
      // Half-mm indicator notch
      if (is_metric_half) {
        hx = start_x - (whole_mm * pitch_x) - 1.2;
        if (hx > k_af * 2.5) {
          translate([hx, k_rad, 0]) rotate([0, 0, 45])
            cube([notch_depth * 0.85, notch_depth * 0.85, k_af + 2], center = true);
        }
      }
    }
  }

}



module printable_hex_wrench(s_flats) {
  w_af   = s_flats + 0.20;
  head_r = w_af * 0.95;
  thick  = max(4.0, min(6.5, s_flats * 0.5));
  arm_l  = max(45, s_flats * 5.0);

  linear_extrude(height = thick) {
    difference() {
      union() {
        // 12-point / 6-point box & open-end combo head
        circle(r = head_r, $fn = 48);
        hull() {
          translate([head_r * 0.5, 0]) circle(d = w_af * 0.85);
          translate([arm_l, 0]) circle(d = w_af * 1.05);
        }
      }
      // Hex socket opening + open-jaw entry slot
      circle(d = w_af / cos(30), $fn = 6);
      translate([-head_r, 0])
        square([head_r * 1.4, w_af], center = true);
      // Hang hole at end of handle
      translate([arm_l, 0])
        circle(d = max(4.0, w_af * 0.45), $fn = 24);
    }
  }
}

module render_matching_installation_tool() {
  if (eff_head_type == "socket") {
    // Socket Head bolt uses the matching Flat-Printed Allen Key
    printable_allen_key(KEY_SZ);
  } else if (eff_head_type == "hex") {
    // Hex Head bolt uses the matching Flat-Printed Hex Wrench
    printable_hex_wrench(S_HEX);
  } else {
    // Knurled Thumb Bolt is hand-turned, so provide the Hex Nut Wrench for holding the nut
    printable_hex_wrench(S_HEX);
  }
}

// =============================================================================
// CLAMP & MOUNT GEOMETRY
// =============================================================================
D  = (profile_shape == "square") ? max(4, square_width) : max(4, round_od);
HY = (profile_shape == "square") ? ((square_height > 0) ? max(4, square_height) : D) : D;
T  = max(1.2, wall_thick);

min_required_w = (clamp_type == "snap_clip" || clamp_type == "saddle_2hole" || clamp_type == "p_clip_1hole")
                 ? ((countersink_holes ? csk_d : hole_d) + 6.4)
                 : 6.0;
W = max(band_width, ceil(min_required_w));

width_note = (W > band_width) ? str(" (Auto-Widened to ", W, "mm for ", screw_spec, ")") : str(" (", W, "mm Wide)");
shape_note = (profile_shape == "square" && clamp_type != "c_clamp") ? str(D, "×", HY, " mm Square/Rect") : str(D, " mm Round");
echo(str("[SPEC] ", clamp_type, "  |  Profile: ", shape_note, width_note, "  |  Fastener: ", screw_spec, " (", eff_head_type, " head, ", worm_fastener_type, ")"));

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
    flex_t   = min(T, max(1.6, min(D, HY) * 0.07));
    gap_span = max(3.5, D * 0.14);
    lug_l    = max(12, s_diam * 2.4);
    lug_d    = max(10, s_diam * 2.2);
    top_y    = HY / 2;

    if (worm_fastener_type == "ratchet_zip") {
        linear_extrude(height = W) {
            difference() {
                if (profile_shape == "square") {
                    offset(r = flex_t * 1.2) square([D, HY], center = true);
                } else {
                    circle(d = D + flex_t * 2);
                }
                if (profile_shape == "square") {
                    square([D, HY], center = true);
                    for (sx = [-D/2, D/2]) for (sy = [-HY/2, HY/2]) translate([sx, sy]) circle(r = 1.0, $fn = 20);
                } else {
                    circle(d = D);
                }
                translate([0, top_y + flex_t])
                    square([gap_span + 2, flex_t * 4], center = true);
            }

            translate([-(gap_span/2 + 6), top_y + flex_t * 0.2]) {
                polygon([
                    [0, 0], [0, 2.4], [gap_span + 12, 2.4],
                    [gap_span + 16, 4.8], [gap_span + 17.2, 3.4], [gap_span + 12.5, 0.4],
                    [gap_span + 11.2, 0.4], [gap_span + 10.2, -1.1], [gap_span + 10.2, 0.4],
                    [gap_span + 8.6,  0.4], [gap_span + 7.6,  -1.1], [gap_span + 7.6,  0.4],
                    [gap_span + 6.0,  0.4], [gap_span + 5.0,  -1.1], [gap_span + 5.0,  0.4],
                    [gap_span + 3.4,  0.4], [gap_span + 2.4,  -1.1], [gap_span + 2.4,  0.4],
                    [gap_span + 1.0,  0.4], [gap_span + 0.0,  -1.1], [gap_span + 0.0,  0.4]
                ]);
            }

            translate([gap_span/2 - 0.5, top_y]) {
                polygon([
                    [0, 0], [7.5, 0], [7.5, 1.4],
                    [4.2, 1.4], [4.2, 2.7], [3.0, 1.4],
                    [1.6, 1.4], [1.6, 2.7], [0.4, 1.4], [0, 1.4]
                ]);
                difference() {
                    translate([0, 0]) square([8.0, 7.6]);
                    translate([-0.5, 1.4]) square([9.0, 3.8]);
                }
            }
        }

    } else {
        if (worm_render_part == "all" || worm_render_part == "clamp_only")
        difference() {
            union() {
                linear_extrude(height = W) {
                    if (profile_shape == "square") {
                        difference() {
                            offset(r = flex_t * 1.2)
                                square([D, HY], center = true);
                            square([D, HY], center = true);
                            translate([0, top_y + flex_t])
                                square([gap_span, flex_t * 4], center = true);
                            for (sx = [-D/2, D/2])
                                for (sy = [-HY/2, HY/2])
                                    translate([sx, sy])
                                        circle(r = 1.0, $fn = 20);
                        }
                    } else {
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

        bolt_len = round(gap_span + lug_l * 2 + 4);
        hw_x = (worm_render_part == "all") ? (D/2 + flex_t + 12) : 0;

        if (worm_render_part == "all" || worm_render_part == "hw_only" || worm_render_part == "bolt_only") {
            translate([hw_x, -6, 0])
                sf_bolt_printed(bolt_len, worm_fastener_type);
        }
        if (worm_render_part == "all" || worm_render_part == "hw_only" || worm_render_part == "nut_only") {
            nut_y = (worm_render_part == "nut_only") ? 0 : 20;
            translate([hw_x + 8, nut_y, 0])
                sf_nut();
        }
        if (worm_render_part == "tool_only") {
            render_matching_installation_tool();
        } else if (include_tool && (worm_render_part == "all" || worm_render_part == "hw_only" || worm_render_part == "bolt_only")) {
            translate([hw_x, -26, 0])
                render_matching_installation_tool();
        }
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

// =====================================================================
//  01_FASTENERS.SCAD — Powered by the Split & Fold Bolt Engine
//  Strong bolts printed lying on the plate (M3 - M24), nuts, washers & optional tools!
// =====================================================================

/* [1. Bolt & Fastener Style] */
// Select Printing Style [split:Split & Fold Bolt (Two Halves Joined by Head Hinge — Strongest!), flat:Flat-Sided One-Piece Lying Bolt]
bolt_style = "split";

// Which Part(s) to Generate [both:Bolt + Nut (+ Washers), bolt:Bolt Only, nut:Nut Only, washer:Washer Only, tool_only:Matching Installation Tool Only]
part = "both";

// Include Matching Installation Tool on Build Plate (Allen Key / Wrench — Optional!)
include_tool = false;

/* [2. Thread Size & Type] */
// Thread Profile Type [print:Print Thread — Coarse & Deep Teeth (Recommended for 3D Printing!), iso:ISO Metric Thread — Fits Real Metal Nuts]
thread_type = "print";

// Metric Size [M3:M3, M4:M4, M5:M5, M6:M6, M8:M8, M10:M10, M12:M12, M14:M14, M16:M16, M20:M20, M24:M24]
size = "M8";

// Thread Direction [right:Right-Hand (Standard), left:Left-Hand (Reverse)]
thread_hand = "right";

// Custom Pitch Override in mm (0 = Automatic Print Thread or ISO Coarse Pitch)
custom_pitch = 0;

/* [3. Bolt Head & Length] */
// Head Type [hex:Hex Head (Wrench Flats), socket:Socket Head (Allen Key), knurled:Knurled Thumb Wheel (Hand Grip), none:No Head (Threaded Stud / Rod)]
head_type = "hex";

// Bolt Length Under Head (mm) [10:10 mm, 16:16 mm, 20:20 mm, 25:25 mm, 30:30 mm, 35:35 mm, 40:40 mm, 50:50 mm, 60:60 mm, 75:75 mm, 100:100 mm]
bolt_length = 30;

// Threaded Length in mm (0 = Fully Threaded Along Entire Shaft)
thread_length = 0;

// Chamfer Bolt Tip (Makes Starting the Nut Easier)
chamfer_tip = true;

/* [4. Split & Fold Hinge Settings] */
// Split Hinge Thickness in mm (2-3 Layers) [0.4:0.4 mm (PLA), 0.6:0.6 mm (Default / PETG), 0.8:0.8 mm (Heavy)] @show_if(bolt_style=split)
hinge_thickness = 0.6;

// Gap Between the Two Halves in mm (= Hinge Length) [1.5:1.5 mm, 2.0:2.0 mm (Default), 3.0:3.0 mm] @show_if(bolt_style=split)
hinge_gap = 2.0;

// Flatten Top of Each Split Half (% of Diameter — Removes Top Blobs) [8:8%, 12:12% (Default), 15:15%, 20:20%] @show_if(bolt_style=split)
split_top_cut = 12;

// Flat Mode: Top & Bottom Cut (% of Diameter) [10:10%, 15:15% (Default), 20:20%, 25:25%] @show_if(bolt_style=flat)
flat_cut = 15;

/* [5. Nut & Washer Options] */
// Nut Height in mm (0 = ISO Standard Height)
nut_height = 0;

// Countersink Thread Entry on Both Sides of Nut
chamfer_nut = true;

// Washers per Bolt [0:0 (No Washers), 1:1 Washer, 2:2 Washers]
washers_per_bolt = 1;

// Washer Shape [round:Round Washer, square:Square Plate Washer]
washer_shape = "round";

/* [6. Print Clearance & Quantity] */
// Clearance Mode [auto:Auto (Scaled to Thread Size — Recommended), manual:Manual Clearance]
clearance_mode = "auto";

// Auto Fine-Tune Clearance (+ Looser, - Tighter) [-0.15:-0.15 mm, -0.1:-0.10 mm, -0.05:-0.05 mm, 0:0.00 mm (Default), 0.05:+0.05 mm, 0.1:+0.10 mm, 0.2:+0.20 mm] @show_if(clearance_mode=auto)
clearance_tweak = 0;

// Manual Bolt Clearance (mm) @show_if(clearance_mode=manual)
bolt_clearance = 0.4;

// Manual Nut Clearance (mm) @show_if(clearance_mode=manual)
nut_clearance = 0.4;

// Extra Clearance for Allen Key Socket (mm)
socket_clearance = 0.2;

// Quantity of Sets to Print [1:1 Set, 2:2 Sets, 4:4 Sets, 6:6 Sets, 10:10 Sets]
quantity = 1;

// Nuts per Bolt [1:1 Nut, 2:2 Nuts (Nut + Jam Nut)]
nuts_per_bolt = 1;

/* [Hidden] */
washer_outer = 0;
washer_thickness = 0;
washer_hole_clearance = 0.2;
washer_corner_radius = 1;
columns = 0;
quality = 64;
spacing = 6;
eps = 0.01;

table = [
  ["M3",  3,  0.5,  5.5,  2.4,  2.0,  2.5],
  ["M4",  4,  0.7,  7,    3.2,  2.8,  3  ],
  ["M5",  5,  0.8,  8,    4.7,  3.5,  4  ],
  ["M6",  6,  1.0,  10,   5.2,  4.0,  5  ],
  ["M8",  8,  1.25, 13,   6.8,  5.3,  6  ],
  ["M10", 10, 1.5,  16,   8.4,  6.4,  8  ],
  ["M12", 12, 1.75, 18,   10.8, 7.5,  10 ],
  ["M14", 14, 2.0,  21,   12.8, 8.8,  12 ],
  ["M16", 16, 2.0,  24,   14.8, 10.0, 14 ],
  ["M20", 20, 2.5,  30,   18.0, 12.5, 17 ],
  ["M24", 24, 3.0,  36,   21.5, 15.0, 19 ]
];

washer_table = [
  [3.2,  7,  0.5], [4.3,  9,  0.8], [5.3, 10, 1.0], [6.4, 12, 1.6],
  [8.4, 16,  1.6], [10.5, 20, 2.0], [13,  24, 2.5], [15,  28, 2.5],
  [17,  30,  3.0], [21,  37, 3.0], [25,  44, 4.0]
];

idx = [for (i = [0:len(table)-1]) if (table[i][0] == size) i][0];
row = table[is_undef(idx) ? 4 : idx];

D       = row[1];
PRINT_THREAD = thread_type == "print";
P_PRINT = max(1, round(D * 0.25 * 4) / 4);
P       = custom_pitch > 0 ? custom_pitch : (PRINT_THREAD ? P_PRINT : row[2]);
S       = row[3];
NUT_H   = nut_height > 0 ? nut_height : row[4];
HEAD_K  = row[5];
KEY     = row[6];
LEFT    = thread_hand == "left";
N       = quality;
KNURL_D = max(12.0, D * 2.2);
KNURL_H = max(5.5, HEAD_K * 1.35);

L       = bolt_length;
TL      = (thread_length <= 0 || thread_length > L) ? L : thread_length;

T_DEPTH = PRINT_THREAD ? 0.45 * P : 0.5413 * P;

AUTO_CL = max(0.15, min(0.6, 0.32 * P));
BOLT_CL = clearance_mode == "auto" ? max(0, AUTO_CL + clearance_tweak) : bolt_clearance;
NUT_CL  = clearance_mode == "auto" ? max(0, AUTO_CL + clearance_tweak) : nut_clearance;
echo(str("[SPEC] ", size, PRINT_THREAD ? " (Print Thread)" : " (ISO)", " P=", P, " mm | Head: ", head_type, " | Length: ", L, " mm"));

module thread_ribbon(R, len) {
  r0 = R - T_DEPTH;
  ri = r0 - 0.1 * P;
  prof = PRINT_THREAD ? [[ri, -0.37*P], [R, -0.15*P], [R, 0.15*P], [ri, 0.37*P]]
                      : [[ri, -0.375*P], [R, -P/16], [R, P/16], [ri, 0.375*P]];
  z0 = -P;
  steps = ceil((len + 2*P) / P * N);
  pts = [for (k = [0:steps])
           let (a = k * 360 / N, z = z0 + k * P / N)
           for (p = prof) [p[0]*cos(a), p[0]*sin(a), p[1] + z]];
  faces = concat(
    [[3, 2, 1, 0]],
    [[steps*4, steps*4+1, steps*4+2, steps*4+3]],
    [for (k = [0:steps-1]) for (j = [0:3])
       let (a = k*4 + j, b = k*4 + (j+1)%4,
            c = (k+1)*4 + (j+1)%4, d = (k+1)*4 + j)
       each [[a, b, c], [a, c, d]]]
  );
  mirror([LEFT ? 1 : 0, 0, 0]) polyhedron(points = pts, faces = faces);
}

module thread_raw(R, len) {
  union() {
    thread_ribbon(R, len);
    translate([0, 0, -P]) cylinder(r = R - T_DEPTH, h = len + 2*P, $fn = N);
  }
}

module trim(R, len, chamfer_bottom, chamfer_top) {
  r0 = R - T_DEPTH;
  Rv = R + 0.5;
  c  = Rv - r0;
  bottom = chamfer_bottom ? [[r0, 0], [Rv, c]]          : [[Rv, 0]];
  top    = chamfer_top    ? [[Rv, len - c], [r0, len]]  : [[Rv, len]];
  rotate_extrude($fn = N)
    polygon(concat([[0, 0]], bottom, top, [[0, len]]));
}

module external_thread(R, len, chamfer_bottom, chamfer_top) {
  intersection() {
    thread_raw(R, len);
    trim(R, len, chamfer_bottom, chamfer_top);
  }
}

module hex_body(s, h) {
  e  = s / cos(30);
  rc = 0.475 * s;
  E  = e/2 + 0.5;
  t  = (E - rc) * tan(30);
  intersection() {
    cylinder(d = e, h = h, $fn = 6);
    rotate_extrude($fn = N)
      polygon([[0, 0], [rc, 0], [E, t], [E, h - t], [rc, h], [0, h]]);
  }
}

module knurled_body(d_k, h_k) {
  union() {
    rotate_extrude($fn = N)
      polygon([[0, 0], [d_k/2 - 0.6, 0], [d_k/2, 0.6],
               [d_k/2, h_k - 0.6], [d_k/2 - 0.6, h_k], [0, h_k]]);
    for (a = [0 : 24 : 336])
      rotate([0, 0, a])
      translate([d_k/2, 0, h_k/2])
        cylinder(d = max(1.5, D * 0.22), h = h_k - 1.0, center = true, $fn = 16);
  }
}

module bolt() {
  Rb = (D - BOLT_CL) / 2;
  if (head_type == "none") {
    external_thread(Rb, L, chamfer_tip, chamfer_tip);
  } else {
    hh = head_type == "socket" ? D : (head_type == "knurled" ? KNURL_H : HEAD_K);
    union() {
      if (head_type == "hex") {
        hex_body(S, hh);
      } else if (head_type == "knurled") {
        knurled_body(KNURL_D, hh);
      } else {
        dh = 1.5 * D;
        difference() {
          rotate_extrude($fn = N)
            polygon([[0, 0], [dh/2 - 0.5, 0], [dh/2, 0.5],
                     [dh/2, hh - 0.5], [dh/2 - 0.5, hh], [0, hh]]);
          translate([0, 0, -eps])
            cylinder(d = (KEY + socket_clearance) / cos(30),
                     h = 0.6 * D + eps, $fn = 6);
        }
      }
      if (TL < L)
        translate([0, 0, hh - eps])
          cylinder(r = Rb, h = L - TL + 2*eps, $fn = N);
      translate([0, 0, hh + L - TL - 0.01])
        external_thread(Rb, TL + 0.01, false, chamfer_tip);
    }
  }
}

HEAD_LEN  = head_type == "none" ? 0 : (head_type == "socket" ? D : (head_type == "knurled" ? KNURL_H : HEAD_K));
BOLT_LEN  = HEAD_LEN + L;
HALF_W    = head_type == "hex" ? S / 2 : head_type == "knurled" ? (KNURL_D / 2 + 0.5) : head_type == "socket" ? 0.75 * D : (D - BOLT_CL) / 2;
FLAT_T    = D * (1 - 2 * flat_cut / 100);
R_CORE    = (D - BOLT_CL) / 2 - T_DEPTH;
SPLIT_OFF = HALF_W + hinge_gap / 2;
BIG       = 2 * (KNURL_D + S + D + BOLT_LEN);

module bolt_lying() {
  rotate([0, 90, 0]) bolt();
}

module bolt_flat() {
  translate([0, 0, FLAT_T / 2])
    intersection() {
      bolt_lying();
      translate([-1, -BIG / 2, -FLAT_T / 2]) cube([BOLT_LEN + 2, BIG, FLAT_T]);
    }
}

HALF_H = D / 2 - D * split_top_cut / 100;

module bolt_half(upper) {
  rotate([upper ? 0 : 180, 0, 0])
    intersection() {
      bolt_lying();
      union() {
        translate([-1, -BIG / 2, upper ? 0 : -BIG]) cube([HEAD_LEN + 1, BIG, BIG]);
        translate([HEAD_LEN, -BIG / 2, upper ? 0 : -HALF_H]) cube([L + 1, BIG, HALF_H]);
      }
    }
}

module bolt_split() {
  translate([0, -SPLIT_OFF, 0]) bolt_half(true);
  translate([0,  SPLIT_OFF, 0]) bolt_half(false);
  hx0 = head_type == "none" ? 0.5 : HEAD_LEN * 0.15;
  hx1 = head_type == "none" ? min(6, L * 0.3) : HEAD_LEN * 0.85;
  ov = (head_type == "knurled" ? 1.5 : 0.8) + (head_type == "none" ? T_DEPTH : 0);
  hx0b = head_type == "none" ? max(hx0, T_DEPTH + 1) : hx0;
  translate([hx0b, -hinge_gap / 2 - ov, 0])
    cube([max(1, hx1 - hx0b), hinge_gap + 2 * ov, hinge_thickness]);
}

module bolt_printed() {
  if (bolt_style == "flat") bolt_flat();
  else bolt_split();
}

module nut() {
  Rn = (D + NUT_CL) / 2;
  r0 = Rn - T_DEPTH;
  c  = Rn - r0 + 0.2;
  difference() {
    hex_body(S, NUT_H);
    thread_raw(Rn, NUT_H);
    if (chamfer_nut) {
      translate([0, 0, -eps])
        cylinder(r1 = Rn + 0.2, r2 = r0 - 0.01, h = c, $fn = N);
      translate([0, 0, NUT_H - c + eps])
        cylinder(r1 = r0 - 0.01, r2 = Rn + 0.2, h = c, $fn = N);
    }
  }
}

WROW    = washer_table[is_undef(idx) ? 4 : idx];
W_HOLE  = WROW[0] + washer_hole_clearance;
W_OUT   = max(washer_outer > 0 ? washer_outer : WROW[1], W_HOLE + 2);
W_T     = washer_thickness > 0 ? washer_thickness : max(1.0, WROW[2]);
W_R     = min(washer_corner_radius, W_OUT / 2 - 0.01);

module washer() {
  difference() {
    if (washer_shape == "square") {
      linear_extrude(W_T)
        offset(r = W_R) offset(delta = -W_R)
          square(W_OUT, center = true);
    } else {
      cylinder(d = W_OUT, h = W_T, $fn = max(N, 64));
    }
    translate([0, 0, -eps]) cylinder(d = W_HOLE, h = W_T + 2*eps, $fn = max(N, 48));
  }
}

// Flat-Printed Matching Installation Tools (Allen Key or Hex Wrench)
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
  thick  = max(4.0, min(7.0, s_flats * 0.45));
  arm_l  = max(45, s_flats * 4.5);

  linear_extrude(height = thick) {
    difference() {
      union() {
        circle(r = head_r, $fn = 48);
        hull() {
          translate([head_r * 0.5, 0]) circle(d = w_af * 0.85);
          translate([arm_l, 0]) circle(d = w_af * 1.05);
        }
      }
      circle(d = w_af / cos(30), $fn = 6);
      translate([-head_r, 0]) square([head_r * 1.4, w_af], center = true);
      translate([arm_l, 0]) circle(d = max(4.0, w_af * 0.4), $fn = 24);
    }
  }
}

module matching_tool() {
  if (head_type == "socket") {
    printable_allen_key(KEY);
  } else {
    printable_hex_wrench(S);
  }
}

head_width = head_type == "socket" ? 1.5 * D : (head_type == "knurled" ? KNURL_D : (head_type == "none" ? D : S / cos(30)));
LYING      = true;
bolt_fx = LYING ? BOLT_LEN : head_width;
bolt_fy = bolt_style == "split" ? 4 * HALF_W + hinge_gap : 2 * HALF_W;
nut_width  = S / cos(30);
washer_width = W_OUT;

cell_bolts   = (part == "both" || part == "bolt") ? 1 : 0;
cell_nuts    = (part == "both" || part == "nut") ? nuts_per_bolt : 0;
cell_washers = part == "both" ? washers_per_bolt : part == "washer" ? max(1, washers_per_bolt) : 0;
cell_w = cell_bolts * (bolt_fx + spacing) + cell_nuts * (nut_width + spacing) + cell_washers * (washer_width + spacing);
cell_d = max(cell_bolts > 0 ? bolt_fy : 0, cell_nuts > 0 ? nut_width : 0, cell_washers > 0 ? washer_width : 0) + spacing;

cols = columns > 0 ? min(columns, quantity) : max(1, ceil(sqrt(quantity * cell_d / cell_w)));
rows = ceil(quantity / cols);

module one_set() {
  if (part == "tool_only") {
    matching_tool();
  } else {
    if (cell_bolts > 0) translate([LYING ? 0 : head_width / 2, 0, 0]) bolt_printed();
    if (cell_nuts > 0) for (j = [0 : cell_nuts - 1])
      translate([cell_bolts * (bolt_fx + spacing) + nut_width / 2 + j * (nut_width + spacing), 0, 0])
        nut();
    if (cell_washers > 0) for (k = [0 : cell_washers - 1])
      translate([cell_bolts * (bolt_fx + spacing) + cell_nuts * (nut_width + spacing) + washer_width / 2 + k * (washer_width + spacing), 0, 0])
        washer();
    if (include_tool) {
      translate([0, -(bolt_fy / 2 + 18), 0])
        matching_tool();
    }
  }
}

for (i = [0 : quantity - 1])
  translate([(i % cols) * cell_w, floor(i / cols) * cell_d, 0])
    one_set();

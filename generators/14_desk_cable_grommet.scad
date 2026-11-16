// =============================================================================
//  14_DESK_CABLE_GROMMET.SCAD — Desk Cable Grommet (Ring + Cap + Retainer)
// =============================================================================

/* [1. Layout & What to Render] */
// What to Show / Export [plate:Print Plate (All Parts Flat on Bed — Support-Free!), assembled:Assembled 3D Preview, ring:Outer Desk Ring Only, cap:Cable Insert Cap Only, retainer:Under-Desk Retainer Ring Only]
show = "plate";

// Cable Pass-Through Cap Style [hole:Round Center Cable Hole, slot:Single Open Slot to Edge, comb:Multi-Finger Cable Comb, solid:Solid Blank Cover (No Hole)]
cap_style = "hole";

// Bottom Retaining Ring Style [none:None (Flange + Friction Fit Only), press:Press-Fit Retainer Ring with 4 Flex Fins]
retainer_style = "none";

/* [2. Desk Hole & Fit Dimensions] */
// Diameter of Hole Cut in Desk (mm) [35:35 mm (~1-3/8"), 45:45 mm (~1-3/4"), 50:50 mm (~2"), 60:60 mm (Standard 2-3/8" Desk Hole), 75:75 mm (~3"), 80:80 mm (~3-1/8"), 100:100 mm (~4")]
hole_d = 60;

// Desk Thickness at Hole (mm) [12:12 mm (~1/2"), 16:16 mm (~5/8"), 19:19 mm (3/4" Plywood/MDF), 25:25 mm (1" Standard Desktop), 30:30 mm (1-1/4"), 38:38 mm (1-1/2" Butcher Block)]
desk_t = 25;

// Outer Hole Fit Clearance (mm) [0.2:0.2 mm (Snug), 0.5:0.5 mm (Standard Smooth Drop-In), 1.0:1.0 mm (Loose)]
clearance = 0.5;

// Cap-to-Ring Radial Clearance (mm) [0.15:0.15 mm (Snug), 0.3:0.30 mm (Standard), 0.45:0.45 mm (Easy Lift-Out)]
cap_clearance = 0.3;

/* [3. Cap Opening Settings] */
// Round Center Hole Diameter (mm) [10:10 mm, 16:16 mm, 22:22 mm (Default), 30:30 mm, 40:40 mm] @show_if(cap_style=hole)
cable_d = 22;

// Open Slot Width (mm) [8:8 mm, 12:12 mm, 16:16 mm, 20:20 mm (Default), 28:28 mm, 35:35 mm] @show_if(cap_style=slot)
slot_w = 20;

// Number of Comb Slots [4:4 Slots, 6:6 Slots, 8:8 Slots (Default), 10:10 Slots, 12:12 Slots] @show_if(cap_style=comb)
comb_count = 8;

// Comb Slot Width (mm) [2.5:2.5 mm (USB Cables), 4.0:4.0 mm (Standard Power Cords), 6.0:6.0 mm (Thick Display Cables)] @show_if(cap_style=comb)
comb_slot_w = 4;

// Cap Top Disc Thickness (mm) [2.0:2.0 mm, 3.0:3.0 mm (Default), 4.0:4.0 mm]
cap_disc_t = 3;

/* [4. Ring & Retainer Dimensions] */
// Top Flange Overlap Width Around Hole (mm) [5:5 mm, 8:8 mm (Standard), 10:10 mm, 12:12 mm]
flange_w = 8;

// Top Flange Thickness (mm) [2.0:2.0 mm, 3.0:3.0 mm (Standard), 4.0:4.0 mm]
flange_t = 3;

// Ring Wall Thickness (mm) [1.8:1.8 mm, 2.4:2.4 mm (Standard), 3.2:3.2 mm (Heavy)]
wall_t = 2.4;

// Retainer Thickness (mm) [2.0:2.0 mm, 3.0:3.0 mm (Default), 4.0:4.0 mm] @show_if(retainer_style=press)
retainer_t = 3;

// Retainer Fin Width (mm) @show_if(retainer_style=press)
fin_w = 9;

// Retainer Fin Grip Interference (mm) [0.3:0.3 mm (Light), 0.6:0.6 mm (Standard Grip), 1.0:1.0 mm (Tight)] @show_if(retainer_style=press)
fin_interference = 0.6;

/* [Hidden] */
$fn = 64;
eps = 0.02;
gap = 10;
plate_width = 250;
ring_color = "#3a3a3a";
cap_color  = "#c8c8c8";
export_part = "all";

protrusion    = 3;
pocket_extra  = min(1.6, wall_t - 0.8);
taper_h       = pocket_extra * 1.4;
lip_h         = 2.2;
rim_min       = 1.5;
comb_center_d = 10;
comb_rim      = 2.5;
fin_reach     = 7;
rim_width_min = 5;

OD        = hole_d - clearance;
ID_main   = OD - 2 * wall_t;
ID_pocket = ID_main + 2 * pocket_extra;
flange_od = hole_d + 2 * flange_w;
tube_h    = desk_t + protrusion;
total_h   = tube_h + flange_t;
s0        = total_h - cap_disc_t - taper_h;

lip_d  = ID_main - 2 * cap_clearance;
disc_d = ID_pocket - 2 * cap_clearance;
cap_h  = lip_h + taper_h + cap_disc_t;

max_cut_d       = max(disc_d - 2 * rim_min, 2);
cable_cut       = min(cable_d, max_cut_d);
slot_cut        = min(slot_w, max_cut_d);
comb_center_cut = min(comb_center_d, max_cut_d);
comb_reach      = max(disc_d / 2 - comb_rim, comb_center_cut / 2 + 1);

fin_root_r = OD / 2 + fin_reach;
fin_tip_r  = max(OD / 2 - fin_interference / 2, 2);
ret_bore   = 2 * fin_root_r;
ret_od     = max(flange_od, ret_bore + 2 * rim_width_min);
fin_t      = retainer_t * 0.5;

function part_on(p) = export_part == "all" || export_part == p;

module ring_outer() {
  union() {
    cylinder(d = OD, h = tube_h);
    translate([0, 0, tube_h]) cylinder(d = flange_od, h = flange_t);
  }
}
module ring_bore() {
  union() {
    translate([0, 0, -eps]) cylinder(d = ID_main, h = s0 + eps);
    translate([0, 0, s0]) cylinder(d1 = ID_main, d2 = ID_pocket, h = taper_h);
    translate([0, 0, s0 + taper_h]) cylinder(d = ID_pocket, h = (total_h - (s0 + taper_h)) + eps);
  }
}
module ring() {
  if (part_on("ring")) color(ring_color)
    difference() {
      ring_outer();
      ring_bore();
    }
}

module cap_outer() {
  union() {
    cylinder(d = lip_d, h = lip_h);
    translate([0, 0, lip_h]) cylinder(d1 = lip_d, d2 = disc_d, h = taper_h);
    translate([0, 0, lip_h + taper_h]) cylinder(d = disc_d, h = cap_disc_t);
  }
}
module cap_cut_2d() {
  if (cap_style == "hole") {
    circle(d = cable_cut);
  } else if (cap_style == "slot") {
    union() {
      circle(d = slot_cut);
      translate([0, -slot_cut / 2]) square([disc_d / 2 + 1, slot_cut]);
    }
  } else if (cap_style == "comb") {
    union() {
      circle(d = comb_center_cut);
      for (i = [0 : comb_count - 1])
        rotate([0, 0, i * 360 / comb_count])
          translate([0, -comb_slot_w / 2]) square([comb_reach, comb_slot_w]);
    }
  }
}
module cap() {
  if (part_on("cap")) color(cap_color)
    difference() {
      cap_outer();
      if (cap_style != "solid")
        translate([0, 0, -eps]) linear_extrude(cap_h + 2 * eps) offset(r = -0.45) offset(r = 0.45) cap_cut_2d();
    }
}

module retainer_rim() {
  difference() {
    cylinder(d = ret_od, h = retainer_t);
    translate([0, 0, -eps]) cylinder(d = ret_bore, h = retainer_t + 2 * eps);
  }
}
module retainer_fin(a) {
  root_r = fin_root_r + 0.3;
  rotate([0, 0, a])
    linear_extrude(fin_t)
      polygon([
        [root_r, -fin_w / 2], [root_r, fin_w / 2],
        [fin_tip_r, fin_w * 0.32], [fin_tip_r, -fin_w * 0.32]
      ]);
}
module retainer() {
  if (retainer_style == "press" && part_on("retainer")) color(ring_color)
    union() {
      retainer_rim();
      for (a = [0 : 90 : 270]) retainer_fin(a);
    }
}

module assembled() {
  ring();
  translate([0, 0, s0 - lip_h]) cap();
  if (retainer_style == "press") translate([0, 0, protrusion - retainer_t]) retainer();
}

part_names = concat(["ring", "cap"], retainer_style == "press" ? ["retainer"] : []);
part_d = [for (nm = part_names) nm == "ring" ? flange_od : (nm == "cap" ? disc_d : ret_od)];

function pack(ds, i, x, y, rowh) =
  i >= len(ds) ? [] :
  (x > 0 && x + ds[i] > plate_width) ?
    concat([[ds[i] / 2, y - rowh - gap]], pack(ds, i + 1, ds[i] + gap, y - rowh - gap, ds[i])) :
    concat([[x + ds[i] / 2, y]], pack(ds, i + 1, x + ds[i] + gap, y, max(rowh, ds[i])));

positions = pack(part_d, 0, 0, 0, 0);

min_x = min([for (i = [0 : len(part_d) - 1]) positions[i][0] - part_d[i] / 2]);
max_x = max([for (i = [0 : len(part_d) - 1]) positions[i][0] + part_d[i] / 2]);
min_y = min([for (i = [0 : len(part_d) - 1]) positions[i][1] - part_d[i] / 2]);
max_y = max([for (i = [0 : len(part_d) - 1]) positions[i][1] + part_d[i] / 2]);
plate_cx = (min_x + max_x) / 2;
plate_cy = (min_y + max_y) / 2;
plate_w_total = max_x - min_x;
plate_h_total = max_y - min_y;

module plate() {
  for (i = [0 : len(part_names) - 1]) {
    nm = part_names[i];
    tx = positions[i][0] - plate_cx;
    ty = positions[i][1] - plate_cy;
    if (nm == "ring") translate([tx, ty, total_h]) rotate([180, 0, 0]) ring();
    else if (nm == "cap") translate([tx, ty, cap_h]) rotate([180, 0, 0]) cap();
    else translate([tx, ty, 0]) retainer();
  }
}

if (show == "plate") plate();
else if (show == "assembled") assembled();
else if (show == "ring") ring();
else if (show == "cap") cap();
else if (show == "retainer") retainer();

echo(str("[SPEC] Desk Grommet: Hole ", hole_d, " mm × Desk ", desk_t, " mm | Ring OD ", OD, " mm, ID ", ID_main, " mm | Cap: ", cap_style));

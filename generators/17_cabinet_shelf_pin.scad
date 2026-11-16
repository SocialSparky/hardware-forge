// =====================================================================
//  17_CABINET_SHELF_PIN.SCAD — Crush-Ribbed Cabinet Shelf Support Pin
//  Prints lying on its side so shelf load runs parallel to layer lines!
// =====================================================================

/* [1. Cabinet Hole & Shank Sizing] */
// Cabinet Drill Hole Diameter (mm) [5.0:5.0 mm (Standard Euro 5mm Shelf Pin), 5.5:5.5 mm (7/32" Drill — Tested Default), 6.0:6.0 mm (6mm Dowel Hole), 6.35:6.35 mm (1/4" Standard American Shelf Pin), 7.0:7.0 mm, 8.0:8.0 mm (5/16" Heavy Pin)]
hole_d = 5.5;

// Pin Shank Length Inside Hole (mm) [8:8 mm (Shallow), 10:10 mm (Standard Default), 12:12 mm (Deep), 15:15 mm (Extra Deep)]
shank_length = 10;

// Crush-Rib Interference Fit (mm) [0.20:0.20 mm (Light Push Fit), 0.35:0.35 mm (Tested Standard Grip), 0.50:0.50 mm (Heavy Hammer-In Fit)]
interference = 0.35;

/* [2. Bracket Body & Batch Quantity] */
// Pin Body Width (mm) [12:12 mm (Standard), 14:14 mm (Wide), 16:16 mm (Extra Wide — Required for >=8mm Holes)]
pin_width = 12;

// Shelf Support Ledge Depth (mm) [9:9 mm, 11:11 mm (Standard Stock Pin), 14:14 mm (Extended Ledge), 18:18 mm (Deep Shelf Ledge)]
ledge_depth = 11;

// Quantity of Shelf Pins to Print on Plate [1:1 Pin, 4:4 Pins (1 Shelf Set), 8:8 Pins (2 Shelves), 12:12 Pins (3 Shelves), 16:16 Pins (4 Shelves)]
quantity = 1;

/* [Hidden] */
W = max(pin_width, ceil(hole_d + interference + 2.5));
T = 2;
PLATE_H = 20;
SHANK_Y = 10;
LEDGE_ABOVE_HOLE = 5.3;
LEDGE_T = 2;
LEDGE_DEPTH = ledge_depth;
GUSSET_FOOT = 2;
GUSSET_TIP = min(ledge_depth - 2, 9);
FILLET = 0.5;
ROOT_FILLET = 1;
CHAMFER = 0.4;

N_RIBS = 8;
RIB_W = 1;
RIB_TAPER = 3;
CORE_CLEAR = 0.3;
TIP_UNDER = 0.2;
TIP_CHAMFER = 0.5;
SINK = 0.5;

$fa = 1; $fs = 0.05;

assert(hole_d + interference <= W - 2, "hole too big for pin width");
assert(shank_length > RIB_TAPER + TIP_CHAMFER, "shank too short");

TOP = SHANK_Y + LEDGE_ABOVE_HOLE;
BOT = TOP - LEDGE_T;
TIP = T + LEDGE_DEPTH;

echo(str("[SPEC] Cabinet Shelf Pin: Hole Ø", hole_d, " mm × ", shank_length, " mm Shank | Crush Interference: +", interference, " mm | Qty: ", quantity));

module raw_profile() {
    polygon([[0, 0], [T, 0], [T, GUSSET_FOOT], [T + GUSSET_TIP, BOT],
             [TIP, BOT], [TIP, TOP], [T, TOP], [T, PLATE_H], [0, PLATE_H]]);
}

module profile() {
    union() {
        offset(r = FILLET) offset(delta = -FILLET)
            offset(r = -FILLET) offset(delta = FILLET) raw_profile();
        difference() {
            translate([T, TOP]) square(ROOT_FILLET);
            translate([T + ROOT_FILLET, TOP + ROOT_FILLET]) circle(r = ROOT_FILLET);
        }
    }
}

module body() {
    minkowski() {
        translate([0, 0, CHAMFER])
            linear_extrude(W - 2 * CHAMFER) offset(r = -CHAMFER) profile();
        union() {
            cylinder(h = CHAMFER, r1 = CHAMFER, r2 = 0, $fn = 48);
            mirror([0, 0, 1]) cylinder(h = CHAMFER, r1 = CHAMFER, r2 = 0, $fn = 48);
        }
    }
}

function corner(d) = sqrt(pow(d / 2, 2) - pow(RIB_W / 2, 2));

module shank() {
    core_r = (hole_d - CORE_CLEAR) / 2;
    r_full = corner(hole_d + interference);
    r_tip = corner(hole_d - TIP_UNDER);
    r_in = core_r - 0.3;
    L = shank_length;
    translate([0, SHANK_Y, W / 2]) {
        rotate([0, -90, 0]) translate([0, 0, -SINK]) {
            cylinder(h = L + SINK - TIP_CHAMFER, r = core_r);
            translate([0, 0, L + SINK - TIP_CHAMFER])
                cylinder(h = TIP_CHAMFER, r1 = core_r, r2 = core_r - TIP_CHAMFER);
        }
        for (i = [0 : N_RIBS - 1])
            rotate([360 / N_RIBS * i, 0, 0])
                linear_extrude(RIB_W, center = true)
                    polygon([[SINK, r_in], [SINK, r_full], [-(L - RIB_TAPER), r_full],
                             [-L, r_tip], [-L, r_in]]);
    }
}

module single_pin() {
    body();
    shank();
}

cols = ceil(sqrt(quantity));
cell_x = shank_length + TIP + 8;
cell_y = PLATE_H + 6;

for (i = [0 : quantity - 1]) {
    cx = (i % cols) * cell_x;
    cy = floor(i / cols) * cell_y;
    translate([cx, cy, 0]) single_pin();
}

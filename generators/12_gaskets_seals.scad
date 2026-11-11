include <BOSL2/std.scad>

/* [1. Gasket / Seal Style] */
// Select Gasket, O-Ring, or Grommet Type [flange_bolt_circle:Round Pipe Flange Gasket (With Bolt Circle Holes), rect_flange:Rectangular Enclosure / Cover Flange Gasket (With Corner/Edge Holes), oring_seal:Round or Rectangular O-Ring Cord Seal (Flat / D-Profile / Round), elec_box_gasket:Electrical Box / Weatherproof Plate Gasket (1-Gang / 2-Gang / 4x4), panel_grommet:Flexible Pass-Through Panel / Knock-Out Cable Grommet]
gasket_type = "flange_bolt_circle";

// Cross-Sectional Sealing Profile [flat:Flat Sheet Gasket (Standard), ribbed:Concentric Dual-Ridge Sealing Beads (Compresses Easier with TPU!), rounded:Rounded O-Ring / Torus Profile] @show_if(gasket_type=flange_bolt_circle|rect_flange|oring_seal|elec_box_gasket)
seal_profile = "flat";

/* [2. Primary Gasket Dimensions] */
// Inner Bore Diameter / Rectangular Inner Width X [10:10 mm (3/8"), 12.7:12.7 mm (1/2"), 16:16 mm (5/8"), 19.05:19.05 mm (3/4"), 25.4:25.4 mm (1"), 32:32 mm (1-1/4"), 38.1:38.1 mm (1-1/2"), 50.8:50.8 mm (2"), 65:65 mm (~2-1/2"), 75:75 mm (~3"), 90:90 mm, 100:100 mm (~4"), 120:120 mm] @show_if(gasket_type=flange_bolt_circle|rect_flange|oring_seal)
inner_x = 38.1;

// Rectangular Inner Depth Y [30:30 mm, 40:40 mm, 50:50 mm, 60:60 mm, 70:70 mm, 80:80 mm, 100:100 mm, 120:120 mm] @show_if(gasket_type=rect_flange)
inner_y = 60;

// Flange / Rim Seal Width (Wall Width from ID to OD) [3:3.0 mm (Narrow O-Ring), 5:5.0 mm (Standard Seal), 8:8.0 mm, 10:10.0 mm, 12:12.0 mm (Standard Flange), 15:15.0 mm (Wide Bolt Flange), 20:20.0 mm (Heavy Pipe Flange), 25:25.0 mm] @show_if(gasket_type=flange_bolt_circle|rect_flange|oring_seal)
rim_width = 15.0;

// Gasket / Seal Thickness (Z Height) [1.0:1.0 mm (Thin Shim Gasket), 1.6:1.6 mm (1/16" Standard Gasket), 2.0:2.0 mm, 2.4:2.4 mm (3/32" Medium Gasket), 3.2:3.2 mm (1/8" Thick Seal), 4.0:4.0 mm, 5.0:5.0 mm]
thickness = 2.0;

// Corner Rounding Radius (For Rectangular Gasket) [2:2 mm, 4:4 mm, 6:6 mm, 10:10 mm, 15:15 mm] @show_if(gasket_type=rect_flange)
corner_r = 5.0;

/* [3. Bolt Holes (For Round & Rectangular Flange Gaskets)] */
// Number of Bolt Holes around Flange (0 = No Bolt Holes) [0:0 (Unpunched Solid Ring/Frame), 2:2 Holes (2-Bolt Oval/Flange), 3:3 Holes, 4:4 Holes (Standard 4-Bolt), 6:6 Holes, 8:8 Holes, 12:12 Holes] @show_if(gasket_type=flange_bolt_circle|rect_flange)
bolt_count = 4;

// Bolt Hole Diameter [3.2:M3 (3.2 mm), 4.2:M4 / #8 (4.2 mm), 5.2:M5 / #10 (5.2 mm), 6.5:M6 / 1/4" (6.5 mm), 8.5:M8 / 5/16" (8.5 mm), 10.5:M10 / 3/8" (10.5 mm), 13.0:M12 / 1/2" (13.0 mm)] @show_if(gasket_type=flange_bolt_circle|rect_flange)
bolt_hole_d = 6.5;

// Bolt Circle Diameter (0 = Auto-Center in Flange Rim) [0:Auto-Center in Flange Rim, 40:40 mm, 50:50 mm, 60:60 mm, 75:75 mm, 85:85 mm, 100:100 mm, 125:125 mm] @show_if(gasket_type=flange_bolt_circle)
custom_bcd = 0;

/* [4. Electrical Box Gasket Presets] */
// Standard Electrical Box Size [gang_1:1-Gang Weatherproof Bell / Device Box (70×115 mm, #6-32 Device Holes), gang_2:2-Gang Weatherproof Device Box (116×115 mm), box_4x4:4" Square (102×102 mm) Junction Box Cover Gasket, round_4in:4" Round Weatherproof Outlet Box (102 mm OD)] @show_if(gasket_type=elec_box_gasket)
elec_preset = "gang_1";

/* [5. Panel Grommet Options] */
// Panel Knockout / Mounting Hole Diameter [12.7:12.7 mm (1/2" Bore), 16:16 mm (5/8" Bore), 19.05:19.05 mm (3/4" Bore), 22.2:22.2 mm (7/8" — 1/2" Trade Knockout!), 25.4:25.4 mm (1" Bore), 27.8:27.8 mm (1-3/32" — 3/4" Trade Knockout!), 34.9:34.9 mm (1-3/8" — 1" Trade Knockout!)] @show_if(gasket_type=panel_grommet)
panel_hole_d = 22.2;

// Inner Cable Pass-Through Bore [4:4 mm, 6:6 mm, 8:8 mm, 10:10 mm, 12:12 mm, 14:14 mm, 16:16 mm, 20:20 mm] @show_if(gasket_type=panel_grommet)
grommet_id = 10.0;

// Sheet Metal / Panel Thickness (Groove Width) [1.2:1.2 mm (18 Gauge Steel), 1.6:1.6 mm (16 Gauge / 1/16" Panel), 2.0:2.0 mm (14 Gauge), 3.2:3.2 mm (1/8" Wall), 4.8:4.8 mm (3/16" Wall)] @show_if(gasket_type=panel_grommet)
panel_thick = 1.6;

/* [Hidden] */
$fn = 72;

ID = max(3, inner_x);
IY = max(6, inner_y);
RW = max(1.5, rim_width);
OD = ID + (RW * 2);
T  = max(0.4, thickness);

echo(str("[SPEC] Gasket/Seal: ", gasket_type, " (", seal_profile, ")  |  Thickness: ", T, " mm"));

module add_sealing_ribs_round(mid_d, span_w) {
    if (seal_profile == "ribbed") {
        for (off = [-span_w * 0.22, span_w * 0.22]) {
            up(T)
            rotate_extrude()
                translate([mid_d/2 + off, 0])
                    circle(d = min(1.6, T * 0.65), $fn = 24);
        }
    }
}

if (gasket_type == "flange_bolt_circle") {
    bcd = (custom_bcd > ID) ? custom_bcd : (ID + RW);
    difference() {
        union() {
            linear_extrude(height = T)
                difference() {
                    circle(d = OD);
                    circle(d = ID);
                }
            add_sealing_ribs_round(bcd, RW);
        }
        if (bolt_count > 0) {
            for (i = [0 : bolt_count - 1]) {
                rotate([0, 0, i * (360 / bolt_count)])
                    translate([bcd / 2, 0, -0.5])
                        cylinder(d = bolt_hole_d, h = T + 3);
            }
        }
    }

} else if (gasket_type == "rect_flange") {
    ox = ID + 2 * RW;
    oy = IY + 2 * RW;
    mid_x = ID + RW;
    mid_y = IY + RW;

    difference() {
        union() {
            linear_extrude(height = T)
                difference() {
                    offset(r = corner_r) square([ox - 2*corner_r, oy - 2*corner_r], center = true);
                    offset(r = max(1, corner_r - RW*0.5)) square([ID - 2*max(1, corner_r - RW*0.5), IY - 2*max(1, corner_r - RW*0.5)], center = true);
                }
            if (seal_profile == "ribbed") {
                up(T)
                linear_extrude(height = min(0.8, T * 0.35))
                    difference() {
                        offset(r = 2) square([mid_x - 2, mid_y - 2], center = true);
                        offset(r = 1) square([mid_x - 4.4, mid_y - 4.4], center = true);
                    }
            }
        }
        // Corner & Mid-Edge Bolt Holes centered in the flange rim
        if (bolt_count >= 2) {
            for (sx = [-mid_x/2, mid_x/2])
                for (sy = (bolt_count == 2) ? [0] : [-mid_y/2, mid_y/2])
                    translate([sx, sy, -0.5])
                        cylinder(d = bolt_hole_d, h = T + 3);
        }
        if (bolt_count >= 6) {
            for (sy = [-mid_y/2, mid_y/2])
                translate([0, sy, -0.5])
                    cylinder(d = bolt_hole_d, h = T + 3);
        }
        if (bolt_count >= 8) {
            for (sx = [-mid_x/2, mid_x/2])
                translate([sx, 0, -0.5])
                    cylinder(d = bolt_hole_d, h = T + 3);
        }
    }

} else if (gasket_type == "oring_seal") {
    if (seal_profile == "rounded") {
        // Flat-bottomed D-Ring / O-Ring so it prints cleanly on Z=0 without bottom overhang spaghetti!
        up(T / 2)
        rotate_extrude()
            translate([ID/2 + RW/2, 0])
                hull() {
                    circle(d = min(RW, T), $fn = 32);
                    translate([0, -T/4]) square([RW * 0.7, T/2], center = true);
                }
    } else {
        linear_extrude(height = T)
            difference() {
                circle(d = OD);
                circle(d = ID);
            }
    }

} else if (gasket_type == "elec_box_gasket") {
    // Standard NEMA / NEC Weatherproof Electrical Box Gaskets
    if (elec_preset == "gang_1") {
        // 1-Gang Bell Box Gasket (70x115mm outer, 46x72mm inner opening, 83.3mm [3.281"] device screw spacing + corner box holes)
        difference() {
            cuboid([70, 115, T], rounding = 6, edges = "Z", anchor = BOTTOM);
            translate([0, 0, -0.5]) cuboid([46, 72, T + 2], rounding = 4, edges = "Z", anchor = BOTTOM);
            for (sy = [-41.67, 41.67]) translate([0, sy, -0.5]) cylinder(d = 4.2, h = T + 2);
            for (sx = [-24, 24]) for (sy = [-47.6, 47.6]) translate([sx, sy, -0.5]) cylinder(d = 4.2, h = T + 2);
        }
    } else if (elec_preset == "gang_2") {
        // 2-Gang Weatherproof Box Gasket (116x115mm outer, 46.1mm gang spacing)
        difference() {
            cuboid([116, 115, T], rounding = 6, edges = "Z", anchor = BOTTOM);
            translate([0, 0, -0.5]) cuboid([92, 72, T + 2], rounding = 4, edges = "Z", anchor = BOTTOM);
            for (gx = [-23.0, 23.0])
                for (sy = [-41.67, 41.67])
                    translate([gx, sy, -0.5]) cylinder(d = 4.2, h = T + 2);
        }
    } else if (elec_preset == "box_4x4") {
        // 4" Square (1900 Box) Weatherproof Cover Gasket (102x102mm)
        difference() {
            cuboid([102, 102, T], rounding = 8, edges = "Z", anchor = BOTTOM);
            translate([0, 0, -0.5]) cuboid([84, 84, T + 2], rounding = 4, edges = "Z", anchor = BOTTOM);
            for (sx = [-38, 38]) for (sy = [-38, 38]) translate([sx, sy, -0.5]) cylinder(d = 4.5, h = T + 2);
        }
    } else {
        // 4" Round Weatherproof Box Gasket (102mm OD, 82mm ID, 88.9mm [3.5"] hole circle)
        difference() {
            cylinder(d = 102, h = T, anchor = BOTTOM);
            translate([0, 0, -0.5]) cylinder(d = 82, h = T + 2, anchor = BOTTOM);
            for (a = [0 : 90 : 270])
                rotate([0, 0, a]) translate([44.45, 0, -0.5]) cylinder(d = 4.5, h = T + 2);
        }
    }

} else if (gasket_type == "panel_grommet") {
    // Flexible Panel Knockout Grommet (With 45-degree chamfered snap lip so it prints without supports!)
    p_od  = max(10, panel_hole_d);
    c_id  = min(p_od - 3.0, max(2, grommet_id));
    flange_od = p_od + 7.0;
    flange_h  = 2.4;
    groove_h  = max(1.0, panel_thick + 0.3);
    total_gh  = flange_h * 2 + groove_h;

    difference() {
        union() {
            // Bottom outer flange (sits flat on Z=0)
            cylinder(d = flange_od, h = flange_h, chamfer1 = 0.6, anchor = BOTTOM);
            // Center panel-hole neck (sits inside knockout hole)
            up(flange_h)
                cylinder(d = p_od, h = groove_h, anchor = BOTTOM);
            // Top snap-in retention flange (with 45-deg bottom ramp so it prints cleanly without supports and pushes through the knockout!)
            up(flange_h + groove_h)
                cylinder(d1 = p_od, d2 = flange_od, h = flange_h * 0.55, anchor = BOTTOM);
            up(flange_h + groove_h + flange_h * 0.55)
                cylinder(d1 = flange_od, d2 = p_od + 2.0, h = flange_h * 0.45, anchor = BOTTOM);
        }
        // Central cable bore with rounded strain-relief entry/exit mouths
        down(0.1)
            cylinder(d = c_id, h = total_gh + 0.2, anchor = BOTTOM);
        down(0.1)
            cylinder(d1 = c_id + 2.4, d2 = c_id, h = 1.4, anchor = BOTTOM);
        up(total_gh - 1.3)
            cylinder(d1 = c_id, d2 = c_id + 2.4, h = 1.4, anchor = BOTTOM);
    }
}

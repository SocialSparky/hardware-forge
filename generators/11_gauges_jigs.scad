include <BOSL2/std.scad>
include <BOSL2/screws.scad>

/* [1. Shop Gauge or Jig Type] */
// Select Calibration Gauge or Drilling Jig [tolerance_test:Printer Fit Slop Calibration Gauge (Tests 0.08mm to 0.25mm Hex & Round Pegs!), bolt_gauge:Metric & SAE Bolt Diameter + Hex Nut Gauge Card, v_drill_jig:Center-Drilling V-Block Jig (For Drilling Dead-Center Through Round Pipe/Rod)]
gauge_type = "tolerance_test";

/* [2. V-Block Drill Jig Options] */
// Drill Bushings / Guide Hole Diameter [3.0:3.0 mm (M3 / 1/8"), 4.0:4.0 mm (M4 / 5/32"), 5.0:5.0 mm (M5 / 3/16"), 6.35:6.35 mm (1/4" / M6), 8.0:8.0 mm (M8 / 5/16"), 10.0:10.0 mm (M10 / 3/8")] @show_if(gauge_type=v_drill_jig)
drill_hole_d = 5.0;

// V-Block Width (Max Round Stock Diameter) [25:25 mm (Up to 1" Stock), 40:40 mm (Up to 1.5" Stock), 60:60 mm (Up to 2.25" Stock)] @show_if(gauge_type=v_drill_jig)
v_block_size = 40;

/* [Hidden] */
$fn = 64;

echo(str("[SPEC] Shop Tool: ", gauge_type));

if (gauge_type == "tolerance_test") {
    // 5-Slot Printer Slop Calibration Block (0.08, 0.12, 0.16, 0.20, 0.25 mm) + Matching Test Plug!
    slops = [0.08, 0.12, 0.16, 0.20, 0.25];
    labels = [".08", ".12", ".16", ".20", ".25"];
    block_l = 95;
    block_w = 34;
    block_h = 8;

    difference() {
        cuboid([block_l, block_w, block_h], rounding = 3, edges = "Z", anchor = BOTTOM);
        for (i = [0 : 4]) {
            sx = -36 + i * 18;
            s_val = slops[i];
            // Top row: 8mm Hex Socket + 2*slop
            translate([sx, 7, -0.1])
                linear_extrude(height = block_h + 1)
                    hexagon(id = 8.0 + s_val * 2);
            // Bottom row: 8mm Round Bore + 2*slop
            translate([sx, -6, -0.1])
                cylinder(d = 8.0 + s_val * 2, h = block_h + 1, anchor = BOTTOM);
            // Engraved clearance label
            translate([sx, -14, block_h - 0.8])
                linear_extrude(height = 1.2)
                    text(text = labels[i], size = 3.8, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
        }
    }

    // Matching Exact 8.00mm Hex + Round Reference Test Peg beside block!
    translate([0, 28, 0]) {
        cuboid([32, 12, 5], rounding = 2, edges = "Z", anchor = BOTTOM);
        translate([-8, 0, 5]) linear_extrude(height = 12) hexagon(id = 8.0);
        translate([ 8, 0, 5]) cylinder(d = 8.0, h = 12, chamfer2 = 0.5, anchor = BOTTOM);
    }

} else if (gauge_type == "bolt_gauge") {
    // Pocket Bolt & Nut Sizer Card (M3, M4, M5, M6, M8, M10)
    sizes = [3.2, 4.2, 5.2, 6.2, 8.2, 10.2];
    hexes = [5.6, 7.1, 8.1, 10.1, 13.1, 16.1];
    names = ["M3", "M4", "M5", "M6", "M8", "M10"];
    xs    = [-45, -29, -13, 4, 23, 44];

    difference() {
        cuboid([116, 44, 5], rounding = 4, edges = "Z", anchor = BOTTOM);
        for (i = [0 : 5]) {
            translate([xs[i], 10, -0.1])
                cylinder(d = sizes[i], h = 6, anchor = BOTTOM);
            translate([xs[i], -6, 1.5])
                linear_extrude(height = 5)
                    hexagon(id = hexes[i]);
            translate([xs[i], -18, 4.0])
                linear_extrude(height = 1.5)
                    text(text = names[i], size = 4.2, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
        }
    }

} else if (gauge_type == "v_drill_jig") {
    // 90-Degree Self-Centering V-Block Pipe/Dowels Drill Guide
    vw = max(25, v_block_size);
    vl = vw * 1.35;
    vh = vw * 0.72;

    difference() {
        cuboid([vl, vw, vh], rounding = 2, edges = "Z", anchor = BOTTOM);
        // 90-degree V-channel along X axis on top
        translate([0, 0, vh])
            rotate([45, 0, 0])
                cuboid([vl + 4, vw * 0.72, vw * 0.72], center = true);
        // Dead-center vertical drill guide hole + chip relief window
        translate([0, 0, -0.1])
            cylinder(d = drill_hole_d, h = vh + 2, anchor = BOTTOM);
    }
}

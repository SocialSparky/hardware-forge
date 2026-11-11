include <BOSL2/std.scad>

/* [1. Bearing Standard & Rolling Element] */
// Bearing Rolling Style [roller:Captive Crowned Rollers (High Load / Easy Print), ball:Captive V-Groove Balls (Low Friction)]
bearing_type = "roller";

// Standard Bearing Size Preset [608:608 Skate Bearing (8×22×7 mm), 606:606 Bearing (6×17×6 mm), 625:625 Bearing (5×16×5 mm), 6000:6000 Bearing (10×26×8 mm), 6001:6001 Bearing (12×28×8 mm), 6002:6002 Bearing (15×32×9 mm), 6004:6004 Bearing (20×42×12 mm), custom:Custom Dimensions (Use Dropdowns Below)]
preset = "608";

/* [2. Custom Dimensions] */
// Custom Inner Bore (ID) [5:5 mm, 6:6 mm, 8:8 mm, 10:10 mm, 12:12 mm, 15:15 mm, 20:20 mm, 25:25 mm] @show_if(preset=custom)
custom_id = 8;

// Custom Outer Diameter (OD) [18:18 mm, 22:22 mm, 26:26 mm, 30:30 mm, 35:35 mm, 40:40 mm, 50:50 mm] @show_if(preset=custom)
custom_od = 24;

// Custom Width / Thickness [6:6 mm, 7:7 mm, 8:8 mm, 10:10 mm, 12:12 mm, 15:15 mm] @show_if(preset=custom)
custom_width = 8;

/* [3. 3D Print Clearance] */
// Print-in-Place Air Gap [0.12:0.12 mm (Ultra Tuned Printer), 0.15:0.15 mm (Snug Fit), 0.18:0.18 mm (Recommended PLA/PETG), 0.22:0.22 mm (Free Spinning), 0.28:0.28 mm (Loose / 0.6mm Nozzle)]
clearance = 0.18;

/* [Hidden] */
$fn = 72;

dims = (preset == "608")  ? [8, 22, 7] :
       (preset == "606")  ? [6, 17, 6] :
       (preset == "625")  ? [5, 16, 5] :
       (preset == "6000") ? [10, 26, 8] :
       (preset == "6001") ? [12, 28, 8] :
       (preset == "6002") ? [15, 32, 9] :
       (preset == "6004") ? [20, 42, 12] :
                            [custom_id, custom_od, custom_width];

ID = dims[0];
OD = max(dims[1], ID + 3.0);
W  = dims[2];

pitch_r = (ID/2 + OD/2) / 2;
radial_span = (OD - ID) / 2;
elem_r = radial_span * 0.28;
groove_depth = elem_r * 0.42;

num_elems = floor((2 * PI * pitch_r) / (elem_r * 2.25));

// 2D Profile of the rolling element + clearance for raceway cutout
module track_cutout_2d(extra_gap) {
    r = elem_r + extra_gap;
    if (bearing_type == "ball") {
        // 45-deg diamond-chamfered ball track so overhangs print cleanly
        circle(r = r);
    } else {
        // Double-conical crowned roller profile (self-capturing at 45 deg)
        polygon([
            [-r + groove_depth, -W/2 + 0.8],
            [-r, 0],
            [-r + groove_depth,  W/2 - 0.8],
            [ r - groove_depth,  W/2 - 0.8],
            [ r, 0],
            [ r - groove_depth, -W/2 + 0.8]
        ]);
    }
}

up(W/2) {
    // Inner & Outer Races
    difference() {
        cylinder(d = OD, h = W, center = true, chamfer = 0.5);
        cylinder(d = ID, h = W + 1, center = true, chamfer = -0.5);

        // Cut central separation channel between inner & outer rings
        difference() {
            cylinder(r = pitch_r + elem_r - groove_depth + clearance, h = W + 1, center = true);
            cylinder(r = pitch_r - elem_r + groove_depth - clearance, h = W + 1, center = true);
        }

        // Cut Captive Raceway Groove
        rotate_extrude()
            translate([pitch_r, 0])
                track_cutout_2d(clearance);
    }

    // Place Rolling Elements Around Pitch Circle
    for (i = [0 : num_elems - 1]) {
        rotate([0, 0, i * (360 / num_elems)])
        translate([pitch_r, 0, 0])
            rotate_extrude()
                intersection() {
                    track_cutout_2d(0);
                    translate([0, -W]) square([elem_r * 2, W * 2]);
                }
    }
}

include <BOSL2/std.scad>

/* [1. Enclosure / Mount Type] */
// Select Electronics Component [project_box:Vented Electronics Project Enclosure (With Corner Lid Bosses & PCB Standoffs), din_clip:35mm DIN-Rail Snap-On Mounting Clip]
enclosure_type = "project_box";

// Render Mode [both:Enclosure Base + Screw-On Lid Side-by-Side, base:Enclosure Base Only, lid:Vented Cover Lid Only] @show_if(enclosure_type=project_box)
render_part = "both";

/* [2. Enclosure Interior Dimensions] */
// Inner Length - X Axis [50:50 mm, 65:65 mm (Raspberry Pi Zero), 85:85 mm, 92:92 mm (Raspberry Pi 4/5), 110:110 mm, 130:130 mm, 160:160 mm] @show_if(enclosure_type=project_box)
inner_x = 92;

// Inner Width - Y Axis [35:35 mm, 50:50 mm, 62:62 mm (Raspberry Pi 4/5), 75:75 mm, 90:90 mm, 110:110 mm] @show_if(enclosure_type=project_box)
inner_y = 62;

// Inner Height - Z Axis [20:20 mm (Slim), 30:30 mm (Standard), 40:40 mm, 50:50 mm (Deep), 65:65 mm] @show_if(enclosure_type=project_box)
inner_z = 30;

// Wall Thickness [2.0:2.0 mm (Standard), 2.4:2.4 mm (Rugged), 3.2:3.2 mm (Heavy Duty)]
wall_t = 2.4;

/* [3. Vents, Cable Gland & Mounting Ears] */
// Include Side & Lid Cooling Louver Vents @show_if(enclosure_type=project_box)
cooling_vents = true;

// Include External Flanged Mounting Ears @show_if(enclosure_type=project_box)
mounting_ears = true;

// Cable Pass-Through Hole Diameter (0 = None) [0:0 mm (Solid Ends), 6:6 mm (USB/Sensor Cable), 10:10 mm (Power Cord), 12.5:12.5 mm (PG7 Cable Gland), 16:16 mm (PG9 / M16 Gland), 20.5:20.5 mm (M20 / 1/2" Knockout)] @show_if(enclosure_type=project_box)
cable_hole_d = 10;

// Internal PCB Standoff Pillars (4 Corners) @show_if(enclosure_type=project_box)
pcb_standoffs = true;

/* [4. DIN-Rail Clip Options] */
// DIN Clip Width [12:12 mm (Narrow), 18:18 mm (1-Module Std), 25:25 mm, 35:35 mm (Wide Heavy Duty)] @show_if(enclosure_type=din_clip)
din_width = 18;

// Mounting Hole Spacing on DIN Clip [20:20 mm, 25:25 mm, 30:30 mm, 35:35 mm] @show_if(enclosure_type=din_clip)
din_hole_span = 25;

/* [Hidden] */
$fn = 48;

IX = max(30, inner_x);
IY = max(25, inner_y);
IZ = max(15, inner_z);
T  = max(1.6, wall_t);
OX = IX + 2*T;
OY = IY + 2*T;

echo(str("[SPEC] Electronics: ", enclosure_type, "  |  Interior: ", IX, "×", IY, "×", IZ, " mm"));

if (enclosure_type == "project_box") {
    if (render_part == "both" || render_part == "base") {
        bx = (render_part == "both") ? -(OX/2 + 8) : 0;
        translate([bx, 0, 0]) {
            difference() {
                union() {
                    cuboid([OX, OY, IZ + T], rounding = 4, edges = "Z", anchor = BOTTOM);
                    if (mounting_ears) {
                        difference() {
                            cuboid([OX + 22, 16, T * 1.5], rounding = 3, edges = "Z", anchor = BOTTOM);
                            for (sx = [-(OX/2 + 6), (OX/2 + 6)])
                                translate([sx, 0, -0.1]) cylinder(d = 4.2, h = T * 3);
                        }
                    }
                }
                // Hollow interior
                up(T)
                    cuboid([IX, IY, IZ + 2], rounding = 2, edges = "Z", anchor = BOTTOM);

                // Side Cooling Vents
                if (cooling_vents) {
                    for (vx = [-IX*0.28 : 6 : IX*0.28])
                        translate([vx, 0, T + IZ * 0.45])
                            cuboid([2.4, OY + 4, IZ * 0.55], rounding = 1, edges = "Y");
                }
                // Cable Gland Hole on -X End Wall
                if (cable_hole_d > 0) {
                    translate([-OX/2, 0, T + IZ/2])
                        rotate([0, 90, 0])
                            cylinder(d = cable_hole_d, h = T * 4, center = true);
                }
            }
            // 4 Corner Lid Screw Bosses (M3 self-tapping / 2.7mm pilot bore)
            for (sx = [-IX/2 + 3.5, IX/2 - 3.5])
                for (sy = [-IY/2 + 3.5, IY/2 - 3.5])
                    translate([sx, sy, T])
                    difference() {
                        cylinder(d = 7.5, h = IZ, anchor = BOTTOM);
                        translate([0, 0, IZ - 12]) cylinder(d = 2.7, h = 13);
                    }
            // 4 Internal PCB Standoffs (5mm tall, M2.5/M3 pilot)
            if (pcb_standoffs) {
                for (sx = [-IX/2 + 12, IX/2 - 12])
                    for (sy = [-IY/2 + 8, IY/2 - 8])
                        translate([sx, sy, T])
                        difference() {
                            cylinder(d = 6.2, h = 5, anchor = BOTTOM);
                            cylinder(d = 2.5, h = 6, anchor = BOTTOM);
                        }
            }
        }
    }

    if (render_part == "both" || render_part == "lid") {
        lx = (render_part == "both") ? (OX/2 + 8) : 0;
        translate([lx, 0, 0]) {
            difference() {
                union() {
                    cuboid([OX, OY, T], rounding = 4, edges = "Z", anchor = BOTTOM);
                    // Inner alignment lip
                    up(T)
                        cuboid([IX - 0.5, IY - 0.5, 2.4], rounding = 1.8, edges = "Z", anchor = BOTTOM);
                }
                up(T)
                    cuboid([IX - 10, IY - 10, 4], rounding = 1.5, edges = "Z", anchor = BOTTOM);
                // 4 Corner M3 Countersunk Lid Screw Holes
                for (sx = [-IX/2 + 3.5, IX/2 - 3.5])
                    for (sy = [-IY/2 + 3.5, IY/2 - 3.5])
                        translate([sx, sy, -0.1]) {
                            cylinder(d = 3.4, h = T + 4);
                            cylinder(d1 = 6.4, d2 = 3.4, h = 1.8);
                        }
                if (cooling_vents) {
                    for (vx = [-IX*0.28 : 6 : IX*0.28])
                        translate([vx, 0, T/2])
                            cuboid([2.4, IY * 0.65, T + 4], center = true);
                }
            }
        }
    }

} else if (enclosure_type == "din_clip") {
    // Standard 35mm Top-Hat DIN Rail (EN 50022) Snap-On Clip with Integrated Flex Spring!
    linear_extrude(height = din_width) {
        difference() {
            union() {
                // Main backplate (48mm tall)
                translate([-24, 0]) square([48, 5.5]);
                // Top fixed hook (grasps top edge of 35mm rail at X = +17.5)
                polygon([[12, 5.5], [22, 5.5], [22, 9.5], [14.8, 9.5], [14.8, 7.2], [17.7, 7.2], [17.7, 5.5]]);
                // Bottom spring cantilever latch (grasps bottom edge at X = -17.5 + release tab)
                polygon([[-13, 5.5], [-24, 5.5], [-24, 7.5], [-19.5, 9.5], [-15.2, 9.5], [-17.7, 7.2], [-13, 7.2]]);
            }
            // Flex relief slot behind bottom latch so it snaps onto 35mm DIN rail smoothly
            translate([-21, 2.2]) square([9, 2.0]);
            // 2 M4 Mounting Holes
            for (hx = [-din_hole_span/2, din_hole_span/2])
                translate([hx, -0.1]) square([4.2, 10]);
        }
    }
}

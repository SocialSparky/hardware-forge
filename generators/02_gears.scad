include <BOSL2/std.scad>
include <BOSL2/gears.scad>

/* [1. Gear Type & Tooth Profile] */
// Gear Style [spur:Standard Spur Gear (Straight), helical:Helical Gear (Angled Teeth), herringbone:Herringbone Gear (Double Helical)]
gear_style = "spur";

// Tooth Size (Metric Module) [0.5:Module 0.5 (Fine Mini Gear), 0.8:Module 0.8, 1.0:Module 1.0 (Standard RC/Robotics), 1.25:Module 1.25, 1.5:Module 1.5 (Medium Mechanical), 2.0:Module 2.0 (Heavy Duty), 2.5:Module 2.5, 3.0:Module 3.0 (Large Industrial)]
mod = 1.5;

// Tooth Count [8:8 Teeth, 10:10 Teeth, 12:12 Teeth, 14:14 Teeth, 15:15 Teeth, 16:16 Teeth, 18:18 Teeth, 20:20 Teeth, 24:24 Teeth, 25:25 Teeth, 30:30 Teeth, 32:32 Teeth, 36:36 Teeth, 40:40 Teeth, 48:48 Teeth, 50:50 Teeth, 60:60 Teeth, 72:72 Teeth, 80:80 Teeth, 100:100 Teeth]
teeth = 24;

// Gear Face Thickness [3:3 mm, 4:4 mm, 5:5 mm, 6:6 mm, 8:8 mm, 10:10 mm, 12:12 mm, 15:15 mm, 20:20 mm, 25:25 mm]
thickness = 8;

// Pressure Angle [14.5:14.5° (Legacy / Fine), 20:20° (Universal Standard), 25:25° (High Torque / Strong Root)]
pressure_angle = 20;

// Helix Angle [15:15° (Gentle), 20:20° (Standard), 25:25°, 30:30° (Steep / Quiet), 35:35°] @show_if(gear_style=helical|herringbone)
helix_angle = 25;

/* [2. Shaft Bore & Keyway] */
// Center Shaft Bore Diameter [3.0:3.0 mm (M3 Shaft), 3.175:3.175 mm (1/8" RC Motor Shaft), 4.0:4.0 mm (M4 Shaft), 5.0:5.0 mm (NEMA 17 Stepper Shaft), 6.0:6.0 mm (M6 / 6mm Shaft), 6.35:6.35 mm (1/4" Imperial Shaft), 8.0:8.0 mm (M8 / 608 Bearing Bore), 10.0:10.0 mm (10mm Rod), 12.0:12.0 mm (12mm Rod)]
shaft_diam = 5.0;

// Shaft Bore Profile [round:Round Smooth Bore, d_flat:D-Shaft Flat (Stepper Motor), keyway:Square Keyway Slot]
bore_style = "d_flat";

// D-Shaft Flat Depth [0.4:0.4 mm (Light Flat), 0.5:0.5 mm (Standard NEMA 17), 0.75:0.75 mm, 1.0:1.0 mm (Deep Flat)] @show_if(bore_style=d_flat)
d_flat_depth = 0.5;

/* [3. Hub Boss Options] */
// Add Raised Center Hub Boss
add_hub = false;

// Hub Outer Diameter [12:12 mm, 14:14 mm, 16:16 mm, 18:18 mm, 20:20 mm, 25:25 mm] @show_if(add_hub=true)
hub_diam = 16;

// Hub Extra Height [4:4 mm, 6:6 mm, 8:8 mm, 10:10 mm] @show_if(add_hub=true)
hub_height = 6;

/* [4. 3D Print Tuning] */
// Tooth Backlash & Bore Clearance [0.08:Tight (0.08 mm), 0.12:Fine PLA (0.12 mm), 0.15:Standard (0.15 mm), 0.20:Loose / High Speed (0.20 mm)]
backlash = 0.15;

/* [Hidden] */
$fn = 72;
$slop = backlash;

h_ang = (gear_style == "spur") ? 0 : helix_angle;
is_hb = (gear_style == "herringbone");
total_h = thickness + (add_hub ? hub_height : 0);
eff_bore = shaft_diam + (backlash * 1.5);

difference() {
    union() {
        spur_gear(
            mod = mod,
            teeth = teeth,
            thickness = thickness,
            shaft_diam = 0,
            pressure_angle = pressure_angle,
            helical = h_ang,
            herringbone = is_hb,
            backlash = backlash,
            anchor = BOTTOM
        );
        if (add_hub) {
            up(thickness)
            cylinder(d = hub_diam, h = hub_height, anchor = BOTTOM);
        }
    }

    // Center Bore Cutout
    down(0.1)
    linear_extrude(height = total_h + 0.2) {
        if (bore_style == "round") {
            circle(d = eff_bore);
        } else if (bore_style == "d_flat") {
            difference() {
                circle(d = eff_bore);
                translate([eff_bore/2 - d_flat_depth, -eff_bore])
                    square([eff_bore, eff_bore * 2]);
            }
        } else if (bore_style == "keyway") {
            circle(d = eff_bore);
            translate([-eff_bore * 0.15, 0])
                square([eff_bore * 0.3, eff_bore * 0.65]);
        }
    }
}

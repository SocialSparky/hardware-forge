include <BOSL2/std.scad>
include <BOSL2/screws.scad>

/* [1. Spacer / Standoff Style & System] */
// Component Type [unthreaded_round:Round Unthreaded Clearance Spacer, unthreaded_hex:Hex Unthreaded Clearance Spacer, female_hex:Female-Female Threaded Hex Standoff, female_round:Female-Female Threaded Round Standoff, male_female_hex:Male-Female Threaded Hex Standoff]
spacer_type = "unthreaded_round";

// Measurement System [metric:Metric (M2 – M20), imperial:Imperial (#4-40 – 3/4")]
unit_system = "metric";

// Metric Screw / Bolt Size [M2:M2 (2.0 mm), M2.5:M2.5 (2.5 mm - Pi), M3:M3 (3.0 mm - Electronics), M4:M4 (4.0 mm), M5:M5 (5.0 mm), M6:M6 (6.0 mm), M8:M8 (8.0 mm), M10:M10 (10.0 mm), M12:M12 (12.0 mm), M14:M14 (14.0 mm), M16:M16 (16.0 mm), M20:M20 (20.0 mm)] @show_if(unit_system=metric)
metric_spec = "M6";

// Imperial Screw / Bolt Size [#4-40:#4-40 (0.112"), #6-32:#6-32 (0.138" - PC/Elec), #8-32:#8-32 (0.164" - Box Screw), #10-24:#10-24 (0.190"), #10-32:#10-32 (0.190"), 1/4-20:1/4"-20 (6.35 mm), 5/16-18:5/16"-18 (7.94 mm), 3/8-16:3/8"-16 (9.53 mm), 1/2-13:1/2"-13 (12.70 mm), 5/8-11:5/8"-11 (15.88 mm), 3/4-10:3/4"-10 (19.05 mm)] @show_if(unit_system=imperial)
imperial_spec = "1/4-20";

/* [2. Body Height & Outer Diameter] */
// Body Height / Spacer Length [2:2 mm, 3:3 mm, 4:4 mm, 5:5 mm, 6:6 mm (~1/4"), 8:8 mm (~5/16"), 10:10 mm (~3/8"), 12:12 mm (~1/2"), 15:15 mm, 16:16 mm (~5/8"), 20:20 mm (~3/4"), 25:25 mm (~1"), 30:30 mm (~1-1/4"), 35:35 mm, 40:40 mm (~1-1/2"), 50:50 mm (~2"), 60:60 mm (~2-3/8"), 75:75 mm (~3"), 100:100 mm (~4")]
height = 15;

// Outer Diameter / Width Mode [auto_thin:Auto Thin Wall (1.5x Bore), auto_std:Auto Standard Wall (2.0x Bore), auto_heavy:Auto Heavy Duty Wall (2.8x Bore), custom:Custom Outer Diameter / Width (Select Below)]
od_mode = "auto_std";

// Custom Outer Width / Diameter [4:4 mm, 5:5 mm, 6:6 mm, 7:7 mm, 8:8 mm, 10:10 mm, 12:12 mm, 14:14 mm, 15:15 mm, 16:16 mm, 18:18 mm, 20:20 mm, 22:22 mm, 25:25 mm (~1"), 30:30 mm, 35:35 mm, 40:40 mm (~1-1/2"), 45:45 mm, 50:50 mm (~2"), 60:60 mm] @show_if(od_mode=custom)
custom_od = 15;

// Male Threaded Stud Length [4:4 mm, 6:6 mm, 8:8 mm, 10:10 mm, 12:12 mm, 15:15 mm, 20:20 mm, 25:25 mm] @show_if(spacer_type=male_female_hex)
stud_length = 8;

/* [3. 3D Print Clearance] */
// Bore / Thread Clearance [0.12:Snug Fit (0.12 mm), 0.16:Standard Fit (0.16 mm), 0.22:Loose Clearance (0.22 mm), 0.30:Free Slip Fit (0.30 mm)]
printer_slop = 0.16;

/* [Hidden] */
$fn = 64;
$slop = printer_slop;

spec_str = (unit_system == "metric") ? metric_spec : imperial_spec;
info = screw_info(spec_str);
nom_d = struct_val(info, "diameter");

calc_od = (od_mode == "auto_thin")  ? (nom_d * 1.55 + 1.2) :
          (od_mode == "auto_std")   ? (nom_d * 2.0 + 1.5) :
          (od_mode == "auto_heavy") ? (nom_d * 2.8 + 2.0) : custom_od;

od = max(calc_od, nom_d + 0.4);
bore_d = nom_d + (printer_slop * 2.2);

echo(str("[SPEC] Fastener: ", spec_str, " (", round(nom_d*100)/100, " mm)  |  Outer Size: ", round(od*10)/10, " mm  |  Length: ", height, " mm"));

if (spacer_type == "unthreaded_round") {
    linear_extrude(height = height)
        difference() {
            circle(d = od);
            circle(d = bore_d);
        }
} else if (spacer_type == "unthreaded_hex") {
    linear_extrude(height = height)
        difference() {
            hexagon(id = od);
            circle(d = bore_d);
        }
} else if (spacer_type == "female_hex") {
    nut(spec = spec_str, shape = "hex", width = od, thickness = height, bevel = true, anchor = BOTTOM);
} else if (spacer_type == "female_round") {
    // Round Knurled/Smooth Female Threaded Standoff
    difference() {
        cylinder(d = od, h = height, chamfer = 0.5, anchor = BOTTOM);
        down(0.1)
            screw(spec = spec_str, head = "none", length = height + 0.2, thread = true, bevel = false, anchor = BOTTOM);
    }
} else if (spacer_type == "male_female_hex") {
    nut(spec = spec_str, shape = "hex", width = od, thickness = height, bevel = true, anchor = BOTTOM);
    up(height)
        screw(spec = spec_str, head = "none", length = stud_length, bevel = true, anchor = BOTTOM);
}

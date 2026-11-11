include <BOSL2/std.scad>
include <BOSL2/screws.scad>

/* [1. Fastener Type & Measurement System] */
// Fastener Type [bolt:Bolt / Machine Screw, nut:Hex Nut, washer:Flat Washer, rod:Threaded Rod / Stud]
part_type = "bolt";

// Measurement System [metric:Metric (ISO M-Series), imperial:Imperial (UTS UNC / UNF)]
unit_system = "metric";

// Metric Thread Size [M1.6:M1.6 (0.35mm Pitch), M2:M2 (0.4mm Pitch), M2.5:M2.5 (0.45mm Pitch), M3:M3 (0.5mm Pitch), M4:M4 (0.7mm Pitch), M5:M5 (0.8mm Pitch), M6:M6 (1.0mm Pitch), M8:M8 (1.25mm Pitch), M10:M10 (1.5mm Pitch), M12:M12 (1.75mm Pitch), M14:M14 (2.0mm Pitch), M16:M16 (2.0mm Pitch), M20:M20 (2.5mm Pitch)] @show_if(unit_system=metric)
metric_size = "M8";

// Imperial Thread Size [#2-56:#2-56 UNC, #4-40:#4-40 UNC, #6-32:#6-32 UNC, #8-32:#8-32 UNC, #10-24:#10-24 UNC, #10-32:#10-32 UNF, 1/4-20:1/4"-20 UNC, 1/4-28:1/4"-28 UNF, 5/16-18:5/16"-18 UNC, 5/16-24:5/16"-24 UNF, 3/8-16:3/8"-16 UNC, 3/8-24:3/8"-24 UNF, 7/16-14:7/16"-14 UNC, 1/2-13:1/2"-13 UNC, 1/2-20:1/2"-20 UNF, 5/8-11:5/8"-11 UNC, 3/4-10:3/4"-10 UNC] @show_if(unit_system=imperial)
imperial_size = "1/4-20";

/* [2. Bolt Head & Wrench / Drive Sizing] */
// Bolt Head Style [socket:Socket Cap (Cylindrical), hex:Hex Bolt Head, button:Button Head (Domed), flat:Flat Countersunk (90°/82°), pan:Pan Head (Rounded Top)] @show_if(part_type=bolt)
head_type = "socket";

// Bolt Head Height / Thickness [auto:Auto (Standard for Bolt), 0.5:0.5 mm (Micro), 1.0:1.0 mm, 1.5:1.5 mm, 2.0:2.0 mm, 3.0:3.0 mm, 4.0:4.0 mm, 5.0:5.0 mm, 6.0:6.0 mm, 8.0:8.0 mm, 10.0:10.0 mm] @show_if(part_type=bolt)
head_height_override = "auto";

// Metric Hex Head Wrench Size (Across Flats) [auto:Auto (ISO Standard for Thread), 3.2:3.2 mm (M1.6 Std), 4.0:4.0 mm (M2 Std), 5.0:5.0 mm (M2.5 Std), 5.5:5.5 mm (M3 Std), 7.0:7.0 mm (M4 Std), 8.0:8.0 mm (M5 Std), 10.0:10.0 mm (M6 Std), 13.0:13.0 mm (M8 Std), 15.0:15.0 mm (M10 Flange/Alt), 16.0:16.0 mm (M10 ISO Std), 17.0:17.0 mm (M10 DIN Old), 18.0:18.0 mm (M12 ISO Std), 19.0:19.0 mm (M12 DIN Old), 21.0:21.0 mm (M14 Std), 24.0:24.0 mm (M16 Std), 30.0:30.0 mm (M20 Std)] @show_if(part_type=bolt, head_type=hex, unit_system=metric)
metric_hex_head_af = "auto";

// Imperial Hex Head Wrench Size (Across Flats) [auto:Auto (ASME Standard for Thread), 4.7625:3/16" (4.76 mm - #2 Std), 6.35:1/4" (6.35 mm - #4 Std), 7.9375:5/16" (7.94 mm - #6 Std), 8.73125:11/32" (8.73 mm - #8 Std), 9.525:3/8" (9.53 mm - #10 Std), 11.1125:7/16" (11.11 mm - 1/4" Std), 12.7:1/2" (12.70 mm - 5/16" Std), 14.2875:9/16" (14.29 mm - 3/8" Std), 15.875:5/8" (15.88 mm - 7/16" Std), 19.05:3/4" (19.05 mm - 1/2" Std), 23.8125:15/16" (23.81 mm - 5/8" Std), 28.575:1-1/8" (28.58 mm - 3/4" Std)] @show_if(part_type=bolt, head_type=hex, unit_system=imperial)
imperial_hex_head_af = "auto";

// Internal Tool Drive Type [hex:Hex (Allen Key), torx:Torx 6-Point Star, phillips:Phillips Cross, slot:Flat Slotted, combo:Combo Phillips + Slotted (Electrical Style)] @show_if(part_type=bolt, head_type=socket|button|flat|pan)
drive_type = "hex";

// Metric Allen Key Drive Size [auto:Auto (ISO Standard for Bolt), 1.3:1.3 mm (M2 Button/Flat), 1.5:1.5 mm (M2 Socket / M2.5 Button), 2.0:2.0 mm (M2.5 Socket / M3 Button), 2.5:2.5 mm (M3 Socket / M4 Button), 3.0:3.0 mm (M4 Socket / M5 Button), 4.0:4.0 mm (M5 Socket / M6 Button), 5.0:5.0 mm (M6 Socket / M8 Button), 6.0:6.0 mm (M8 Socket / M10 Button), 8.0:8.0 mm (M10 Socket / M12 Button), 10.0:10.0 mm (M12 Socket / M14 Button), 12.0:12.0 mm (M14 Socket / M20 Button), 14.0:14.0 mm (M16 Socket), 17.0:17.0 mm (M20 Socket)] @show_if(part_type=bolt, head_type=socket|button|flat|pan, drive_type=hex, unit_system=metric)
metric_allen_size = "auto";

// Imperial Allen Key Drive Size [auto:Auto (ASME Standard for Bolt), 1.5875:1/16" (1.59 mm - #4 Button/Flat), 1.9844:5/64" (1.98 mm - #6 Button/Flat), 2.38125:3/32" (2.38 mm - #4 Socket / #8 Button), 2.7781:7/64" (2.78 mm - #6 Socket), 3.175:1/8" (3.18 mm - #10 Button/Flat), 3.5719:9/64" (3.57 mm - #8 Socket), 3.96875:5/32" (3.97 mm - #10 Socket / 1/4" Button), 4.7625:3/16" (4.76 mm - 1/4" Socket / 5/16" Button), 5.55625:7/32" (5.56 mm - 3/8" Button/Flat), 6.35:1/4" (6.35 mm - 5/16" Socket / 7/16" Button), 7.9375:5/16" (7.94 mm - 3/8" Socket / 1/2" Button), 9.525:3/8" (9.53 mm - 7/16" & 1/2" Socket), 12.7:1/2" (12.70 mm - 5/8" Socket), 15.875:5/8" (15.88 mm - 3/4" Socket)] @show_if(part_type=bolt, head_type=socket|button|flat|pan, drive_type=hex, unit_system=imperial)
imperial_allen_size = "auto";

// Torx Star Bit Size [auto:Auto (Standard for Bolt), T6:T6 Torx (1.70 mm OD - M2), T8:T8 Torx (2.31 mm OD - M2.5), T10:T10 Torx (2.74 mm OD - M3 / #4), T15:T15 Torx (3.27 mm OD - #6), T20:T20 Torx (3.86 mm OD - M4 / #8), T25:T25 Torx (4.43 mm OD - M5 / #10), T27:T27 Torx (4.99 mm OD), T30:T30 Torx (5.52 mm OD - M6 / 1/4"), T40:T40 Torx (6.65 mm OD - 5/16"), T45:T45 Torx (7.82 mm OD - M8 / 3/8"), T50:T50 Torx (8.83 mm OD - M10 / 7/16"), T55:T55 Torx (11.22 mm OD - M12 / 1/2"), T60:T60 Torx (13.25 mm OD - M14+ / 5/8"+)] @show_if(part_type=bolt, head_type=socket|button|flat|pan, drive_type=torx)
torx_drive_size = "auto";

// Phillips Tip Size [auto:Auto (Standard for Bolt), PH0:PH0 (Micro - M2), PH1:PH1 (Small - M2.5/M3/#4), PH2:PH2 (Standard - M4/M5/#6-#10), PH3:PH3 (Large - M6/M8/1/4"/5/16"), PH4:PH4 (Heavy - M10+/3/8"+)] @show_if(part_type=bolt, head_type=socket|button|flat|pan, drive_type=phillips|combo)
phillips_drive_size = "auto";

// Slotted Blade Width [auto:Auto (Standard for Bolt), 0.5:0.5 mm Micro Slot, 0.8:0.8 mm Fine Slot, 1.0:1.0 mm Slot, 1.2:1.2 mm Standard Slot, 1.6:1.6 mm Medium Slot, 2.0:2.0 mm Wide Slot, 2.5:2.5 mm Heavy Slot, 3.0:3.0 mm Extra Heavy Slot] @show_if(part_type=bolt, head_type=socket|button|flat|pan, drive_type=slot|combo)
slot_width_override = "auto";

/* [3. Bolt, Shoulder Grip & Thread Length] */
// Thread Coverage [full:Fully Threaded Shank, partial_grip:Exact Unthreaded Shoulder Grip + Positive-Stop Flush Nut (Recommended!), partial_total:Specify Total Shank Length & Partial Thread Length] @show_if(part_type=bolt)
thread_coverage = "partial_grip";

// Exact Unthreaded Shoulder Grip Length (Nut Stops Dead at This Length!) [5:5 mm, 8:8 mm, 10:10 mm, 12:12 mm, 15:15 mm, 16:16 mm, 18:18 mm, 20:20 mm, 21:21 mm, 22:22 mm, 25:25 mm (~1"), 30:30 mm, 35:35 mm, 40:40 mm, 50:50 mm (~2"), 60:60 mm, 75:75 mm] @show_if(part_type=bolt, thread_coverage=partial_grip)
shoulder_grip_len = 21;

// Total Shank / Rod Length [6:6 mm (~1/4"), 8:8 mm (~5/16"), 10:10 mm (~3/8"), 12:12 mm (~1/2"), 16:16 mm (~5/8"), 20:20 mm (~3/4"), 25:25 mm (~1"), 27.5:27.5 mm (21mm + 6.5mm M8 Nut), 30:30 mm (~1-1/4"), 35:35 mm, 40:40 mm (~1-1/2"), 45:45 mm, 50:50 mm (~2"), 60:60 mm (~2-1/2"), 75:75 mm (~3"), 100:100 mm (~4"), 125:125 mm (~5"), 150:150 mm (~6")] @show_if(part_type=rod|bolt, thread_coverage=full|partial_total)
length = 25;

// Threaded Tip Length (Beyond Positive Shoulder Stop) [nut_match:Match Standard Nut Thickness (100% Flush Back — Zero Protrusion!), 4:4 mm, 6:6 mm, 8:8 mm, 10:10 mm, 12:12 mm, 15:15 mm, 20:20 mm, 25:25 mm, 30:30 mm, 40:40 mm] @show_if(part_type=bolt, thread_coverage=partial_grip|partial_total)
thread_len = "nut_match";

/* [4. Nut Options] */
// Nut Profile [normal:Standard Hex Nut, thin:Thin Jam Nut, thick:Thick Heavy Nut, custom:Custom Thickness] @show_if(part_type=nut)
nut_style = "normal";

// Nut Internal Thread Entry Bevel [standard:Standard Beveled Entry (Easy Start), minimal:Minimal Entry Bevel (Maximizes Thread Engagement)] @show_if(part_type=nut)
nut_inner_bevel = "standard";

// Metric Nut Wrench Size (Across Flats) [auto:Auto (ISO Standard for Thread), 3.2:3.2 mm (M1.6), 4.0:4.0 mm (M2), 5.0:5.0 mm (M2.5), 5.5:5.5 mm (M3), 7.0:7.0 mm (M4), 8.0:8.0 mm (M5), 10.0:10.0 mm (M6), 13.0:13.0 mm (M8), 15.0:15.0 mm (M10 Alt), 16.0:16.0 mm (M10 ISO), 17.0:17.0 mm (M10 DIN), 18.0:18.0 mm (M12 ISO), 19.0:19.0 mm (M12 DIN), 21.0:21.0 mm (M14), 24.0:24.0 mm (M16), 30.0:30.0 mm (M20)] @show_if(part_type=nut, unit_system=metric)
metric_nut_af = "auto";

// Imperial Nut Wrench Size (Across Flats) [auto:Auto (ASME Standard for Thread), 4.7625:3/16" (4.76 mm - #2), 6.35:1/4" (6.35 mm - #4), 7.9375:5/16" (7.94 mm - #6), 8.73125:11/32" (8.73 mm - #8), 9.525:3/8" (9.53 mm - #10), 11.1125:7/16" (11.11 mm - 1/4"), 12.7:1/2" (12.70 mm - 5/16"), 14.2875:9/16" (14.29 mm - 3/8"), 15.875:5/8" (15.88 mm - 7/16"), 19.05:3/4" (19.05 mm - 1/2"), 23.8125:15/16" (23.81 mm - 5/8"), 28.575:1-1/8" (28.58 mm - 3/4")] @show_if(part_type=nut, unit_system=imperial)
imperial_nut_af = "auto";

// Custom Nut Thickness [1.5:1.5 mm, 2:2 mm, 3:3 mm, 4:4 mm, 5:5 mm, 6:6 mm, 8:8 mm, 10:10 mm, 12:12 mm, 15:15 mm, 20:20 mm] @show_if(part_type=nut, nut_style=custom)
custom_nut_height = 5;

/* [5. Washer Options] */
// Washer Outer Diameter Ratio [1.8:Narrow / Split Size (1.8x ID), 2.2:Standard Flat Washer (2.2x ID), 3.0:Wide Fender Washer (3.0x ID), 3.8:Extra Wide Body Washer (3.8x ID)] @show_if(part_type=washer)
washer_od_mult = 2.2;

// Washer Thickness [0.5:0.5 mm (Micro Shim), 0.8:0.8 mm (Thin), 1.2:1.2 mm, 1.6:1.6 mm (Standard), 2.0:2.0 mm, 2.5:2.5 mm (Heavy), 3.0:3.0 mm (Extra Heavy), 4.0:4.0 mm (Structural Plate)] @show_if(part_type=washer)
washer_thickness = 1.6;

/* [6. 3D Print Tuning] */
// Printer Clearance / Fit Slop [0.08:Tight Fit (0.08 mm), 0.12:Fine PLA Fit (0.12 mm), 0.16:Standard PLA/PETG Fit (0.16 mm), 0.20:Loose / Easy Fit (0.20 mm), 0.25:Heavy Layer Clearance (0.25 mm)]
printer_slop = 0.16;

// Chamfer Ends (Prevents Elephant Foot)
bevel_ends = true;

/* [Hidden] */
$fn = 64;
$slop = printer_slop;

spec_str = (unit_system == "metric") ? metric_size : imperial_size;

base_info = screw_info(spec_str);
nom_diam = struct_val(base_info, "diameter");
pitch_val = struct_val(base_info, "pitch");

std_n_info = nut_info(spec_str, shape = "hex", thickness = "normal");
std_nut_af = struct_val(std_n_info, "width");
std_nut_h  = struct_val(std_n_info, "thickness");

hex_head_sel = (unit_system == "metric") ? metric_hex_head_af : imperial_hex_head_af;
nut_af_sel   = (unit_system == "metric") ? metric_nut_af : imperial_nut_af;

eff_head_af = (hex_head_sel != "auto") ? parse_num(str(hex_head_sel)) : std_nut_af;
eff_nut_af  = (nut_af_sel != "auto") ? parse_num(str(nut_af_sel)) : std_nut_af;

auto_allen = (unit_system == "metric") ? (
                (head_type == "socket") ? (
                    (nom_diam <= 1.7) ? 1.5 : (nom_diam <= 2.1) ? 1.5 : (nom_diam <= 2.6) ? 2.0 : (nom_diam <= 3.2) ? 2.5 :
                    (nom_diam <= 4.2) ? 3.0 : (nom_diam <= 5.2) ? 4.0 : (nom_diam <= 6.2) ? 5.0 :
                    (nom_diam <= 8.2) ? 6.0 : (nom_diam <= 10.2) ? 8.0 : (nom_diam <= 12.2) ? 10.0 :
                    (nom_diam <= 14.2) ? 12.0 : (nom_diam <= 16.2) ? 14.0 : 17.0
                ) : (
                    (nom_diam <= 2.1) ? 1.3 : (nom_diam <= 2.6) ? 1.5 : (nom_diam <= 3.2) ? 2.0 :
                    (nom_diam <= 4.2) ? 2.5 : (nom_diam <= 5.2) ? 3.0 : (nom_diam <= 6.2) ? 4.0 :
                    (nom_diam <= 8.2) ? 5.0 : (nom_diam <= 10.2) ? 6.0 : (nom_diam <= 12.2) ? 8.0 : 10.0
                )
             ) : (
                (head_type == "socket") ? (
                    (nom_diam <= 3.0) ? 2.38125 : (nom_diam <= 3.6) ? 2.7781 : (nom_diam <= 4.3) ? 3.5719 :
                    (nom_diam <= 5.0) ? 3.96875 : (nom_diam <= 6.5) ? 4.7625 : (nom_diam <= 8.1) ? 6.35 :
                    (nom_diam <= 9.8) ? 7.9375 : (nom_diam <= 13.0) ? 9.525 : (nom_diam <= 16.2) ? 12.7 : 15.875
                ) : (
                    (nom_diam <= 3.0) ? 1.5875 : (nom_diam <= 3.6) ? 1.9844 : (nom_diam <= 4.3) ? 2.38125 :
                    (nom_diam <= 5.0) ? 3.175 : (nom_diam <= 6.5) ? 3.96875 : (nom_diam <= 8.1) ? 4.7625 :
                    (nom_diam <= 9.8) ? 5.55625 : (nom_diam <= 11.5) ? 6.35 : (nom_diam <= 13.0) ? 7.9375 : 9.525
                )
             );

allen_sel = (unit_system == "metric") ? metric_allen_size : imperial_allen_size;
eff_allen = (allen_sel == "auto") ? auto_allen : parse_num(str(allen_sel));

auto_torx_str = (nom_diam <= 2.1) ? "T6" : (nom_diam <= 2.6) ? "T8" : (nom_diam <= 3.2) ? "T10" :
                (nom_diam <= 3.7) ? "T15" : (nom_diam <= 4.3) ? "T20" : (nom_diam <= 5.2) ? "T25" :
                (nom_diam <= 6.5) ? "T30" : (nom_diam <= 8.1) ? "T40" : (nom_diam <= 9.8) ? "T45" :
                (nom_diam <= 11.5) ? "T50" : (nom_diam <= 13.0) ? "T55" : "T60";
eff_torx_str = (torx_drive_size == "auto") ? auto_torx_str : torx_drive_size;

function torx_od_lookup(t_code) =
    (t_code == "T6")  ? 1.70 :
    (t_code == "T8")  ? 2.31 :
    (t_code == "T10") ? 2.74 :
    (t_code == "T15") ? 3.27 :
    (t_code == "T20") ? 3.86 :
    (t_code == "T25") ? 4.43 :
    (t_code == "T27") ? 4.99 :
    (t_code == "T30") ? 5.52 :
    (t_code == "T40") ? 6.65 :
    (t_code == "T45") ? 7.82 :
    (t_code == "T50") ? 8.83 :
    (t_code == "T55") ? 11.22 : 13.25;

module custom_torx_2d(od) {
    R_out = od / 2;
    R_in  = R_out * 0.715;
    lobe_d = R_out * 0.37;
    flute_d = R_out * 0.31;
    difference() {
        union() {
            circle(r = R_in, $fn = 48);
            for (a = [0 : 60 : 300])
                rotate([0, 0, a])
                    translate([R_out - lobe_d/2, 0])
                        circle(d = lobe_d, $fn = 32);
        }
        for (a = [30 : 60 : 330])
            rotate([0, 0, a])
                translate([R_in + flute_d * 0.33, 0])
                    circle(d = flute_d, $fn = 32);
    }
}

auto_ph = (nom_diam <= 2.1) ? "PH0" : (nom_diam <= 3.3) ? "PH1" : (nom_diam <= 5.2) ? "PH2" : (nom_diam <= 8.2) ? "PH3" : "PH4";
eff_ph = (phillips_drive_size == "auto") ? auto_ph : phillips_drive_size;

auto_slot_w = (nom_diam <= 2.1) ? 0.5 : (nom_diam <= 3.2) ? 0.8 : (nom_diam <= 4.2) ? 1.0 :
              (nom_diam <= 5.2) ? 1.2 : (nom_diam <= 6.5) ? 1.6 : (nom_diam <= 8.2) ? 2.0 :
              (nom_diam <= 10.5) ? 2.5 : 3.0;
eff_slot_w = (slot_width_override == "auto") ? auto_slot_w : parse_num(str(slot_width_override));

head_od = (head_type == "socket") ? nom_diam * 1.55 :
          (head_type == "button" || head_type == "pan") ? nom_diam * 1.75 :
          (head_type == "flat") ? nom_diam * 1.95 : eff_head_af;

std_head_h = (head_type == "socket") ? nom_diam * 0.90 :
             (head_type == "hex") ? max(1.5, nom_diam * 0.65) :
             (head_type == "button") ? nom_diam * 0.58 :
             (head_type == "pan") ? nom_diam * 0.65 :
             (head_od - nom_diam) / 2;

head_h = (head_height_override == "auto") ? std_head_h : max(0.1, parse_num(str(head_height_override)));
recess_depth = min(head_h * 0.75, max(0.2, head_h * 0.64));

// RESOLVE EXACT SHOULDER GRIP vs THREAD LENGTH:
// Why your previous M8 bolt tightened to 19.1mm instead of 21.0mm:
// 1. BOSL2's `screw()` starts with a 1.5-pitch thread lead-in taper at the bottom of the threads.
// 2. BOSL2's `nut()` has a countersunk entry bevel (`ibev`) + thread slop (`4 * $slop`), allowing the nut to ride ~1.9mm up onto an 8.0mm cylinder!
// THE FIX:
// - We embed the bottom of the threaded rod 1.5 pitches DOWN inside the smooth shoulder so full-depth threads begin right at the shoulder line,
// - AND we place a positive mechanical Thread-Stop Shoulder (`nom_diam + printer_slop * 3.0` OD) at the exact top of the unthreaded shoulder (`Z = smooth_shoulder_len`) so the nut's front face Physically Stops at your exact target grip length (e.g. 21.0 mm) and the bolt tip sits 100% flush with the back of the nut!
parsed_t_len = parse_num(str(thread_len));
target_t_len = (str(thread_len) == "nut_match" || is_undef(parsed_t_len)) ? std_nut_h : max(0.05, parsed_t_len);

smooth_shoulder_len = (thread_coverage == "full") ? 0 :
                      (thread_coverage == "partial_grip") ? max(0.5, shoulder_grip_len) :
                      max(0, max(0.05, length) - target_t_len);

t_len = (thread_coverage == "full") ? max(0.05, length) :
        (thread_coverage == "partial_grip") ? target_t_len :
        min(max(0.05, length), target_t_len);

total_shank_len = smooth_shoulder_len + t_len;

safe_bevel = (t_len < 1.5) ? false : bevel_ends;
head_chamfer = min(0.3, head_h * 0.2);

drive_summary = (head_type == "hex") ? str("Hex Wrench: ", round(eff_head_af*100)/100, " mm AF") :
                (drive_type == "hex") ? str("Allen Key: ", round(eff_allen*100)/100, " mm") :
                (drive_type == "torx") ? str("Torx Star: ", eff_torx_str, " (", torx_od_lookup(eff_torx_str), " mm OD)") :
                (drive_type == "phillips") ? str("Phillips Cross: ", eff_ph) :
                (drive_type == "combo") ? str("Combo ", eff_ph, " + ", eff_slot_w, " mm Slot") :
                str("Slotted Blade: ", eff_slot_w, " mm Wide");

thread_summary = (part_type == "bolt" && thread_coverage != "full")
    ? str("  |  Exact Grip Stop: ", round(smooth_shoulder_len*100)/100, " mm + ", round(t_len*100)/100, " mm Flush Thread (Total Shank: ", round(total_shank_len*100)/100, " mm)")
    : str("  |  Length: ", round(total_shank_len*100)/100, " mm");

echo(str("[SPEC] ", spec_str, "  |  Tool: ", drive_summary, "  |  Nut Flats: ", round(eff_nut_af*100)/100, " mm", thread_summary));

module phillips_cross_3d(ph_code, depth, extra_clear = 0) {
    span = ((ph_code == "PH0") ? 2.0 :
            (ph_code == "PH1") ? 3.0 :
            (ph_code == "PH2") ? 4.6 :
            (ph_code == "PH3") ? 6.2 : 7.8) + (extra_clear * 2);
    arm_w = (span * 0.24) + (extra_clear * 1.2);
    union() {
        hull() {
            translate([0, 0, 0])
                linear_extrude(height = 0.05)
                    square([span, arm_w], center = true);
            translate([0, 0, depth])
                linear_extrude(height = 0.05)
                    square([span * 0.28, arm_w * 0.55], center = true);
        }
        hull() {
            translate([0, 0, 0])
                linear_extrude(height = 0.05)
                    square([arm_w, span], center = true);
            translate([0, 0, depth])
                linear_extrude(height = 0.05)
                    square([arm_w * 0.55, span * 0.28], center = true);
        }
        rotate([0, 0, 45])
        hull() {
            translate([0, 0, 0])
                linear_extrude(height = 0.05)
                    square([arm_w * 1.35, arm_w * 1.35], center = true);
            translate([0, 0, depth * 0.85])
                linear_extrude(height = 0.05)
                    square([arm_w * 0.5, arm_w * 0.5], center = true);
        }
    }
}

module cut_drive_recess() {
    if (head_type != "hex") {
        down(0.05)
        if (drive_type == "hex") {
            linear_extrude(height = recess_depth + 0.05)
                hexagon(id = eff_allen + printer_slop * 0.65);
        } else if (drive_type == "torx") {
            t_od = torx_od_lookup(eff_torx_str) + (printer_slop * 0.7);
            linear_extrude(height = recess_depth + 0.05)
                custom_torx_2d(t_od);
        } else if (drive_type == "phillips") {
            phillips_cross_3d(eff_ph, recess_depth + 0.05, printer_slop * 0.45);
        } else if (drive_type == "slot") {
            translate([0, 0, recess_depth / 2])
                cube([head_od + 4, eff_slot_w + printer_slop * 0.4, recess_depth + 0.1], center = true);
        } else if (drive_type == "combo") {
            slot_d = recess_depth * 0.72;
            translate([0, 0, slot_d / 2])
                cube([head_od + 4, eff_slot_w + printer_slop * 0.4, slot_d + 0.1], center = true);
            phillips_cross_3d(eff_ph, recess_depth + 0.15, printer_slop * 0.45);
        }
    }
}

if (part_type == "bolt") {
    difference() {
        union() {
            // 1. Bolt Head resting flush on Z=0
            if (head_type == "socket") {
                cylinder(d = head_od, h = head_h, chamfer1 = head_chamfer, chamfer2 = head_chamfer, anchor = BOTTOM);
            } else if (head_type == "hex") {
                linear_extrude(height = head_h)
                    hexagon(id = eff_head_af);
            } else if (head_type == "button") {
                cylinder(d1 = head_od * 0.78, d2 = head_od, h = head_h * 0.45, anchor = BOTTOM);
                up(head_h * 0.45)
                    cylinder(d = head_od, h = head_h * 0.55, chamfer2 = head_chamfer * 0.6, anchor = BOTTOM);
            } else if (head_type == "pan") {
                cylinder(d = head_od, h = head_h, rounding1 = head_h * 0.40, anchor = BOTTOM);
            } else if (head_type == "flat") {
                cylinder(d1 = head_od, d2 = nom_diam, h = head_h, chamfer1 = head_chamfer * 0.6, anchor = BOTTOM);
            }

            // 2. Shank & Threads
            up(head_h) {
                if (thread_coverage != "full" && smooth_shoulder_len > 0) {
                    // Embed bottom of thread 1.5 pitches down inside the shoulder so there is ZERO unthreaded/tapered gap above the shoulder!
                    embed_overlap = min(smooth_shoulder_len * 0.8, pitch_val * 1.5);
                    stop_od = nom_diam + (printer_slop * 2.8);
                    stop_taper_h = min(smooth_shoulder_len * 0.4, 1.2);

                    // Main unthreaded smooth shoulder (exact nominal diameter so it slides through M8 clearance holes & washers!)
                    cylinder(d = nom_diam, h = smooth_shoulder_len, anchor = BOTTOM);

                    // Positive Nut-Stop Collar right at the top of the shoulder (Z = smooth_shoulder_len):
                    // Fills the nut's entry countersink bevel so the nut dead-stops at EXACTLY `smooth_shoulder_len` (e.g. 21.0 mm)!
                    up(smooth_shoulder_len - stop_taper_h)
                        cylinder(d1 = nom_diam, d2 = stop_od, h = stop_taper_h, anchor = BOTTOM);

                    // Threaded tip extending exactly `t_len` (6.5mm for M8) above the stop collar so the bolt back is 100% flush with the nut!
                    up(smooth_shoulder_len - embed_overlap)
                        screw(
                            spec = spec_str,
                            head = "none",
                            length = t_len + embed_overlap,
                            bevel1 = false,
                            bevel2 = safe_bevel,
                            anchor = BOTTOM,
                            orient = UP
                        );
                } else {
                    screw(
                        spec = spec_str,
                        head = "none",
                        length = total_shank_len,
                        bevel = safe_bevel,
                        anchor = BOTTOM,
                        orient = UP
                    );
                }
            }
        }
        cut_drive_recess();
    }
} else if (part_type == "rod") {
    screw(
        spec = spec_str,
        head = "none",
        length = max(0.05, length),
        thread = true,
        bevel = safe_bevel,
        anchor = BOTTOM
    );
} else if (part_type == "nut") {
    nut(
        spec = spec_str,
        shape = "hex",
        width = (nut_af_sel == "auto") ? undef : eff_nut_af,
        thickness = (nut_style == "custom") ? custom_nut_height : nut_style,
        bevel = (nut_style == "custom" && custom_nut_height < 1.5) ? false : bevel_ends,
        ibevel = (nut_inner_bevel == "minimal") ? false : true,
        anchor = BOTTOM
    );
} else if (part_type == "washer") {
    id_val = nom_diam + (printer_slop * 2);
    od_val = nom_diam * washer_od_mult;
    linear_extrude(height = max(0.05, washer_thickness))
        difference() {
            circle(d = od_val);
            circle(d = id_val);
        }
}

// =====================================================================
//  19_GUSSET_L_BRACKET.SCAD — Parametric Rounded L-Bracket with Gusset
// =====================================================================

/* [1. Bracket Dimensions] */
// Bracket Width Along Y-Axis (mm) [15:15 mm, 20:20 mm (Standard), 25:25 mm (1"), 30:30 mm, 40:40 mm (Heavy)]
width = 20;

// Plate Wall Thickness (mm) [2.5:2.5 mm, 3.0:3.0 mm (Standard), 4.0:4.0 mm, 5.0:5.0 mm (Heavy Duty)]
thickness = 3;

// Vertical Wall Arm Height — Z Axis (mm) [25:25 mm (1"), 30:30 mm, 40:40 mm (Standard), 50:50 mm (2"), 60:60 mm, 80:80 mm]
wall_height = 40;

// Horizontal Protrusion Arm Length — X Axis (mm) [25:25 mm (1"), 30:30 mm, 40:40 mm (Standard), 50:50 mm (2"), 60:60 mm, 80:80 mm]
protrusion_length = 40;

/* [2. Gusset & Rounding Options] */
// Gusset Height Upward from Inside Corner (mm) [15:15 mm, 20:20 mm, 25:25 mm (Standard), 30:30 mm, 40:40 mm]
gusset_height = 25;

// Gusset Length Outward from Inside Corner (mm) [15:15 mm, 20:20 mm, 25:25 mm (Standard), 30:30 mm, 40:40 mm]
gusset_length = 25;

// Enable Minkowski Rounded Edges
round_corners = true;

// Edge Rounding Radius (mm) [0.6:0.6 mm, 1.0:1.0 mm (Standard), 1.5:1.5 mm, 2.0:2.0 mm] @show_if(round_corners=true)
corner_radius = 1;

/* [3. Countersunk Screw Holes] */
// Include Mounting Screw Holes
include_holes = true;

// Screw Hole Diameter (mm) [3.2:3.2 mm (M3), 4.2:4.2 mm (M4 / #8 Screw — Standard), 5.2:5.2 mm (M5 / #10 Screw), 6.4:6.4 mm (M6 / 1/4")] @show_if(include_holes=true)
screw_diameter = 4.2;

// Countersink Screw Holes for Flush Heads @show_if(include_holes=true)
countersink = true;

// Screw Head Countersink Diameter (mm) [6.5:6.5 mm (M3), 8.5:8.5 mm (M4 / #8 — Standard), 10.5:10.5 mm (M5 / #10), 12.5:12.5 mm (M6)] @show_if(include_holes=true)
countersink_diameter = 8.5;

// Hole Center Offset from Bracket Ends (mm) [6:6 mm, 8:8 mm (Standard), 10:10 mm, 12:12 mm] @show_if(include_holes=true)
hole_offset = 8;

/* [Hidden] */
echo(str("[SPEC] Gusset L-Bracket: ", wall_height, "×", protrusion_length, "×", width, " mm | Gusset: ", gusset_height, "×", gusset_length, " mm | Hole Ø", screw_diameter, " mm"));

l_bracket();

module l_bracket() {
    if (include_holes) {
        difference() {
            rounded_bracket();
            cut_holes();
        }
    } else {
        rounded_bracket();
    }
}

module rounded_bracket() {
    if (round_corners) {
        minkowski() {
            bracket_base();
            sphere(r=corner_radius, $fn=20);
        }
    } else {
        bracket_base();
    }
}

module bracket_base() {
    union() {
        cube([thickness, width, wall_height]);
        cube([protrusion_length, width, thickness]);
        translate([thickness, width, thickness])
        rotate([90, 0, 0])
        linear_extrude(height=width)
        polygon(points=[
            [0, 0],
            [gusset_length, 0],
            [0, gusset_height]
        ]);
    }
}

module cut_holes() {
    actual_thickness = round_corners ? thickness + corner_radius : thickness;
    cs_depth = (countersink_diameter - screw_diameter) / 2;
    $fn = 30;

    translate([protrusion_length - hole_offset, width / 2, -corner_radius - 1])
    cylinder(h=thickness + (corner_radius*2) + 2, d=screw_diameter);

    if (countersink) {
        translate([protrusion_length - hole_offset, width / 2, actual_thickness - cs_depth + 0.01])
        cylinder(h=cs_depth, d1=screw_diameter, d2=countersink_diameter);
    }

    translate([-corner_radius - 1, width / 2, wall_height - hole_offset])
    rotate([0, 90, 0])
    cylinder(h=thickness + (corner_radius*2) + 2, d=screw_diameter);

    if (countersink) {
        translate([actual_thickness - cs_depth + 0.01, width / 2, wall_height - hole_offset])
        rotate([0, 90, 0])
        cylinder(h=cs_depth, d1=screw_diameter, d2=countersink_diameter);
    }
}

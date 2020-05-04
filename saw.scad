use <materials.scad>

function perimeter(r) = 2 * PI * r;

module blade_tooth(width, height) {
  polygon([[0, 0], [width * 0.5, height * 0.875], [width, height], [width * 0.75, 0]]);
}

module blade(diameter, saw_arbor_diameter, teeth, kerf) {
  tooth_height = perimeter(diameter / 2) / teeth;
  color("red") linear_extrude(kerf) {
    toothless_radius = diameter / 2 - tooth_height;
    difference() {
      circle(r=toothless_radius + tooth_height / 3);
      circle(r=saw_arbor_diameter / 2);
    }

    for (i = [0:360 / teeth:359.99]) {
      rotate(i) translate([0, toothless_radius]) blade_tooth(tooth_height, tooth_height);
    }
  }
}

module blade_guard(thickness, diameter, blade_diameter, blade_teeth) {
  radius = diameter / 2;
  tooth_height = perimeter(blade_diameter / 2) / blade_teeth;
  color("gray") rotate_extrude(angle=180) translate([blade_diameter / 2, 0]) {
    intersection() {
      difference() {
        circle(r=radius);
        circle(r=radius - thickness);
      }

      translate([radius, 0]) square(diameter, center=true);
    }

    translate([-radius, radius - thickness]) square([radius, thickness]);
    translate([-radius, -radius]) square([radius, thickness]);
  }
}

module base(length, left_width, right_width, thickness, blade_diameter, blade_teeth) {
  tooth_height = perimeter(blade_diameter / 2) / blade_teeth;
  width = right_width + left_width;
  color("gray") linear_extrude(thickness) difference() {
    translate([(right_width - left_width) / 2, 0]) square([width, length], center=true);
    square([tooth_height, blade_diameter + 2 * tooth_height], center=true);
  }
}

module motor(diameter, length, motor_color) {
  color(motor_color) rotate([-90, 0, 0]) translate([0, 0, diameter / 8]) minkowski() {
    cylinder(r=diameter / 2 - diameter / 8, h=length - diameter / 4);
    sphere(r=diameter / 8);
  }
}

module arbor_nut(diameter, height) {
  color("black") nut(diameter * 3, diameter, height);
}

module saw(
    saw_arbor_diameter, saw_arbor_thickness, saw_cut_depth, blade_diameter,
    blade_teeth, blade_kerf, blade_guard_thickness, blade_guard_diameter,
    base_thickness, base_right_width, base_left_width, base_length,
    motor_diameter, motor_length, motor_color) {
  translate([base_length / 2, 0, blade_diameter / 2]) {
    rotate([90, 0, 0]) blade(blade_diameter, saw_arbor_diameter, blade_teeth, blade_kerf);
    rotate([90, 0, 0]) blade_guard(blade_guard_thickness, blade_guard_diameter, blade_diameter, blade_teeth);
    translate([0, 0, -blade_diameter / 2 + saw_cut_depth]) rotate([0, 0, 90]) base(base_length, base_left_width, base_right_width, base_thickness, blade_diameter, blade_teeth);
    translate([blade_kerf / 2, 0, (motor_diameter - blade_diameter) / 2 + saw_cut_depth + base_thickness]) motor(motor_diameter, motor_length, motor_color);
    translate([0, -saw_arbor_thickness / 2, 0]) rotate([90, 0, 0]) arbor_nut(saw_arbor_diameter, saw_arbor_thickness);
  }
}

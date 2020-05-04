module board(length, width, thickness) {
  color("#c19a6b") translate([0, 0, thickness / 2]) cube([length, width, thickness], center=true);
}

module pipe(diameter, length, thickness) {
  color("silver") difference() {
    cylinder(r=diameter / 2, h=length, center=true);
    translate([0, 0, -1]) cylinder(r=diameter / 2 - thickness, h=length + 2, center=true);
  }
}

module socket_screw(diameter, length, head_diameter, head_height) {
  color("silver") {
    mirror([0, 0, 1]) cylinder(r=diameter / 2, h=length);
    cylinder(r=head_diameter / 2, h=head_height);
  }
}

module flat_screw(diameter, length, head_diameter, head_height) {
  color("silver") {
    mirror([0, 0, 1]) cylinder(r=diameter / 2, h=length);
    cylinder(r1=diameter / 2, r2=head_diameter / 2, h=head_height);
  }
}

module nut(diameter, screw_diameter, height) {
  color("silver") difference() {
    cylinder(r=diameter / 2, h=height, center=true, $fn=6);
    cylinder(r=screw_diameter / 2, h=height + 2, center=true);
  }
}

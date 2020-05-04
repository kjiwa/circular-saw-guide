use <materials.scad>

module bushing(length, width, height, thickness, pipe_diameter, screw_diameter, screw_head_diameter, screw_head_height) {
  color("orange") difference() {
    pipe_offset = pipe_diameter / 2 + thickness - height;
    translate([0, length / 2, -pipe_offset]) rotate([90, 0, 0]) linear_extrude(height=length) difference() {
      translate([0, pipe_offset + height / 2]) {
        intersection() {
          circle(r=max(height, width) / 2);
          square([width, height], center=true);
        }

        translate([0, -height / 4]) square([width, height / 2], center=true);
      }

      circle(r=pipe_diameter / 2);
    }

    mirror([0, 0, 1]) {
      screw_length = height * 2;
      translate([width / 4, length / 4, 0]) flat_screw(screw_diameter, screw_length, screw_head_diameter, screw_head_height);
      translate([-width / 4, length / 4, 0]) flat_screw(screw_diameter, screw_length, screw_head_diameter, screw_head_height);
      translate([-width / 4, -length / 4, 0]) flat_screw(screw_diameter, screw_length, screw_head_diameter, screw_head_height);
      translate([width / 4, -length / 4, 0]) flat_screw(screw_diameter, screw_length, screw_head_diameter, screw_head_height);
    }
  }
}

// include <configuration/configuration_makita_5402na.scad>
include <configuration/configuration_ryobi_p508.scad>
// include <configuration/configuration_worx_wx429l.scad>

$fn = 32;
scale(25.4) {
  difference() {
    bushing(BUSHING_LENGTH, BUSHING_WIDTH, BUSHING_HEIGHT, BUSHING_THICKNESS, PIPE_DIAMETER, SCREW_DIAMETER, SCREW_HEAD_DIAMETER, SCREW_HEAD_HEIGHT);
  }
}

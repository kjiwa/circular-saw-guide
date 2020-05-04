use <bushing.scad>
use <materials.scad>
use <saw.scad>
use <tape.scad>

module platform(board_width, board_length, board_thickness) {
  support_width = board_width / 3;
  translate([0, 0, board_thickness]) board(board_length, board_width, board_thickness);
  translate([(-board_length + support_width) / 2, 0, 0]) board(support_width, board_width, board_thickness);
  board(support_width, board_width, board_thickness);
  translate([(board_length - support_width) / 2, 0, 0]) board(support_width, board_width, board_thickness);
}

module shoulder(width, height, board_width, pipe_diameter, pipe_left_offset, pipe_right_offset, bushing_length, bushing_width, bushing_height, bushing_thickness, screw_diameter, screw_head_diameter, screw_head_height) {
  // TODO(kjiwa): Add extrusions or a T-slot to support bushing adjustments.
  rotate([0, 0, 90]) {
    board(board_width, width, height);
    translate([-pipe_left_offset, 0, height]) bushing(bushing_length, bushing_width, bushing_height, bushing_thickness, pipe_diameter, screw_diameter, screw_head_diameter, screw_head_height);
    translate([pipe_right_offset, 0, height]) bushing(bushing_length, bushing_width, bushing_height, bushing_thickness, pipe_diameter, screw_diameter, screw_head_diameter, screw_head_height);
  }
}

module carriage(left_width, right_width, length, thickness, pipe_diameter, bushing_length, bushing_width, bushing_height, bushing_thickness, screw_diameter, screw_head_diameter, screw_head_height) {
  width = left_width + right_width;
  translate([0, (right_width - left_width) / 2, 0]) {
    color("saddlebrown") translate([0, 0, -thickness]) board(length, width, thickness);
    translate([(length - bushing_length) / 2, (width - bushing_width) / 2, 0]) rotate([0, 0, 90]) bushing(bushing_length, bushing_width, bushing_height, bushing_thickness, pipe_diameter, screw_diameter, screw_head_diameter, screw_head_height);
    translate([-(length - bushing_length) / 2, -(width - bushing_width) / 2, 0]) rotate([0, 0, 90]) bushing(bushing_length, bushing_width, bushing_height, bushing_thickness, pipe_diameter, screw_diameter, screw_head_diameter, screw_head_height);
    translate([(length - bushing_length) / 2, -(width - bushing_width) / 2, 0]) rotate([0, 0, 90]) bushing(bushing_length, bushing_width, bushing_height, bushing_thickness, pipe_diameter, screw_diameter, screw_head_diameter, screw_head_height);
    translate([-(length - bushing_length) / 2, (width - bushing_width) / 2, 0]) rotate([0, 0, 90]) bushing(bushing_length, bushing_width, bushing_height, bushing_thickness, pipe_diameter, screw_diameter, screw_head_diameter, screw_head_height);
  }
}

module guide(board_length, board_width, board_thickness, carriage_length, carriage_thickness, saw_cut_depth, blade_kerf, base_length, base_left_width, base_right_width, pipe_diameter, pipe_thickness, pipe_left_offset, pipe_right_offset, bushing_length, bushing_width, bushing_height, bushing_thickness, screw_diameter, screw_head_diameter, screw_head_height) {
  platform_height = 2 * board_thickness;
  shoulder_height = saw_cut_depth;
  shoulder_width = board_width / 6;
  pipe_radius = pipe_diameter / 2;
  pipe_height = bushing_height - pipe_diameter;
  pipe_offset = platform_height + shoulder_height + pipe_height;

  // platform
  platform(board_width, board_length, board_thickness);

  // shoulders
  translate([0, 0, platform_height]) {
    translate([(-board_length + shoulder_width) / 2, 0, 0]) shoulder(shoulder_width, shoulder_height, board_width, pipe_diameter, pipe_left_offset, pipe_right_offset, bushing_length, bushing_width, bushing_height, bushing_thickness, screw_diameter, screw_head_diameter, screw_head_height);
    translate([(board_length - shoulder_width) / 2, 0, 0]) shoulder(shoulder_width, shoulder_height, board_width, pipe_diameter, pipe_left_offset, pipe_right_offset, bushing_length, bushing_width, bushing_height, bushing_thickness, screw_diameter, screw_head_diameter, screw_head_height);
  }

  // rails
  rail_offset = platform_height + shoulder_height + bushing_height - bushing_thickness - pipe_radius;
  translate([0, -pipe_left_offset, rail_offset]) rotate([0, 90, 0]) pipe(pipe_diameter, board_length, pipe_thickness);
  translate([0, pipe_right_offset, rail_offset]) rotate([0, 90, 0]) pipe(pipe_diameter, board_length, pipe_thickness);

  // carriage
  carriage_left_width = pipe_left_offset + bushing_width / 2;
  carriage_right_width = pipe_right_offset + bushing_width / 2;
  carriage_thickness = carriage_thickness;
  translate([base_length / 2, 0, platform_height + saw_cut_depth]) carriage(carriage_left_width, carriage_right_width, carriage_length, carriage_thickness, pipe_diameter, bushing_length, bushing_width, bushing_height, bushing_thickness, screw_diameter, screw_head_diameter, screw_head_height);

  // measurement guides
  translate([-board_length / 4, -board_width / 2, platform_height]) rotate([0, 0, 90]) tape(0.5, board_width, 0.0039);
  translate([board_length / 4, -board_width / 2, platform_height]) rotate([0, 0, 90]) tape(0.5, board_width, 0.0039);
}

// include <configuration/configuration_makita_5402na.scad>
include <configuration/configuration_ryobi_p508.scad>
// include <configuration/configuration_worx_wx429l.scad>

$fn = 32;
guide(BOARD_LENGTH, BOARD_WIDTH, BOARD_THICKNESS, CARRIAGE_LENGTH, CARRIAGE_THICKNESS, SAW_CUT_DEPTH, BLADE_KERF, BASE_LENGTH, BASE_LEFT_WIDTH, BASE_RIGHT_WIDTH, PIPE_DIAMETER, PIPE_THICKNESS, PIPE_LEFT_OFFSET, PIPE_RIGHT_OFFSET, BUSHING_LENGTH, BUSHING_WIDTH, BUSHING_HEIGHT, BUSHING_THICKNESS, SCREW_DIAMETER, SCREW_HEAD_DIAMETER, SCREW_HEAD_HEIGHT);
translate([0, 0, 2 * BOARD_THICKNESS]) saw(SAW_ARBOR_DIAMETER, SAW_ARBOR_THICKNESS, SAW_CUT_DEPTH, BLADE_DIAMETER, BLADE_TEETH, BLADE_KERF, BLADE_GUARD_THICKNESS, BLADE_GUARD_DIAMETER, BASE_THICKNESS, BASE_RIGHT_WIDTH, BASE_LEFT_WIDTH, BASE_LENGTH, MOTOR_DIAMETER, MOTOR_LENGTH, MOTOR_COLOR);

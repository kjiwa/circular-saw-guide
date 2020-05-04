module tape_segment(width, thickness) {
  translate([0.5, 0, 0.0039 / 2]) {
    inner_width = min(width - 0.0625, width * 0.875);
    color("black") difference() {
      cube([1, width, thickness], center=true);
      cube([0.96875, inner_width, thickness + 2], center=true);
    }
    
    color("white") cube([0.96875, inner_width, thickness], center=true);
  }
}

module tape(width, length, thickness) {
  actual_length = floor(length);
  for (i = [0:actual_length - 1]) {
    translate([i, 0, 0]) tape_segment(width, thickness);
  }
}

// Game Boy Color (CGB-001) Battery Cover
// Dimensions based on standard GBC battery cover specs
$fn = 64;

// Main cover body dimensions
cover_length = 55.0;   // top to bottom
cover_width  = 35.0;   // left to right
cover_thick  = 1.6;    // wall thickness

// Corner radius
corner_r = 2.0;

// Slide tab at top (slides into console groove)
tab_width = 18.0;
tab_length = 4.0;
tab_thick = 1.2;
tab_offset_z = -0.2; // sits slightly recessed

// Latch catch at bottom (snaps into place)
latch_width = 8.0;
latch_height = 2.0;
latch_depth = 1.0;
latch_thick = 0.8;

// Inner lip/rim around perimeter (sits inside the battery well)
lip_height = 1.2;
lip_inset = 1.0;

// Slight texture ridge (grip lines on original cover)
ridge_count = 6;
ridge_spacing = 5.0;
ridge_width = 1.0;
ridge_height = 0.3;

module rounded_rect(w, l, h, r) {
    hull() {
        for (x = [r, w - r])
            for (y = [r, l - r])
                translate([x, y, 0])
                    cylinder(r = r, h = h);
    }
}

module cover_body() {
    // Main flat cover plate
    rounded_rect(cover_width, cover_length, cover_thick, corner_r);
}

module inner_lip() {
    // Perimeter lip that sits inside the battery compartment
    difference() {
        translate([lip_inset, lip_inset, -lip_height])
            rounded_rect(
                cover_width - 2 * lip_inset,
                cover_length - 2 * lip_inset,
                lip_height,
                corner_r - lip_inset
            );
        translate([lip_inset + lip_inset, lip_inset + lip_inset, -lip_height - 0.1])
            rounded_rect(
                cover_width - 4 * lip_inset,
                cover_length - 4 * lip_inset,
                lip_height + 0.2,
                max(0.5, corner_r - 2 * lip_inset)
            );
    }
}

module slide_tab() {
    // Tab at top edge that slides into the console slot
    translate([(cover_width - tab_width) / 2, cover_length, tab_offset_z])
        cube([tab_width, tab_length, tab_thick]);
}

module snap_latch() {
    // Spring latch at bottom that clicks into place
    translate([(cover_width - latch_width) / 2, -latch_depth, 0]) {
        // Latch arm
        cube([latch_width, latch_depth, latch_thick]);
        // Catch bump
        translate([0, -0.3, 0])
            cube([latch_width, 0.5, latch_height]);
    }
}

module grip_ridges() {
    // Horizontal grip lines on the outer surface (like original)
    start_y = (cover_length - (ridge_count - 1) * ridge_spacing) / 2;
    for (i = [0 : ridge_count - 1]) {
        translate([4, start_y + i * ridge_spacing, cover_thick])
            cube([cover_width - 8, ridge_width, ridge_height]);
    }
}

// Assemble
union() {
    cover_body();
    inner_lip();
    slide_tab();
    snap_latch();
    grip_ridges();
}

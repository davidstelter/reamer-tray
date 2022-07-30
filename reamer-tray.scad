$fn=100;
module reamer_tray() {
	// overall coarse dimensions of tray body
	width = (12 - 3) * (10 + ((12 + 3)/2));
	depth = 160;
	height = 12;		
	hw = width / 2;
	hh = height / 2;

	gap = 8; // space between reamers
	minRLen = 60; // 3mm reamer
	maxRLen = 145; // 12mm reamer
	
	// reamer shanks vary +/- 1mm from nominal
	cylCutoutClearance = 0.5;

	// boolean operation "wiggle"
	w = 1;

	intersection() {
		difference() {
			// core shape
			cube([width, depth, height], center=true);

			union() {
				// tray cutout/lift clearance
				linear_extrude(height + w) {
					polygon(points=[[-80,-60],[80,-40],[80,30],[-80,-30]]);
				}

				// half-cylinder cutouts for reamers
				translate([-hw,0,hh])
				for (i = [3: 12]) {
					x = i - 2;
					spacing = x * (((i+3)/2) + (gap * x/i));
					cylL = minRLen + ((maxRLen - minRLen) / 9) * (x-1);
					cylD = (i + cylCutoutClearance);

					translate([spacing, -(maxRLen-cylL)/2, 0])
					rotate([90, 0, 0])
						cylinder(d=(i + cylCutoutClearance), h=cylL, center=true);
				}
			}
		}

		// trim outer profile to reduce used material
		translate([0,0,-hh])
		linear_extrude(height + 2) {
			bhw = hw + w;
			polygon(points=[
				[-bhw,-100],[bhw,-100],[bhw,100],[-bhw,0]
			]);
		}
	}

	//rotate([90,0,0]) {
	//	translate([-(width/2 + 10), 0, 0])
	//		cylinder(d=3, h=minRLen, center=true);
	//	translate([width/2 + 10, 0, 0])
	//		cylinder(d=12, h=maxRLen, center=true);
	//}
}

reamer_tray();

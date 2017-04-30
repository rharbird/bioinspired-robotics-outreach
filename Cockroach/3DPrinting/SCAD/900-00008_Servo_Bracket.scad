// Create the bracket in two parts
//
THICKNESS=7.5;    // Thickness of the walls of the bracket
HOLEDIAMETER=4.5; // Diameter of the holes
SERVOHEIGHT=20;   // How tall the servo motor is when placed side-on to drive legs
SERVOWIDTH=40.5;  // Width of the servo
SERVOSLACK=1;     // How much more room we want to give around the servo in each dimension to allow for each fitting
SIDEWIDTH=10;     // How wide the surround should be
SIDEHOLESEPX=50.5;// x distance between the holes on the side
SIDEHOLESEPZ=10;  // z distance between the holes on the side
BASEHOLESEP=30;   // Distance between the holes on the base of the bracket
BASEDEPTH=20;     // Depth of the projecting part of the base
NOTCHLENGTH=4.5;    // Dimensions of the notch on the rear
NOTCHWIDTH=2.5;
NOTCHDEPTH=1.25;

//Draw a prism based on a 
//right angled triangle
//l - length of prism
//w - width of triangle
//h - height of triangle
module prism(l, w, h) {
       polyhedron(points=[
               [0,0,h],           // 0    front top corner
               [0,0,0],[w,0,0],   // 1, 2 front left & right bottom corners
               [0,l,h],           // 3    back top corner
               [0,l,0],[w,l,0]    // 4, 5 back left & right bottom corners
       ], faces=[ // points for all faces must be ordered clockwise when looking in
               [0,2,1],    // top face
               [3,4,5],    // base face
               [0,1,4,3],  // h face
               [1,2,5,4],  // w face
               [0,3,5,2],  // hypotenuse face
       ]);
}

module bracketSide () {

  difference() {
    // The side
    cube([SIDEWIDTH*2+SERVOWIDTH, THICKNESS, SERVOHEIGHT+SIDEWIDTH*2]);

    union(){      
      // Take out the centre of the side
      // NB might also need to take out the top edge to allow the servo to slot in.
      // In that case, make the z in the cube above SERVOHEIGHT+SIDEWIDTH
      translate([SIDEWIDTH-SERVOSLACK/2, 0, SIDEWIDTH-SERVOSLACK/2])
        cube([SERVOWIDTH+SERVOSLACK, THICKNESS, SERVOHEIGHT+SERVOSLACK]);
      
      // And the holes in the LHS.
      translate([SIDEWIDTH/2,THICKNESS,SIDEWIDTH+(SERVOHEIGHT-SIDEHOLESEPZ)/2])
        rotate([90,0,0])
          cylinder(h=THICKNESS, d=HOLEDIAMETER);
      translate([SIDEWIDTH/2,THICKNESS,SIDEHOLESEPZ+SIDEWIDTH+(SERVOHEIGHT-SIDEHOLESEPZ)/2])
        rotate([90,0,0])
          cylinder(h=THICKNESS, d=HOLEDIAMETER);
      
      // And the holes in the RHS
      translate([1.5*SIDEWIDTH+SERVOWIDTH,THICKNESS,SIDEWIDTH+(SERVOHEIGHT-SIDEHOLESEPZ)/2])
        rotate([90,0,0])
          cylinder(h=THICKNESS, d=HOLEDIAMETER);
      translate([1.5*SIDEWIDTH+SERVOWIDTH,THICKNESS,SIDEHOLESEPZ+SIDEWIDTH+(SERVOHEIGHT-SIDEHOLESEPZ)/2])
        rotate([90,0,0])
          cylinder(h=THICKNESS, d=HOLEDIAMETER);
          
      // And the chamfer on the LHS
      translate([SIDEWIDTH-SERVOSLACK/2, 0, SIDEWIDTH-SERVOSLACK/2])
        rotate([90,0,180])
          prism(SERVOHEIGHT+SERVOSLACK, 1, 1);

      // And the chamfer on the RHS
      translate([SIDEWIDTH+SERVOWIDTH+SERVOSLACK/2, 0, SIDEWIDTH-SERVOSLACK/2])
        rotate([90,0,90])
          prism(SERVOHEIGHT+SERVOSLACK, 1, 1);
          
      // And the LHS rear notch
      translate([SIDEWIDTH-NOTCHLENGTH,THICKNESS-NOTCHDEPTH,SIDEWIDTH+SERVOHEIGHT/2-NOTCHWIDTH/2])
        cube([NOTCHLENGTH, NOTCHDEPTH, NOTCHWIDTH]);
      
      // And the RHS rear notch
      // And the LHS rear notch
      translate([SIDEWIDTH+SERVOWIDTH+SERVOSLACK/2,THICKNESS-NOTCHDEPTH,SIDEWIDTH+SERVOHEIGHT/2-NOTCHWIDTH/2])
        cube([NOTCHLENGTH, NOTCHDEPTH, NOTCHWIDTH]);
      
    }
  }
}

module bracketBase() {
  difference() {
    // The base
    cube([SERVOWIDTH+2*SIDEWIDTH, THICKNESS+BASEDEPTH, THICKNESS]);
    
    union() {
      // Holes
      translate([(SERVOWIDTH+2*SIDEWIDTH-BASEHOLESEP)/2, THICKNESS+BASEDEPTH/2, 0]) {
        cylinder(h=THICKNESS, d=HOLEDIAMETER);
      }
      translate([(SERVOWIDTH+2*SIDEWIDTH+BASEHOLESEP)/2, THICKNESS+BASEDEPTH/2, 0]) {
        cylinder(h=THICKNESS, d=HOLEDIAMETER);
      }
      // And countersinks
      translate([(SERVOWIDTH+2*SIDEWIDTH-BASEHOLESEP)/2, THICKNESS+BASEDEPTH/2, THICKNESS-HOLEDIAMETER/4]) {
        cylinder(h=HOLEDIAMETER/4, d1=HOLEDIAMETER, d2=HOLEDIAMETER*2);
      }
      translate([(SERVOWIDTH+2*SIDEWIDTH+BASEHOLESEP)/2, THICKNESS+BASEDEPTH/2, THICKNESS-HOLEDIAMETER/4]) {
        cylinder(h=HOLEDIAMETER/4, d1=HOLEDIAMETER, d2=HOLEDIAMETER*2);
      }
      
    }
  }
}

union() {
  bracketSide();
  bracketBase();
}




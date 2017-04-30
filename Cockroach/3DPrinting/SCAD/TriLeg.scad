// Thickness of the leg - used everywhere
leg_thickness=10;

//-- Parameters common to all horns
horn_drill_diam   = 1.5;
horn_plate_height = 2;              //-- plate height
horn_height       = leg_thickness;  //-- Total height: shaft + plate

//-- Parallax 900-0008 4-arm horn parameters
a4h_end_diam       = 5;
a4h_center_diam    = 9.5;
a4h_arm_length     = 19.4;
a4h_drill_distance = 13.4;


// Flag - leg on the left (0) or right (1). Side is given if you
// were standing at the back of the robot looking towards its front
side = 0;

// Hub
hub_diameter=40;
hub_screw_diameter=7.05;

// Leg arc
outside_diameter = 75;

leg_radius=42.5;
leg_width=10;

arm_length = outside_diameter - hub_diameter/2;
arm_circle_diameter = 25;
arm_cube_length = arm_length - arm_circle_diameter/2 + hub_diameter/2;

// Embedded magnets; spacing is how much gap to add around the magnet
// Dimensions website. However, not clear if these are radii or diameter
magnet_spacing = 0.5;
magnet_diameter = 6 + magnet_spacing;
magnet_thickness = 1.5 + magnet_spacing;
magnet_dist = 30;


hub_radius = 0.5 * hub_diameter;
hub_thickness=leg_thickness;

module arm()
{ // Make an arm of the leg
  //
  difference() {
    union() {
      translate([arm_cube_length/2,0,0])
        cube([arm_cube_length, leg_thickness, leg_thickness], center=true);
      translate([arm_cube_length,0,0])
        cylinder(h=leg_thickness,d=arm_circle_diameter, center=true);
    }

    translate([arm_cube_length,0,0])
      cylinder(h=leg_thickness,d=arm_circle_diameter-leg_thickness*2, center=true);    
  }
}

module raw_leg()
{ 
  // The hub
  cylinder(h=hub_thickness,d=hub_diameter, $fn=120, center=true);

  arm();
  
  rotate([0,0,120])
    arm();
  
  rotate([0,0,240])
    arm();
  
}

module screw_hole()
{
  // The screw hole
  cylinder(h=hub_thickness,d=hub_screw_diameter, $fn=120, center=true);  
}


module magnet() {
  translate([magnet_dist, 0, (leg_thickness - magnet_thickness)/2])
  cylinder(h=magnet_thickness,d=magnet_diameter, $fn=120, center=true);  
}

module magnets()
{
  magnet();

  rotate([0,0,120])
    magnet();
  
  rotate([0,0,240])
    magnet();

}

//--------------------------------------------------------------
//-- Generic module for the horn's drills
//-- Parameters:
//--  d = drill's radial distance (from the horn's center)
//--  n = number of drills
//--  h = wheel height
//--------------------------------------------------------------
module horn_drills(d,n,h)
{
  translate([0,0,horn_height-horn_plate_height])  
    union() {
      for ( i = [0 : n-1] ) {
          rotate([0,0,i*360/n])
          translate([0,d,0])
          cylinder(r=horn_drill_diam/2, h=h+10,center=true, $fn=6);  
        }
    }
}

//-----------------------------------------
//-- Parallax 900-0008 horn4 arm
//-- This module is just one arm
//-----------------------------------------
module horn4_arm(h=5)
{
  translate([0,a4h_arm_length-a4h_end_diam/2,0])
  //-- The arm consist of the perimeter of a cylinder and a cube
  hull() {
    cylinder(r=a4h_end_diam/2, h=h, center=true, $fn=20);
    translate([0,1-a4h_arm_length+a4h_end_diam/2,0])
      cube([a4h_center_diam,2,h],center=true);
  }
}

//-------------------------------------------
//-- Parallax 900-0008 4-arm horn
//-------------------------------------------
module horn4(h=5)
{
  translate([0,0,horn_height-horn_plate_height])
    union() {
      //-- Center part (is a square)
      cube([a4h_center_diam+0.2,a4h_center_diam+0.2,h],center=true);

      //-- Place the 4 arms in every side of the cube
      for ( i = [0 : 3] ) {
        rotate( [0,0,i*90])
        translate([0, a4h_center_diam/2, 0])
        horn4_arm(h);
      }
    }
}

difference() {
  // Make the basic leg
  raw_leg();
  screw_hole();

  //-- substract the 4-arm servo horn
  if (side == 1) {
    mirror([0,0,1]) {
      horn4(h=leg_thickness);
      magnets();
    }
  } else {
    horn4(h=leg_thickness);    
    magnets();
  }
  
  horn_drills(d=a4h_drill_distance, n=4, h=leg_thickness*2);
}





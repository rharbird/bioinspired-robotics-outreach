//-------------------------------------------------------------
//-- Axle and servo 4 horn hub for mobile robots
//-------------------------------------------------------------

//-- Parameters common to all horns
horn_drill_diam   = 1.5;
horn_plate_height = 2;                  //-- plate height

//-- Parallax 900-0008 4-arm horn parameters
a4h_end_diam       = 5;
a4h_center_diam    = 9.5;
a4h_arm_length     = 19.4;
a4h_drill_distance = 13.4;

stop_diam      = 10;
stop_length    = 10;
axle_diam      = 5;
axle_length    = 55+stop_length;

//--------------------------------------------------------------
//-- Generic module for the horn's drills
//-- Parameters:
//--  d = drill's radial distance (from the horn's center)
//--  n = number of drills
//--  h = horn_plate_height
//--------------------------------------------------------------
module horn_drills(d,n,h)
{
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



//-------------------------------------------------------
//--  An axle with a 4 horn servo hub attached
//--------------------------------------------------------
module axle_and_hub()
{
  difference() {
  
    union() {   
      horn4(h=horn_plate_height);

      // Axle
      cylinder(h=horn_plate_height/2+axle_length, d=axle_diam, $fn=100);
    
      // Stop
      cylinder(h=horn_plate_height/2+stop_length, d=stop_diam, $fn=20);
    }

    //-- Horn drills
    horn_drills(d=a4h_drill_distance, n=4, h=horn_plate_height*2);
  }    
}


//-- Test!
axle_and_hub();




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

stop_diam       = 10;
wheel_thickness = 5;
stop_length     = 10;
axle_diam       = 5;
axle_length     = 55+stop_length;

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
        cylinder(r=horn_drill_diam/2, h=h+10, center=true, $fn=6);  
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
      // Axle
      cylinder(h=horn_plate_height/2+axle_length, d=axle_diam, $fn=100);
    
      // Square stop
      translate([-stop_diam/2, -stop_diam/2, 0])
      cube([stop_diam, stop_diam, horn_plate_height+wheel_thickness]);

      // Cylinder stop
      cylinder(h=horn_plate_height+wheel_thickness+stop_length, d=stop_diam, $fn=100);
      
      // End cylinder
      cylinder(h=horn_plate_height, r=a4h_arm_length);      
    }

    //-- Horn drills
    horn_drills(d=a4h_drill_distance, n=4, h=horn_plate_height*2);
  }    
}


//-- Test!
axle_and_hub();




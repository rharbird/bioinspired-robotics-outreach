//-------------------------------------------------------------
//-- Axle cap
//-------------------------------------------------------------

gap              = 0.2;
cap_diam         = 10;
cap_length       = 10;
axle_diam        = 5;
axle_hole_length = 50;



//-------------------------------------------------------
//--  A cap for the axle
//--------------------------------------------------------
module axle_cap()
{
  difference() {
    // Cap
    cylinder(h=cap_length, d=cap_diam, $fn=20);

    // Axle
    cylinder(h=axle_hole_length, d=axle_diam+gap, $fn=100);    
  }
}


//-- Test!
axle_cap();




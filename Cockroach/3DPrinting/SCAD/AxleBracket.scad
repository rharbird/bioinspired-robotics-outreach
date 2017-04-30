// 90 degree bracket

$fn    = 25;
length = 45;
height = 35;
width  = 20;
walls  = 3;

angle = 20;

axle_diam   = 5;
axle_gap    = 0.2;
axle_height = 20;

screwhole_diam = 4.5;
axlehole_diam  = axle_diam + axle_gap;

module half() {
translate([-length/2, 0, 0])
difference()  {
    cube([length/2, height, width], center=false);
    
    translate([walls, walls, walls])
      cube([length-2*walls, height, width-(walls * 2)], center=false);
    
    translate([walls+(height-walls)*cos(90-angle), walls, 0])
      rotate([0,0,angle])
        cube([2*height, 2*height, width+2], center=false);

    translate([walls+(height-walls)*cos(90-angle), walls, 0])
      cube([2*height, 2*height, width+2], center=false);

    // bottom screw hole
    translate([length/2 - 8, walls+1, width/2])
    rotate([90, 0, 0])
    #cylinder(d=screwhole_diam, h=walls+2);

    // side hole
    translate([-1, axle_height, width/2])
    rotate([0, 90, 0])
    #cylinder(d=axlehole_diam, h=walls+2);

  }
}


module whole() {
 union() {
   half();
   mirror([1,0,0])
     half();
 }
}

whole();



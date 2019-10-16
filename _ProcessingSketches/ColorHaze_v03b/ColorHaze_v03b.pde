// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flow Field Following
// Via Reynolds: http://www.red3d.com/cwr/steer/FlowFollow.html

// Using this variable to decide whether to draw all the stuff
boolean debug = false;

// Flowfield object
FlowField flowfield;
// An ArrayList of vehicles
ArrayList<Vehicle> vehicles;

color c1 = #005f5f;
color c2 = #ff5a5a;

void setup() {
  size(1920, 1080);
  background(0);
  //colorMode(HSB, 360, 100, 100, 100);
  // Make a new flow field with "resolution" of 16
  flowfield = new FlowField(20);
  vehicles = new ArrayList<Vehicle>();
  // Make a whole bunch of vehicles with random maxspeed and maxforce values
  for (int i = 0; i < 3000; i++) {
    vehicles.add(new Vehicle(new PVector(random(width), random(height)), random(2, 5), random(0.1, 0.5), i));
  }
}

void draw() {
  flowfield.init();
  //background(255);
    fill(0, 5);
  noStroke();
  rect(0, 0, width, height);
  // Display the flowfield in "debug" mode
  if (debug) flowfield.display();
  // Tell all the vehicles to follow the flow field
  for (Vehicle v : vehicles) {
    v.follow(flowfield);
    v.run();
  }

  // Instructions
  fill(0);
  text("Hit space bar to toggle debugging lines.\nClick the mouse to generate a new flow field.",10,height-20);
}


void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}

// Make a new flowfield
void mousePressed() {
  flowfield.init();
}

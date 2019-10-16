// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

Flock flock;
color c1 = #005f5f;
color c2 = #ff5a5a;

void setup() {
  size(1920,1080);
  background(0);
  colorMode(HSB, 360, 100, 100, 100);
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 500; i++) {
    Boid b = new Boid(width/2,height/2, i);
    flock.addBoid(b);
  }
}

void draw() {
  //background(255);
  fill(0, 1);
  noStroke();
  rect(0, 0, width, height);
  
  flock.run();
  
  // Instructions
  fill(0);
  text("Drag the mouse to generate new boids.",10,height-16);
}

// Add a new boid into the System
void mouseDragged() {
  flock.addBoid(new Boid(mouseX,mouseY, 1000));
}

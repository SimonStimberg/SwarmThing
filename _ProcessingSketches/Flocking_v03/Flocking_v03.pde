// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

Flock flock;
float d = 25;

Wall wall;

void setup() {
  size(1300,1000);
  newWall();
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 200; i++) {
    Boid b = new Boid(width/2+random(-5,5),height/2+random(-5,5));
    flock.addBoid(b);
  }
}

void newWall() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  wall = new Wall();
  float offset = 30;
  wall.addPoint(offset*2,offset);
  wall.addPoint(width-offset*2,offset);
  wall.addPoint(width-offset,offset*2);
  wall.addPoint(width-offset,height-offset*2);
  wall.addPoint(width-offset*2,height-offset);
  wall.addPoint(width/3*2+offset,height-offset);
  wall.addPoint(width/3*2,height-offset*2);
  wall.addPoint(width/3*2,height*0.75);
  wall.addPoint(width/3,height*0.75);
  wall.addPoint(width/3,height-offset*2);
  wall.addPoint(width/3-offset,height-offset);
  wall.addPoint(offset*2,height-offset);
  wall.addPoint(offset,height-offset*2);
  wall.addPoint(offset,offset*2);
}

void draw() {
  background(255);
  wall.display();
  flock.run();
  
  // Instructions
  fill(0);
  text("Drag the mouse to generate new boids.",10,height-16);
}

// Add a new boid into the System
void mouseDragged() {
  flock.addBoid(new Boid(mouseX,mouseY));
}

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
  ellipseMode(CORNER);
  newWall();
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 200; i++) {
    Boid b = new Boid(width/2,height*0.2);
    flock.addBoid(b);
  }
}

void newWall() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  wall = new Wall();
  
  float offset = 30;
  
  wall.addPoint(offset,height);
  wall.addPoint(0,height-offset);
  wall.addPoint(0,offset);
  wall.addPoint(offset,0);
  wall.addPoint(width-offset,0);
  wall.addPoint(width,offset); 
  wall.addPoint(width,height-offset);
  wall.addPoint(width-offset,height);
  
  wall.addPoint(width-width*0.146+offset,height);
  wall.addPoint(width-width*0.146,height-offset);
  wall.addPoint(width-width*0.146,height*0.675+offset*2);
  wall.addPoint(width-width*0.146-offset*2,height*0.675);
  wall.addPoint(width-width*0.27+offset*2,height*0.675);
  wall.addPoint(width-width*0.27,height*0.675+offset*2);
  wall.addPoint(width-width*0.27,height-offset);
  wall.addPoint(width-width*0.27-offset,height);
  
  wall.addPoint(width-width*0.377+offset,height);
  wall.addPoint(width-width*0.377,height-offset);
  wall.addPoint(width-width*0.377,height*0.4+offset*3);
  wall.addPoint(width-width*0.377-offset*3,height*0.4);
  wall.addPoint(width*0.377+offset*3,height*0.4);
  wall.addPoint(width*0.377,height*0.4+offset*3);
  wall.addPoint(width*0.377,height-offset);
  wall.addPoint(width*0.377-offset,height);
  
  wall.addPoint(width*0.27+offset,height);
  wall.addPoint(width*0.27,height-offset);
  wall.addPoint(width*0.27,height*0.675+offset*2);
  wall.addPoint(width*0.27-offset*2,height*0.675);
  wall.addPoint(width*0.146+offset*2,height*0.675);
  wall.addPoint(width*0.146,height*0.675+offset*2);
  wall.addPoint(width*0.146,height-offset);
  wall.addPoint(width*0.146-offset,height);
 
}

void draw() {
  background(255);
  
  
  //wall.display();
  drawGate();
  flock.run();
  
  // Instructions
  fill(0);
  text("Drag the mouse to generate new boids.",10,height-16);
}

// Add a new boid into the System
void mouseDragged() {
  flock.addBoid(new Boid(mouseX,mouseY));
}

void drawGate() {
  fill(0);
  rect(width*0.146, height*0.675+width*0.062, width*0.124, height*0.245);
  ellipse(width*0.146, height*0.675, width*0.124, width*0.124);
  
  rect(width-width*0.27, height*0.675+width*0.062, width*0.124, height*0.245);
  ellipse(width-width*0.27, height*0.675, width*0.124, width*0.124);
  
  rect(width*0.377, height*0.4+width*0.123, width*0.246, height*0.44);
  ellipse(width*0.377, height*0.4, width*0.246, width*0.246);
}

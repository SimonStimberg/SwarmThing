// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

Flock flock;
Wall wall;
Ground ground;

color c1, c2;

float yWave;

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
  
  int gridSize = 20;
  int cols = width / gridSize;
  int rows = height / gridSize;
  ground = new Ground(cols, rows, gridSize);
  
  c1 = color(223, 203, 192);
  c2 = color(191, 71, 45);   
  
  yWave = 0.0;
  
}



void draw() {
  //background(c2);
  //drawGround();
  
  //wall.display();

  flock.update();
  ground.update(flock.boids);
  flock.render();
  
  drawGate();
  drawWave();
  
  // Instructions
  //fill(0);
  //text("Drag the mouse to generate new boids.",10,height-16);
  
  fill(0);
  rect(0,height-20,width,20);
  fill(255);
  text("Framerate: " + int(frameRate),10,height-6);
  text("Boids: " + int(flock.boids.size()),100,height-6);
}



// Add a new boid into the System
void mouseDragged() {
  flock.addBoid(new Boid(mouseX,mouseY));
}

void drawGround() {
  noFill();
   for (int i = 0; i <= height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(0, i, width, i);
  }
  
}



void drawGate() {
  
  noStroke();
  fill(0);
  rect(width*0.146, height*0.675+width*0.062, width*0.124, height*0.245);
  ellipse(width*0.146, height*0.675, width*0.124, width*0.124);
  
  rect(width-width*0.27, height*0.675+width*0.062, width*0.124, height*0.245);
  ellipse(width-width*0.27, height*0.675, width*0.124, width*0.124);
  
  rect(width*0.377, height*0.4+width*0.123, width*0.246, height*0.44);
  ellipse(width*0.377, height*0.4, width*0.246, width*0.246);
}

void drawWave() {
  fill(0);
  float xWave = 0.0;
  
  beginShape(); 
    
  // Iterate over horizontal pixels
  for (float x = 0; x <= width; x += 25) {
    // Calculate a y value according to noise, map to 
    float y = map(noise(xWave, yWave), 0, 1, 200,300); // Option #1: 2D Noise
    // float y = map(noise(xoff), 0, 1, 200,300);    // Option #2: 1D Noise
    
    // Set the vertex
    vertex(x, y); 
    // Increment x dimension for noise
    xWave += 0.05;
  }
  // increment y dimension for noise
  yWave += 0.005;
  vertex(width, 0);
  vertex(0, 0);
  endShape(CLOSE);

}



void newWall() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  wall = new Wall();
  
  float offset = 30;
  
  wall.addPoint(offset,height);
  wall.addPoint(0,height-offset);
  wall.addPoint(0,offset+300);
  wall.addPoint(offset,0+300);
  wall.addPoint(width-offset,0+300);
  wall.addPoint(width,offset+300); 
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
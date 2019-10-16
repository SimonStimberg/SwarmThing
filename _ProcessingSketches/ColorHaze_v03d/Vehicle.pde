// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flow Field Following

class Vehicle {

  // The usual stuff
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  
  float noiseOffset;
  float yOff;

  Vehicle(PVector l, float ms, float mf, int i) {
    position = l.get();
    r = 2.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    
    noiseOffset = 0;
    yOff = i * 0.01;
  }

  public void run() {
    update();
    borders();
    display();
  }


  // Implementing Reynolds' flow field following algorithm
  // http://www.red3d.com/cwr/steer/FlowFollow.html
  void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(position);
    // Scale it up by maxspeed
    desired.mult(maxspeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() {
    // Draw a triangle rotated in the direction of velocity
    
    
    //float hue = map(noise(noiseOffset, yOff), 0, 1, 0, 360);
    //fill(hue, 100, 100);
    //color interColor = lerpColor(c1, c2, noise(noiseOffset, yOff));
    color interColor = color(map(noise(noiseOffset), 0, 1, 0, 255), map(noise(yOff), 0, 1, 0, 255), 69);
    fill(interColor);
    
    
    noStroke();
    
    //float theta = velocity.heading2D() + radians(90);
    //pushMatrix();
    //translate(position.x,position.y);
    //rotate(theta);
    //beginShape(TRIANGLES);
    //vertex(0, -r*2);
    //vertex(-r, r*2);
    //vertex(r, r*2);
    //endShape();
    //popMatrix();
    circle(position.x, position.y, r);
    
    noiseOffset += 0.01;
    yOff += 0.1;
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }
}

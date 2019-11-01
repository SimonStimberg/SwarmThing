// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Path Following

class Wall {

  // A Path is an arraylist of points (PVector objects)
  ArrayList<PVector> points;
  // A path has a radius, i.e how far is it ok for the boid to wander off
  float radius;

  Wall() {
    // Arbitrary radius of 20
    radius = 20;
    points = new ArrayList<PVector>();
  }

  // Add a point to the path
  void addPoint(float x, float y) {
    PVector point = new PVector(x, y);
    points.add(point);
  }
  
  void adjustWall(float depth, int mode) {
    for(int i = 0; i < 8; i++) {      
      PVector p = points.get(i);
      
      // mode defines different behavior considering the big gate
      if(mode == 0) {
        if(i < 1 || i > 6) p.y = depth + 95; else if(i < 3 || i > 4) p.y = depth + 65;  else  p.y = depth + 125; 
      } else if (mode == 1) {
        if(i < 1 || i > 6) p.y = depth + 95; else if(i < 3 || i > 4) p.y = depth + 65; else p.y = 660;
      } else if (mode == 2) {        
        if(i < 1 || i > 6) p.y = depth + 95; else p.y = depth + 65;
      }
    }
  }

  // Draw the path
  void display() {
    strokeJoin(ROUND);
    
    // Draw thick line for radius
    stroke(175);
    strokeWeight(radius*2);
    noFill();
    beginShape();
    for (PVector v : points) {
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    // Draw thin line for center of path
    stroke(0);
    strokeWeight(1);
    noFill();
    beginShape();
    for (PVector v : points) {
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
  }
}

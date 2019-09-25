// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Boid class
// Methods for Separation, Cohesion, Alignment added

class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  Boid(int gate) {
    float y = height * 0.9;
    float x = 0;
    float velY = random(-1,1);
    float velX = 0;


    // which gate to spawn
    if (gate == 1) {
      x = width*0.146;     
    } else 
    if (gate == 2) {
      x = width*0.73;
    }
    
    // distribute randomly on the left and right side of the gateway
    if (int(random(2)) < 1) {
      velX = random(-1,-0.2);        
    } else {
      x += width*0.124;
      velX = random(0.2,1);       
    }
    
    
    acceleration = new PVector(0,0);
    velocity = new PVector(velX,velY);
    position = new PVector(x,y);
    r = random(3.0, 6.0);
    maxspeed = random(2.0, 4.0);
    maxforce = 0.05;
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    //borders();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    PVector bnd = boundaries(wall);
    PVector bnd2 = boundaries(avoider);
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    bnd.mult(4.0);
    bnd2.mult(4.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(bnd);
    applyForce(bnd2);
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

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }
  
  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(0);
    noStroke();
    pushMatrix();
    translate(position.x,position.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*3);
    bezierVertex(r*2, -r*2, r, r, 0, r*3);
    bezierVertex(-r, r, -r*2, -r*2, 0, -r*3);
    endShape();
    popMatrix();
  }

  // Wraparound
  //void borders() {
  //  if (position.x < -r) position.x = width+r;
  //  if (position.y < -r) position.y = height+r;
  //  if (position.x > width+r) position.x = -r;
  //  if (position.y > height+r) position.y = -r;
  //}
  
  PVector boundaries(Wall p) {

    //PVector desired = null;
    
    // Predict position 25 (arbitrary choice) frames ahead
    PVector predict = velocity.get();
    predict.mult(25);
    
    PVector predictpos = PVector.add(position, predict);
    
    fill(255,0,255);
    //ellipse(predictpos.x, predictpos.y, 10, 10);

    // Now we must find the normal to the path from the predicted position
    // We look at the normal for each line segment and pick out the closest one
    PVector target = predictpos.copy();
    boolean wallDetected = false;
    int wallUrge = 0;
    
    // Loop through all points of the path
    for (int i = 0; i < p.points.size(); i++) {

      // Look at a line segment
      PVector a = p.points.get(i);
      PVector b = p.points.get((i+1)%p.points.size()); // Note Path has to wraparound

      // Get the normal point to that line
      PVector normalPoint = getNormalPoint(predictpos, a, b);

      // Check if normal is on line segment
      PVector dir = PVector.sub(b, a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      //if (da + db > line.mag()+1) {
      if (normalPoint.x < min(a.x,b.x) || normalPoint.x > max(a.x,b.x) || normalPoint.y < min(a.y,b.y) || normalPoint.y > max(a.y,b.y)) {
        //normalPoint = b.get();
        //// If we're at the end we really want the next line segment for looking ahead
        //a = p.points.get((i+1)%p.points.size());
        //b = p.points.get((i+2)%p.points.size());  // Path wraps around
        //dir = PVector.sub(b, a);
      } else {

        // How far away are we from the path?
        float d = PVector.dist(predictpos, normalPoint);
        
        
        // if we are close to a wall add force to steer away from it
        if (d <= p.radius) {
          wallUrge += 125;
          wallDetected = true;
          
          
          // calculate the angle between my velocity and the wall
          float theta = PVector.angleBetween(dir, velocity);

          // calculate the reflection vector used as desired target to steer away from the wall
          // for this use trigonomy
          float gk = sin(theta) * predict.mag(); // Gegenkathete
        
          PVector pointer = PVector.sub(predictpos, normalPoint); // get direction between predicted position and the wall
          pointer.normalize();
          pointer.mult(5+gk*2); // move away from the wall by double its distance
          
          target.add(pointer);
          
        }

      }
    }
    
    if (wallDetected) {
      

        //strokeWeight(4);
        //stroke(255, 0, 0);
        //line(wallA.x, wallA.y, wallB.x, wallB.y);
        
        
        

        
        fill(wallUrge,0,0);
        ellipse(target.x, target.y, 10, 10);
        



        
        //fill(0,255,0);
        //ellipse(normal.x, normal.y, 10, 10);
        
        return seek(target);  // Steer towards the position
    } else {
      return new PVector(0,0);
    }    
    

        


    //return target;
      
    //// Only if the distance is greater than the path's radius do we bother to steer
    //if (worldRecord < p.radius) {
    //  return seek(target);
    //}
    //else {
    //  return new PVector(0, 0);
    //}
    
  }    
  
  
  
  // A function to get the normal point from a point (p) to a line segment (a-b)
  // This function could be optimized to make fewer new Vector objects
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p, a);
    // Vector from a to b
    PVector ab = PVector.sub(b, a);
    ab.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
  }
  

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position,other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position,other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0,0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position,other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum,velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0,0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position,other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } else {
      return new PVector(0,0);
    }
  }
}



class Food {
  
  ArrayList<Stuff> stuff;
  //int decayTime;
  float liquidDrag = 0.2;
  
  Food() {
    stuff = new ArrayList<Stuff>(); // Initialize the ArrayList
    //decayTime = 1200; // Time in milliseconds the food needs to be eaten up
  }
  
  void spawn() {
    stuff.add(new Stuff(random(30, 400), random(2, 5)));
  }
  
  void update(float depth) {
    vanish();
    
    for (Stuff s : stuff) {
      if (s.pos.y > depth) {
        s.drag(liquidDrag);
      }
      
      float m = 0.1*s.mass;
      // Note that we are scaling gravity according to mass.
      PVector gravity = new PVector(0, m);
      s.applyForce(gravity);
  
      s.update();
      s.render();
    }
  }

  
  void eat(int index) {
    Stuff s = stuff.get(index);
    if(!s.inDecay) {
      s.decay();
    }
  }
  
  
  void vanish() {
    for (int i = stuff.size() - 1; i >= 0; i--) {
      Stuff s = stuff.get(i);
      if (s.inDecay && millis() > s.expiration) {
        stuff.remove(i);
      }
    }
  }
  
}





class Stuff {
  
  PVector pos;
  PVector velocity;
  PVector acceleration;
  float mass;
  boolean inLiquid;
  
  
  int expiration;
  boolean inDecay;
  float zOff;
  float size;
  int decayTime;
  

  
  
  Stuff(float posX, float m) {
    pos = new PVector(posX, 0);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = m;
    
    expiration = 0;
    inDecay = false;
    decayTime = 1200; // Time in milliseconds the food needs to be eaten up
    
    zOff = 0;   
  }
  
  void update() {
    velocity.add(acceleration);
    pos.add(velocity);

    // Now add clearing the acceleration each time!
    acceleration.mult(0);    
  }
  

  

  
  void applyForce(PVector force) 
  {
    // Receive a force, divide by mass, and add to acceleration.
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  
  boolean isInside(Liquid l) 
  {
    //This conditional statement determines if the PVector location 
    //is inside the rectangle defined by the Liquid class.
    if (location.x>l.x && location.x<l.x+l.w && location.y>l.y && location.y<l.y+l.h)
    {
      return true;
    } else 
    {
      return false;
    }
  }  
  
  
  void drag(float c) 
  {

    float speed = velocity.mag();
    // The force’s magnitude: Cd * v~2~
    float dragMagnitude = c * speed * speed;

    PVector drag = velocity.get();
    drag.mult(-1);
    // The force's direction: -1 * velocity
    drag.normalize();

    // Finalize the force: magnitude and direction together.
    drag.mult(dragMagnitude);

    // Apply the force.
    applyForce(drag);
  }
  
  void decay() {
    expiration = millis() + decayTime;
    inDecay = true;    
  }
  
  
  
  void render() {
    noStroke();
    float alpha = 200;
    if(inDecay) {
      alpha = map(expiration-millis(), decayTime, 0, 255, 0);
      
    }
    fill(200, alpha);
    ellipse(pos.x+map(noise(0.01, zOff), 0, 1, -6, 6), pos.y+map(noise(0.02, zOff), 0, 1, -10, 10), mass*3, mass*3); // +noise(0.01, 0.02, zOff)*25
    
    zOff += 0.01;

  }
  
  
}

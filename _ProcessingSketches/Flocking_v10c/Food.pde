

class Food {
  
  ArrayList<Stuff> stuff;
  int decayTime;
  
  Food() {
    stuff = new ArrayList<Stuff>(); // Initialize the ArrayList
    decayTime = 1200; // Time in milliseconds the food needs to be eaten up
  }
  
  void spawn() {
    stuff.add(new Stuff(random(30, 400), random(200, 700)));
  }
  
  void update() {
    vanish();
    
    for (Stuff s : stuff) {
      s.render();
    }
  }

  
  void eat(int index) {
    Stuff s = stuff.get(index);
    if(!s.inDecay) {
      s.expiration = millis() + decayTime;
      s.inDecay = true;
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
  int expiration;
  boolean inDecay;
  float zOff;
  float size;
  
  Stuff(float posX, float posY) {
    pos = new PVector(posX, posY);
    expiration = 0;
    inDecay = false;
    zOff = 0;
    size = random(2, 6);
  }
  
  void render() {
    noStroke();
    fill(200);
    ellipse(pos.x+map(noise(0.01, zOff), 0, 1, -6, 6), pos.y+map(noise(0.02, zOff), 0, 1, -10, 10), size, size); // +noise(0.01, 0.02, zOff)*25
    
    zOff += 0.01;
   
    
    //pushMatrix();
    //  translate(pos.x,pos.y);
    //  float xOff = 0;
    //  float yOff = 0;
    //  beginShape();
    //    //for(int m = 0; m < 3; m++) {
    //    //  for(int n = 0; n < 3; n++) {
    //    //    vertex( );
    //    //  }
    //    //}
    //    vertex(-10+noise(0.01, 0.01, zOff), 10);
    //    vertex(10, 10);
    //    vertex(10, -10);
    //    vertex(-10, -10);        
    //  endShape(CLOSE);
    //popMatrix();
  }
  
  
}

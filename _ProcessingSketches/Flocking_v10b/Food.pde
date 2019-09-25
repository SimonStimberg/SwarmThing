

class Food {
  
  ArrayList<PVector> stuff;
  IntList decayList;
  
  Food() {
    stuff = new ArrayList<PVector>(); // Initialize the ArrayList
    decayList = new IntList();
  }
  
  void spawn() {
    stuff.add(new PVector(random(30, 400), random(200, 700)));
  }
  
  void render() {
    if(decayList.size() > 0) vanish();
    for (PVector s : stuff) {
      noStroke();
      fill(200);
      ellipse(s.x, s.y, 10, 10);
    }
  }
  
  void eaten(int index) {
    decayList.append(index);
    decayList.append(millis());
    //stuff.remove(index);
    
  }
  
  void vanish() {
    for(int i = 0; i < decayList.size(); i+=2) {
      int index = decayList.get(i);
      int expiration = decayList.get(i+1) + 3000;
      if(millis() > expiration) {
        stuff.remove(index);
      }
    }
    
  }
  
}

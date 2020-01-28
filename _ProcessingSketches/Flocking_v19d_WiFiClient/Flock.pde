// based on The Nature of Code - Flocking Example
// by Daniel Shiffman
// https://natureofcode.com/book/chapter-6-autonomous-agents/
// https://github.com/nature-of-code/noc-examples-processing/tree/master/chp06_agents


class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  
  int spawnInterval;
  int minTime;
  int maxTime;

  Flock(int min, int max) {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    minTime = min;
    maxTime = max;
    
    nextSpawn();
  }
  
  void nextSpawn() {
    spawnInterval = millis() + int(random(minTime, maxTime))*1000;
  }

  void update() {
    
    if (spawnInterval < millis()) {
      addBoid();
      nextSpawn();
    }
    
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }

    // if a boid moves offscreen, remove it
    for (int i = boids.size() - 1; i >= 0; i--) {
      Boid b = boids.get(i);
      if (b.position.x < -20 || b.position.x > width+20 || b.position.y < -20 || b.position.y > height+20) boids.remove(i);
    }
  }

  void render() {
    for (Boid b : boids) {
      b.render();
    }
  }

  void addBoid() {
    for (int i = 0; i <= random(10, 16); i++) {
      boids.add(new Boid());
    }
    if (boids.size() > 300) {
      for (int i = 0; i < boids.size() - 300; i++) {
        Boid b = boids.get(i);
        b.die();        
      }
    }
  }
  
  void killFlock() {
    for (int i = boids.size() - 1; i >= 0; i--) {
      Boid b = boids.get(i);
      b.die();
    }    
  }
  
  void removeFlock() {
    for (int i = boids.size() - 1; i >= 0; i--) {
      boids.remove(i);
    }    
  }
  
  
}

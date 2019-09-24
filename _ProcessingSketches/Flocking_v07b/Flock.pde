// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void update() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }
  
  void render() {
    for (Boid b : boids) {
      b.render();
    }
  }

  void addBoid(int gate) {
    for(int i = 0; i <= random(8, 12); i++){
      boids.add(new Boid(gate));
    }
    //boids.add(b);
  }

}

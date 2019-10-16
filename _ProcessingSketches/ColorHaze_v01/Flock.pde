// based on The Nature of Code - Flocking Example
// by Daniel Shiffman
// https://natureofcode.com/book/chapter-6-autonomous-agents/
// https://github.com/nature-of-code/noc-examples-processing/tree/master/chp06_agents


class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void update() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }

    // if a boid moves offscreen, remove it
    for (int i = boids.size() - 1; i >= 0; i--) {
      Boid b = boids.get(i);
      if (b.position.x < 0 || b.position.x > width || b.position.y < 0 || b.position.y > height) boids.remove(i);
    }
  }

  void render() {
    for (Boid b : boids) {
      b.render();
    }
  }

  void addBoid(int gate) {
    for (int i = 0; i <= random(8, 12); i++) {
      boids.add(new Boid(gate));
    }
  }
}

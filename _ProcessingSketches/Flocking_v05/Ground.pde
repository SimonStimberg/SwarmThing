class Ground {
  int[][] grid;
  int cols, rows, scl;
  color c1, c2;
  
  
  Ground(int c, int r, int s) {
    cols = c;
    rows = r;
    scl = s;
    grid = new int[c][r];    
    
    c1 = color(232, 169, 133);
    c2 = color(191, 71, 45);    
  }
  
  
  
  void update(ArrayList<Boid> boids) {
    for (Boid b : boids) {
      float x = b.position.x;
      float y = b.position.y;
      if(x > 0 && x <= width && y > 0 && y <= height) {
        int i = int(x) / scl; 
        int j = int (y) /scl;
        grid[i][j]++;
      }
     
    }
    
    display();
    flush();
  }
  
  void display() {
    fill(0);
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        float c = constrain(map(grid[i][j], 0, 20, 0.,1.), 0., 1.);
        color inter = lerpColor(c1, c2, c);
        noStroke();
        fill(inter);
        rect(i*scl, j*scl, scl, scl);
      }
    }
  }
  
  
  
  void debug() {
    fill(0);
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        text(grid[i][j],  i * scl,  j * scl);
      }
    }
  }

  
  
  void flush() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j] = 0;
      }
    }   
  }
  
  
}

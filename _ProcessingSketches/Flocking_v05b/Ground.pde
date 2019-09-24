class Ground {
  int[][] grid;
  int cols, rows, scl;
  color c1, c2;
  
  
  Ground(int c, int r, int s) {
    cols = c;
    rows = r;
    scl = s;
    grid = new int[c][r];    
    
    //c1 = color(232, 169, 133);
    c1 = color(223, 203, 192);
    c2 = color(191, 71, 45);    
  }
  
  
  
  void update(ArrayList<Boid> boids) {
    for (Boid b : boids) {
      float x = b.position.x;
      float y = b.position.y;
      if(x > 0 && x <= width && y > 0 && y <= height) {
        int i = int(x) / scl; 
        int j = int (y) /scl;
        //grid[i][j]++;
        
        for (int n = -5; n <= 5; n++) {
          for (int m = -5; m <= 5; m++) {
            if (i+n >= 0 && i+n < cols && j+m >= 0 && j+m< rows) grid[i+n][j+m]++;
          }
        }
      }
     
    }
    
    display();
    //debug();
    flush();
  }
  
  void display() {
    fill(0);
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        float c = constrain(map(grid[i][j], 0, 40, 0.,1.), 0., 1.);
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

class Ground {
  int[][] grid;
  float[][] intensities;
  int cols, rows, scl;
  color c1, c2;
  float zOff;
  
  
  Ground(int c, int r, int s) {
    cols = c;
    rows = r;
    scl = s;
    grid = new int[c][r];    
    intensities = new float[c][r];
    
    //c1 = color(232, 169, 133);
    c1 = color(223, 203, 192);
    //c1 = #008ea8;
    c2 = color(191, 71, 45);    
    
    zOff = 0.0;
  }
  
  
  
  void update(ArrayList<Boid> boids) {
    for (Boid b : boids) {
      float x = b.position.x;
      float y = b.position.y;
      if(x > 0 && x <= width && y > 0 && y <= height) {
        int i = int(x) / scl; 
        int j = int (y) /scl;
        //grid[i][j]++;
        
        for (int n = -7; n <= 7; n++) {
          for (int m = -7; m <= 7; m++) {
            if (i+n >= 0 && i+n < cols && j+m >= 0 && j+m< rows) grid[i+n][j+m]++;
          }
        }
      }
      
      
     
    }
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        float c = constrain(map(grid[i][j], 0, 100, 0.,1.), 0., 1.);
        intensities[i][j] = intensities[i][j] * 0.8 + c * 0.2;
        
        float xOff = i*0.01;
        float yOff = j*0.01;
        intensities[i][j] += noise(xOff, yOff, zOff) * 0.15;
        
      }
    }
    zOff += 0.01;
    
    display();
    //debug();
    flush();
  }
  
  void display() {
    fill(0);
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        //float c = constrain(map(grid[i][j], 0, 40, 0.,1.), 0., 1.);
        color inter = lerpColor(c1, c2, intensities[i][j]);
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

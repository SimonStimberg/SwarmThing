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
    //c1 = color(223, 203, 192);
    c1 = #008ea8;
    c2 = color(191, 71, 45);    
    
    zOff = 0.0;
  }
  
  
  
  void update(ArrayList<Boid> boids) {
    //for (Boid b : boids) {
    //  float x = b.position.x;
    //  float y = b.position.y;
    //  if(x > 0 && x <= width && y > 0 && y <= height) {
    //    int i = int(x) / scl; 
    //    int j = int (y) /scl;
    //    //grid[i][j]++;
        
    //    for (int n = -7; n <= 7; n++) {
    //      for (int m = -7; m <= 7; m++) {
    //        if (i+n >= 0 && i+n < cols && j+m >= 0 && j+m< rows) grid[i+n][j+m]++;
    //      }
    //    }
    //  }   
    //}
    
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        //float c = constrain(map(grid[i][j], 0, 100, 0.,1.), 0., 1.);
        //intensities[i][j] = intensities[i][j] * 0.8 + c * 0.2;
        
        float xOff = i*0.01;
        float yOff = j*0.01;
        intensities[i][j] = noise(xOff, yOff, zOff) * 0.8;
        
      }
    }
    zOff += 0.005;
    
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





class Waves {
  
  float yOff;
  int wavesAmount;
  float resolution;
  float[] wavesY;

  
  Waves() {
    yOff = 0;
    wavesAmount = 50;
    resolution = width/(wavesAmount-2);
    
    wavesY = new float[wavesAmount];
  }
  
  
  float checkSurface(float x) {
    
    int index = floor(x/resolution);
    float interPos = (x - resolution * index) / resolution;
    float interY = lerp(wavesY[index], wavesY[index+1], interPos);
    return interY;   
    
  }

  
  void render(float depth) {
    fill(0);
    noStroke();
    float xOff = 0.0;
    
    beginShape(); 
      
    // Iterate over horizontal pixels
    for (int i = 0; i < wavesAmount; i++) {
      // Calculate a y value according to noise, map to 
      
      wavesY[i] = map(noise(xOff, yOff), 0, 1, depth,depth+100); // Option #1: 2D Noise
      // float y = map(noise(xoff), 0, 1, 200,300);    // Option #2: 1D Noise
      
      float x = i * resolution;
      
      
      // Set the vertex
      vertex(x, wavesY[i]); 
      // Increment x dimension for noise
      xOff += 0.05;
    }
    // increment y dimension for noise
    yOff += 0.005;
    vertex(width, 0);
    vertex(0, 0);
    endShape(CLOSE);
  
  }
}

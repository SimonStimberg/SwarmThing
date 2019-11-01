// Simon Stimberg - September 2019
//
// Code based on the teachings from 
// The Nature of Code by Daniel Shiffman
// http://natureofcode.com
//
// which implements Craig Reynolds' "Flocking" and "Steering" behavior
// See: http://www.red3d.com/cwr/



// Adjustable dimensions
int matteLeft = 54;
int matteRight = 72;

int outerColumnWidth = 226;  // 14,6% from building width (= total width - matte left&right)
int smallGateWidth = 191;    // 12,4%
int innerColumnWidth = 154;  // 10,7%
int bigGateWidth = 360;      // 24,6%
int innerColumn2Width = 157;
int smallGate2Width = 176;
int outerColumn2Width = 210;

int smallGateHeight = 344;   // 32,3% from total height
int bigGateHeight = 650;     // 60,0%



// for FullHD 16:9 1920x1080

//int matteLeft = 258;
//int matteRight = 258;

//int outerColumnWidth = 205;  // 14,6% from building width (= total width - matte left&right)
//int innerColumnWidth = 150;  // 10,7%
//int smallGateWidth = 174;    // 12,4%
//int bigGateWidth = 346;      // 24,6%






// import UDP library
import hypermedia.net.*;
import processing.video.*;

UDP udp;  // define the UDP object
String sendIp       = "192.168.137.178";  // the remote IP address
int sendPort        = 6000;    // the destination port


Movie mov;
boolean movieIsPlaying = false;
boolean switcher = false;

PImage matte;



Flock flock;
Wall wall;
Ground ground;
Waves waves;
Food food;

float depth;
float initDepth;


boolean triggerBoid;
boolean showdown;

int simDuration = 15;  // duration of simulation in min. 
int simEnd;   // timestamp when to end the simulation


boolean debug;



void setup() {

  // create a new datagram connection on port 6000
  // and wait for incomming message
  udp = new UDP( this, 9000 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );

  size(1600, 1200);
  background(0);
  //fullScreen(2);

  // define the starting depth, resp. the position of the wave-line
  initDepth = 0.6;  
  depth = height;

  // initialize all elements
  food = new Food(20, 50);   // parameters: seconds in between to spawn 
  waves = new Waves();  
  newWall();
  flock = new Flock(5, 20);

  // the ground consists of a grid of squares - comparable to "big pixels"
  // which make it much more performative, computing the color changing background
  int gridSize = 20;
  int cols = width / gridSize;
  int rows = height / gridSize;
  ground = new Ground(cols, rows, gridSize);

  debug = true;
  triggerBoid = true;
  showdown = false;

  mov = new Movie(this, "lichtspektakel_filmuni.mp4");
  //mov.frameRate(25);
  matte = loadImage("maskeBt.png");
  imageMode(CENTER);
  simEnd = millis() + simDuration * 60000;
}



void draw() {
  
  if (showdown && depth > height-10) {
    switcher = true;
    showdown = false;
  }
  
  if (movieIsPlaying && mov.time() >= mov.duration()) { 
    switcher = true;
  }



  if (switcher && !movieIsPlaying) {
    mov.play();
    movieIsPlaying = true;
    flock.removeFlock();
    switcher = false;
  }

  if (switcher && movieIsPlaying) {
    mov.stop();  
    movieIsPlaying = false;
    depth = height;
    simEnd = millis() + simDuration * 60000;
    food.timeNextDrop();
    triggerBoid = true;
    switcher = false;
  }

  if (!movieIsPlaying) {
    runSimulation();
  } else {    
    playVideo();
  }
  
  // end the simulation when time is up
  if (!movieIsPlaying && simEnd < millis()) {
    flock.killFlock();
    showdown = true;    
  }

  // draw matte for mapping
  //tint(255, 127);   // alpha 50%
  image(matte, width * 0.5, height * 0.5);


  if (debug) {
    fill(0);
    rect(0, 0, width, 20);
    fill(255);
    text("Framerate: " + int(frameRate), 10, 16);
    text("Boids: " + int(flock.boids.size()), 100, 16);
  }
}


void runSimulation() {

  // the boids have to be added during the draw loop and not in the oscEvent function
  // since the osc function works as an interrupt it could break the other functions
  // because if the amount of boids changes while a boid function is in the middle of a run is not good
  if (triggerBoid && !showdown) {
    flock.addBoid();
    println("new boid spawned");
    triggerBoid = false;
  }


  adjustDepth();
  ground.update();
  waves.render(depth);
  food.update(waves);
  flock.update();
  flock.render();
  //drawGate();
  //wall.display();   // display the boundaries for debugging purposes
}

void playVideo() {
  background(0);
  // Display the playing mov
  image(mov, width * 0.5, height * 0.5);
}

void movieEvent(Movie m)
{
  m.read();
}



public void keyPressed() {
  if (key == '1') {
    triggerBoid = true;
  }
  if (key == ' ') {
    food.spawn();
  }
  if (key == 'k') {
    flock.killFlock();
    showdown = true;
  }

  if (key == 'm') {
    switcher = !switcher;
  }
  if (keyCode == RIGHT && movieIsPlaying) {
    mov.jump(mov.time() + 60);
  }

  // sends a UDP message to sensor to see if its still alive
  if (key == 'a') {
    String message  = str( key );  // the dummy message to send

    // send the message
    udp.send( message, sendIp, sendPort );
  }
}


// void receive( byte[] data ) {       // <-- default handler
void receive( byte[] data, String ip, int port ) {  // <-- extended handler

  String message = new String( data );
  // cange the send IP+port to the ones received
  sendIp = ip;
  sendPort = port;

  // print the result
  println( "receive: \""+message+"\" from "+ip+" on port "+port );

  if (int(message) == 1) {
    triggerBoid = true;
    println("TRIGGER received");
  }
}


// adjusts the depth according to the amount of boids
// while smoothly transitioning the water level using a lerp function
void adjustDepth() {

  ground.pollution = map(constrain(flock.boids.size(), 0, 300), 0, 300, 0.0, 1.0);

  float newDepth = depth;
  if (showdown ) {
    //if (flock.boids.size() < 1) {
    //  newDepth = height;
    //}
    newDepth = height * map(constrain(flock.boids.size(), 0, 300), 0, 300, 1.1, 0.1);
  } else {
    newDepth = height * constrain(map(flock.boids.size(), 0, 200, initDepth, 0.1), 0.1, initDepth);
  }

  // only lerp, if depth differs from the newDepth
  // since lerp always approximates but never reaches the target value we enhance the threshhold by 0.5
  if (depth > newDepth+0.5 || depth < newDepth-0.5) {

    depth = lerp(depth, newDepth, 0.05);

    // also adjust the boundaries for boid behavior
    int mode = 0;
    if (depth < 575) mode = 1;  
    if (depth < 375) mode = 2;  
    wall.adjustWall(depth, mode);
  }
}



// draws the cavities of the gateways
// all positions are relative to the canvas size for easier adaption to various screen dimensions
void drawGate() {

  ellipseMode(CORNER);
  noStroke();
  fill(0);

  // draw small gate left
  rect(matteLeft+outerColumnWidth, height-smallGateHeight+smallGateWidth*0.5, smallGateWidth, smallGateHeight);
  ellipse(matteLeft+outerColumnWidth, height-smallGateHeight, smallGateWidth, smallGateWidth);

  // draw small gate right
  rect(matteLeft+outerColumnWidth+smallGateWidth+innerColumnWidth*2+bigGateWidth, height-smallGateHeight+smallGateWidth*0.5, smallGateWidth, smallGateHeight);
  ellipse(matteLeft+outerColumnWidth+smallGateWidth+innerColumnWidth*2+bigGateWidth, height-smallGateHeight, smallGateWidth, smallGateWidth);

  // draw big gate
  rect(matteLeft+outerColumnWidth+smallGateWidth+innerColumnWidth, height-bigGateHeight+bigGateWidth*0.5, bigGateWidth, bigGateHeight);
  ellipse(matteLeft+outerColumnWidth+smallGateWidth+innerColumnWidth, height-bigGateHeight, bigGateWidth, bigGateWidth);


  // draw matte Left and Right
  rect(0, 0, matteLeft, height);
  rect(width-matteRight, 0, matteRight, height);
}



// describes the boundaries of the space the boids are allowed to move in
//
// this is a bit of a hacky approach - since the boids don't behave well at corners with an angle of 90° or less,
// we ease out those corners to ensure the boids are moving smooth 
void newWall() {

  wall = new Wall();

  float offset = 30; // defines the amount of smoothness

  int innerWidth = width - matteLeft - matteRight;

  int column1_X = matteLeft;
  int gate1_X = matteLeft + outerColumnWidth;
  int column2_X = matteLeft + outerColumnWidth + smallGateWidth;
  int gate2_X = matteLeft + outerColumnWidth + smallGateWidth + innerColumnWidth;
  int column3_X = matteLeft + outerColumnWidth + smallGateWidth + innerColumnWidth + bigGateWidth; 
  int gate3_X = matteLeft + outerColumnWidth + smallGateWidth + innerColumnWidth + bigGateWidth + innerColumn2Width;
  int column4_X = matteLeft + outerColumnWidth + smallGateWidth + innerColumnWidth + bigGateWidth + innerColumn2Width + smallGate2Width;

  int rightEnd = width - matteRight;

  int smallGate_Y = height-smallGateHeight;
  int bigGate_Y = height-bigGateHeight;




  wall.addPoint(column1_X, offset+depth+65);
  wall.addPoint(column1_X+offset, 0+depth+65);

  wall.addPoint(gate2_X-offset*2, 0+depth+65);
  wall.addPoint(gate2_X, 0+depth+65+offset*2);
  wall.addPoint(column3_X, 0+depth+65+offset*2);
  wall.addPoint(column3_X+offset*2, 0+depth+65);


  wall.addPoint(rightEnd-offset, 0+depth+65);
  wall.addPoint(rightEnd, offset+depth+65); 
  wall.addPoint(rightEnd, height-offset);
  wall.addPoint(rightEnd-offset, height);

  wall.addPoint(column4_X+offset, height);
  wall.addPoint(column4_X, height-offset);
  wall.addPoint(column4_X, smallGate_Y+offset*2);
  wall.addPoint(column4_X-offset*2, smallGate_Y);
  wall.addPoint(gate3_X+offset*2, smallGate_Y);
  wall.addPoint(gate3_X, smallGate_Y+offset*2);
  wall.addPoint(gate3_X, height-offset);
  wall.addPoint(gate3_X-offset, height);

  wall.addPoint(column3_X+offset, height);
  wall.addPoint(column3_X, height-offset);
  wall.addPoint(column3_X, bigGate_Y+offset*3);
  wall.addPoint(column3_X-offset*3, bigGate_Y);
  wall.addPoint(gate2_X+offset*3, bigGate_Y);
  wall.addPoint(gate2_X, bigGate_Y+offset*3);
  wall.addPoint(gate2_X, height-offset);
  wall.addPoint(gate2_X-offset, height);

  wall.addPoint(column2_X+offset, height);
  wall.addPoint(column2_X, height-offset);
  wall.addPoint(column2_X, smallGate_Y+offset*2);
  wall.addPoint(column2_X-offset*2, smallGate_Y);
  wall.addPoint(gate1_X+offset*2, smallGate_Y);
  wall.addPoint(gate1_X, smallGate_Y+offset*2);
  wall.addPoint(gate1_X, height-offset);
  wall.addPoint(gate1_X-offset, height);

  wall.addPoint(column1_X+offset, height);
  wall.addPoint(column1_X, height-offset);
}

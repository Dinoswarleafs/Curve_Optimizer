// Press a key to start/pause the search
// Press "s" to bring up stats
// Press "c" to clear the line streak
// Press the mouse to switch modes
// Press a key once the program is done to restart it


// Point you want to minimize the distance to
float givenPointX = 3;
float givenPointY = 9;

// Domain of x you want to test over
float startingX = 0;
float endingX = 3;

// Preciseness (How far apart should x values be tested)
// 1 means the program will check 0, 1, 2, 3
// .1 means the program will check 0, .1, .2, .3, etc.
// Through testing ~.1 gives more accurate answers for rational numbers
// Of course irrationals should be tested with more preciness
float precisness = .01;

// Animation Speed (Lines draw per second)
float speed = 30;

// Single line (This to true only has one line like a flashlight. I like it more off)
// Press a key at any time to reverse its mode
boolean singleLine = true;

// Color of line (R, G, B)
color lineColor = color(0, 0, 0);


// Don't mess with this stuff. Go down to function if you want to change it.

// Math Assests
PVector givenPointMapped;
PVector points[] = new PVector[(int)((endingX - startingX) / precisness) + 1];
PVector range;
PVector optimalPoint;
boolean searchStarted;
int index = 0;
float scrubX;
float scrubY;

// Stylistic Stuff
PGraphics graph;
PFont mono;
boolean showStats;

void setup() {
 frameRate(3000);
 size(800, 800);
 background(255);

 // Graphics stuff
 mono = createFont("Calibri", 20);
 textFont(mono);
 strokeWeight(3);
 graph = createGraphics(800, 800);

 // Construct Graph
 println("Mapping out all the points. This should be quick");
 float min = 1000;
 float max = -1000;

 for (int i = 0; i < points.length; i++) {
  float rawX = precisness * i;
  float rawY = function(precisness * i);
  if (rawY < min)
   min = rawX;
  if (rawY > max)
   max = rawY;
 }
 for (int i = 0; i < points.length; i++) {
  float rawX = precisness * i;
  float rawY = function(precisness * i);
  float x = map(rawX, startingX, endingX, 0, width);
  float y = map(rawY, min, max, height, 0);
  points[i] = new PVector(x, y);
 }
 float rawX = givenPointX;
 float rawY = givenPointY;
 float x = map(rawX, startingX, endingX, 0, width);
 float y = map(rawY, min, max, height, 0);
 givenPointMapped = new PVector(x, y);
 println("Ding! Done.");

 println("One second Mr. Korpi (or maybe more) ... drawing the graph");
 graph.beginDraw();
 graph.background(255);
 graph.stroke(0);
 for (int i = 0; i < points.length; i++)
  if (i != 0) 
   graph.line(points[i].x, points[i].y, points[i - 1].x, points[i - 1].y);
 graph.endDraw();
 println("Ding! I sketched a pretty good approximation of the graph :)");
 
 optimalPoint = new PVector(startingX, function(startingX));

 background(255);
 frameRate(speed);
 image(graph, 0, 0);
}


void draw() {
 stroke(lineColor);
 if(singleLine || key == 'c')
  image(graph, 0, 0);
 fill(0, 50);
 ellipse(givenPointMapped.x, givenPointMapped.y, 25, 25);
 if(searchStarted) {
  scrubX = index * precisness;
  scrubY = function(scrubX);
  if (distance(scrubX, scrubY) < distance(optimalPoint.x, optimalPoint.y))
   optimalPoint = new PVector(scrubX, scrubY);
  if(index >= points.length) {
   searchStarted = !searchStarted;
   index = 0;
  }
  // Animation
  line(givenPointMapped.x, givenPointMapped.y, points[index].x, points[index].y);
  index++;
 }
 else if (index != 0)
   line(givenPointMapped.x, givenPointMapped.y, points[index].x, points[index].y);
 
 if (showStats) {
  noStroke();
  fill(255, 200);
  rect(600, 0, 200, 140);
  fill(0);
  textAlign(LEFT);
  text("X : " + nf(scrubX, 2, 2), 600, 20);
  text("Y : " + nf(scrubY, 2, 4), 600, 40);
  text("Distance : " + nf(distance(scrubX, scrubY), 2, 4), 600, 60);
  text("Optimal X : " + nf(optimalPoint.x, 2, 4), 600, 80);
  text("Optimal Y : " + nf(optimalPoint.y, 2, 4), 600, 100);
  text("Distance : " + nf(distance(optimalPoint.x, optimalPoint.y), 2, 4), 600, 120);
 }
}

void mousePressed() {
  singleLine = !singleLine;
}

void keyPressed() {
  if (key != 'c' && key != 's')
   searchStarted = !searchStarted;
  else if (key == 's')
   showStats = !showStats;
}

float distance(float x_, float y_) {
  return sqrt(pow(x_ - givenPointX, 2) + pow(y_ - givenPointY, 2));
}

float
function(float x) {
 return 9 - pow(x, 2);
}
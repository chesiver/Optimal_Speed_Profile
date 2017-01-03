Points points = new Points();
Points sPoints = new Points();
Points rPoints = new Points();
Points uPoints = new Points();
int nLevels = 5;
int nSample = 200;
int showNumber = 0;
boolean isShowCurvatures = false, isShownAcceleration = false;
float timeStep = 1.0 / 30;
float lapTime=0;
String Timing="";
int ms=0, me=0; // milli seconds start and end for timing
float maxAcceleration = 100;

void setup(){
  size(800,800);
  myFace = loadImage("./data/pic.jpg");
  RodFace = loadImage("./data/rod_pic.jpg");
  frameRate(30);
  //points.ResetOnCircle(10);
  points.LoadPoints("data/pts");
  points.copyInto(sPoints); 
  nSample = sPoints.subdivide(nLevels); // subdivides S 'levels' times
  sPoints.copyInto(rPoints); 
  sPoints.Resample(uPoints, nSample);
}

void draw(){
  background(white);
  if(mousePressed){
    points.copyInto(sPoints); 
    sPoints.subdivide(nLevels); // subdivides S 'levels' times
  }
  
  
  fill(yellow); Pen(lgrey,30); sPoints.drawCurve();
  noFill(); Pen(black,2); sPoints.drawCurve();
  
  rPoints.drawPoints(purple);
  sPoints.drawPoints(green);
  
  ++showNumber;
  if(showNumber >= nSample){
    showNumber = 0;
    me=millis();
    lapTime=(float)(me-ms)/1000;
    Timing = str(nSample)+" samples. Lap time = "+str(lapTime)+" seconds";
    ms=me;
  }
  // show curvatures
  if(isShowCurvatures) {Pen(magenta,1);  rPoints.ShowCurvatures(); }
  if(isShownAcceleration) {Pen(pink,1);  rPoints.ShowAccelerations(); }
  
  fill(blue); scribeHeader(Timing,2);
  fill(magenta); noStroke(); rPoints.GetPoint(showNumber).Show(5);
  fill(red); noStroke(); uPoints.GetPoint(showNumber).Show(7);
  
  fill(black); displayHeader();
}
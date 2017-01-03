void keyPressed(){
  switch(key){
    //case 's': sPoints.Resample(rPoints, nSample);  break; // resample
    case 's': println("original points: " + sPoints.nVertices + " "); nSample = sPoints.ResampleAccordingToMaxAccelaration(rPoints, maxAcceleration);  sPoints.Resample(uPoints, nSample); showNumber = 0; println("nSample = " +nSample + " " + rPoints.nVertices + " " + uPoints.nVertices); break; // resample
    case 'c': points.ResetOnCircle(10); println("ResetOnCircle"); break;
    case ')': isShowCurvatures = !isShowCurvatures; rPoints.SetCurvatures(); break; //curvature
    case '*': isShownAcceleration = !isShownAcceleration; rPoints.SetAccelerations(); break; //acceleration
    case '1': points.LoadPoints("/data/pt1"); break;
    case '2': points.LoadPoints("/data/pt2"); break;
    case '3': points.LoadPoints("/data/pt3"); break;
    case '7': points.SavePoints("/data/pt1"); break;
    case '8': points.SavePoints("/data/pt2"); break;
    case '9': points.SavePoints("/data/pt3"); break;
  }
}

void mousePressed()   // executed when the mouse is pressed
{
  points.pickClosest(Mouse()); // pick vertex closest to mouse: sets pv ("picked vertex") in pts
  if(keyPressed) {
    if(key == 'a') {points.AddPoint(Mouse());} // appends vertex after the last one
  }
}

void mouseDragged()
{
  if(!keyPressed) points.dragPicked();
}
int ResampleAccordingToMaxAccelarationAux(Points S, Points R, float maxAccelaration)
{
  int nVertices = S.nVertices;
  S.SetCurvatures();
  float[] curvatures = S.curvatures;
  //for(int i = 0; i < nVertices; ++i) println("curvatures  "+ i + " " + curvatures[i]);
  Point[] pointsVector = S.pointsVector;
  float[] forwardVelocities = getVelocitiesForward(pointsVector, nVertices,  curvatures, maxAccelaration);  
  float[] velocities = getVelocitiesBackward(pointsVector, nVertices,  curvatures, maxAccelaration, forwardVelocities);
  //for(int i = 0; i < velocities.length; ++i) println(i + " " + velocities[i]);
  R.Clear();
  int nCount = 0;
  int index = 0;
  float accu = 0, v = 0;
  //R.AddPoint(pointsVector[0]);
  while(index < nVertices){
    float d = Dist(pointsVector[index], pointsVector[(index + 1) % nVertices]);
    if(accu >= d) accu -= d;
    else{
      R.AddPoint(MoveByDistanceTowards(pointsVector[index], accu, pointsVector[(index + 1) % nVertices])); 
      float a = (sq(velocities[(index + 1) % nVertices]) - sq(velocities[index])) / (2 * d);
      //println("a " + index + " ", a);
      float vMid = (v + velocities[(index + 1) % nVertices]) / 2;
      //println("vMid " + index + " ", vMid);
      int times = (int)((d - accu) / vMid / timeStep);
      //println("times " + index + " ", times);
      for(int i = 0; i <= times; ++i){
        float t = i * timeStep;
        R.AddPoint(MoveByDistanceTowards(pointsVector[index], accu + v * t  + 0.5 * a * sq(t), pointsVector[(index + 1) % nVertices]));
      }
      float t = (times + 1) * timeStep;
      //println("t " + index + " ", t);
      accu = accu + v * t  + 0.5 * a * sq(t) - d;
      v += a * t;
      nCount += times + 2;
    }
    //println("accu: " + index + " " + accu);
    ++index;
  }
  return nCount;
}

float[] getMaxTangentVelocity(float[] curvatures, float maxAccelaration){
  int n = curvatures.length;
  float[] result = new float[n];
  for(int i = 0; i < n; ++i){
    result[i] = sqrt(maxAccelaration / curvatures[i]);
  }
  return result;
}

float[] getVelocitiesForward(Point[] pointsVector, int nVertices, float[] curvatures, float maxAccelaration){
  float[] result = new float[nVertices];
  float[] velocities = getMaxTangentVelocity(curvatures, maxAccelaration);
  result[0] = 0;
  for(int i = 1; i < nVertices; ++i){
    result[i] = velocities[i];
    float v = sqrt(sq(result[i - 1]) + 2 * sqrt(sq(maxAccelaration) - sq(sq(result[i - 1]) * curvatures[i - 1])) * Dist(pointsVector[i], pointsVector[i - 1]));
    if(v < result[i]) result[i] = v;
  }
  //for(int i = 0; i < nVertices; ++i) println("forwardVelocity " + i + " " + velocities[i] + " " + result[i]);
  //for(int i = 0; i < nVertices - 1; ++i) println("acceleration " + i + " " + (sq(result[i]) - sq(result[(i + 1) % nVertices])) / (2 * Dist(pointsVector[i], pointsVector[(i + 1) % nVertices])));
  return result;
}

float[] getVelocitiesBackward(Point[] pointsVector, int nVertices, float[] curvatures, float maxAccelaration, float[] forwardVelocities){
  float[] result = new float[nVertices];
  for(int i = nVertices - 1; i > 0; --i){
    int index = i;
    if(i == nVertices) index = 0;  // last point is same as first point
    result[i - 1] = forwardVelocities[i - 1];
    float v = sqrt(sq(result[index]) + 2 * sqrt(sq(maxAccelaration) - sq(sq(result[index]) * curvatures[index])) * Dist(pointsVector[i - 1], pointsVector[index]));
    if(v < result[i - 1]) result[i - 1] = v;
  }
  //for(int i = 0; i < nVertices; ++i) println("Velocity " + i + " " + forwardVelocities[i] + " " + result[i]);
  //for(int i = 0; i < nVertices - 1; ++i) println("acceleration " + i + " " + (sq(result[i]) - sq(result[(i + 1) % nVertices])) / (2 * Dist(pointsVector[i], pointsVector[(i + 1) % nVertices])));
  return result;
}
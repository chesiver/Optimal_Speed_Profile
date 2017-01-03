class Points{
  int nVertices = 0;
  int nPickedVertice = 0;
  int maxNumber = 100000;
  boolean isLoop = true;
  Point[] pointsVector = new Point[maxNumber];
  float[] curvatures = new float[maxNumber];
  Vector[] accelerations = new Vector[maxNumber];
  
  Points(){
    for(int i = 0; i < maxNumber; ++i){
      pointsVector[i] = new Point();
      accelerations[i] = new Vector();
    }
  }
  
  void Clear(){nVertices = 0;}
  void AddPoint(float x, float y){ pointsVector[nVertices].x = x; pointsVector[nVertices].y = y; ++nVertices;}  
  void AddPoint(Point P){ pointsVector[nVertices].SetTo(P); ++nVertices;}
  
  void ResetOnCircle(int k){
    Clear();
    Point Center = ScreenCenter(); 
    Vector translation = new Vector(0, -width / 3);
    for(int i = 0; i < k; ++i){
      Point P = Rotation(Translate(Center,translation),2.*PI * i / k, Center);
      AddPoint(P);
    }
  }
  
  //modified
  void dragPicked(){
    pointsVector[nPickedVertice].moveWithMouse();
  }
  void pickClosest(Point M){
    this.nPickedVertice = 0;
    for(int i = 1; i < nVertices; ++i){
      if(Dist2(pointsVector[i], M) < Dist2(pointsVector[this.nPickedVertice], M)) this.nPickedVertice = i;
    }
  }
  
  //draw
  Point GetPoint(int n)
  {
    if(0 <= n && n < nVertices) return pointsVector[n];
    else return pointsVector[0];
  }
  void drawPoints(){
    Pen(green,5);
    beginShape(POINTS); 
      for(int i = 0; i < nVertices; ++i) pointsVector[i].Display(); 
    endShape(); 
  }
  void drawPoints(color c){
    Pen(c,5);
    beginShape(POINTS); 
      for(int i = 0; i < nVertices; ++i) pointsVector[i].Display(); 
    endShape(); 
  }
  void drawCurve(){
    if(isLoop){
      beginShape(); 
        for (int i = 0; i < nVertices; ++i) pointsVector[i].Display(); 
      endShape(CLOSE); 
    }
    else{
      Pen(green,5);
      beginShape(POINTS); 
        for (int i = 0; i < nVertices; ++i) pointsVector[i].Display(); 
      endShape(); 
    }
  }
  // SHOW CURVATURES
  float curvatureScale = 2000;
  void SetCurvatures(){
    for(int i = 0; i < nVertices; ++i){
      Point A = pointsVector[pre(i)], B = pointsVector[i], C = pointsVector[next(i)];
      this.curvatures[i] = Curvature(A,B,C);
      println("curvatures i" + " " + this.curvatures[i]);
    }
  }
  void ShowCurvatures() 
  {
    for(int i = 0; i < nVertices; ++i){
      Point A = pointsVector[pre(i)], B = pointsVector[i], C = pointsVector[next(i)];
      Vector AB = new Vector(A,B), AC = new Vector(A,C);
      float k = Curvature(A,B,C);
      float g = k * curvatureScale;
      if(Det(AC, AB)>0) Show(B, g, Rotate(Unit(AC))); else Show(B, -g, Rotate(Unit(AC)));
    }
  }
  float Curvature(Point A, Point B, Point C) // computes 1 / radius of circumcircle to (A,B,C)
  {
    float a = Dist(B,C), b = Dist(C,A), c = Dist(A,B); // edge lengths
    float s = (a + b + c) / 2; // half perimeter
    float d = s * (a + b - s) * (b + c - s) * (c + a - s);
    if(d < 0.000001) return 0;
    float k = sqrt(d) * 4 / (a * b * c); // curvature
    return k;
  } // radius of circumcenter
  
  //Acceleration
  void SetAccelerations(){
    for(int i = 0; i < nVertices; ++i) {
      Point A = pointsVector[pre(i)], B = pointsVector[i], C = pointsVector[next(i)];
      Vector BA = new Vector(B,A), BC = new Vector(B,C);
      accelerations[i] = Sum(BC,BA);
      //println("acceleration norm i" + " " + Norm(accelerations[i]));
    }
  }
  float accelerationScale = 30;
  void ShowAccelerations() // plots inverse of acceleration vectors scaled by accelerationScale
    { 
    for(int i = 0; i < nVertices; ++i) {
      //Point A = pointsVector[pre(i)], B = pointsVector[i], C = pointsVector[next(i)];
      //Vector BA = new Vector(B,A), BC = new Vector(B,C);
      //Vector G = Sum(BC,BA);
      if(Norm(accelerations[i]) > maxAcceleration / accelerationScale) Show(pointsVector[i], accelerationScale ,accelerations[i]);
      //float s = sq(ab+bc);
      //if(s>0.00001) show(B, accelerationScale / s ,G);
      }
    }
    
  //measure
  float Length() // length of perimeter
  {
    float L = 0; 
    for (int i = nVertices - 1, j = 0; j < nVertices; i = j++) L += Dist(pointsVector[i], pointsVector[j]); 
    return L; 
  }

  //subdivision
  void copyInto(Points Q) 
  {
    Q.Clear(); 
    for(int i = 0; i < nVertices; ++i) 
      Q.AddPoint(pointsVector[i]); 
  }
  int subdivide (int NumberOfSubdivisionSteps){
    for(int i = 0; i < NumberOfSubdivisionSteps; ++i) SubdivideCentripetal();
    return nVertices;
  }
  int next(int i) {if(i == nVertices - 1) return 0; else return i + 1;} // index of next point
  int pre(int i) {if(i == 0) return nVertices - 1; else return i - 1;} // index of precious point
  void SubdivideCentripetal() 
  {
    Point [] S = new Point [2 * nVertices];
    for(int i = 0; i < nVertices; ++i) S[2 * i] = new Point(pointsVector[i]);
    for(int i = 0; i < nVertices; ++i) S[2 * i + 1] = CentripetalMidcourseCorrected(pointsVector[pre(i)],pointsVector[i],pointsVector[next(i)],pointsVector[next(next(i))]);
    for(int i = 0; i < 2 * nVertices; ++i) pointsVector[i].SetTo(S[i]);
    nVertices *= 2;
  }
  
  //file
  void LoadPoints(String FileName) 
  {
    println("loading: " + FileName); 
    String[] ss = loadStrings(FileName);
    int s = 0;   
    int comma;   
    float x, y;
    nVertices = int(ss[s++]); println("nVertices = " + nVertices);
    for(int k = 0; k < nVertices; ++k) {
      int i = k + s; 
      comma=ss[i].indexOf(',');   
      x = float(ss[i].substring(0, comma));
      y = float(ss[i].substring(comma+1, ss[i].length()));
      pointsVector[k].SetTo(x,y);
    };
    nPickedVertice = 0;
  }; 
  
  void SavePoints(String FileName) 
  {
    String [] inppts = new String [nVertices + 1];
    int s = 0;
    inppts[s++] = str(nVertices);
    for (int i = 0; i < nVertices; ++i) {inppts[s++]=str(pointsVector[i].x)+","+str(pointsVector[i].y);}
    saveStrings(FileName,inppts);
  };
  
  //resample
  void Resample(Points S, int nSample) 
  { 
   S.Clear();
   if(nVertices == 0) return;
   float len = Length();                            
   Point[] R = new Point[nSample];  // temporary array for new samples
   Point Q = new Point();
   float d = len / nSample;  // desired distance between new samples
   float rd=d;  // remaining distance to next sample
   float cl=0;  // length of remaining portion of current edge
   int nk=1;    // index of the next vertex on the original curve
   int c=0;     // number of already added points
   Q.SetTo(pointsVector[0]);     // Set Q as first vertex         
   R[c++] = new Point(Q);       // add Q as first sample and increment counter n
   while (c < nSample)   // keep adding samples to R
   { 
     cl = Dist(Q, pointsVector[nk]);                                                 
     if(rd <= cl) // next sample is along the current edge (or at its end)
     {
        Q = MoveByDistanceTowards(Q, rd, pointsVector[nk]);
        R[c++] = new Point(Q); 
        cl -= rd; 
        rd = d; 
     }  
     else                                  // move past the end-vertex of the current edge
     {
       rd-=cl; 
       Q.SetTo(pointsVector[nk]); 
       nk=next(nk);
     }
   }
   for(int i = 0; i < c; ++i) S.AddPoint(R[i]); // copy new samples to P
     S.nVertices = c;      // reset vertex count                                
  }
  
  int ResampleAccordingToMaxAccelaration(Points S, float maxAccelaration)
  {
    return ResampleAccordingToMaxAccelarationAux(this, S, maxAccelaration);
  }
}
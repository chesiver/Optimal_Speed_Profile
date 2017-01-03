float n(float a, float A, float b, float B, float t) {return A+(t-a)/(b-a)*(B-A);}
float n(float a, float A, float b, float B, float c, float C, float t) {return n(a,n(a,A,b,B,t),c,n(b,B,c,C,t),t);}
float n(float a, float A, float b, float B, float c, float C, float d, float D, float t) {return n(a,n(a,A,b,B,c,C,t),d,n(b,B,c,C,d,D,t),t);}

Point N(float a, Point A, float b, Point B, float t) {return new Point(A,(t-a)/(b-a),new Vector(A,B));}
Point N(float a, Point A, float b, Point B, float c, Point C, float t) {return N(a,N(a,A,b,B,t),c,N(b,B,c,C,t),t);}
Point N(float a, Point A, float b, Point B, float c, Point C, float d, Point D, float t) {return N(a,N(a,A,b,B,c,C,t),d,N(b,B,c,C,d,D,t),t);}

Point Centripetal(Point A, Point B, Point C, Point D, float t) {
  float a = 0, b = sqrt(Dist(A,B)), c = b + sqrt(Dist(B,C)), d = c + sqrt(Dist(C,D)); 
  b = b / d; c = c / d; d = 1;
  return N(a,A,b,B,c,C,d,D,t); 
}

Point CentripetalMidcourseCorrected(Point A, Point B, Point C, Point D) {
  float a = 0, b = sqrt(Dist(A, B)), c = b + sqrt(Dist(B, C)), d = c + sqrt(Dist(C, D)); 
  b = b / d; c = c / d; d = 1;
  return N(a,A,b,B,c,C,d,D,n(0,a,1./3,b,2./3,c,1.,d,0.5)); 
  }
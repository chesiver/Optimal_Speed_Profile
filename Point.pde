class Point{
  float x = 0, y = 0;
  Point(){}
  Point(float x, float y){ this.x = x; this.y = y; }
  Point(Point P){this.x = P.x; this.y = P.y;}
  Point(Point P, float c, Vector V){ this.x = P.x + c * V.x; this.y = P.y + c * V.y;}
  
  void SetTo(float x, float y){this.x = x; this.y = y;}
  void SetTo(Point P){ this.x = P.x; this.y = P.y;}
  
  void moveWithMouse() { this.x += mouseX-pmouseX; this.y += mouseY-pmouseY;}
  
  //display
  void Display(){ vertex(this.x, this.y); };
  void Show(float r){ ellipse(this.x, this.y, 2 * r, 2 * r);} // shows point as disk of radius r
}

//create
Point ScreenCenter(){return new Point(width / 2.0, height / 2.0);}
Point Mouse(){ return new Point(mouseX, mouseY); }
Point MoveByDistanceTowards(Point P, float d, Point Q) { return new Point(P, d, Unit(new Vector(P,Q)));}

//measure
float Dist2(Point a, Point b){ return sq(a.x - b.x) + sq(a.y - b.y);}
float Dist(Point a, Point b){return sqrt(Dist2(a, b));}
boolean isSame(Point a, Point b){return a.x == b.x && a.y == b.y;}

//transform
Point Translate(Point P, Vector V) {return new Point(P.x + V.x, P.y + V.y); }   
Point Rotation(Point A, float angle, Point C){
  float dx = A.x - C.x, dy = A.y - C.y;
  float c = cos(angle), s = sin(angle);
  return new Point(C.x + dx * c - dy * s, C.y + dx * s + dy *c);
}

//display
void Display(Point P){ vertex(P.x, P.y); };



class Vector{
  float x = 0, y = 0;
  Vector(){}
  Vector(float x, float y){ this.x = x; this.y = y;}
  Vector(Point A, Point B){ this.x = B.x - A.x; this.y = B.y - A.y;}
  
  void SetTo(float _x, float _y){ x = _x; y = _y;}
  void SetTo(Vector V){ x = V.x; y = V.y;}
  
}

//create
Vector Unit(Vector V){
  float d = sqrt(sq(V.x) + sq(V.y));
  return new Vector(V.x / d, V.y / d);
}

//measure
float Dot(Vector U, Vector V) { return U.x * V.x + U.y * V.y; }    
float Det(Vector U, Vector V) { return Dot(Rotate(U), V); }
float Norm(Vector V){ return sqrt(Dot(V, V)); }

//transform
Vector Rotate(Vector V){ return new Vector(-V.y, V.x); }
Vector Rotate(Vector V, float a){
  float c = cos(a), s = sin(a);
  return new Vector(c * V.x- s * V.y, s * V.x + c * V.y); 
}

//operation 
Vector Sum(Vector A, Vector B){return new Vector(A.x + B.x, A.y + B.y);}

// display 
void Show(Point P, Vector V) {line(P.x, P.y, P.x + V.x, P.y + V.y); }
void Show(Point P, float s, Vector V) {line(P.x, P.y, P.x + s * V.x, P.y + s * V.y); }
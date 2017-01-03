//colors
color black = #000000, white = #FFFFFF, green=#00FF01, yellow=#FEFF00, grey=#5F5F5F, lgrey=#BFBFBF, red=#FF0000,
      magenta=#FF00FB, blue=#0300FF, cyan=#00FDFF, purple = #80189D, pink = #F55211;

void Pen(color c, float w) {stroke(c); strokeWeight(w);}

void scribeHeader(String S, int i) { text(S,10,20+i*20); noFill();} // writes black at line i
void scribeHeaderRight(String S) {fill(0); text(S,width - 100, 20); noFill();} // writes black on screen top, right-aligned
void scribeHeaderRightDown(String S) {fill(0); text(S,width - 250, 20); noFill();} // 

PImage myFace, RodFace;

void displayHeader(){
  scribeHeaderRight("Yidong Liu"); 
  scribeHeaderRightDown("Rodrigo Borela Valente");
  image(myFace, width-100, 25, myFace.width / 4, myFace.height / 4); 
  image(RodFace, width-200, 25, RodFace.width / 2, RodFace.height / 2); 
}
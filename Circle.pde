class Round {
  
  int x;
  int y;
  int w;
  int h;
 Round(int x_, int y_) {
  x = x_;
  y = y_; 
  w = 50;
  h = 50;
 } 
  
  void display() {
  pushMatrix();
  translate(x, y);
  fill(255);
  ellipse(0,0, w, h);
  popMatrix();
  
  }
  
}

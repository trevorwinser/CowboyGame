class Collision {
  AnimatedImage Blood = new AnimatedImage("Images/Blood", "png", 1, 1, 0, 0);
  float x, y;
  Collision next;
  
  Collision(float x, float y, Collision next) {
    this.x = x;
    this.y = y;
    this.next = next;
  }
  void draw() {
  Blood.draw(x, y);
    
    if (next != null) {
      next.draw();
    }
  }
}

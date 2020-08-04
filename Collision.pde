class Collision {
  float x, y;
  Collision next;
  
  Collision(float x, float y, Collision next) {
    this.x = x;
    this.y = y;
    this.next = next;
  }
  
  void draw() {
    fill(255, 0, 0);
    stroke(255, 0, 0);
    
    ellipse(x, y, 20, 20);
    
    if (next != null) {
      next.draw();
    }
  }
}

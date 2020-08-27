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
    //Creates a new object for each time a blood splatter occurs (this allows multiple blood splatters being visible instead of just the latest one)
    if (next != null) {
      next.draw();
    }
  }
}

class Cactus {
  //uses AnimatedImage to create a cactus animation that can start on either frame 0 or 1, and have a random pause between cycling
  float x, y;
  AnimatedImage cactusImage;
  Cactus(float x, float y) {
    this.x = x;
    this.y = y;
    for (int i = 0; i < cacti.length; i++) {
      cactusImage = new AnimatedImage("Images/Cactus", "png", 2, 30, int(random(2)), int(random(10)));
    }
  }
  void draw() {
    cactusImage.draw(x, y);
  }
}

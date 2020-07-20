class Cactus {
  float x, y;
  AnimatedImage cactusImage;
    Cactus(float x, float y) {
    this.x = x;
    this.y = y;
    for (int i = 0; i < cacti.length; i++) {
      cactusImage = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/Cactus", "png", 2, 30, int(random(2)), int(random(10)));
    }
  }
  void draw() {
    cactusImage.draw(x, y);
  }
}

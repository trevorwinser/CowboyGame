class Health {
  //thing that will track the amount of health the player has, making a for loop for skulls and health
  PImage hp, skull;
  int healthCounter = 10;
  Health() {
    skull = loadImage("Images/Health1.png");
    hp = loadImage("Images/Health2.png");
  }
  void draw() {
    for (int i = 0; i < 10; i++) {
     image(skull, cowboy.position.x - cowboy.currentImage.height/2 + (i*skull.width) - 5, cowboy.position.y - cowboy.currentImage.height/2 - 10); 
    }
    for (int i = 0; i < healthCounter; i++) {
           image(hp, cowboy.position.x - cowboy.currentImage.height/2 + (i*skull.width) - 5, cowboy.position.y - cowboy.currentImage.height/2 - 10); 
    }
  }
}

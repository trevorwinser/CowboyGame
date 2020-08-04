class Zombie {
  
  int direction;
  float oldPosX, oldPosY, rotation, speed, intelligence;
  PVector position = new PVector();
  AnimatedImage currentImage, imageWalkingLeft, imageWalkingRight, imageHurtLeft, imageHurtRight;
  Zombie(float positionx, float positiony) {
    this.position.x = positionx;
    this.position.y = positiony;
    speed = random(5, 10);
    intelligence = random(3, 8);
    //creates a health system, that allows smarter zombies to have higher health, and faster zombies have less
    imageWalkingLeft = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/ZombieWalkingLeft", "png", 2, 10, 0, 0);
    imageWalkingRight = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/ZombieWalkingRight", "png", 2, 10, 0, 0);
    imageHurtLeft = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/ZombieHurtLeft", "png", 3, 1, 0, 0);
    imageHurtRight = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/ZombieHurtRight", "png", 3, 1, 0, 0);
    currentImage = imageWalkingRight;
  }
  void draw() {
    currentImage.draw(position.x, position.y);
    decideMovement();
    update();
  }
  void decideMovement() {
    //checks if the zombie is smart enough to catch the players scent, the higher the intelligence, the higher the range.
    if (dist(cowboy.position.x, cowboy.position.y, position.x, position.y) < intelligence * 100) {
      oldPosX = cowboy.position.x;
      oldPosY = cowboy.position.y;
      rotation = atan2(oldPosY - position.y, oldPosX - position.x) / PI * 180;
      direction = 9;
      //creates a chance every frame to change random movement if not within distance of player
    } else if (random(10) > 9.5) {
      direction = int(random(9));
    }
  }
  void update() {
    switch (direction) {
    case 0:
      position.y -= speed;
      break;
    case 1:
      position.x += speed;
      position.y -= speed;
      currentImage = imageWalkingRight;
      break;
    case 2:
      position.x += speed;
      currentImage = imageWalkingRight;
      break;
    case 3:
      position.x += speed;
      position.y += speed;
      currentImage = imageWalkingRight;
      break;
    case 4:
      position.y += speed;
      break;
    case 5:
      position.x -= speed;
      position.y += speed;
      currentImage = imageWalkingLeft;
      break;
    case 6:
      position.x -= speed;
      currentImage = imageWalkingLeft;
      break;
    case 7:
      position.x -= speed;
      position.y -= speed;
      currentImage = imageWalkingLeft;
      break;
    case 8:
      break;
    case 9:
      position.x = position.x + cos(rotation/180*PI)*speed;
      position.y = position.y + sin(rotation/180*PI)*speed;
      if (oldPosX > position.x) {
        currentImage = imageWalkingRight;
      } else {
        currentImage = imageWalkingLeft;
      }
      break;
    } 
    position.x = constrain(position.x, 0, width-currentImage.width/2);
    position.y = constrain(position.y, 0, height-currentImage.height/2);
  }
}

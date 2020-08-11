class Zombie {
  int health;
  int direction;
  int hurtCount;
  float oldPosX, oldPosY, rotation, speed, intelligence;
  PVector position = new PVector();
  boolean hurt;
  AnimatedImage currentImage, imageWalkingLeft, imageWalkingRight, imageHurtLeft, imageHurtRight;
  Zombie(float positionx, float positiony) {
    speed = random(5, 8);
    intelligence = random(5, 8);
    health = int(speed/intelligence*5);
    //creates a health system, that allows smarter zombies to have higher health, and faster zombies have less
    imageWalkingLeft = new AnimatedImage("Images/ZombieWalkingLeft", "png", 2, 10, 0, 0);
    imageWalkingRight = new AnimatedImage("Images/ZombieWalkingRight", "png", 2, 10, 0, 0);
    imageHurtLeft = new AnimatedImage("Images/ZombieHurtLeft", "png", 3, 1, 0, 0);
    imageHurtRight = new AnimatedImage("Images/ZombieHurtRight", "png", 3, 1, 0, 0);
    currentImage = imageWalkingRight;
    switch(int(positionx)) {
    case 0:
      this.position.x = currentImage.width;
      break;
    case 1:
      this.position.x = width - currentImage.width;
      break;
    }
    switch (int(positiony)) {
    case 0:
      this.position.y = currentImage.height;
      break;
    case 1:
      this.position.y = height - currentImage.height;
      break;
    }
  }
  void draw() {
    currentImage.draw(position.x, position.y);
    decideMovement();
    update();
  }
  void startHurt() {
    hurt = true;
    hurtCount = 0;
    if (health > 0) {
      health--;
    }
  }

  void updateHurt() {
    if (++hurtCount > 5) {
      hurt = false;
    }
  }
  void decideMovement() {
    //checks if the zombie is smart enough to catch the players scent, the higher the intelligence, the higher the range.
    if (dist(cowboy.position.x, cowboy.position.y, position.x, position.y) < intelligence * width/12) {
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
    updateHurt();
    switch (direction) {
    case 0:
      position.y -= speed;
      break;
    case 1:
      position.x += speed;
      position.y -= speed;
      if (hurt) {
        currentImage = imageHurtRight;
      } else {
        currentImage = imageWalkingRight;
      }
      break;
    case 2:
      position.x += speed;
      if (hurt) {
        currentImage = imageHurtRight;
      } else {
        currentImage = imageWalkingRight;
      }
      break;
    case 3:
      position.x += speed;
      position.y += speed;
      if (hurt) {
        currentImage = imageHurtRight;
      } else {
        currentImage = imageWalkingRight;
      }
      break;
    case 4:
      position.y += speed;
      break;
    case 5:
      position.x -= speed;
      position.y += speed;
      if (hurt) {
        currentImage = imageHurtLeft;
      } else {
        currentImage = imageWalkingLeft;
      }
      break;
    case 6:
      position.x -= speed;
      if (hurt) {
        currentImage = imageHurtLeft;
      } else {
        currentImage = imageWalkingLeft;
      }
      break;
    case 7:
      position.x -= speed;
      position.y -= speed;
      if (hurt) {
        currentImage = imageHurtLeft;
      } else {
        currentImage = imageWalkingLeft;
      }
      break;
    case 8:
      break;
    case 9:
      //follows player at optimal speed (without the *2 and /sqrt(2) it would be slower diagonally)
      position.x = position.x + cos(rotation/180*PI)*speed*2/sqrt(2);
      position.y = position.y + sin(rotation/180*PI)*speed*2/sqrt(2);
      if (oldPosX > position.x) {
        if (hurt) {
          currentImage = imageHurtRight;
        } else {

          currentImage = imageWalkingRight;
        }
      } else {
        if (hurt) {
          currentImage = imageHurtLeft;
        } else {
          currentImage = imageWalkingLeft;
        }
      }
      break;
    } 
    position.x = constrain(position.x, 0, width-currentImage.width/2);
    position.y = constrain(position.y, 0, height-currentImage.height/2);
  }
}

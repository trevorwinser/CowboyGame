class Cowboy {
  //didn't explain it earlier, but over the summer, my dad taught me a lot about programming. I learned PVector's to the extent of understanding how to manipulate them on a basic level. I'm not perfect at it, but I use it to make movement for multiple things a lot easier for myself.
  PVector position = new PVector(width/2, height/2);
  boolean facingRight = false;
  int idleCount = 0;
  int hurtCount = 0;
  boolean hurt;
  boolean idle;
  boolean canShoot = true;
  float delay, shotTimer;
  AnimatedImage imageIdle, imageWalkingLeft, imageWalkingRight, imageHurt, imageDead;
  AnimatedImage currentImage;
  Cowboy() {
    delay = 15;
    imageIdle = new AnimatedImage("Images/CowboyIdle", "png", 2, 30, 0, 0);
    imageWalkingLeft = new AnimatedImage("Images/CowboyWalkingLeft", "png", 2, 10, 0, 0);
    imageWalkingRight = new AnimatedImage("Images/CowboyWalkingRight", "png", 2, 10, 0, 0);
    imageHurt = new AnimatedImage("Images/CowboyHurt", "png", 3, 1, 0, 0);
    imageDead = new AnimatedImage("Images/CowboyDead", "png", 1, 1, 0, 0);
    currentImage = imageIdle;
  }
  //this forces the player to move otherwise they won't be able to shoot after 1.5 seconds of standing still
  boolean isIdle() {
    return idleCount > 90;
  }
  //checks healthCounter in health class to determine if player is dead
      boolean isDead() {
    return health.healthCounter == 0;
  }
  void draw() {
    //draws whatever the set image is at the position of the player
    currentImage.draw(position.x, position.y);
    //if you stand still or are dead, obviously you can't shoot
    if (!isDead() && !isIdle()) {
      drawWeaponCrosshair();
    }
    //makes it so player can't do anything if dead
    if (!isDead()) {
      update();
    }   else {
     currentImage = imageDead; 
    }  
  }
  //simple crosshair to show where the bullet will move towards
  void drawWeaponCrosshair() {
    noFill();
    strokeWeight(3);
    stroke(250, 100, 100);
    line(mouseX - 10, mouseY, mouseX + 10, mouseY);
    line(mouseX, mouseY - 10, mouseX, mouseY + 10);
    ellipse(mouseX, mouseY, 20, 20);
  }
  //hard to explain, but to put it simply, if you are hurt, you can't be hurt for another 1.5 seconds, if you're not dead, you will lose health
  void startHurt() {
    canShoot = false;
    hurt = true;
    hurtCount = 0;
    if (health.healthCounter > 0) {
      health.healthCounter--;
    }
  }
  void updateHurt() {
    //creates an update for the hurtCount every frame, and checks if it has been 1.5 seconds since they were hurt, if so, they can get hurt again
    if (++hurtCount > 90) {
      hurt = false;
    }
  }
  void update() {
    updateHurt();
    //the idleCount increases no matter what, but will be set to 0 if movement is made
    idleCount++;
    if (up) {
      idleCount = 0;
      position.y -= 10;
    }
    if (down) {
      idleCount = 0;
      position.y += 10;
    }
    if (left) {
      idleCount = 0;
      position.x -= 10;
    }
    if (right) {
      idleCount = 0;
      position.x += 10;
    }
    //makes it so the player can't leave the screen
    position.x = constrain(position.x, currentImage.width/2, width - currentImage.width/2);
    position.y = constrain(position.y, currentImage.height/2, height - currentImage.height/2);

    if (position.x < mouseX) {
      facingRight = true;
    } else if (position.x > mouseX) {

      facingRight = false;
    }
    if (mousePressed) {
      //checks if player can shoot, makes player unable to shoot for a set delay, and then creates a bullet, with the starting position of the player x, y
      if (canShoot) {
        canShoot = false;
        shotTimer = 0;
        bullets.add( new Bullet(position.copy()));
      }
    }
    if (canShoot == false) {
      shotTimer++;
    }
    if (shotTimer >= delay) {
      canShoot = true;
    }
    if (health.healthCounter == 0) {
      currentImage = imageDead;
    } else if (hurt && hurtCount < 16) {
      currentImage = imageHurt;
      //if you're idle, you cannot shoot, this is to avoid camping
    } else if (isIdle()) {
      canShoot = false;
      currentImage = imageIdle;
    } else {
      if (facingRight) {
        currentImage = imageWalkingRight;
      } else {
        currentImage = imageWalkingLeft;
      }
    }
  }
}

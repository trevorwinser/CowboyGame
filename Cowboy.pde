class Cowboy {
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
  boolean isIdle() {
    return idleCount > 90;
  }
      boolean isDead() {
    return health.healthCounter == 0;
  }
  void draw() {
    currentImage.draw(position.x, position.y);
    if (!isDead() && !isIdle()) {
      drawWeaponCrosshair();
    }
    if (!isDead()) {
      update();
    }   else {
     currentImage = imageDead; 
    }  
  }
  void drawWeaponCrosshair() {
    noFill();
    strokeWeight(3);
    stroke(250, 100, 100);
    line(mouseX - 10, mouseY, mouseX + 10, mouseY);
    line(mouseX, mouseY - 10, mouseX, mouseY + 10);
    ellipse(mouseX, mouseY, 20, 20);
  }
  void startHurt() {
    canShoot = false;
    hurt = true;
    hurtCount = 0;
    if (health.healthCounter > 0) {
      health.healthCounter--;
    }
  }
  void updateHurt() {
    if (++hurtCount > 90) {
      hurt = false;
    }
  }
  void update() {
    updateHurt();
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
    position.x = constrain(position.x, currentImage.width/2, width - currentImage.width/2);
    position.y = constrain(position.y, currentImage.height/2, height - currentImage.height/2);

    if (position.x < mouseX) {
      facingRight = true;
    } else if (position.x > mouseX) {

      facingRight = false;
    }
    if (mousePressed) {
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

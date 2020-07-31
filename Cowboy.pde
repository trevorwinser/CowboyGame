class Cowboy {
  PVector position = new PVector(width/2, height/2);
  boolean facingRight = false;
  int idleCount = 0;
  int hurtCount = 0;
  boolean hurt;
  boolean idle;
  boolean canShoot = true;

  float delay, shotTimer;
  int health = 10;
  AnimatedImage imageIdle, imageWalkingLeft, imageWalkingRight, imageHurt, imageDead;
  AnimatedImage currentImage;
  Cowboy() {
    delay = 15;
    imageIdle = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/CowboyIdle", "png", 2, 30, 0, 0);
    imageWalkingLeft = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/CowboyWalkingLeft", "png", 2, 10, 0, 0);
    imageWalkingRight = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/CowboyWalkingRight", "png", 2, 10, 0, 0);
    imageHurt = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/CowboyHurt", "png", 3, 1, 0, 0);
    imageDead = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/CowboyHurt", "png", 1, 1, 0, 0);

    currentImage = imageIdle;
  }

  boolean isIdle() {
    return idleCount > 90;
  }
  boolean isDead() {
    return health == 0;
  }

  void draw() {

    currentImage.draw(position.x, position.y);
    if (!isDead() && !isIdle()) {
      drawWeaponCrosshair();
    }

    if (!isDead()) {
      update();
    }    


    fill(0);
    text("Health " + nf(health), position.x + 90, position.y);
    if (isIdle()) {
      text("Idle", position.x + 90, position.y + 10);
    }
  }

  void drawWeaponCrosshair() {
    noFill();
    strokeWeight(3);
    stroke(200, 100, 100);
    line(mouseX - 10, mouseY, mouseX + 10, mouseY);
    line(mouseX, mouseY - 10, mouseX, mouseY + 10);
    ellipse(mouseX, mouseY, 20, 20);
  }

  void startHurt() {
    canShoot = false;
    hurt = true;
    hurtCount = 0;
    if (health > 0) {
      health--;
    }
  }

  void stopHurt() {
    hurt = false;
  }
  void updateHurt() {
    if (++hurtCount > 90) {
      hurt = false;
    }
  }

  void update() {
    if (!hurt) {
      if (dist(position.x, position.y, zombie.position.x, zombie.position.y) < 80) {
        startHurt();
      } else {
        for (int i = 0; i < cacti.length; i++) {
          if (dist(position.x, position.y, cacti[i].x, cacti[i].y) < 80 ) {
            startHurt();
            break;
          }
        }
      }
    }
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

    if (health == 0) {
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

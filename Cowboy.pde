class Cowboy {
  PVector position = new PVector(width/2, height/2);
  boolean facingRight = false;
  int idleCount = 0;
  AnimatedImage imageIdle, imageWalkingLeft, imageWalkingRight;
  AnimatedImage currentImage;
  Cowboy() {
    imageIdle = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/CowboyIdle", "png", 2, 30, 0, 0);
    imageWalkingLeft = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/CowboyWalkingLeft", "png", 2, 10, 0, 0);
    imageWalkingRight = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/CowboyWalkingRight", "png", 2, 10, 0, 0);
  }
  void draw() {
    if (idleCount > 90) {
      //idle = true;
      canShoot = false;
      currentImage = imageIdle;
    } else {
      if (facingRight) {
        currentImage = imageWalkingRight;
      } else {
        currentImage = imageWalkingLeft;
      }
      drawWeaponCrosshair();
    }
    currentImage.draw(position.x, position.y);
    update();
  }

  void drawWeaponCrosshair() {
    noFill();
    strokeWeight(3);
    stroke(200, 100, 100);
    line(mouseX - 10, mouseY, mouseX + 10, mouseY);
    line(mouseX, mouseY - 10, mouseX, mouseY + 10);
    ellipse(mouseX, mouseY, 20, 20);
  }
  void update() {
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
    position.x = constrain(position.x, 0, width-currentImage.width);
    position.y = constrain(position.y, 0, height-currentImage.height);

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
  }
}

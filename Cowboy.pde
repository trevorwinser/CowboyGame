class Cowboy {
  PVector position = new PVector(width/2, height/2);
  boolean facingRight = false;
  int idleCount = 0;
  PVector weaponDirection = new PVector(0, 0);
  AnimatedImage imageIdle, imageWalkingLeft, imageWalkingRight;
  AnimatedImage currentImage;
  Cowboy() {
    imageIdle = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/CowboyIdle", "png", 2, 30);
    imageWalkingLeft = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/CowboyWalkingLeft", "png", 2, 30);
    imageWalkingRight = new AnimatedImage("C:/Users/Trevor/Documents/Processing/CowboyGame/Images/CowboyWalkingRight", "png", 2, 30);
  }
  void draw() {
    if (idleCount > 300) {
      //idle = true;
      currentImage = imageIdle;
    } else {
      if (facingRight) {
        currentImage = imageWalkingRight;
      } else {
        currentImage = imageWalkingLeft;
      }
    }

    currentImage.draw(position.x, position.y);
    drawWeaponCrosshair();
    // drawWeapon();

    update();
  }

  void drawWeaponCrosshair() {
    noFill();
    stroke(0);
    line(mouseX - 10, mouseY, mouseX + 10, mouseY);
    line(mouseX, mouseY - 10, mouseX, mouseY + 10);
    ellipse(mouseX, mouseY, 20, 20);
  }

  void drawWeapon() {
    float xOffset = position.x + currentImage.width / 2;
    float yOffset = position.y + currentImage.height / 2;
    pushMatrix();
    translate(xOffset, yOffset);

    stroke(255);
    PVector weapon = weaponDirection.copy();
    line(0, 0, weapon.x - xOffset, weapon.y - yOffset); 
    popMatrix();
  }
  void update() {
    float previousX = position.x;

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

    weaponDirection.x = mouseX;
    weaponDirection.y = mouseY;
  }
}

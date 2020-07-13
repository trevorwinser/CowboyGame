class Cowboy {
  PVector position = new PVector(width/2, height/2);
  PVector weaponDirection = new PVector(0, 0);
  Cowboy() {
  }
  void draw() {
    image(cowboyImage, position.x, position.y);

  drawWeaponCrosshair();
  drawWeapon();

    update();
  }

  void drawWeaponCrosshair() {
    noFill();
    stroke(255);
    line(mouseX - 10, mouseY, mouseX + 10, mouseY);
    line(mouseX, mouseY - 10, mouseX, mouseY + 10);
    ellipse(mouseX, mouseY, 20, 20);
  }
  
  void drawWeapon() {
    float xOffset = position.x + cowboyImage.width / 2;
    float yOffset = position.y + cowboyImage.height / 2;
    pushMatrix();
    translate(xOffset, yOffset);
    
    stroke(255);
    PVector weapon = weaponDirection.copy();
    line(0, 0, weapon.x - xOffset, weapon.y - yOffset); 
    popMatrix();
  }
  void update() {
    if (up) {
      position.y -= 10;
    }
    if (down) {
      position.y += 10;
    }
    if (left) {
      position.x -= 10;
    }
    if (right) {
      position.x += 10;
    }
    position.x = constrain(position.x, 0, width-cowboyImage.width);
    position.y = constrain(position.y, 0, height-cowboyImage.height);
    
    weaponDirection.x = mouseX;
    weaponDirection.y = mouseY;
  }
}

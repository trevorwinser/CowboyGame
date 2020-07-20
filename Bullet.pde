class Bullet {
  //standard PVector used for the origin of the bullet
  PVector origin;
  //vars used to check the angle between origin and the mouse
  float oldPosX, oldPosY, rotation, speed;
  Bullet(PVector origin) {
    //places the bullet in the middle of the room
    this.origin = origin;
    //this checks the angle
    oldPosX = mouseX;
    oldPosY = mouseY;
    rotation = atan2(oldPosY - origin.y, oldPosX - origin.x) / PI * 180;
    //bullet speed
    speed = 30;//change this number to change the speed
  } 
  void update() {
    //move the bullet
    origin.x = origin.x + cos(rotation/180*PI)*speed;
    origin.y = origin.y + sin(rotation/180*PI)*speed;
    stroke(150,120,50);
    line (origin.x, origin.y, (origin.x + cos(rotation/180*PI)*speed), (origin.y + sin(rotation/180*PI)*speed));
    if (origin.x > 0 && origin.x < width && origin.y > 0 && origin.y < height) {
    } else {
      bullets.remove(i);
    }
  }
}

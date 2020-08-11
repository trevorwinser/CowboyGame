class Bullet {
  //standard PVector used for the origin of the bullet
  PVector origin;
  int frame;
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
  boolean update() {
    //move the bullet
    origin.x = origin.x + cos(rotation/180*PI)*speed;
    origin.y = origin.y + sin(rotation/180*PI)*speed;
    stroke(240, 170, 100);
    line (origin.x, origin.y, (origin.x + cos(rotation/180*PI)*speed), (origin.y + sin(rotation/180*PI)*speed));
    //creates a test for if the bullet is on the screen
    if (origin.x > 0 && origin.x < width && origin.y > 0 && origin.y < height) {
      return false;
    } else {
      return true;
    }
  }
}

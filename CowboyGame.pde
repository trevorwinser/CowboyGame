PImage cowboyImage;
Cowboy cowboy;
boolean up, down, left, right, shoot;
void setup() {
  fullScreen();
  cowboyImage = loadImage("Images/Cowboy.png");
  cowboy = new Cowboy();
}
void draw() {
  background(0);
  cowboy.draw();
}
void keyPressed() {
  switch(key) {
  case 'a':
  left = true;
  break;
  case 'd':
  right = true;
  break;
  case 'w':
  up = true;
  break;
  case 's':
  down = true;
  break;
  case ' ':
  shoot = true;
  break;
  }
  
}

void keyReleased() {
  switch(key) {
  case 'a':
  left = false;
  break;
  case 'd':
  right = false;
  break;
  case 'w':
  up = false;
  break;
  case 's':
  down = false;
  break;
  case ' ':
  shoot = false;
  break;
  }
}

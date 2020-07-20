Cowboy cowboy;
AnimatedImage image;
Cactus[] cacti;
ArrayList<Bullet> bullets;
boolean up, down, left, right, shoot;
boolean canShoot;
float delay, shotTimer;
int i;
//Vars to regulate shooting speed
void setup() {
  //sets the time between each shot in seconds divided by 60(frames)
  delay = 15;
  imageMode(CENTER);
  fullScreen();
  //fullScreen();
  cowboy = new Cowboy();
  cacti = new Cactus[10];
  for (int i = 0; i < cacti.length; i++) {
    cacti[i] = new Cactus(random(width), random(height));
  }
  bullets = new ArrayList<Bullet>();
}
void draw() {
  background(#D3C886);

  for (int i = 0; i < cacti.length; i++) {
    cacti[i].draw();
  }
  cowboy.draw();
  for (i = bullets.size()-1; i >= 0; i--) {
    Bullet bullet = bullets.get(i);
    bullet.update();
  }
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

Cowboy cowboy; //<>//
AnimatedImage image;
Cactus[] cacti;
Zombie zombie;
//ArrayList<Zombie> zombies;
ArrayList<Bullet> bullets;
boolean up, down, left, right, shoot;

//Vars to regulate shooting speed
void setup() {
  //sets the time between each shot in seconds divided by 60(frames)

  imageMode(CENTER);
  fullScreen();
  //fullScreen();
  cowboy = new Cowboy();
  cacti = new Cactus[10];
  for (int i = 0; i < cacti.length; i++) {
    cacti[i] = new Cactus(random(width), random(height));
  }
  bullets = new ArrayList<Bullet>();
  zombie = new Zombie(random(width), random(height));
  //zombies = new ArrayList<Zombie>();
}
void draw() {
  background(#D3C886);

  for (int i = 0; i < cacti.length; i++) {
    cacti[i].draw();
  }
  zombie.draw();
  //zombies.add( new Zombie(random(width), random(height)));
  cowboy.draw();

  for (int i = 0; i < bullets.size(); ) {
    Bullet bullet = bullets.get(i);
    if (bullet.update()) {
      bullets.remove(i) ;
    } else {
      i++;
    }
  }

  if (cowboy.isDead()) {
    filter(GRAY);
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

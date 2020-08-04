Cowboy cowboy; //<>//
AnimatedImage image;
Cactus[] cacti;
Collision collision;
ArrayList<Zombie> zombies;
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
  zombies = new ArrayList<Zombie>();
  for (int i = 0; i < 5; i++) {
    zombies.add(new Zombie(random(width), random(height)));
  }
}
void draw() {
  background(#D3C886);

  for (int i = 0; i < cacti.length; i++) {
    cacti[i].draw();
  }
  for (int i = 0; i < zombies.size(); i++) {
    zombies.get(i).draw();
  }
  cowboy.draw();

  for (int i = 0; i < bullets.size(); ) {
    Bullet bullet = bullets.get(i);
    if (bullet.update()) {
      bullets.remove(i) ;
    } else {
      i++;
    }
  }

  updateCollision();

  if (cowboy.isDead()) {
    filter(GRAY);
  }
}


void updateCollision() {

  collisionCactus();
  collisionZombie();
  collisionBullet();
}
void  collisionCactus() {
  if (cowboy.hurt == false) {
    for (int i = 0; i < cacti.length; i++) {
      if (dist(cowboy.position.x, cowboy.position.y, cacti[i].x, cacti[i].y) < 80 ) {
        cowboy.startHurt();
        break;
      }
    }
  }
}
void collisionZombie() {
  if (cowboy.hurt == false) {
    for (int i = 0; i < zombies.size(); i++) {

      if (dist(cowboy.position.x, cowboy.position.y, zombies.get(i).position.x, zombies.get(i).position.y) < 80) {


        cowboy.startHurt();
        break;
      }
    }
  }
}
void collisionBullet() {
  for (int i = 0; i < bullets.size(); i++) {
    Bullet bullet = bullets.get(i);
    for (int j = 0; j < zombies.size(); j++) {
      Zombie zombie = zombies.get(j);  
        if (dist(bullet.origin.x, bullet.origin.y, zombie.position.x, zombie.position.y) < 40) {
          zombies.remove(j);
          break;
        }
    }
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

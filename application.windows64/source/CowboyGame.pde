Cowboy cowboy;
AnimatedImage image;
//called it cacti because its funny as a plural of cactus
Cactus[] cacti;
Wave wave;
Health health;
ArrayList<Zombie> zombies;
ArrayList<Bullet> bullets;
boolean up, down, left, right, start, restart, help;
Collision collisionList = null;
void setup() {
  //this imageMode, makes it easier to detect collision, if it were corners, a different check would have to be made
  imageMode(CENTER);
  help = true;
  fullScreen();
  wave = new Wave();
  cowboy = new Cowboy();
  health = new Health();
  cacti = new Cactus[10];
  for (int i = 0; i < cacti.length; i++) {
    cacti[i] = new Cactus(random(width), random(height));
  }
  bullets = new ArrayList<Bullet>();
  zombies = new ArrayList<Zombie>();
}
void draw() {
  //draws things in order of priority (cowboy should be over everything for user visibility)
  background(#FAE56F);
  if (collisionList != null) {
    collisionList.draw();
  }
  //draws the cacti given the amount in the array
  for (int i = 0; i < cacti.length; i++) {
    cacti[i].draw();
  }
    //draws the zombies given the amount in the array
  for (int i = 0; i < zombies.size(); i++) {
    zombies.get(i).draw();
  }
  cowboy.draw();
  health.draw();
  //checks each bullet if they are out of bounds, if so, it removes the bullet that is, otherwise, it checks the next bullet
  for (int i = 0; i < bullets.size(); ) {
    Bullet bullet = bullets.get(i);
    if (bullet.update()) {
      bullets.remove(i) ;
    } else {
      i++;
    }
  }
  if (help) {
    helpMenu();
  }
  wave.draw();
  updateCollision();
}
void mousePressed() {
  //this is for the button that changes difficulty level
  if (wave.currentWave == 0) {
    if (dist(mouseX, mouseY, width/2, height/3) < 100) {
      wave.difficulty++;
      if (wave.difficulty > 3) {
        wave.difficulty = 1;
      }
    }
  }
}

void updateCollision() {
  //check if the player is already hurt
  if (cowboy.hurt == false) {
    collisionCactus();
    collisionZombie();
  }
  collisionBullet();
}
void  collisionCactus() {
  //check if there's a cactus intersecting with the cowboy. If there is hurt the player.
  for (int i = 0; i < cacti.length; i++) {
    if (dist(cowboy.position.x, cowboy.position.y, cacti[i].x, cacti[i].y) < 80 ) {
      cowboy.startHurt();
      break;
    }
  }
}
void collisionZombie() {
  //check if there's a zombie intersecting with the cowboy. If there is hurt the player.

  for (int i = 0; i < zombies.size(); i++) {
    if (dist(cowboy.position.x, cowboy.position.y, zombies.get(i).position.x, zombies.get(i).position.y) < 80) {
      collisionList = new Collision(cowboy.position.x, cowboy.position.y, collisionList);
      cowboy.startHurt();
      break;
    }
  }
}
void collisionBullet() {
  //for every bullet check if it interacts with any zombie the moment it does, hurt the zombie, and stop checking for bullet interaction (this happens every frame so the cases where it messes up aren't noticeable)
  for (int i = 0; i < bullets.size(); i++) {
    Bullet bullet = bullets.get(i);
    for (int j = 0; j < zombies.size(); j++) {
      Zombie zombie = zombies.get(j);  
      if (dist(bullet.origin.x, bullet.origin.y, zombie.position.x, zombie.position.y) < 40) {
        zombie.startHurt();
        if (zombie.health == 0) {
          zombies.remove(j);
        }
        break;
      }
    }
  }
}
void helpMenu() {
  //simple helpmenu that appears at the start of the game so the user understands how to interact with the program
  textAlign(CENTER);
  text("WASD for movement", width/2, 20);
  text("SPACE to start", width/2, 40);
  text("R to restart", width/2, 60);
  text("H to toggle help menu", width/2, 80);
  text("Left click to shoot", width/2, 100);
  text("Objective is to finish as many waves possible before dying", width/2, 120);
}
void keyPressed() {
  //switch case to detect which key is being pressed, if it isn't one of these keys it won't affect the booleans.
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
    start = true;
    break;
  case 'r':
    restart = true;
    break;
    //the reason this isn't on keyReleased is so the user can toggle the help menu themself rather than it being off by default.
  case 'h':
    help = !help;
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
    start = false;
    break;
  case 'r':
    restart = false;
    break;
  }
}

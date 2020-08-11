import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class CowboyGame extends PApplet {

Cowboy cowboy;
AnimatedImage image;
Cactus[] cacti;
Wave wave;
ArrayList<Zombie> zombies;
ArrayList<Bullet> bullets;
boolean up, down, left, right, start, restart;
Collision collisionList = null;
public void setup() {
  imageMode(CENTER);

  
  wave = new Wave();
  cowboy = new Cowboy();
  cacti = new Cactus[10];
  for (int i = 0; i < cacti.length; i++) {
    cacti[i] = new Cactus(random(width), random(height));
  }
  bullets = new ArrayList<Bullet>();
  zombies = new ArrayList<Zombie>();
}
public void draw() {
  background(0xffFAE56F);
  if (collisionList != null) {
    collisionList.draw();
  }
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
  wave.draw();
  updateCollision();
}
public void mousePressed() {
  if (wave.currentWave == 0) {
    if (dist(mouseX, mouseY, width/2, height/3) < 100) {
      wave.difficulty++;
      wave.update();
      if (wave.difficulty > 3) {
        wave.difficulty = 1;
        wave.update();
      }
    }
  }
}

public void updateCollision() {
  collisionCactus();
  collisionZombie();
  collisionBullet();
}
public void  collisionCactus() {
  if (cowboy.hurt == false) {
    for (int i = 0; i < cacti.length; i++) {
      if (dist(cowboy.position.x, cowboy.position.y, cacti[i].x, cacti[i].y) < 80 ) {
        cowboy.startHurt();
        break;
      }
    }
  }
}
public void collisionZombie() {
  if (cowboy.hurt == false) {
    for (int i = 0; i < zombies.size(); i++) {
      if (dist(cowboy.position.x, cowboy.position.y, zombies.get(i).position.x, zombies.get(i).position.y) < 80) {
        collisionList = new Collision(cowboy.position.x, cowboy.position.y, collisionList);
        cowboy.startHurt();
        break;
      }
    }
  }
}
public void collisionBullet() {
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

public void keyPressed() {
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
  }
}

public void keyReleased() {
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

class AnimatedImage {
  int imageCount;
  int framesPerImage;
  PImage[] images;
  int width, height;
  int offset;
  int pause;
  AnimatedImage(String filePathPrefix, String fileSuffix, int imageCount, int framesPerImage, int offset, int pause) {
    this.imageCount = imageCount;
    this.images = new PImage[imageCount];
    this.framesPerImage = framesPerImage;
    this.offset = offset;
    this.pause = pause;
    for (int i = 1; i <= this.imageCount; i++) {
      
      this.images[i-1] = loadImage(filePathPrefix + nf(i) + "." + fileSuffix);
    }
    
    this.width = this.images[0].width;
    this.height = this.images[0].height;
  }

  public void draw(float x, float y) {
    int currentImage = (((frameCount + pause ) / framesPerImage) + offset) % (imageCount + pause);
    if (currentImage >= imageCount) {
      currentImage = 0;
    }
    image(images[currentImage], x, y);
  }
}
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
  public boolean update() {
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
class Cactus {
  float x, y;
  AnimatedImage cactusImage;
  Cactus(float x, float y) {
    this.x = x;
    this.y = y;
    for (int i = 0; i < cacti.length; i++) {
      cactusImage = new AnimatedImage("Images/Cactus", "png", 2, 30, PApplet.parseInt(random(2)), PApplet.parseInt(random(10)));
    }
  }
  public void draw() {
    cactusImage.draw(x, y);
  }
}
class Collision {
  AnimatedImage Blood = new AnimatedImage("Images/Blood", "png", 1, 1, 0, 0);
  float x, y;
  Collision next;
  
  Collision(float x, float y, Collision next) {
    this.x = x;
    this.y = y;
    this.next = next;
  }
  
  public void draw() {
  Blood.draw(x, y);
    
    if (next != null) {
      next.draw();
    }
  }
}
class Cowboy {
  PVector position = new PVector(width/2, height/2);
  boolean facingRight = false;
  int idleCount = 0;
  int hurtCount = 0;
  boolean hurt;
  boolean idle;
  boolean canShoot = true;

  float delay, shotTimer;
  int health = 10;
  AnimatedImage imageIdle, imageWalkingLeft, imageWalkingRight, imageHurt, imageDead;
  AnimatedImage currentImage;
  Cowboy() {
    delay = 15;
    imageIdle = new AnimatedImage("Images/CowboyIdle", "png", 2, 30, 0, 0);
    imageWalkingLeft = new AnimatedImage("Images/CowboyWalkingLeft", "png", 2, 10, 0, 0);
    imageWalkingRight = new AnimatedImage("Images/CowboyWalkingRight", "png", 2, 10, 0, 0);
    imageHurt = new AnimatedImage("Images/CowboyHurt", "png", 3, 1, 0, 0);
    imageDead = new AnimatedImage("Images/CowboyDead", "png", 1, 1, 0, 0);

    currentImage = imageIdle;
  }

  public boolean isIdle() {
    return idleCount > 90;
  }
  public boolean isDead() {
    return health == 0;
  }

  public void draw() {

    currentImage.draw(position.x, position.y);
    if (!isDead() && !isIdle()) {
      drawWeaponCrosshair();
    }

    if (!isDead()) {
      update();
    }   else {
     currentImage = imageDead; 
    }


    fill(0);
    textAlign(LEFT);
    textSize(20);
    text("Health: " + health, 0, 60);
  }

  public void drawWeaponCrosshair() {
    noFill();
    strokeWeight(3);
    stroke(250, 100, 100);
    line(mouseX - 10, mouseY, mouseX + 10, mouseY);
    line(mouseX, mouseY - 10, mouseX, mouseY + 10);
    ellipse(mouseX, mouseY, 20, 20);
  }

  public void startHurt() {
    canShoot = false;
    hurt = true;
    hurtCount = 0;
    if (health > 0) {
      health--;
    }
  }

  public void updateHurt() {
    if (++hurtCount > 90) {
      hurt = false;
    }
  }

  public void update() {

    updateHurt();

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
    position.x = constrain(position.x, currentImage.width/2, width - currentImage.width/2);
    position.y = constrain(position.y, currentImage.height/2, height - currentImage.height/2);

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

    if (health == 0) {
      currentImage = imageDead;
    } else if (hurt && hurtCount < 16) {
      currentImage = imageHurt;
    } else if (isIdle()) {
      canShoot = false;
      currentImage = imageIdle;
    } else {
      if (facingRight) {
        currentImage = imageWalkingRight;
      } else {
        currentImage = imageWalkingLeft;
      }
    }
  }
}
class Wave {
  int currentWave = 0;
  int waveSize = 5;
  int difficulty = 1;
  int x;
  int waveCounter;
  int highestWave;
  public void draw() {
    textSize(20); 
    text("Wave: " +waveCounter, 0, 20);
        text("Highest Wave: " +highestWave, 0, 40);
    difficultySign();
    if (restart) {
      gameRestart();
    }
    if (start) {
      gameStart();
    }
    if (currentWave > 0 && zombies.size() == 0) {
      waveSuccess();
    }
    if (cowboy.isDead()) {
      waveFailure();
    }
  }
  public void gameRestart() {
    currentWave = 0;
    update();
  }
  public void gameStart() {

    if (currentWave == 0) {
      currentWave = 1;
      update();
    }
  }
  public void waveSuccess() {
    update();
  }
  public void waveFailure() {
    filter(GRAY);
  }

  public void difficultySign() {
    if (currentWave == 0) {
      rectMode(CENTER);
      stroke(0);
      fill(255);
      rect(width/2, height/3, 150, 50);
      fill(0);
      textAlign(CENTER);
      text("Difficulty: " + difficulty, width/2, height/3);
    }
  }
  public void update() {
    waveCounter++;
    x++;
    waveSize = PApplet.parseInt(difficulty * sqrt(x * difficulty));
    switch(currentWave) {
    case 0:
      x = 0;
      waveCounter = 0;
      cowboy.position.x = width/2;
      cowboy.position.y = height/2;
      cowboy.health = 10;
      for (int i = 0; i < zombies.size(); i++) {
        zombies.remove(i);
      }
      break;
    case 1:
    highestWave = waveCounter;
      for (int i = 0; i < waveSize; i++ ) {
        zombies.add(new Zombie(PApplet.parseInt(random(2)), PApplet.parseInt(random(2))));
      }
      break;
    }
  }
}
class Zombie {
  int health;
  int direction;
  int hurtCount;
  float oldPosX, oldPosY, rotation, speed, intelligence;
  PVector position = new PVector();
  boolean hurt;
  AnimatedImage currentImage, imageWalkingLeft, imageWalkingRight, imageHurtLeft, imageHurtRight;
  Zombie(float positionx, float positiony) {
    speed = random(5, 8);
    intelligence = random(5, 8);
    health = PApplet.parseInt(speed/intelligence*5);
    //creates a health system, that allows smarter zombies to have higher health, and faster zombies have less
    imageWalkingLeft = new AnimatedImage("Images/ZombieWalkingLeft", "png", 2, 10, 0, 0);
    imageWalkingRight = new AnimatedImage("Images/ZombieWalkingRight", "png", 2, 10, 0, 0);
    imageHurtLeft = new AnimatedImage("Images/ZombieHurtLeft", "png", 3, 1, 0, 0);
    imageHurtRight = new AnimatedImage("Images/ZombieHurtRight", "png", 3, 1, 0, 0);
    currentImage = imageWalkingRight;
    switch(PApplet.parseInt(positionx)) {
    case 0:
      this.position.x = currentImage.width;
      break;
    case 1:
      this.position.x = width - currentImage.width;
      break;
    }
    switch (PApplet.parseInt(positiony)) {
    case 0:
      this.position.y = currentImage.height;
      break;
    case 1:
      this.position.y = height - currentImage.height;
      break;
    }
  }
  public void draw() {
    currentImage.draw(position.x, position.y);
    decideMovement();
    update();
  }
  public void startHurt() {
    hurt = true;
    hurtCount = 0;
    if (health > 0) {
      health--;
    }
  }

  public void updateHurt() {
    if (++hurtCount > 5) {
      hurt = false;
    }
  }
  public void decideMovement() {
    //checks if the zombie is smart enough to catch the players scent, the higher the intelligence, the higher the range.
    if (dist(cowboy.position.x, cowboy.position.y, position.x, position.y) < intelligence * width/12) {
      oldPosX = cowboy.position.x;
      oldPosY = cowboy.position.y;
      rotation = atan2(oldPosY - position.y, oldPosX - position.x) / PI * 180;
      direction = 9;
      //creates a chance every frame to change random movement if not within distance of player
    } else if (random(10) > 9.5f) {
      direction = PApplet.parseInt(random(9));
    }
  }
  public void update() {
    updateHurt();
    switch (direction) {
    case 0:
      position.y -= speed;
      break;
    case 1:
      position.x += speed;
      position.y -= speed;
      if (hurt) {
        currentImage = imageHurtRight;
      } else {
        currentImage = imageWalkingRight;
      }
      break;
    case 2:
      position.x += speed;
      if (hurt) {
        currentImage = imageHurtRight;
      } else {
        currentImage = imageWalkingRight;
      }
      break;
    case 3:
      position.x += speed;
      position.y += speed;
      if (hurt) {
        currentImage = imageHurtRight;
      } else {
        currentImage = imageWalkingRight;
      }
      break;
    case 4:
      position.y += speed;
      break;
    case 5:
      position.x -= speed;
      position.y += speed;
      if (hurt) {
        currentImage = imageHurtLeft;
      } else {
        currentImage = imageWalkingLeft;
      }
      break;
    case 6:
      position.x -= speed;
      if (hurt) {
        currentImage = imageHurtLeft;
      } else {
        currentImage = imageWalkingLeft;
      }
      break;
    case 7:
      position.x -= speed;
      position.y -= speed;
      if (hurt) {
        currentImage = imageHurtLeft;
      } else {
        currentImage = imageWalkingLeft;
      }
      break;
    case 8:
      break;
    case 9:
      //follows player at optimal speed (without the *2 and /sqrt(2) it would be slower diagonally)
      position.x = position.x + cos(rotation/180*PI)*speed*2/sqrt(2);
      position.y = position.y + sin(rotation/180*PI)*speed*2/sqrt(2);
      if (oldPosX > position.x) {
        if (hurt) {
          currentImage = imageHurtRight;
        } else {

          currentImage = imageWalkingRight;
        }
      } else {
        if (hurt) {
          currentImage = imageHurtLeft;
        } else {
          currentImage = imageWalkingLeft;
        }
      }
      break;
    } 
    position.x = constrain(position.x, 0, width-currentImage.width/2);
    position.y = constrain(position.y, 0, height-currentImage.height/2);
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "CowboyGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

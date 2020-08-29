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
//called it cacti because its funny as a plural of cactus
Cactus[] cacti;
Wave wave;
Health health;
ArrayList<Zombie> zombies;
ArrayList<Bullet> bullets;
boolean up, down, left, right, start, restart, help;
Collision collisionList = null;
public void setup() {
  //this imageMode, makes it easier to detect collision, if it were corners, a different check would have to be made
  imageMode(CENTER);
  help = true;
  
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
public void draw() {
  //draws things in order of priority (cowboy should be over everything for user visibility)
  background(0xffFAE56F);
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
public void mousePressed() {
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

public void updateCollision() {
  //check if the player is already hurt
  if (cowboy.hurt == false) {
    collisionCactus();
    collisionZombie();
  }
  collisionBullet();
}
public void  collisionCactus() {
  //check if there's a cactus intersecting with the cowboy. If there is hurt the player.
  for (int i = 0; i < cacti.length; i++) {
    if (dist(cowboy.position.x, cowboy.position.y, cacti[i].x, cacti[i].y) < 80 ) {
      cowboy.startHurt();
      break;
    }
  }
}
public void collisionZombie() {
  //check if there's a zombie intersecting with the cowboy. If there is hurt the player.

  for (int i = 0; i < zombies.size(); i++) {
    if (dist(cowboy.position.x, cowboy.position.y, zombies.get(i).position.x, zombies.get(i).position.y) < 80) {
      collisionList = new Collision(cowboy.position.x, cowboy.position.y, collisionList);
      cowboy.startHurt();
      break;
    }
  }
}
public void collisionBullet() {
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
public void helpMenu() {
  //simple helpmenu that appears at the start of the game so the user understands how to interact with the program
  textAlign(CENTER);
  text("WASD for movement", width/2, 20);
  text("SPACE to start", width/2, 40);
  text("R to restart", width/2, 60);
  text("H to toggle help menu", width/2, 80);
  text("Left click to shoot", width/2, 100);
  text("Objective is to finish as many waves possible before dying", width/2, 120);
}
public void keyPressed() {
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
  //hard to explain, but this class is a helper for animated images, which is a majority of the images in the program
  int imageCount;
  int framesPerImage;
  PImage[] images;
  int width, height;
  //offset and pause are for the cacti to bob up and down at a different rate specifically
  int offset;
  int pause;
  AnimatedImage(String filePathPrefix, String fileSuffix, int imageCount, int framesPerImage, int offset, int pause) {
    this.imageCount = imageCount;
    //creates array for the number of images
    this.images = new PImage[imageCount];
    this.framesPerImage = framesPerImage;
    this.offset = offset;
    this.pause = pause;
    //checks how many images there are given the specified imageCount
    for (int i = 1; i <= this.imageCount; i++) {
      //loads the image given the specified fields (could remove suffix, since all images are the same kind being png's)
      this.images[i-1] = loadImage(filePathPrefix + nf(i) + "." + fileSuffix);
    }
    this.width = this.images[0].width;
    this.height = this.images[0].height;
  }
  public void draw(float x, float y) {
    //displays the current image based on the framesPerImage specified, and the frameCount of the program (thats why % is used)
    int currentImage = (((frameCount + pause ) / framesPerImage) + offset) % (imageCount + pause);
    //restarts the loop
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
    speed = 30;  //change this number to change the speed
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
  //uses AnimatedImage to create a cactus animation that can start on either frame 0 or 1, and have a random pause between cycling
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
    //Creates a new object for each time a blood splatter occurs (this allows multiple blood splatters being visible instead of just the latest one)
    if (next != null) {
      next.draw();
    }
  }
}
class Cowboy {
  //didn't explain it earlier, but over the summer, my dad taught me a lot about programming. I learned PVector's to the extent of understanding how to manipulate them on a basic level. I'm not perfect at it, but I use it to make movement for multiple things a lot easier for myself.
  PVector position = new PVector(width/2, height/2);
  boolean facingRight = false;
  int idleCount = 0;
  int hurtCount = 0;
  boolean hurt;
  boolean idle;
  boolean canShoot = true;
  float delay, shotTimer;
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
  //this forces the player to move otherwise they won't be able to shoot after 1.5 seconds of standing still
  public boolean isIdle() {
    return idleCount > 90;
  }
  //checks healthCounter in health class to determine if player is dead
      public boolean isDead() {
    return health.healthCounter == 0;
  }
  public void draw() {
    //draws whatever the set image is at the position of the player
    currentImage.draw(position.x, position.y);
    //if you stand still or are dead, obviously you can't shoot
    if (!isDead() && !isIdle()) {
      drawWeaponCrosshair();
    }
    //makes it so player can't do anything if dead
    if (!isDead()) {
      update();
    }   else {
     currentImage = imageDead; 
    }  
  }
  //simple crosshair to show where the bullet will move towards
  public void drawWeaponCrosshair() {
    noFill();
    strokeWeight(3);
    stroke(250, 100, 100);
    line(mouseX - 10, mouseY, mouseX + 10, mouseY);
    line(mouseX, mouseY - 10, mouseX, mouseY + 10);
    ellipse(mouseX, mouseY, 20, 20);
  }
  //hard to explain, but to put it simply, if you are hurt, you can't be hurt for another 1.5 seconds, if you're not dead, you will lose health
  public void startHurt() {
    canShoot = false;
    hurt = true;
    hurtCount = 0;
    if (health.healthCounter > 0) {
      health.healthCounter--;
    }
  }
  public void updateHurt() {
    //creates an update for the hurtCount every frame, and checks if it has been 1.5 seconds since they were hurt, if so, they can get hurt again
    if (++hurtCount > 90) {
      hurt = false;
    }
  }
  public void update() {
    updateHurt();
    //the idleCount increases no matter what, but will be set to 0 if movement is made
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
    //makes it so the player can't leave the screen
    position.x = constrain(position.x, currentImage.width/2, width - currentImage.width/2);
    position.y = constrain(position.y, currentImage.height/2, height - currentImage.height/2);

    if (position.x < mouseX) {
      facingRight = true;
    } else if (position.x > mouseX) {

      facingRight = false;
    }
    if (mousePressed) {
      //checks if player can shoot, makes player unable to shoot for a set delay, and then creates a bullet, with the starting position of the player x, y
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
    if (health.healthCounter == 0) {
      currentImage = imageDead;
    } else if (hurt && hurtCount < 16) {
      currentImage = imageHurt;
      //if you're idle, you cannot shoot, this is to avoid camping
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
class Health {
  //thing that will track the amount of health the player has, making a for loop for skulls and health
  PImage hp, skull;
  int healthCounter = 10;
  Health() {
    skull = loadImage("Images/Health1.png");
    hp = loadImage("Images/Health2.png");
  }
  public void draw() {
    //hearts drawn based on healthCounter
    int i;
    for (i = 0; i < healthCounter; i++) {
           image(hp, cowboy.position.x - cowboy.currentImage.height/2 + (i*skull.width) - 5, cowboy.position.y - cowboy.currentImage.height/2 - 10); 
    }
    //10 skulls drawn every time
    for (; i < 10; i++) {
     image(skull, cowboy.position.x - cowboy.currentImage.height/2 + (i*skull.width) - 5, cowboy.position.y - cowboy.currentImage.height/2 - 10); 
    }
  }
}
class Wave {
  int currentWave = 0;
  int waveSize = 5;
  int difficulty = 1;
  //int x is part of the equation used to determine how many zombies each wave will have, the harder the difficulty the higher the increase in zombies.
  int x;
  int waveCounter;
  int highestWave;
  //allows the player to have 4 seconds before the next wave starts. It will display three seconds, but it is also including the time it takes to fully reach 0.
  float startTimer = 4;
  public void draw() {
    textAlign(LEFT);
    textSize(20); 
    text("Wave: " +waveCounter, 0, 20);
    text("Highest Wave: " +highestWave, 0, 40);
    difficultySign();
    if (startTimer >= 0) {
      waveStart();
    }
    //global boolean that only occurs when R is pressed
    if (restart) {
      gameRestart();
    }
    //global boolean that only occurs when SPACE is pressed
    if (start) {
      gameStart();
    }
    //Checks if the game is currently happening (currentWave == 1) and if they beat all the enemies
    if (currentWave == 1 && zombies.size() == 0) {
      waveSuccess();
    }
    //could change this to simply check health rather than cowboy
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
    highestWave = waveCounter;
    update();
  }
  public void waveFailure() {
    filter(GRAY);
  }
  public void waveStart() {
    textAlign(CENTER);
    if (startTimer == 4 ) {
    } else {
    text("Starting in: " + PApplet.parseInt(startTimer), width/2, height/4);
    }
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
      text("Click me!", width/2, height/3 + 20);
    }
  }
  public void update() {
    //makes it so the next wave will not start if the timer isn't finished or the restart button is pressed
    if (startTimer <= 0 || restart) {
      waveCounter++;
      x++;
      //resets startTimer, also making it not visbile because of the if statement in waveStart
      startTimer = 4;
      waveSize = PApplet.parseInt(difficulty * sqrt(x * difficulty));
      switch(currentWave) {
      case 0:
        x = 0;
        waveCounter = 0;
        cowboy.position.x = width/2;
        cowboy.position.y = height/2;
        health.healthCounter = 10;
        for (int i = 0; i < zombies.size(); i++) {
          zombies.remove(i);
        }
        break;
      case 1:
        for (int i = 0; i < waveSize; i++ ) {
          zombies.add(new Zombie(PApplet.parseInt(random(2)), PApplet.parseInt(random(2))));
        }
        break;
      }
    } else {
     startTimer -= .01666f; 
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
    } else if (random(10) > 9) {
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
      //Follows player with a multiplier that makes it harder to catch up to the player if going diagonally
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
    //makes it so the zombies can't leave the screen
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

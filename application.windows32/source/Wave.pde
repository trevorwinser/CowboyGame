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
  void draw() {
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
  void gameRestart() {
    currentWave = 0;
    update();
  }
  void gameStart() {
    if (currentWave == 0) {
      currentWave = 1;
      update();
    }
  }
  void waveSuccess() {
    highestWave = waveCounter;
    update();
  }
  void waveFailure() {
    filter(GRAY);
  }
  void waveStart() {
    textAlign(CENTER);
    if (startTimer == 4 ) {
    } else {
    text("Starting in: " + int(startTimer), width/2, height/4);
    }
  }
  void difficultySign() {
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
  void update() {
    //makes it so the next wave will not start if the timer isn't finished or the restart button is pressed
    if (startTimer <= 0 || restart) {
      waveCounter++;
      x++;
      //resets startTimer, also making it not visbile because of the if statement in waveStart
      startTimer = 4;
      waveSize = int(difficulty * sqrt(x * difficulty));
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
          zombies.add(new Zombie(int(random(2)), int(random(2))));
        }
        break;
      }
    } else {
     startTimer -= .01666; 
    }
  }
}

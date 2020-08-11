class Wave {
  int currentWave = 0;
  int waveSize = 5;
  int difficulty = 1;
  int x;
  int waveCounter;
  int highestWave;
  void draw() {
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
    update();
  }
  void waveFailure() {
    filter(GRAY);
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
    }
  }
  void update() {
    waveCounter++;
    x++;
    waveSize = int(difficulty * sqrt(x * difficulty));
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
        zombies.add(new Zombie(int(random(2)), int(random(2))));
      }
      break;
    }
  }
}

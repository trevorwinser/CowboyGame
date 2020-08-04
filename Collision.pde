class Collision {

  void updateCollision() {
    collisionCactus();
  }
  void collisionCactus() {
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
      for (int i = zombies.size(); i < 0; i--) {
        if (dist(cowboy.position.x, cowboy.position.y, zombies.get(i).position.x, zombies.get(i).position.y) < 80) {
          cowboy.startHurt();
          break;
        }
      }
    }
  }
  void collisionBullet() {
  }
}

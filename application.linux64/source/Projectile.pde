class Projectile {
  float xPos;
  float yPos;
  
  Projectile(float x, float y) {
    xPos = x;
    yPos = y;
  }
  
  void drawBullet() {
    xPos+=5;
    fill(255,0,0);
    rect((int)xPos,(int)yPos,6,3);
  }
}

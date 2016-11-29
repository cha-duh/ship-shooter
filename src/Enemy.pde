class Enemy {
  
  float xPos, yPos, x2, y2, grow1, grow2, hSpeed, vSpeed;
  boolean exploding;
  int range;
  
  Enemy(float x, float y) {
    xPos = x;
    yPos = y;
    x2 = 0;
    y2 = 0;
    grow1 = 0;
    grow2 = 0;
    range = 20;
    hSpeed = random(3,6);
  }
  
  void drawEnemy() {
   xPos-=hSpeed;
   range = 20;
   if (!exploding) {
     if (yPos > ship.yPos) {
        yPos -= (yPos-ship.yPos)/(hSpeed*10);
      }
      else {
        yPos += (ship.yPos-yPos)/(hSpeed*10);
      }
      for (Projectile p : shots) {
        if (dist(xPos,yPos,p.xPos,p.yPos) <= 23) {
          die();
        }
      }
      if (ship.hasSuperShield) { range = 40; }
      if (dist(xPos,yPos,ship.xPos,ship.yPos) <= range) {
        ship.hit();
        die();
      }
      for (Explosion x : explosions) {
        if (x.shieldBlast) {
          if (dist(x.xPos,x.yPos,xPos,yPos) <= (10 + (x.innerRadius+x.outerRadius)/2)) {
            die();
          }
        }
      }
      imageMode(CENTER);
      image(enemyImage,xPos,yPos);
   }
   else {
     Explosion x = new Explosion(xPos,yPos,hSpeed);
     Explosion ex = new Explosion(xPos+random(-5,5),yPos+random(-4,4),
       hSpeed+random(-3.3));
     explosions.add(x);
     explosions.add(ex);
     enemies.remove(this);
   }
  }  
  void die() {
    score++;
    exploding = true;
  }
}

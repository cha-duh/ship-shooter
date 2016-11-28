class BossProjectile {
  boolean exploding;
  boolean growing;
  boolean done;
  float xPos;
  float yPos;
  float size;
  float dX;
  float dY;
  
  BossProjectile(float x, float y, float tarX, float tarY) {
    xPos = x;
    yPos = y;
    size = 5;
    dX   = (tarX-x)/20;
    dY   = (tarY-y)/20;
    exploding = false;
    growing = true;
    done = false;
  }
  
  void drawBullet() {
    if (!exploding) {
      xPos+=dX;
      yPos+=dY;
      //dY  -=dY/20;
      dY-=dY/35;
      dX-=dX/30;
      size-=size/30;
      fill(255,0,0);
      rect((int)xPos,(int)yPos,size,size);
      if (size<=2) exploding=true;
    }
    else {
      noStroke();
      for (BossTarget bt : targets) {
        if (dist(xPos,yPos,bt.xPos,bt.yPos) < bt.size) {
          bt.hit();
          score += 10;
        }
        else if(dist(xPos,yPos,bt.xPos,bt.yPos) < bt.size*2) {
          bt.hit();
          score += 8;
        }
        else if(dist(xPos,yPos,bt.xPos,bt.yPos) < bt.size*3) {
          bt.hit();
          score += 6;
        }
        else if(dist(xPos,yPos,bt.xPos,bt.yPos) < bt.size*4) {
          bt.hit();
          score += 4;
        }
        else if(dist(xPos,yPos,bt.xPos,bt.yPos) < bt.size*5) {
          bt.hit();
          score += 2;
        }
      }
      if (growing) {
        fill(random(200,255),random(200,255),0);
        ellipse(xPos,yPos,size,size);
        size++;
        if (size >=15) growing=false;
      }
      else {
        fill(random(200,255),random(200,255),0);
        ellipse(xPos,yPos,size,size);
        size-=.6;
        if (size<=2) done=true;
      }
    }
  }
}

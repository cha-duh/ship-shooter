class BossTarget {
  
  float xPos;
  float yPos;
  float dx;
  float dy;
  float size;
  
  BossTarget(float x, float y) {
    xPos = x;
    yPos = y;
    dx = (xPos - width/2)/20;
    dy = (yPos - height/2)/2;
    size = 2;
  }
  
  void drawTarget() {
    dx = (xPos - width/2)/100;
    dy = (yPos - height/2)/100;
    xPos += dx;
    yPos += dy;
    fill(255,0,0);
    ellipse(xPos,yPos,size*5,size*5);
    fill(255);
    ellipse(xPos,yPos,size*4,size*4);
    fill(255,0,0);
    ellipse(xPos,yPos,size*3,size*3);
    fill(255);
    ellipse(xPos,yPos,size*2,size*2);
    fill(255,0,0);
    ellipse(xPos,yPos,size,size);
    size += .1;
    if (xPos > width || xPos < 0 || yPos < 0 || yPos > height) trashTargets.add(this);
  }
  
  void hit() {
    trashTargets.add(this);
  }
}

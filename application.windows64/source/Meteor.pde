class Meteor {
  float xPos,yPos,yDir,speed,size,prob;
  PImage img;
  
  Meteor(float x, float y, float dx, float s) {
    xPos = x;
    yPos = y;
    yDir = random(-.5, .5);
    speed = dx;
    size = s;
    prob = ((speed*3)+size)/40;
    if (prob >= 1) img = goldSatellite;
    else img = silverSatellite;
  }
  
  void drawMeteor() {
    if (ship.grappling && ship.closest == this) {}
    else {
      xPos -= speed;
      yPos += yDir;
    }
    imageMode(CENTER);
    float theta = atan((yPos-ship.yPos)/ (xPos-ship.xPos));
    pushMatrix();
    translate(xPos,yPos);
    if (img == fullClaw) rotate(theta+HALF_PI);
    image(img,0,0);
    popMatrix();
    ellipse(xPos,yPos,10,10);
    for (Projectile p : shots) {
      if (dist(xPos,yPos,p.xPos,p.yPos) < 15) {
        makeExplosion(xPos,yPos,prob>=1);
        meteors.remove(this);
      }
    }
  }
 
 void setImage(PImage im) {
  img = im;
 } 
}

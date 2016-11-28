class Ship {
  int health;
  int vDelay;
  int hDelay;
  int ssCount;
  float xPos;
  float yPos;
  float bank;
  float und;
  Meteor closest;
  boolean isFaster;
  boolean hasShield;
  boolean grappling;
  boolean hasSuperShield;

  Ship(float x, float y) {
    xPos = x;
    yPos = y;
    ssCount = 0;
    vDelay = 40;
    hDelay = 30;
    health = 4;
    isFaster = false;
    hasShield = false;
    hasSuperShield = false;
    und = 0;
  }

  void fly() {
    if (grappling) reel();

    if (mouseX > xPos && xPos < 400) {
      xPos += (mouseX-xPos)/hDelay;
    }
    else if (mouseX < xPos) {
      xPos -= (xPos-mouseX)/hDelay;
    }
    if (mouseY > yPos) {
      yPos += (mouseY-yPos)/vDelay;
    }
    else if (mouseY < yPos) {
      yPos -= (yPos-mouseY)/vDelay;
    }
    if (hasShield) {
      noFill();
      und+=.05;
      und=und%TWO_PI;
      stroke(255);
      strokeWeight(map(cos(und), -1, 1, .5, 1.5));
      ellipse(xPos, yPos, 65+(10*sin(und)), 70+(10*cos(und)));
    }
    if (hasSuperShield) {
      hasShield=false;
      if (ssCount < 500) {
        for (float inc=0;inc<TWO_PI;inc+=.03) {
          float shock = random(TWO_PI)*.03;
          float x2 = xPos+map(noise(inc, ssCount/15), 0, 1, 30, 70)*cos(inc);
          float y2 = yPos+map(noise(inc, ssCount/15), 0, 1, 30, 70)*sin(inc);
          strokeWeight(random(3));
          stroke(random(255), random(100), 0);
          point(x2, y2);
          point(x2, y2-(2*(y2-yPos)));
          if (inc == shock) {
            stroke(random(255), random(255), 0);
            line(xPos+15, yPos, x2, y2);
          }
        }
        ssCount++;
      }
      else {
        ssCount = 0;
        hasSuperShield = false;
        Explosion x = new Explosion(xPos, yPos, 0, 
        40, 80);
        explosions.add(x);
      }
    }
    fill(0, 25, 200);
    imageMode(CENTER);
    image(shipImage, xPos, yPos);
    //triangle(xPos, yPos-6, xPos, yPos+6, xPos+30, yPos);
  }

  void hit() {
    if (!hasSuperShield) {
      if (hasShield) {
        hasShield = false;
      }
      else {
        health--;
        fourBarrel = false;
        doubleSpeed = false;
        isFaster = false;
        if (health == 0) {
          setup();
        }
      }
    }
  }

  void grapple() {
    if (meteors.size() > 0) {
      closest = meteors.get(0);
      for (Meteor m : meteors) {
        if (dist(xPos, yPos, m.xPos, m.yPos) <
          dist(xPos, yPos, closest.xPos, closest.yPos)) {
          closest = m;
        }
      }
      if (dist(xPos, yPos, closest.xPos, closest.yPos) < 150) {
        grappling=true;
        //cast();
        reel();
      }
      else  { 
        grappling = false;
        //cast();
      }
    }
  }
  
  void cast() {
    float tx = closest.xPos - xPos;
    float ty = closest.yPos - yPos;
    float theta = atan2(ty,tx);
    bezier(xPos,yPos,tx/20,ty/20,tx/15,ty/15,tx/10, ty/10);
    tx = tx/10;
    ty = ty/10;
    pushMatrix();
    translate(tx, ty);
    rotate(theta + PI);
    image(openClaw,0,0);
    popMatrix();
  }
    

  void reel() {
    closest.setImage(fullClaw);
    line(xPos, yPos, closest.xPos, closest.yPos);
    closest.xPos-= (closest.xPos-xPos)/8;
    closest.yPos-= (closest.yPos-yPos)/8;
    if (dist(xPos, yPos, closest.xPos, closest.yPos) <= 20) {
      if (closest.prob > 1) {
        Goodie g = new Goodie(xPos,yPos);
        g.collected();
      } else {
        sats++;
      }
      meteors.remove(closest);
      grappling = false;
    }
  }      

  void explode() {
    setup();
  }
  
  void flyNoMouse() {
    
    if (hasShield) {
      noFill();
      und+=.05;
      und=und%TWO_PI;
      stroke(255);
      strokeWeight(map(cos(und), -1, 1, .5, 1.5));
      ellipse(xPos, yPos, 65+(10*sin(und)), 70+(10*cos(und)));
    }
    if (hasSuperShield) {
      hasShield=false;
      if (ssCount < 500) {
        for (float inc=0;inc<TWO_PI;inc+=.03) {
          float shock = random(TWO_PI)*.03;
          float x2 = xPos+map(noise(inc, ssCount/15), 0, 1, 30, 70)*cos(inc);
          float y2 = yPos+map(noise(inc, ssCount/15), 0, 1, 30, 70)*sin(inc);
          strokeWeight(random(3));
          stroke(random(255), random(100), 0);
          point(x2, y2);
          point(x2, y2-(2*(y2-yPos)));
          if (inc == shock) {
            stroke(random(255), random(255), 0);
            line(xPos+15, yPos, x2, y2);
          }
        }
        ssCount++;
      }
      else {
        ssCount = 0;
        hasSuperShield = false;
        Explosion x = new Explosion(xPos, yPos, 0, 
        40, 80);
        explosions.add(x);
      }
    }
    fill(0, 25, 200);
    imageMode(CENTER);
    image(shipImage, xPos, yPos);
    //triangle(xPos, yPos-6, xPos, yPos+6, xPos+30, yPos);
  }
}


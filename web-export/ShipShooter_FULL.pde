int[] goodieBag = { 
  1, 2, 3, 4
};

final int MENU = 0;
final int LEVEL1 = 1;
final int TRANSITION = 2;
final int TUNNEL = 3;
final int BOSS = 4;
final int CREDITS = 5;

int level;

float[] x = new float[300];
float[] y = new float[300]; 
float[] speed = new float[300];
float time;
Ship ship;
ArrayList<Projectile> shots;
ArrayList<Meteor>  meteors;
ArrayList<Goodie> goodies;
ArrayList<Enemy> enemies;
ArrayList<Explosion> explosions;
TunnelTraverse tunnel;
int count;
int magicNumber;
int maxBullets;
int ENDVAR = 20;
int score;
int sats;
String points;
String kills;
boolean doubleSpeed;
boolean fourBarrel;
PImage openClaw;
PImage fullClaw;
PImage shipImage;
PImage enemyImage;
PImage goldSatellite;
PImage silverSatellite;

BossBattle bb;
int asize, bsize;
ArrayList<BossTarget> targets;
ArrayList<BossTarget> trashTargets;
ArrayList<BossProjectile> bossShots;

void setup() {
  size(700, 432, P2D);

  String url = "http://i.imgur.com/Cbd5Vjx.png";
  shipImage = loadImage(url, "png");
  url = "http://i.imgur.com/8dkTYqQ.png";
  silverSatellite = loadImage(url, "png");
  url = "http://i.imgur.com/Hhtoxca.png";
  enemyImage = loadImage(url, "png");
  url = "http://i.imgur.com/cFB8vPR.png";
  goldSatellite = loadImage(url, "png");
  url = "http://i.imgur.com/mJcQnlR.png";
  openClaw = loadImage(url, "png");
  url = "http://i.imgur.com/aLz9Hj0.png";
  fullClaw = loadImage(url, "png");

  background(0);
  noCursor();
  rectMode(CORNER);
  shots = new ArrayList<Projectile>();
  meteors = new ArrayList<Meteor>();
  goodies = new ArrayList<Goodie>();
  enemies = new ArrayList<Enemy>();
  explosions = new ArrayList<Explosion>();
  tunnel = new TunnelTraverse();
  ship = new Ship(25, height/2);
  time = 0;
  count = 0;
  score = 0;
  magicNumber = (int)random(10);
  maxBullets = 3;
  //shipImage = loadImage("data/ShipShot_Top.gif");
  //enemyImage = loadImage("data/EnemeyShipShooter.gif");
  //silverSatellite = loadImage("data/Satellite_ShipShooter.gif");
  //goldSatellite = loadImage("data/AuSatelitte_ShipShooter.gif");
  ship.hasShield= false;
  ship.hasSuperShield = false;
  bb = new BossBattle();

  int i = 0;
  while (i < x.length) {  
    x[i] = random(0, width);
    y[i] = random(0, height);
    speed[i] = random (1, 7);
    i++;
  }
  level = MENU;
}

void draw() {
  switch(level) {
  case MENU:
    drawMenu();
    break;
  case LEVEL1:
    drawLvl1();
    break;
  case TRANSITION:
    drawTransition1();
    break;
  case TUNNEL:
    drawTunnel();
    break;
  case BOSS:
    drawBoss();
    break;
  case CREDITS:
    //drawCredits();
    break;
  }
}

void drawLvl1() {
  background(0);
  stroke(255);
  strokeWeight(2);
  updateText();
  drawStars();
  drawShield();
  drawExplosions();
  drawSatellites();
  strokeWeight(1);
  stroke(255);
  ship.fly();
  drawEnemies();
  drawProjectiles();
  drawGoodies();

  //if you reach the random magicNumber, send a satellite
  count++;
  if (count == magicNumber) {
    sendMeteor();
  }

  //send a new enemy 2 out of each 50 frames.
  if (random(0, 50) > 48) {
    Enemy e = new Enemy(width, random(height));
    enemies.add(e);
  }
  if (sats >= 1) level=TRANSITION;
}

void drawTransition1() {
  background(0);
  drawStars();
  for (Enemy e : enemies) {
    e.die();
  }
  ship.xPos+=5;
  drawEnemies();
  ship.flyNoMouse();
  fill(0, 0, 180);
  textSize(38);
  textAlign(CENTER);
  text("HYPERDRIVE REPAIRED", width/2, 75);
  text("OPENING WORMHOLE", width/2, 100);
  if (ship.xPos > width) {
    fill(0, map(ship.xPos, width, width*2, 0, 255));
    rect(0, 0, width*2, height*2);
  }
  if (ship.xPos > width*2.5) level = TUNNEL;
}

void drawTunnel() {
  tunnel.drawTraversal();
  if (tunnel.lifeSpan <= 250) {
    fill(255, map(tunnel.lifeSpan,250,0,0,255));
    rect(0, 0, width*2, height*2);
  }
  if (tunnel.lifeSpan <= 0) {
    bb.battleSetup();
    level=BOSS;
  }
}

void drawBoss() {
  bb.drawBattle();
}

void sendMeteor() {
  Meteor m = new Meteor(width, random(height), random(1, 5), random(20, 40));
  meteors.add(m);
  magicNumber=(int)random(50, 300);
  count = 0;
}

void makeExplosion(float x, float y, boolean goodie) {
  for (int i=0; i<30; i++) {
    fill(i*8, i*3, 0);
    ellipse(x, y, i*2, i*2);
  }
  if (goodie) {
    Goodie g = new Goodie(x, y);
    goodies.add(g);
  }
}

void keyPressed() {
  if (level == BOSS) {
    BossProjectile bp = new BossProjectile(bb.bossShip.xPos, bb.bossShip.yPos, bb.targetX, bb.targetY);
    bossShots.add(bp);
  }
  else if (keyCode == SHIFT) {
    if (!ship.grappling) ship.grapple();
  }
  else if (shots.size() < maxBullets) {
    Projectile bullet = new Projectile(ship.xPos+30, ship.yPos);
    shots.add(bullet);
  }
}

void drawStatus(float w) {
  fill(255, 0, 0);
  rectMode(CORNER);
  rect(width/2-100, height/2-30, w, 60);
}

void drawMenu() {
  cursor();
  background(0);
  //move stars
  for (int i=0;i < x.length;i++) {
    float yMove = map(mouseY, 0, height, -speed[i]/10, speed[i]/10);
    y[i]-=yMove;
    if (y[i] <= 0) {
      y[i] = height;
    }
    else if (y[i] >= height) {
      y[i] = 0;
    }
    float co = map(speed[i], 1, 5, 100, 255);
    stroke(co);
    strokeWeight(speed[i]/2);
    point(x[i], y[i]);

    x[i] = x[i] - speed[i] / 2;
    if (x[i] < 0) {
      x[i] = width;
    }
  }
  //restart? box
  stroke(255);
  noFill();
  rectMode(CENTER);
  rect(width/2, height/2, 200, 60);
  fill(255);
  textAlign(CENTER);
  text("Start a New Game", width/2, height/2);
  //fill with red while mouse is inside
  if (mouseX<=width/2+100 && mouseX >= width/2 - 100 &&
    mouseY >= height/2 - 50 && mouseY <= height/2 + 50) {
    if (time < 200) {
      drawStatus(time);
      time ++;
    } else {
      level=LEVEL1;
    }
  }
  //restart if you move out of the box
  else {
    time = 0;
  }
}

void drawStars() {
  for (int i=0;i < x.length;i++) {
    float yMove = map(mouseY, 0, height, -speed[i]/10, speed[i]/10);
    y[i]-=yMove;
    if (y[i] <= 0) {
      y[i] = height;
    }
    else if (y[i] >= height) {
      y[i] = 0;
    }
    float co = map(speed[i], 1, 5, 100, 255);
    stroke(co);
    strokeWeight(speed[i]/2);
    point(x[i], y[i]);

    x[i] = x[i] - speed[i] / 2;
    if (x[i] < 0) {
      x[i] = width;
    }
  }
}

void drawEnemies() {
  stroke(255);
  fill(255, 0, 50);
  strokeWeight(2);
  for (int i=0; i<enemies.size(); i++) {
    Enemy e = enemies.get(i);
    e.drawEnemy();
  }
}

void drawSatellites() {
  stroke(255);
  strokeWeight(2);
  for (int j=0; j<meteors.size(); j++) {
    Meteor m = meteors.get(j);
    m.drawMeteor();
    if (m.xPos < 0) {
      meteors.remove(m);
    }
  }
}

void drawProjectiles() {
  strokeWeight(.5);
  fill(255, 255, 0);
  for (int j=0; j<shots.size(); j++) {
    Projectile p = shots.get(j);
    p.drawBullet();
    if (p.xPos > width) {
      shots.remove(p);
    }
  }
}

void drawExplosions() {
  for (int i=0; i<explosions.size(); i++) {
    Explosion ex = explosions.get(i);
    if (ex.shieldBlast) {
      fill(255);
    }
    else {
      fill(255, 250, 205);
    }
    noStroke();
    ex.drawExplosion();
    if (ex.xPos < 0) {
      explosions.remove(ex);
    }
  }
}

void drawGoodies() {
  stroke(255);
  strokeWeight(0);
  for (int j=0; j<goodies.size(); j++) {
    goodies.get(j).drawGoodie();
    if (dist(goodies.get(j).xPos, goodies.get(j).yPos, 
    ship.xPos, ship.yPos) < 20) {
      goodies.get(j).collected();
    }
  }
}

void drawShield() {
  if (ship.hasSuperShield) {
    int rand = (int)random(100);
    if (rand > 90) {
      text("Sheeee Ovvvllld", 75, 25);
    }
    else if (rand > 70) {
      text("Shi3ld O erlo4d", 75, 25);
    }
    else {
      text("Shield Overload", 75, 25);
    }
  }
}

void updateText() {
  fill(255);
  textSize(10);
  textAlign(LEFT);
  text(ship.health, 25, 25);
  kills = score + " enemies killed";
  points = sats + " satellites retrieved";
  text(points, 50, 50);
  text(kills, 50, 75);
  if (ship.hasSuperShield) {
    int rand = (int)random(100);
    if (rand > 90) {
      text("Sheeee Ovvvllld", 75, 25);
    }
    else if (rand > 70) {
      text("Shi3ld O erlo4d", 75, 25);
    }
    else {
      text("Shield Overload", 75, 25);
    }
  }  
  else if (ship.hasShield) {
    text("Shields Up", 75, 25);
  }
  else {
    text("Shields Depleted", 50, 25);
  }
  if (doubleSpeed) {
    text("Thrusters at Maximum", 175, 25);
  }
  if (fourBarrel) {
    text("Chamber 4 Clear", 350, 25);
  }
}

class BossBattle {

  float offset, inc, slowInc, targetX, targetY, shift, lavaColor;
  float landscape[][];
  float colors[][];
  BossShip bossShip;
  
  void BossBattle() {
  }

  void battleSetup() {
    background(0, 100, 200);
    strokeWeight(.5);
    stroke(200, 200, 0);
    //rocks = new ArrayList<RockWall>();
    inc = 0;
    shift = 0;
    slowInc = 0;
    asize = 65;
    lavaColor = 0;
    bsize = width;
    score = 0;
    bossShip = new BossShip(width/2, height/2, true);
    bossShots = new ArrayList<BossProjectile>();
    targets   = new ArrayList<BossTarget>();
    trashTargets = new ArrayList<BossTarget>();
    landscape = new float[asize][bsize];
    colors    = new float[asize][bsize];
    noCursor();
  } 

  void drawBattle() {

    if (random(50) > 49.5) { 
      // RockWall rw = new RockWall(random(width),height/2+100,
      //    random(60,100),random(30,90)); 
      //  rocks.add(rw);
      BossTarget bt = new BossTarget(random(width/2-50, width/2+50), random(height/2-150, height/2+50));
      targets.add(bt);
    }

    background(0, 100, 200);
    fill(230);
    textSize(10);
    int frames = (int)frameRate;
    text(frames, width-50, 50);
    text(score, 50, 50);

    if (trashTargets.size() > 0) {
      for (BossTarget bt : trashTargets) {
        targets.remove(bt);
      }
    }
    for (BossTarget bt : targets) {
      bt.drawTarget();
    }
    //rectMode(CORNER);
    //fill(255,150,0);
    //rect(0,height/2+60,width,height);

    shift = map(mouseX, 0, width, -2, 2);
    slowInc += .01;
    inc += .07;
    for (int i=0; i<bsize; i++) {
      landscape[0][i] = map(noise(i/100.0, slowInc, inc), 0, 1, height/2+100, height/2+150);
      colors[0][i]    = map(landscape[0][i], height/2+100, height/2+150, 255, 10);
      //line(i,landscape[0][i],i,height);
    }
    float least;
    for (int i=0; i<bsize; i++) {
      least = 10000;
      for (int j=5; j<15; j++) {
        if (landscape[j][i] < least) least = landscape[j][i];
      }
      stroke(255, 150, 0);
      line(i, least, i, height);
    }
    strokeWeight(2);
    for (int i=asize-1; i>0; i--) {
      for (int j=0; j<bsize-1; j++) {
        landscape[i][j] = landscape[i-1][j]+i/15;
        colors[i][j]    = colors[i-1][j];
      }
      for (int k=0; k<width; k++) {
        lavaColor = colors[i][k];
        stroke(255, lavaColor, 0);
        if (i>1 && landscape[i][k] > landscape[i-1][k] && colors[i][k]>200 || colors[i][k]<50) point(k, landscape[i][k]);
      }
    }
    strokeWeight(1);

    stroke(0);

    for (int i=0;i<bossShots.size();i++) {
      BossProjectile bp = bossShots.get(i);
      if (bp.done) bossShots.remove(bp);
      else bp.drawBullet();
    }
    if (frameCount < 100) { 
      fill(0, 100, 200);
      textAlign(CENTER);
      textSize(40);
      text("RED ALERT", width/2, 100);
    }

    //for (RockWall rw : rocks) {
    //  fill(random(139,250),69,19);
    //  rw.drawWall();
    //}

    rectMode(CENTER);
    noFill();
    stroke(200, 0, 0);
    targetX = map(mouseX, 0, width, 60, width-60);
    targetY = map(mouseY, 0, height, 0, height/2+140);
    rect(targetX, targetY, 20, 20);
    //fill(0,0,255);
    //rect(mouseX,mouseY,75,35);
    bossShip.fly();
  }

  void keyPressed() {

  }
}

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
class BossShip {
  int health;
  int ssCount;
  float xPos;
  float yPos;
  boolean hasShield;
  boolean hasSuperShield;
  boolean grappling;
  PImage shipRear;
  ParticleSystem leftEngine;
  ParticleSystem rightEngine;
  
  BossShip(float x, float y, boolean shield) {
    xPos = x;
    yPos = y;
    ssCount = 0;
    health = 4;
    String url = "http://i.imgur.com/LXqHIJx.gif";
    shipRear = loadImage(url, "gif");
    hasShield = shield;
    leftEngine = new ParticleSystem(new PVector(xPos-5,yPos));
    rightEngine = new ParticleSystem(new PVector(xPos+5,yPos));
  }
  
  void fly() {
    float dx = (mouseX-xPos)/20;
    float dy = (mouseY-yPos)/20;
    xPos+=dx;
    yPos+=dy;
    float rotation = map(dx,-width/20,width/20,-HALF_PI,HALF_PI);
    pushMatrix();
    translate(xPos,yPos);
    rotate(rotation);
    imageMode(CENTER);
    image(shipRear,0,0);
    popMatrix();
    leftEngine.origin.set(xPos-10,yPos+18,0);
    rightEngine.origin.set(xPos+10,yPos+18,0);
    leftEngine.addParticle();
    rightEngine.addParticle();
    leftEngine.run();
    rightEngine.run();
  }
  
  void hit() {
    health--;
    if (health <= 0) {
      level=MENU;
    }
  }
}
    
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
class Explosion {
  
  float xPos,yPos,hSpeed,spikes,rotation,rotSp,innerRadius,outerRadius;
  boolean shieldBlast;
  
  Explosion (float x, float y, float speed) {
    xPos = x;
    yPos = y;
    rotSp = random(8);
    rotation = 0;
    hSpeed = speed;
    spikes = random(4,9);
    shieldBlast = false;
    innerRadius = random(10,20);
    outerRadius = random(30,40);
  }
  
  Explosion (float x, float y, float speed, float radIn, float radOut) {
    xPos = x;
    yPos = y;
    rotSp = random(8);
    rotation = 0;
    hSpeed = speed;
    shieldBlast = true;
    spikes = random(4,9);
    innerRadius = radIn;
    outerRadius = radOut;
  }
  
  void drawExplosion() {
    rotation+=rotSp;
    pushMatrix();
    translate(xPos,yPos);
    rotate(rotation);
    int numVertices = (int)spikes * 2;
    float angleStep = TWO_PI / numVertices;
    innerRadius-=.3;
    outerRadius-=.3;
    beginShape();
    for ( int i = 0; i < numVertices; i++ ) {
      float x, y;
      if ( i % 2 == 0 ) {
        x = cos( angleStep * i ) * outerRadius;
        y = sin( angleStep * i ) * outerRadius;
      } else {
        x = cos( angleStep * i ) * innerRadius;
        y = sin( angleStep * i ) * innerRadius;
      }
      vertex( x, y );
    }
    
    endShape(CLOSE);
    popMatrix();
    if (innerRadius <= 0) {
      explosions.remove(this);
    }
    xPos-=hSpeed;
  }
}
class Goodie {
  int power;
  float xPos;
  float yPos;
  
  Goodie(float x, float y) {
    xPos = x;
    yPos = y;
    power = goodieBag[(int)random(goodieBag.length)];
  }
  
  void drawGoodie() {
    xPos -= 3;
    fill(0,power*50,0);
    ellipse(xPos,yPos,15,5);
  }
  
  void collected() {
    switch(power) {
      case 1:
        ship.health++;
        break;
      case 2:
        ship.vDelay = 20;
        doubleSpeed = true;
        break;
      case 3:
        if (ship.hasSuperShield) {
          ship.ssCount=0;
        }
        if (ship.hasShield==true) {
          ship.hasSuperShield = true;
          ship.ssCount=0;
        }
        else {
          ship.hasShield = true;
        }
        break;
      case 4:
        maxBullets = 4;
        fourBarrel = true;
        break;
    }
    goodies.remove(this);
  }
}
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
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float grow;

  Particle(PVector l) {
    acceleration = new PVector(0,0.2);
    velocity = new PVector(random(-1.5,1.5),random(0,1));
    location = l.get();
    lifespan = 80.0;
    grow = 15;
  }

  void run() {
    update();
    display();
    grow+=1.4;
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    noStroke();
    //if (location.y-ship.yPos < 30 && abs(location.x-ship.xPos) < 30) {
    if(lifespan > 78) {
      fill(0,110,255,80);
      ellipse(location.x,location.y,grow,grow);
    }
    else if(lifespan > 74) {
      fill(255,200,0,lifespan-30);
      ellipse(location.x,location.y,grow+5,grow+5);
    }
    else if(lifespan > 72) {
      fill(255,110,0,40);
      ellipse(location.x,location.y,grow,grow);
    }
    else {
      fill(130,lifespan);
      ellipse(location.x,location.y,grow,grow);
    }
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
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

class TunnelTraverse {

  PImage cockpit;
  PVector[] centers;
  float[] sizes;
  float size;
  int arraySize;
  int lifeSpan;

  TunnelTraverse() {
    String url = "http://i.imgur.com/Y09O0ca.png";
    cockpit = loadImage(url, "png");
     //arraySize = 50;
     //centers = new PVector[arraySize];
     //sizes = new float[arraySize];
     //for (int i=0; i<arraySize; i++) {
     //centers[i] = new PVector(0, 0);
     //sizes[i] = 0;
     //}
     //size = 1;
     //centers[0] = new PVector(0, 0);
     //sizes[0] = 10;*/
    lifeSpan = 1000;
  }

  void drawTraversal() {
      //fill(0, 50);
     //rect(0, 0, width, height);
     //fill(0,255,0);
     //if (size < height*32) ellipse(width/2,height/2,size,size);
     //if (size > height/2 && size < height*32) {
     //  fill(0);
     //  ellipse(width/2,height/2,size/16,size/16);
     //}
     
     //for (int i=arraySize-1;i>0;i--) {
     //centers[i]  = centers[i-1].get();
     //sizes[i]    = sizes[i-1]+10;
     //}
     //centers[0] = new PVector(
     //map(noise(frameCount/60.0), 0, 1, width/4, 3*width/4), 
     //map(noise(frameCount/50.2), 0, 1, height/4, 3*height/4));
     //sizes[0] = 10;
     //int index = frameCount%arraySize;
     //stroke(255);
     //noFill();
     //for (int i=0; i<100; i++) {
     //  ellipse(centers[(index+5*i)%arraySize].x, centers[(index+5*i)%arraySize].y, 
     //  sizes[(index+5*i)%arraySize], sizes[(index+5*i)%arraySize]);
     //}
     //strokeWeight(.4);
     //for (int i=0; i<arraySize; i++) {
     //ellipse(centers[i].x,centers[i].y,sizes[i],sizes[i]);
     //noFill();
     //if (centers[i].x!=0) ellipse(centers[i].x, centers[i].y, sizes[i], sizes[i]);
     //fill(0,5);
     //rect(0,0,width,height);
     //
    //size+=size/40;
    pushMatrix();
    translate(width/2, height/2);
    bezier(50*cos(frameCount), 50*sin(frameCount), width/3*cos(frameCount+noise(frameCount/100.9)), width/3*sin(frameCount+noise(frameCount/234.9)), 
      2*width/3*cos(frameCount+noise(frameCount/122.4)), 2*width/3*sin(frameCount+noise(frameCount/314.4)), width*cos(frameCount+noise(234.9)), width*sin(frameCount+noise(232.11)));
    popMatrix();
    image(cockpit, width/2, height/2);

    lifeSpan--;
  }
}



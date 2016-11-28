int[] goodieBag = { 
  1, 2, 3, 3, 3, 4
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
  if (sats >= 15) level=TRANSITION;
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


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
        if (i>1 && landscape[i][k] > landscape[i-1][k] && (i+k)%3==0) point(k, landscape[i][k]);
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


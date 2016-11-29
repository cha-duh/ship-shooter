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
    String url = "http://i.imgur.com/K2YKz5j.png";
    shipRear = loadImage(url, "png");
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
    

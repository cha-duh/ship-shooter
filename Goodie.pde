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

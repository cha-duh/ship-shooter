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

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

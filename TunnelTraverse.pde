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


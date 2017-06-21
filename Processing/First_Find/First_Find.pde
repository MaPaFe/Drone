Knct kinect;
Drone drone;

void setup() {
  size(512, 424, P2D);
  //frameRate(2);

  kinect = new Knct(this);
  
  drone = new Drone();
}

void draw() {
  background(0);
  surface.setTitle(getClass().getName()+" [size "+width+"/"+height+"] [frame "+frameCount+"] [frameRate "+frameRate+"]");

  drone.update();

  //println(currentDronePos);
}

void keyPressed() {
  drone.foundAtBeginning = false;
}
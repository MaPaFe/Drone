final int FIND_FIRST_THRESHOLD = 1500;

Knct kinect;
Drone drone;

void setup() {
  size(512, 424, P2D);
  // frameRate(2);

  kinect = new Knct(this);

  drone = new Drone();
}

void draw() {
  background(0);
  surface.setTitle(getClass().getName() + " [size " + width + "/" +height + "] [frame " + frameCount + "] [frameRate " +frameRate + "]");

  
  // drone.foundAtBeginning = false;

  // println(drone.currentDronePos);
  //int[] depth = kinect.getDepth();
  //loadPixels();
  //for (int i = 0; i < depth.length; i++) {
  //  int d = depth[i];
  //  if (d == 0) pixels[i] = color(255, 0, 0);
  //  else if (d > 3000){ pixels[i] = color(0, 255, 0); }
  //  else if (d > 0 && d < 1000) pixels[i] = color(0, 0, 255);
  //  else pixels[i] = color(map(d, 0, 5000, 0, 255));
  //}
  //updatePixels();
  
  drone.update();
}

void keyPressed() {
  drone.foundAtBeginning = false;
}
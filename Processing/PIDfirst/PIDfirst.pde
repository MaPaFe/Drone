import processing.serial.*;

final int FIND_FIRST_THRESHOLD = 1500;

Knct kinect;
Drone drone;
Serial serial;

void setup() {
  size(512, 424, P2D);
  // frameRate(2);

  kinect = new Knct(this);

  drone = new Drone();

  serial = new Serial(this, Serial.list()[1]);
}

void draw() {
  background(0);
  surface.setTitle(getClass().getName() + " [size " + width + "/" +height + "] [frame " + frameCount + "] [frameRate " +frameRate + "]");

  drone.update(new PVector(width/2, height/2, FIND_FIRST_THRESHOLD));
  //drone.foundAtBeginning = false;
}

void keyPressed() {
  drone.foundAtBeginning = false;
}
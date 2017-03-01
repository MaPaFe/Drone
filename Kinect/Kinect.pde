import org.openkinect.processing.*;

Kinect2 kinect;

ArrayList <Blob> blobs;

int threshold = 500;
int[] background;
PImage display;

void setup() {
  size(512, 424, P2D);

  blobs = new ArrayList();

  kinect = new Kinect2(this);
  kinect.initDepth();
  kinect.initDevice();

  display    = createImage(512, 424, RGB);
  background = kinect.getRawDepth();
}

void draw() {
  background(0);

  blobs();

  image(display, 0, 0);
  textSize(32);
  text(blobs.size(), 20, 20+32);
  for (Blob b : blobs) b.display();
}

void keyPressed() {
  background = kinect.getRawDepth();
}
Knct kinect;

ArrayList <Blob> blobs;

int threshold = 500;
int[] background;
PImage display;

void setup() {
  size(512, 424, P2D);

  blobs = new ArrayList();

  kinect = new Knct(this);

  display    = createImage(512, 424, RGB);
  background = kinect.getDepth();
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
  background = kinect.getDepth();
}
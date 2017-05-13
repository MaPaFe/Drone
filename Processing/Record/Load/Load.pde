Knct kinect;

void setup() {
  size(512, 424, P2D);
  
  kinect = new Knct(this);
}

void draw() {
  image(kinect.getImage(), 0, 0);
}
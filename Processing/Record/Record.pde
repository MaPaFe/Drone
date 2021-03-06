Knct kinect; //<>// //<>// //<>//
PrintWriter out;

void setup() {
  size(512, 424, P2D);
  frameRate(30);

  kinect = new Knct(this);

  out = createWriter("data.txt");
}

void draw() {
  background(0);
  image(kinect.getImage(), 0, 0);

  if (frameCount > 50) {
    out.println(join(str(kinect.getDepth()), ","));
  }
  if (frameCount >= 550) {
    out.close();
    exit();
  }
}
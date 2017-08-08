Knct kinect;

void setup() {
  size(512, 424);

  kinect = new Knct(this);
}

void draw() {
  set(0, 0, kinect.getImage());
 
  int[] depth = kinect.getDepth();
  IntList diff = new IntList();

  for (int dist = 1; dist < min(kinect.width, kinect.height) / 2; dist+=10) {
    int x = kinect.width / 2;
    int y = kinect.height / 2;
    
    int depthLeft = depth[x - dist + y * kinect.width];
    int depthRight = depth[x + dist + y * kinect.width];
    
    ellipse(x - dist, y, 8, 8);
    ellipse(x + dist, y, 8, 8);
    
    diff.append(abs(depth[x + y * kinect.width] - depthRight));
  }
  
  for (int a : diff) println(a);

  //println(depth[108644] - depth[108944]);
  
   
   //ellipse(100, 212, 8, 8);
   //ellipse(400, 212, 8, 8);
}
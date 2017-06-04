Knct kinect;
int[] data;//2168 2153 15
int max=0, min=8000;

void setup() {
  size(512, 424);
  kinect = new Knct(this);
  data = new int[15];
  java.util.Arrays.fill(data, 0);
}

void draw() {
  int[] i = kinect.getDepth();
  image(kinect.getImage(), 0, 0);
  if (i[100000]!=0) {
    int index = floor(map(i[100000], 2168, 2153, 0, 14));
    data[index]+=1;
    //int current = i[100000];
    //  if (current>max) {
    //  max=current;
    //} else if (current<min) {
    //  min=current;
    //}
    //println(i[100000]);
    paint(data);
    surface.setTitle(String.format(getClass().getName()+ "  [fps %6.2f]   [frame %d]   [size %d/%d]", frameRate, frameCount, width, height));
  }
}
void keyPressed() {
  println(max, min, max-min);
}
void paint(int[] d) {
  stroke(0, 255, 0);
  int maxd=0;
  for (int i = 1; i<15; i++) {
    if (d[i]>maxd) {
      maxd = d[i];
    }
  }
  for (int i = 1; i<15; i++) {
    strokeWeight(1);
    //int n=floor((d[i]/maxd)*height);
    //int p=floor((d[i-1]/maxd)*height);
    int n = d[i]/5;
    int p = d[i-1]/5;
    //point(i*17, n);
    line(i*17,p,i*17+17, n);
  }
}
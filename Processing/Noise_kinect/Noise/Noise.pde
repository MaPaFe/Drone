 //<>//
Knct kinect;
int[][] data;//stores[pixel(index)][different measurments for sigma measurment]
float[] sigma;//stores[pixel(index)->sigma]
int max=0, min=4000;//minimum and maximum posibble values for measurment (used for mapping) 
final int MEASUREMENTS=100;

void setup() {
  size(512, 424);
  frameRate(30);
  //variable initialitation
  kinect = new Knct(this);
  data = new int[width*height][MEASUREMENTS];//255 measurment points = 8.5 seconds recording @30fps
  sigma   = new float[width*height];
}

void draw() {
  //image(kinect.getImage(), 0, 0,width,height);
  //update data
  int[] a = kinect.getDepth();
  for (int i = 0; i<a.length; i++) {
    //data[i][frameCount%data[0].length]=a[i];                           //update data //looping
    if (frameCount<data[0].length)data[i][frameCount]=a[i];
    else noLoop();//update data //once
  }
  //update sigma
  for (int i = 0; i<data.length; i++) {
    sigma[i]=sigma(data[i]);
    if (frameCount==MEASUREMENTS) {
      //printArray(data[i]);
      noLoop();
    }
  }
  //visulice sigma
  loadPixels();
  for (int i = 0; i<data.length-1; i++) {
    pixels[i]=color(map(sigma[i], 0, 2000, 0, 255));
    //if (i==data.length/2)println(map(sigma[i], 0, 2000, 0, 255), sigma[i], i);//for debugging
  }//&&i==width*mouseY+mouseX
  updatePixels();
  surface.setTitle(String.format(getClass().getName()+ "  [fps %6.2f]   [frame %d]   [size %d/%d]", frameRate, frameCount, width, height));
  saveFrame("data/###.jpg");
}
float sigma(int[] data) {
  float average = 0;
  for (int i=0; i<data.length; i++) {
    average+=data[i];
  }
  average/=data.length;
  float sigma = 0; 
  for (int i=0; i<data.length; i++) {
    sigma+=abs(average-data[i]);
  }
  sigma/=data.length;
  return sigma;
}
float average(int[] data) {
  float average = 0;
  for (int i=0; i<data.length; i++) {
    average+=data[i];
  }
  average/=data.length;
  return average;
}
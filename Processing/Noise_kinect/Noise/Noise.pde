/* //<>//
Calculates mean_deviation value for every pixel and presents it by mapping to HSB for visualitation.
 MAX decides the maximum mean_deviation to map, values biger than MAX are displayed black.
 MAX can be incremented by pressing 'q' and decremented by pressing 'a'.
 */
Knct kinect;//kinect variable
int[][] data;//stores[pixel index][different measurments for mean_deviation measurment]
float[] mean_deviation;//stores[pixel index to mean_deviation]
float MIN=0, MAX=2;//minimum and maximum for color mapping (if more than max ->black)
final float inc=.1;//increment/decrement for MAX with up/down arrow
final int MEASUREMENTS=90;//amount of measurments to be taken
final int OFFSET=30;//wait time before beginnig to collect measurments(it's for the kinect lag)
final boolean visual=false;//setting for visualicing mean_deviation as it is calculated
void setup() {
  size(512, 424);
  frameRate(30);
  colorMode(HSB, 255, 255, 255);
  kinect = new Knct(this);
  data = new int[width*height][MEASUREMENTS];//data[index of pixel][which frame] //stores all of the pixel values through time/frame
  mean_deviation   = new float[width*height];//mean_deviation[index of pixel] //stores the mean_deviation value of every pixel
}

void draw() {
  if (frameCount>=OFFSET && frameCount-OFFSET<MEASUREMENTS) {//collect if frameCount-OFFSET is between 0 and MEASUREMENTS
    int[] a = kinect.getDepth();//get kinect frame
    if (frameCount==OFFSET) { //when the first "real frame" comes, copy the value to every frame, this asures a realistic visualitation of the mean_deviation as it is calculated
      for (int i = 0; i<data.length; i++) {
        java.util.Arrays.fill(data[i], a[i]);
      }
    }
    //update data:
    for (int i = 0; i<a.length; i++) {//for every pixel copy value from a to data
      data[i][max(frameCount-OFFSET, 0)] = a[i];
    }
    //update mean_deviation:
    for (int i = 0; i<data.length; i++) {//go through every pixel and calculate its mean_deviation
      mean_deviation[i] = mean_deviation(data[i]);
    }
    //visualice mean_deviation:
    if (visual)visualice_mean_deviation();
  }
  
  //reading individual mean_deviations by pressing the pixel:
  if (mousePressed)println(mean_deviation[constrain(mouseX+mouseY*kinect.width, 0, mean_deviation.length-1)]);
  
  surface.setTitle(String.format(getClass().getName()+ "  [fps %6.2f]   [frame %d]   [size %d/%d]", frameRate, frameCount, width, height));//show info in window
}

float mean_deviation(int[] dataIN) {//calculate mean_deviation of values stored in dataIN
  //calculate average:
  float average = 0;
  for (int i=0; i<dataIN.length; i++) {
    average+=dataIN[i];
  }
  average/= dataIN.length;
  //calculate mean_deviation:
  float mean_deviation = 0; 
  for (int i=0; i<dataIN.length; i++) {
    mean_deviation+=abs(average-dataIN[i]);
  }
  mean_deviation/= dataIN.length;
  return mean_deviation;
}

void visualice_mean_deviation() {
  //visualice mean_deviation:
  loadPixels();
  for (int i = 0; i<data.length; i++) {
    pixels[i] = mean_deviation[i]>MAX?color(0):color(map(mean_deviation[i], MIN, MAX, 0, 255), 255, 255);
  }
  updatePixels();
}

void keyPressed() {
  switch(key) {
    case('q'):
    MAX+=inc;
    break;
    case('a'):
    MAX-=inc;
    break;
  }
  println("MAX: ", MAX);
  println( "measurments: "+(frameCount-OFFSET));
  visualice_mean_deviation();
}
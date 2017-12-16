Knct kinect;
int[] data;//stores the amount values [deviation +10] 
int index;
final int OFFSET = 50;
final int frames_for_average_calculation = 60;
int[] averages = new int[frames_for_average_calculation];
float average = 0f;
float max_deviation = 0;

void setup() {
  size(512, 424);
  kinect = new Knct(this);
  index = kinect.width/2+(kinect.height/2)*kinect.width;//index of the center pixel
  index = kinect.width/2+(kinect.height/4)*kinect.width;
}

void draw() {
  image(kinect.getImage(), 0, 0);
  if (frameCount>=OFFSET && frames_for_average_calculation>frameCount-OFFSET)averages[frameCount-OFFSET]=kinect.getDepth()[index];//fill averages array with data
  if (frames_for_average_calculation==frameCount-OFFSET) {//calculate average and maximum deviation
    //calculate average:
    average = 0f;
    for (int i = 0; i<averages.length; i++) {
      average+=averages[i];
    }
    average/=averages.length;
    //calculate max deviation:
    max_deviation = 0;
    for (int i = 0; i<averages.length; i++) {
      max_deviation = abs(average-averages[i])>max_deviation?(average-averages[i]):max_deviation;
    }
    println("max_deviation: ", max_deviation);
    //intialice data array:
    data = new int[round(max_deviation)*2+1];//size of data is dependent of maximum deviation (example max_deviation = 3) ([0](average-3),[1](average-2),[2](average-1),[3](average),[4](average+1),[5](average+2),[6](average+3))
    println(data.length);
    java.util.Arrays.fill(data, 0);
  }

  if (frameCount>=OFFSET && frameCount-OFFSET>frames_for_average_calculation) {
    int indexx = round(max_deviation)+round(average)-kinect.getDepth()[index];
    if (indexx>=0 && indexx<data.length)data[indexx]+=1;//not acurate due to raunding of average. Data only suitable for visualitation
    if (frameCount == 50+frames_for_average_calculation) printArray(data);
    paint(data);
  }

  surface.setTitle(String.format(getClass().getName()+ "  [fps %6.2f]   [frame %d]   [size %d/%d]", frameRate, frameCount, width, height));
}
void keyPressed() {
  if (key==' ')saveFrame(str(millis())+"noise"+".png");
}
void paint(int[] d) {
  stroke(0, 255, 0);
  strokeWeight(1);
  fill(0, 255, 0, 100);
  beginShape();
  vertex(0, height);
  int max = -1;
  for (int i = 0; i<d.length; i++) {
    max = d[i]>max?d[i]:max;
  }
  for (int i = 0; i<d.length; i++) {
    vertex(i*(width/(d.length-1)),
    height-d[i]*(height/max));
  }
  vertex(width, height);
  endShape();
}
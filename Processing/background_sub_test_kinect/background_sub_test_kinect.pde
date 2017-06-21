import java.util.Arrays;
import processing.video.*;

Knct kinect;
int N = 30;// N is the number of preceding images taken for averaging
int mtreshold = 803;//treshold to be considered movement
Capture video;
int[][] b;//[time][pixel] STACK(frames made in the past) + actual information of the frames

void setup() {
  size(512, 424);
  kinect = new Knct(this);
  video = new Capture(this, width, height);
  b = new int[N][video.width*video.height];
}

void draw() {
  background(255);
  int[] kinectDepht = kinect.getDepth();
  loadPixels();
  int index = 0;
  for (int y = 0; y < kinect.height; y++) {     //go throughevery pixel
    for (int x = 0; x < kinect.width; x++) {    //*
      if (abs(mean(b, index) - kinectDepht[index]) < mtreshold) { //depth tresholding//
        pixels[index] = color(255);
      } else {
        pixels[index] = color(255, 0, 0);//color((int)map(kinectDepht[index],0,4095,0,255));
      }
      index++;
    }
  }
  b = push(b, kinectDepht);//update queue
  updatePixels();
}

int[][] push(int[][] buf, int[] a) {//pushes a into buf (queue structure)
  for (int i = 1; i<b.length; i++) {//it works ;) 
    for (int j = 0; j<b[i].length; j++) {
      buf[i-1][j]=buf[i][j];
    }
  }
  for (int i = 0; i<b[0].length; i++) {
    buf[buf.length-1][i]=a[i];
  }
  return buf;
}

int mean(int[][] buf, int index) {///give de average value of pixel index i
  int a = buf[buf.length-1][index];  //keeps track of the value to be averaged, inicialized with current pixel value

  for (int i = 0; i<buf.length-1; i++) { //goes through every frame made in the past and makes the median
    a += buf[i][index];//add every value
  }
  a /= buf.length;//divide between the amount of values adde
  return a;//return average
}
int median(int[][] buf, int index) {
  int[] a = new int[buf.length];
  for (int i=0; i<buf.length; i++) {
    a[i] = buf[i][index];
  }
  Arrays.sort(a);
  if (a.length%2==0) {
    return (a[a.length/2]+a[(a.length/2)+1])/2;
  } else {
    return a[ceil(a.length/2)];
  }
}
void keyPressed() {//captures and saves frame width random name and frame
  saveFrame(str(random(100))+"_"+str(frameCount)+".png");
}
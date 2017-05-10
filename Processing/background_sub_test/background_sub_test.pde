import processing.video.*; //<>//


int N = 100;// N is the number of preceding images taken for averaging
int mtreshold = 50;//treshold to be considered movement
Capture video;
int[][] b;//[time][pixel] STACK(frames made in the past) + actual information of the frames
int n = 0;//t active (used to keep track at first buffer loop when the buffer is empty(initializing the stack))

void setup() {
  size(640, 480);
  video = new Capture(this, width, height);
  video.start();
  b = new int[N][video.width*video.height];
}

void draw() {
  if (video.available()) {
    background(255);
    video.read();
    video.loadPixels();
    loadPixels();
    int index = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        if (n<N) b[n][index] = video.pixels[index]; //first loading of the buffer: the b array is loaded with frame at time n 
        if (abs(brightness(mean(b, index)) - brightness(video.pixels[index]))< mtreshold) { //brightness tresholding//
          pixels[index] = color(0);
        } else {
          pixels[index] = color(0,0,255);//video.pixels[index];//b[b.length-1][index];
        }
        index++;
      }
    }
    if (n<=N)n++;
    b = push(b, video.pixels);
    updatePixels();
  }
}

int[][] push(int[][] buf, int[] a) {//pushes a into buf (queue structure)
  //Arrays.copyOfRange(buff, 0, 1);
  for (int i = 1; i<b.length; i++) {
    for (int j = 0; j<b[i].length; j++) {
      buf[i-1][j]=buf[i][j];
    }
  }
  for (int i = 0; i<b[0].length; i++) {
    buf[buf.length-1][i]=a[i];
  }
  return buf;
}

color mean(int[][] buf, int index) {///give de average value of pixel index i
  int a = (buf[buf.length-1][index] >> 24) & 0xFF;  //
  int r = (buf[buf.length-1][index] >> 16) & 0xFF;   ////acumulates the value to be averaged inicialized width current pixel value
  int g = (buf[buf.length-1][index] >>  8) & 0xFF;  //
  int b = (buf[buf.length-1][index]      ) & 0xFF;
  ;  //

  for (int i = 0; i<buf.length-1; i++) { //goes through every "t" and makes the median
    a += (buf[i][index] >> 24) & 0xFF;
    r += (buf[i][index] >> 16) & 0xFF;  
    g += (buf[i][index] >> 8) & 0xFF;   // Faster way of getting green(argb) with bit shifting
    b += buf[i][index] & 0xFF;
  }
  a /= buf.length;
  r /= buf.length;
  g /= buf.length;
  b /= buf.length;

  return color(r, g, b, a);
}
void keyPressed(){
 saveFrame("srtrgf2.png");
}
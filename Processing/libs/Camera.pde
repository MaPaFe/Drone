import processing.video.*;
class Knct {
  Capture video;
  static int width = 512;
  static int height = 424;

  Knct(PApplet pa) {
    video = new Capture(pa, 640, 480);
    video.start();
  }

  int[] getDepth() {
    if (video.available()) { //check if video is available
      video.read(); //update to current frame
    }
    video.loadPixels(); //prepare array
    Capture temp = video; //copy to temporal array
  for (int i = 0; i<temp.pixels.length; i++)
      temp.pixels[i] = int(java.awt.Color.RGBtoHSB((temp.pixels[i] >> 16) & 0xff, (temp.pixels[i] >> 8) & 0xff, temp.pixels[i] & 0xff, null)[2]*4000); //extract normalized brightness values and scale to kinect(7000)
    return temp.get(64, 28, this.width, this.height).pixels; //return video frame
  }

  PImage getImage() {
    if (video.available()) { //check if video is available
      video.read(); //update to current frame
    }
    Capture temp = video; //copy to temporal array
    for (int i = 0; i<temp.pixels.length; i++)
      temp.pixels[i] = color(java.awt.Color.RGBtoHSB((temp.pixels[i] >> 16) & 0xff, (temp.pixels[i] >> 8) & 0xff, temp.pixels[i] & 0xff, null)[2]*255,java.awt.Color.RGBtoHSB((temp.pixels[i] >> 16) & 0xff, (temp.pixels[i] >> 8) & 0xff, temp.pixels[i] & 0xff, null)[2]*255,java.awt.Color.RGBtoHSB((temp.pixels[i] >> 16) & 0xff, (temp.pixels[i] >> 8) & 0xff, temp.pixels[i] & 0xff, null)[2]*255); //extract and scale normalized brightness values and set as R, G and B (gives a black and white image)
    return temp;
  }
}

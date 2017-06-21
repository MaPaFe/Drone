import org.openkinect.processing.*;

class Knct {
  Kinect2 kinect;
  int width, height;

  Knct(PApplet pa) {
    kinect = new Kinect2(pa);
    kinect.initDepth();
    kinect.initDevice();
    
    width = 512;
    height = 424;
  }

  int[] getDepth() {
    return kinect.getRawDepth();
  }

  PImage getImage() {
    return kinect.getDepthImage();
  }
}
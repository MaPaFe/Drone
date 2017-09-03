import org.openkinect.processing.*;

class Knct {
  Kinect2 kinect;
  static int width = 512;
  static int height = 424;

  Knct(PApplet pa) {
    kinect = new Kinect2(pa);
    kinect.initDepth();
    kinect.initDevice();
  }

  int[] getDepth() {
    return kinect.getRawDepth();
  }

  PImage getImage() {
    return kinect.getDepthImage();
  }
}

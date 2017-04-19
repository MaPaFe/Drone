import org.openkinect.processing.*;

class Knct {
  Kinect2 kinect;

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

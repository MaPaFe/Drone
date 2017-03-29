import KinectPV2.*;

class Knct {
  KinectPV2 kinect;

  Knct(PApplet pa) {
    kinect = new Kinect2(pa);
    kinect.enableDepthImage(true);
    kinect.init(true);
  }

  int[] getDepth() {
    return kinect.getRawDepthData();
  }

  PImage getImage() {
    return kinect.getDepthImage();
  }
}
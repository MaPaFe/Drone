import KinectPV2.*;

class Knct {
  KinectPV2 kinect;

  Knct(PApplet pa) {
    kinect = new KinectPV2(pa);
    kinect.enableDepthImg(true);
    kinect.init();
  }

  int[] getDepth() {
    return kinect.getRawDepthData();
  }

  PImage getImage() {
    return kinect.getDepthImage();
  }
}
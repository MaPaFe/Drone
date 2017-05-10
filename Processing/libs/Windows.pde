import KinectPV2.*;

class Knct {
  KinectPV2 kinect;
  int width, height;

  Knct(PApplet pa) {
    kinect = new KinectPV2(pa);
    kinect.enableDepthImg(true);
    kinect.init();
    width = 512;
    height = 424;
  }

  int[] getDepth() {
    return kinect.getRawDepthData();
  }

  PImage getImage() {
    return kinect.getDepthImage();
  }
}

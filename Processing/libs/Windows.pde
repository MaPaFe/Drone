import KinectPV2.*;

static class Knct {
  KinectPV2 kinect;
  static int width = 512;
  static int height = 424;

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

  static PVector kinectToReal(PVector kinect) {
    float focalX = 364.18;
    float focalY = 364.33;
    float principleX = Knct.width/2;
    float principleY = Knct.height/2;
    float x = (kinect.x - principleX) * kinect.z / focalX;
    float y = (kinect.y - principleY) * kinect.z / focalY;

    kinect = new PVector(x, y, kinect.z);
    return kinect;
  }

  static PVector realToKinect(PVector real) {
    float focalX = 364.18;
    float focalY = 364.33;
    float principleX = Knct.width / 2;
    float principleY = Knct.height / 2;
    float x = (real.x * focalX / real.z) + principleX;
    float y = (real.y * focalY / real.z) + principleY;

    real = new PVector(x, y, real.z);
    return real;
  }
}

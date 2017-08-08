void setup() {
  size(640, 480);
}
void draw() {
}
PVector realToKinect(PVector real) {
  int xmax = 512;
  int ymax = 424;
  int zmax =4500;
  float x = (real.x/abs(real.x))*((xmax/2)/zmax)*real.z + xmax/2;
  float y = (real.y/abs(real.y))*((ymax/2)/zmax)*real.z + ymax/2;
  PVector kinect = new PVector(x, y, real.z);
  return kinect;
}
PVector kinectToReal(PVector kinect) {
  int xmax = 512;
  int ymax = 424;
  int zmax =4500;
  float degx = radians(70);
  float degy = radians(60);
  float x = (((((tan(degx/2)*zmax*2)/2)/zmax)*kinect.z)/(xmax/2))*kinect.x;
  float y = (((((tan(degy/2)*zmax*2)/2)/zmax)*kinect.z)/(ymax/2))*kinect.y;
  PVector real = new PVector(x, y, kinect.z);
  return real;
}
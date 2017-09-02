void setup() {
  size(640, 480);
}
void draw() {
}
//https://threeconstants.wordpress.com/2014/11/21/kinect-point-cloud-normals-rendering-part-1/
PVector KinectToReal(PVector kinect) {
  float focalx = 364.18;
  float focaly = 364.33;
  float principelx = kinect.width/2;
  float principely = kinect.height/2;
  float x = (kinect.x-principelx)*kinect.z/focalx;
  float y = (kinect.y-principely)*kinect.z/focaly;

  kinect = new PVector(x, y, kinect.z);
  return kinect;
}
PVector RealToKinect(PVector real) {
  float focalx = 364.18;
  float focaly = 364.33;
  float principelx = kinect.width/2;
  float principely = kinect.height/2;
  float x = (real.x*focalx/real.z)+principelx;
  float y = (real.y*focaly/real.z)+principely;

  real = new PVector(x, y, real.z);
  return real;
}
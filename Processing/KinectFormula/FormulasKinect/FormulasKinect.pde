void setup() {
  size(640, 480);
}
void draw() {
}
//https://threeconstants.wordpress.com/2014/11/21/kinect-point-cloud-normals-rendering-part-1/
PVector kinectToReal(PVector kinect) {
  float focalx = 364.18;
  float focaly = 364.33;
  float principleX = Knct.width/2;
  float principleY = Knct.height/2;
  float x = (kinect.x-principleX)*kinect.z/focalx;
  float y = (kinect.y-principleY)*kinect.z/focaly;

  kinect = new PVector(x, y, kinect.z);
  return kinect;
}

PVector realToKinect(PVector real) {
  float focalx = 364.18;
  float focaly = 364.33;
  float principleX = Knct.width/2;
  float principleY = Knct.height/2;
  float x = (real.x*focalx/real.z)+principleX;
  float y = (real.y*focaly/real.z)+principleY;

  real = new PVector(x, y, real.z);
  return real;
}
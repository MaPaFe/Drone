import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

int zmax=4500;
Knct kinect;
PeasyCam cam;
final int SCALE_DEFINED_WIDTH_Z_SIZE = 400;
float w = tan(70/2)*zmax*2/4500*SCALE_DEFINED_WIDTH_Z_SIZE;
float h = tan(70/2)*zmax*2/4500*SCALE_DEFINED_WIDTH_Z_SIZE;
int res = 4;
int[] depth;
void setup() {
  //size(640, 480, P3D);
  fullScreen(P3D);
  colorMode(HSB);
  strokeWeight(4);
  kinect = new Knct(this);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(5000);
}
void draw() {
  //println(frameRate);///////////////////////////////centrar para blobs
  rotateX(PI);
  rotateZ(PI);
  background(0);
  //translate(width/2,height/2);
  stroke(360, 0, 100);
  knct_box(w, -h, SCALE_DEFINED_WIDTH_Z_SIZE);
  //int med=0;
  //int count=0;
  res = keyPressed?1:4;
  if(res==1) strokeWeight(1);
  else strokeWeight(4);;
  depth = kinect.getDepth();//if(frameCount<194)
  for (int x=0; x<kinect.width; x+=res) {
    for (int y=0; y<kinect.height; y+=res) {
      try{
      int index=y*kinect.width+x;
      float[] p = KinectToReal(x,y,depth[index]);
               // p = KinectToReal(pp[0],pp[1],pp[2]);
               // med+=p[2];
               // count++;
        //printArray(p);
        //point(KinectToReal(x,y,depth[index]),SCALE_DEFINED_WIDTH_Z_SIZE);
        point(p, SCALE_DEFINED_WIDTH_Z_SIZE);
      }
      catch(IndexOutOfBoundsException e) {
      }
    }
  }
  //med/=count                       ;
  //println(med);
  //image(kinect.getImage(),0,0);  
  //float[] p = KinectToReal(512/2, 424/2, 7000);///////////////
  //printArray(p);
  surface.setTitle(String.format(getClass().getName()+ "  [fps %6.2f]   [frame %d]   [size %d/%d]", frameRate, frameCount, width, height));
}

//https://threeconstants.wordpress.com/2014/11/21/kinect-point-cloud-normals-rendering-part-1/
float[] KinectToReal(float px, float py, float pz) {
  float focalx = 391.096;
  float focaly = 463.098;
  float principelx = kinect.width/2;
  float principely = kinect.height/2;
  float x = (px-principelx)*pz/focalx;
  float y = (py-principely)*pz/focaly;
   
  float[] realPoint = {x, y, pz};
  //float[] realPoint = {theta*1000,phi*1000,radius};
  return realPoint;
}
float[] RealToKinect(float px, float py, float pz) {
  float focalx = 391.096;
  float focaly = 463.098;
  float principelx = kinect.width/2;
  float principely = kinect.height/2;
  float x = (px*focalx/pz)+principelx;
  float y = (py*focaly/pz)+principely;
   
  float[] realPoint = {x, y, pz};
  //float[] realPoint = {theta*1000,phi*1000,radius};
  return realPoint;
}
void knct_box(float d, float w, int h) {
  pushMatrix();
  rotateX(HALF_PI);
  line(0, 0, 0, w, h, d);
  line(0, 0, 0, w, h, -d);

  line(0, 0, 0, -w, h, d);
  line(0, 0, 0, -w, h, -d);

  line(w, h, d, w, h, -d);
  line(w, h, -d, -w, h, -d);
  line(-w, h, d, -w, h, -d);
  line(-w, h, d, w, h, d);
  popMatrix();
}
void point(float[] p, float s) {
  stroke(map(p[2], 0, 4500, 0, 360), 360, 360);
  s = s/4500;
  point(p[0]*s, p[1]*s, p[2]*s);
}
import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

int zmax=4500;
Knct kinect;
PeasyCam cam;
float FAKTOR=1;
float inc = .2;
float DEFINED_WIDTH_Z_SIZE = 6000/FAKTOR;
int minRes = 3;
int maxRes = 1;
int res = 3;
int[] depth;

void setup() {
  fullScreen(P3D);
  colorMode(HSB);
  kinect = new Knct(this);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(100000);
}
void draw() {
  DEFINED_WIDTH_Z_SIZE = 6000/FAKTOR;
  //translate(0,0,200);
  rotateX(PI);
  rotateZ(PI);
  background(0);
  //translate(width/2,height/2);
  stroke(360, 360, 360);
  knct_box(DEFINED_WIDTH_Z_SIZE);
  //int med=0;
  //int count=0;
  //
  if (res==1) strokeWeight(maxRes+1);
  else strokeWeight(minRes);
  noFill();
  depth = kinect.getDepth();
  for (int x=0; x<Knct.width; x+=res) {
    for (int y=0; y<Knct.height; y+=res) {
      try {
        int index=y*Knct.width+x;
        float[] p = KinectToReal(x, y, depth[index]/FAKTOR);
        point(p);
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
  float focalx = 364.18;
  float focaly = 364.33;
  float principelx = Knct.width/2;
  float principely = Knct.height/2;
  float x = (px-principelx)*pz/focalx;
  float y = (py-principely)*pz/focaly;

  float[] realPoint = {x, y, pz};
  //float[] realPoint = {theta*1000,phi*1000,radius};
  return realPoint;
}
float[] RealToKinect(float px, float py, float pz) {
  float focalx = 364.33;
  float focaly = 364.33;
  float principelx = Knct.width/2;
  float principely = Knct.height/2;
  float x = (px*focalx/pz)+principelx;
  float y = (py*focaly/pz)+principely;

  float[] realPoint = {x, y, pz};
  //float[] realPoint = {theta*1000,phi*1000,radius};
  return realPoint;
}
void keyPressed() {
  res = key==' '?maxRes:minRes;
  switch(keyCode) {
  case UP:   
    FAKTOR+=inc;
    println(FAKTOR);
    break;
  case DOWN: 
    FAKTOR = FAKTOR!=1?FAKTOR-inc:1;
    println(FAKTOR);
    break;
  }
}
void knct_box(float z) {
  pushMatrix();
  PVector p = new PVector(0, 0, 0);
  PVector p2 = new PVector(tan(radians(70/2))*z, tan(radians(60/2))*z, z);
  //println(radians(70));
  line(p.x, p.y, p.z, p2.x, p2.y, p2.z);
  line(p.x, p.y, p.z, -p2.x, p2.y, p2.z);
  line(p.x, p.y, p.z, -p2.x, -p2.y, p2.z);
  line(p.x, p.y, p.z, p2.x, -p2.y, p2.z);

  line(p2.x, p2.y, p2.z, -p2.x, p2.y, p2.z);
  line( -p2.x, p2.y, p2.z, -p2.x, -p2.y, p2.z);
  line(-p2.x, -p2.y, p2.z, p2.x, -p2.y, p2.z);
  line(p2.x, -p2.y, p2.z, p2.x, p2.y, p2.z);
  popMatrix();
}
void point(float[] p) {
  stroke(map(p[2], 0, DEFINED_WIDTH_Z_SIZE, 0, 360), 360, 360);
  point(p[0], p[1], p[2]);
}
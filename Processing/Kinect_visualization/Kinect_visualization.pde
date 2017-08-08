import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

int zmax=4500;
Knct kinect;
PeasyCam cam;
final int SCALE_DEFINED_WIDTH_Z_SIZE = 400;
float w = tan(70/2)*zmax*2/4500*SCALE_DEFINED_WIDTH_Z_SIZE;
float h = tan(70/2)*zmax*2/4500*SCALE_DEFINED_WIDTH_Z_SIZE;
final int res = 4;
void setup() {
  //size(640, 480, P3D);
  fullScreen(P3D);
  colorMode(HSB);
  kinect = new Knct(this);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5000);
}
void draw() {
  background(0);
  //translate(width/2,height/2);
  stroke(360, 0, 100);
  strokeWeight(2);
  //line(0,0,0,0,0,100);
  knct_box(w, -h, SCALE_DEFINED_WIDTH_Z_SIZE);
  int[] depth = kinect.getDepth();
  for (int x=0; x<kinect.width; x+=res) {
    for (int y=0; y<kinect.width; y+=res) {
      int index=y*kinect.width+x;
      try {
        float[] p = KinectToReal(x, y, depth[index]);
        //printArray(p);
        //point(KinectToReal(x,y,depth[index]),SCALE_DEFINED_WIDTH_Z_SIZE);
        point(p, SCALE_DEFINED_WIDTH_Z_SIZE);
      }
      catch(IndexOutOfBoundsException e) {
      }
    }
  }
  float[] p = KinectToReal(512/2, 424/2, 7000);
  printArray(p);
  surface.setTitle(String.format(getClass().getName()+ "  [fps %6.2f]   [frame %d]   [size %d/%d]", frameRate, frameCount, width, height));
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
  strokeWeight(4);
  stroke(map(p[2], 0, 4500, 0, 360), 360, 360);
  s = s/4500;
  point(p[0]*s, p[1]*s, p[2]*s);
}

float[] KinectToReal(int px, int py, int pz) {
  final float degx = radians(60.0); //max x-angle(theta)
  final float degy = radians(70.0); //max y-angle(phi)
  final int zmax = 4500;
  final float realDxmax=tan(degx/2)*zmax*2;
  final float realDymax=tan(degy/2)*zmax*2;
  final float dxmax = 512;
  final float dymax = 424;//println(dxmax,dymax);
  final float kx = dxmax/( tan(degx/2)*zmax*2);
  final float ky = dymax/( tan(degy/2)*zmax*2);
  float theta = 0.0; // x-rotation
  float phi = 0.0; // y-rotation
  float radius = pz;

  //to Angle and radius
  theta = atan((px-(dxmax/2))/(pz*kx))+(degx/2);
  phi = atan((py-(dymax/2))/(pz*ky))+(degy/2);
  radius = sqrt(sq((((realDxmax/zmax)*px)/zmax)*pz)+sq(pz)+sq((((realDymax/zmax)*py)/zmax)*pz));
  //radius*= cot( sqrt(sq(theta)+sq(phi)));
  //point(0, 0, radius);
  float lat1=degx/2;
  float lon1=degy/2;
  
  float lat2=theta;
  float lon2=phi;
  
  float a = radius*acos(sin(lat1)*sin(lat2)+cos(lat1)*cos(lat2)*cos(lon1 - lon2));//sin(lat1) sin(lat2) + cos(lat1) cos(lat2) cos(lon1 - lon2)
  //radius=radius/cos(a);

  //center the angles
  theta += HALF_PI-degx/2;
  phi += HALF_PI-degy/2;
  //println(degrees(theta),degrees(phi),radius);

  //spherical to cartesian
  float x1 = radius*sin(theta)*cos(phi);
  float y1 = radius*sin(theta)*sin(phi);
  float z1 = radius*cos(theta);

  //rotation of the coordinatesystem +HALF_PI/+90° in x-axes
  float x2 = x1*1+y1*0           +z1*0;
  float y2 = x1*0+y1*cos(HALF_PI)-z1*sin(HALF_PI);
  float z2 = x1*0+y1*sin(HALF_PI)+z1*cos(HALF_PI);

  //rotation of the coordinatesystem -PI/-180° in z-axes
  float x3 = x2*cos(-PI)-y2*sin(-PI)*y2+z2*0;
  float y3 = x2*sin(-PI)+y2*cos(-PI)+z2*0;
  float z3 = x2*0       +y2*0       +1*z2;

  float[] realPoint = {x3, y3, z3};
  //float[] realPoint = {theta*1000,phi*1000,radius};
  return realPoint;
}
float cot(float a){
return 1/tan(a);
}
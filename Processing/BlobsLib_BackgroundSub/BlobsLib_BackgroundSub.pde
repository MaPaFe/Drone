import blobDetection.*;

Knct kinect;
BlobDetection blobs;

int threshold = 250;
PImage background;

void setup() {
  size(1024, 424, P2D);

  kinect = new Knct(this);

  blobs = new BlobDetection(kinect.width, kinect.height);
  blobs.setThreshold(0.2f);
  blobs.setBlobMaxNumber(1);

  background = createImage(kinect.width, kinect.height, RGB);
}

void draw() {
  background(0);

  int[] kinectDepth = kinect.getDepth();
  PImage blobsImage = createImage(kinect.width, kinect.height, RGB);
  blobsImage.loadPixels();
  for (int i = 0; i < kinectDepth.length; i++) {
    if (abs(kinectDepth[i] - brightness(background.pixels[i])*4f) < threshold && kinectDepth[i] > 0) {
      blobsImage.pixels[i] = color(255);
    } else {
      blobsImage.pixels[i] = color(0);
    }
    //blobsImage.pixels[i] = color(map(kinectDepth[i], 0, 4096, 0, 255));
  }
  blobsImage.updatePixels();
  blobsImage.filter(BLUR, 3);

  blobs.computeBlobs(blobsImage.pixels);
  println(blobs.getBlobNb());
  println(kinectDepth[108544]);

  image(blobsImage, 0, 0);
  image(background, 512, 0);
  drawBlobsAndEdges(true, false);
}

void keyPressed() {
  background = kinect.getImage();
  background.filter(BLUR, 3);
}

void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges) {
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0; n<blobs.getBlobNb(); n++) {
    b = blobs.getBlob(n);
    if (b != null) {
      if (drawEdges) {
        strokeWeight(2);
        stroke(0, 255, 0);
        for (int m = 0; m < b.getEdgeNb(); m++) {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null) line(eA.x*kinect.width, eA.y*kinect.height, eB.x*kinect.width, eB.y*kinect.height);
        }
      }
      if (drawBlobs) {
        strokeWeight(5);
        stroke(255, 0, 0);
        rect(b.xMin*kinect.width, b.yMin*kinect.height, b.w*kinect.width, b.h*kinect.height);
      }
    }
  }
}
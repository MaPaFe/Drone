import blobDetection.*;

Knct kinect;
BlobDetection blobs;

int threshold = 1000;

void setup() {
  size(512, 424, P2D);

  kinect = new Knct(this);

  blobs = new BlobDetection(width, height);
  blobs.setThreshold(0.2f);
  blobs.setBlobMaxNumber(1);
}

void draw() {
  background(0);

  int[] kinectDepth = kinect.getDepth();
  PImage blobsImage = createImage(kinect.width, kinect.height, RGB);
  blobsImage.loadPixels();
  for (int i = 0; i < kinectDepth.length; i++) {
    if (kinectDepth[i] < threshold && kinectDepth[i] > 0) {
      blobsImage.pixels[i] = color(0);
    } else {
      blobsImage.pixels[i] = color(255);
    }
  }
  blobsImage.updatePixels();
  blobsImage.filter(BLUR, 3);

  blobs.computeBlobs(blobsImage.pixels);

  image(blobsImage, 0, 0);
  drawBlobsAndEdges(true, false);
}

void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges) {
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0; n<blobs.getBlobNb(); n++) {
    b=blobs.getBlob(n);
    if (b!=null) {
      // Edges
      if (drawEdges) {
        strokeWeight(2);
        stroke(0, 255, 0);
        for (int m=0; m<b.getEdgeNb(); m++) {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
              eA.x*width, eA.y*height, 
              eB.x*width, eB.y*height
              );
        }
      }

      // Blobs
      if (drawBlobs) {
        strokeWeight(5);
        stroke(255, 0, 0);
        rect(
          b.xMin*width, b.yMin*height, 
          b.w*width, b.h*height
          );
      }
    }
  }
}
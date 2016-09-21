class Blob {
  PVector min, max;

  Blob(float x, float y) {
    min = new PVector(x, y);
    max = new PVector(x, y);
  }

  void add(float x, float y) {
    min.set(min(min.x, x), min(min.y, y));
    max.set(max(max.x, x), max(max.y, y));
  }

  boolean isNear(float circleX, float circleY, float radius) {
    float rectangleX = min.x;
    float rectangleY = min.y;
    float rectangleWidth = max.x - min.x;
    float rectangleHeight = max.y - min.y;
    float circleDistanceX = abs(circleX - rectangleX - rectangleWidth/2);
    float circleDistanceY = abs(circleY - rectangleY - rectangleHeight/2);

    if (circleDistanceX > rectangleWidth/2 + radius) return false;
    if (circleDistanceY > rectangleHeight/2 + radius) return false;
    if (circleDistanceX <= rectangleWidth/2) return true;
    if (circleDistanceY <= rectangleHeight/2) return true;

    float cornerDistanceSq = sq(circleDistanceX - rectangleWidth/2) + sq(circleDistanceY - rectangleHeight/2);

    return cornerDistanceSq <= sq(radius);
  }

  float size() {
    return min.dist(max);
  }

  void display() {
    rectMode(CORNERS);
    noFill();
    stroke(255);
    rect(min.x, min.y, max.x, max.y);
  }
}

void blobs() {
  int[] depth = kinect.getRawDepth();
  PImage bkg = kinect.getDepthImage();

  blobs.clear();

  display.loadPixels();
  for (int x = 0; x < kinect.depthWidth; x++) {
    for (int y = 0; y < kinect.depthHeight; y++) {
      int index =  x + y*kinect.depthWidth;
      int rawDepth = depth[index];
      int bkgDepth = background[index];
      if (rawDepth > 0 && delta(rawDepth, bkgDepth) > threshold) {
        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y, 32)) {
            b.add(x, y);
            found = true;
          }
        }
        if (!found) blobs.add(new Blob(x, y));
        display.set(x, y, color(170, 0, 0));
      } else display.set(x, y, bkg.pixels[index]);
    }
  } 
  display.updatePixels();
}

float delta(float x, float y) {
  return abs(x - y);
}
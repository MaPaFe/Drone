class Drone {
  PVector currentDronePos, previousDronePos, predictionObserved;

  Knct kinect;
  PID[] pids;

  Drone(PApplet pa) {
    currentDronePos = new PVector();
    previousDronePos = new PVector();
    predictionObserved = new PVector();

    kinect = new Knct(pa);

    pids = new PID[3];
    pids[0] = new PID(pidKs[0][0], pidKs[0][1], pidKs[0][2]); // throttle
    pids[1] = new PID(pidKs[1][0], pidKs[1][1], pidKs[1][2]);    // alante atras
    pids[2] = new PID(pidKs[2][0], pidKs[2][1], pidKs[2][2]);    // izq der
  }

  void update(PVector setPoint) {
    currentDronePos = searchDrone(FIND_FIRST_THRESHOLD);

    if (currentDronePos != null) {
      if (GRAPHS) {
        for (int i = 0; i < history.length; i++) {
          history[i][frameCount % history[i].length] = Knct.realToKinect(currentDronePos).array()[i];
        }
      }

      if (serial.available() > 0) {
        byte[] vals = new byte[4];

        vals[0] = (byte) map(pids[0].compute(currentDronePos.y, setPoint.y), -127, 127, -90, 127);
        vals[1] = (byte) pids[1].compute(currentDronePos.z, setPoint.z);
        vals[2] = (byte) pids[2].compute(currentDronePos.x, setPoint.x);
        vals[3] = 0;

        serial.clear();
        serial.write(vals);
        printArray(vals);
      }
    }
  }

  PVector searchDrone(int threshold) {
    int[] depth = kinect.getDepth();
    PImage blobsImage = createImage(Knct.width, Knct.height, RGB);

    BlobDetection blobs = new BlobDetection(Knct.width, Knct.height);
    blobs.setThreshold(0.25);
    blobs.setBlobMaxNumber(1);

    blobsImage.loadPixels();

    for (int i = 0; i < depth.length; i++) {
      if (depth[i] < threshold && depth[i] > 0) {
        blobsImage.pixels[i] = color(0);
      } else {
        blobsImage.pixels[i] = color(255);
      }
    }

    blobsImage.updatePixels();
    fastblur(blobsImage, 2);

    blobs.computeBlobs(blobsImage.pixels);
    
    // set(0, 0, Knct.getImage());
    set(0, 0, blobsImage);
    drawBlobsAndEdges(blobs, true, false);

    int averageDepth = 0, counter = 0;
    if (blobs.getBlobNb() >= 1) {
      Blob b = blobs.getBlob(0);
      for (float x = b.xMin * Knct.width; x < b.xMax * Knct.width; x++) {
        for (float y = b.xMin * Knct.height; y < b.yMax * Knct.height; y++) {
          int i = (int) x + (int) y * blobsImage.width;
          if (depth[i] < threshold && depth[i] > 0) {
            averageDepth += depth[i];
            counter++;
          }
        }
      }
      if (counter > 0) averageDepth /= counter;
      else averageDepth = FIND_FIRST_THRESHOLD;
      
      return Knct.kinectToReal(new PVector(b.x * Knct.width, b.y * Knct.height, averageDepth));
    }
    return null;
  }
}
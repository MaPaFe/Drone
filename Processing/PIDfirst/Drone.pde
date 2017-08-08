class Drone {
  final int MIN_BOX_THRESHOLD = 20;
  final int MAX_BOX_THRESHOLD = 100;
  final int BOX_INCREMENT = 10;

  PVector currentDronePos, previousDronePos, predictionObserved;
  boolean foundAtBeginning;

  PID[] pids;

  Drone() {
    currentDronePos = new PVector();
    previousDronePos = new PVector();
    predictionObserved = new PVector();

    foundAtBeginning = false;

    pids = new PID[3];
    pids[0] = new PID(-1, 0, -10);
    pids[1] = new PID(-1, 0, -10);
    pids[2] = new PID(-1, 0, -10);
  }

  void update(PVector setPoint) {
    if (!foundAtBeginning) {
      currentDronePos = findAtBeginning(FIND_FIRST_THRESHOLD);

      if (currentDronePos != null) {
        //println("-----------------------");
        foundAtBeginning = true;
        predictionObserved = currentDronePos.copy();
        previousDronePos = currentDronePos.copy();
      }
    } else {
      try {
        previousDronePos = currentDronePos.copy();

        // PVector prediction = PVector.add(predObserved, predIdeal);
        // prediction.mult(0.5);

        currentDronePos = searchDrone(predictionObserved);

        predictionObserved = PVector.add(currentDronePos, PVector.sub(currentDronePos, previousDronePos));

        if (serial.available() > 0) {
          byte[] vals = new byte[4];

          vals[0] = (byte) pids[0].compute(currentDronePos.y, setPoint.y);
          vals[1] = 0;//(byte) pids[1].compute(currentDronePos.z, setPoint.z);
          vals[2] = (byte) pids[2].compute(currentDronePos.x, setPoint.x);
          vals[3] = 0;

          serial.clear();
          serial.write(vals);
          printArray(vals);
        }

        //println(predictionObserved, currentDronePos, previousDronePos);
        //line(currentDronePos.x, currentDronePos.y, predictionObserved.x * -100, predictionObserved.y * -100);
        //noStroke();
        //fill(0, 0, 255);
        //ellipse(previousDronePos.x, previousDronePos.y, 8, 8);
        //fill(0, 255, 0);
        //ellipse(currentDronePos.x, currentDronePos.y, 8, 8);
        //fill(255, 0, 0);
        //ellipse(predictionObserved.x, predictionObserved.y, 8, 8);
      }
      catch (NullPointerException e) {
        foundAtBeginning = false;
      }
    }
  }

  PVector findAtBeginning(int threshold) {
    int[] depth = kinect.getDepth();
    PImage blobsImage = createImage(kinect.width, kinect.height, RGB);

    BlobDetection blobs = new BlobDetection(kinect.width, kinect.height);
    blobs.setThreshold(0.25);
    blobs.setBlobMaxNumber(1);

    blobsImage.loadPixels();

    int averageDepth = 0, counter = 0;
    for (int i = 0; i < depth.length; i++) {
      if (depth[i] < threshold && depth[i] > 0) {
        blobsImage.pixels[i] = color(0);
        averageDepth += depth[i];
        counter++;
      } else {
        blobsImage.pixels[i] = color(255);
      }
    }
    if (counter != 0) averageDepth /= counter;
    else averageDepth = FIND_FIRST_THRESHOLD;

    blobsImage.updatePixels();
    fastblur(blobsImage, 2);

    blobs.computeBlobs(blobsImage.pixels);

    // set(0, 0, kinect.getImage());
    set(0, 0, blobsImage);
    drawBlobsAndEdges(blobs, true, false);

    if (blobs.getBlobNb() >= 1) {
      Blob b = blobs.getBlob(0);
      return new PVector(b.x * kinect.width, b.y * kinect.height, averageDepth);
    }
    return null;
  }

  PVector searchDrone(PVector prediction) {
    int[] depth = kinect.getDepth();
    PImage blobsImage = createImage(kinect.width, kinect.height, RGB);

    BlobDetection blobs = new BlobDetection(blobsImage.width, blobsImage.height);
    blobs.setThreshold(0.25);
    blobs.setBlobMaxNumber(1);

    for (int threshold = MIN_BOX_THRESHOLD; threshold < MAX_BOX_THRESHOLD; threshold += BOX_INCREMENT) {
      //PVector boxMin = new PVector(
      //  max(prediction.x - threshold, 0), 
      //  max(prediction.y - threshold, 0), 
      //  prediction.z - threshold
      //  // max(prediction.z - threshold, 0)
      //  );
      //PVector boxMax = new PVector(
      //  min(prediction.x + threshold, kinect.width), 
      //  min(prediction.y + threshold, kinect.height), 
      //  prediction.z + threshold
      //  // min(prediction.z + threshold, 7000)
      //  );

      PVector boxMin = new PVector(max(prediction.x - threshold, 0), max(prediction.y - threshold, 0), FIND_FIRST_THRESHOLD - threshold);
      PVector boxMax = new PVector(min(prediction.x + threshold, kinect.width), min(prediction.y + threshold, kinect.height), FIND_FIRST_THRESHOLD + threshold);

      stroke(255, 0, 0);
      noFill();
      //rect(boxMin.x, boxMin.y, boxMax.x, boxMax.y);

      blobsImage.loadPixels();
      for (int i = 0; i < blobsImage.pixels.length; i++) blobsImage.pixels[i] = color(255);

      int averageDepth = 0, counter = 0;
      for (int y = int(boxMin.y); y < boxMax.y; y++) {
        for (int x = int(boxMin.x); x < boxMax.x; x++) {
          int i = x + y * blobsImage.width;
          if (depth[i] > boxMin.z && depth[i] < boxMax.z) {
            blobsImage.pixels[i] = color(0);
            averageDepth += depth[i];
            counter++;
          } else {
            blobsImage.pixels[i] = color(255);
          }
        }
      }
      if (counter != 0) averageDepth /= counter;
      else averageDepth = FIND_FIRST_THRESHOLD;

      blobsImage.updatePixels();
      fastblur(blobsImage, 2);

      blobs.computeBlobs(blobsImage.pixels);

      set(0, 0, kinect.getImage());
      // set(0, 0, blobsImage);
      drawBlobsAndEdges(blobs, true, false);

      if (blobs.getBlobNb() >= 1) {
        Blob b = blobs.getBlob(0);

        return new PVector(b.x * kinect.width, b.y * kinect.height, averageDepth);
      }
    }
    return null;
  }
}
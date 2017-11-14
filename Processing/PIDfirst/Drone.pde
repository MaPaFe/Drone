class Drone {
  final int MIN_BOX_THRESHOLD = 20;
  final int MAX_BOX_THRESHOLD = 100;
  final int BOX_INCREMENT = 10;

  PVector currentDronePos, previousDronePos, predictionObserved;
  boolean foundAtBeginning;

  Knct kinect;
  PID[] pids;

  Drone(PApplet pa) {
    currentDronePos = new PVector();
    previousDronePos = new PVector();
    predictionObserved = new PVector();

    foundAtBeginning = false;

    kinect = new Knct(pa);

    pids = new PID[3];
    //pids[0] = new PID(-0.85, 0.5, 0); // throttle
    //pids[1] = new PID(0.7, 0, 0);    // alante atras
    //pids[2] = new PID(0.7, 0, 0);    // izq der
    pids[0] = new PID(pidXP, pidXI, pidXD); // throttle
    pids[0].setMinMaxOut(50, 127);
    pids[1] = new PID(pidYP, pidYI, pidYD);    // alante atras
    pids[2] = new PID(pidZP, pidZI, pidZD);    // izq der
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

        // For future prediction with PID
        // PVector prediction = PVector.add(predObserved, predIdeal);
        // prediction.mult(0.5);

        currentDronePos = searchDrone(predictionObserved);

        if (GRAPHS) {        
          for (int i = 0; i < history.length; i++) {
            history[i][frameCount % history[i].length] = Knct.realToKinect(currentDronePos).array()[i];
          }
        }

        predictionObserved = PVector.add(currentDronePos, PVector.sub(currentDronePos, previousDronePos));

        if (serial.available() > 0) {
          byte[] vals = new byte[4];

          vals[0] = (byte) pids[0].compute(currentDronePos.y, setPoint.y);
          vals[1] = (byte) pids[1].compute(currentDronePos.z, setPoint.z);
          vals[2] = (byte) pids[2].compute(currentDronePos.x, setPoint.x);
          vals[3] = 0;

          serial.clear();
          serial.write(vals);
          printArray(vals);
        }

        // For visualizing the prediction
        // println(predictionObserved, currentDronePos, previousDronePos);
        // line(currentDronePos.x, currentDronePos.y, predictionObserved.x * -100, predictionObserved.y * -100);
        // noStroke();
        // fill(0, 0, 255);
        // ellipse(previousDronePos.x, previousDronePos.y, 8, 8);
        // fill(0, 255, 0);
        // ellipse(currentDronePos.x, currentDronePos.y, 8, 8);
        // fill(255, 0, 0);
        // ellipse(predictionObserved.x, predictionObserved.y, 8, 8);
      }
      catch (NullPointerException e) {
        foundAtBeginning = false;
      }
    }
  }

  PVector findAtBeginning(int threshold) {
    int[] depth = kinect.getDepth();
    PImage blobsImage = createImage(Knct.width, Knct.height, RGB);

    BlobDetection blobs = new BlobDetection(Knct.width, Knct.height);
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
      return Knct.kinectToReal(new PVector(b.x * Knct.width, b.y * Knct.height, averageDepth));
    }
    return null;
  }

  PVector searchDrone(PVector prediction) {
    prediction = Knct.realToKinect(prediction);
    int[] depth = kinect.getDepth();
    PImage blobsImage = createImage(Knct.width, Knct.height, RGB);

    BlobDetection blobs = new BlobDetection(blobsImage.width, blobsImage.height);
    blobs.setThreshold(0.25);
    blobs.setBlobMaxNumber(1);

    for (int threshold = MIN_BOX_THRESHOLD; threshold < MAX_BOX_THRESHOLD; threshold += BOX_INCREMENT) {
      PVector boxMin = new PVector(
        max(prediction.x - threshold, 0), 
        max(prediction.y - threshold, 0), 
        prediction.z - threshold
        // max(prediction.z - threshold, 0)
        );
      PVector boxMax = new PVector(
        min(prediction.x + threshold, Knct.width), 
        min(prediction.y + threshold, Knct.height), 
        prediction.z + threshold
        // min(prediction.z + threshold, 7000)
        );

      //PVector boxMin = new PVector(max(prediction.x - threshold, 0), max(prediction.y - threshold, 0), FIND_FIRST_THRESHOLD - threshold);
      //PVector boxMax = new PVector(min(prediction.x + threshold, Knct.width), min(prediction.y + threshold, Knct.height), FIND_FIRST_THRESHOLD + threshold);

      stroke(255, 0, 0);
      strokeWeight(4);
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

        return Knct.kinectToReal(new PVector(b.x * Knct.width, b.y * Knct.height, averageDepth));
      }
    }
    return null;
  }
}
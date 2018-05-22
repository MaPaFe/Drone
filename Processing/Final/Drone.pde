class Drone {
  // Konstante variablen initialisieren
  final int MIN_BOX_THRESHOLD = 50;
  final int MAX_BOX_THRESHOLD = 100;
  final int BOX_INCREMENT = 10;
  final int MAX_TIME_LOST = 2000;

  PVector currentDronePos, previousDronePos, predictionObserved;
  boolean foundAtBeginning;
  float lastSeen;

  Knct kinect;
  PID[] pids;

  Drone(PApplet pa) {
    currentDronePos = new PVector();
    previousDronePos = new PVector();
    predictionObserved = new PVector();

    foundAtBeginning = false;

    lastSeen = millis();

    kinect = new Knct(pa);

    pids = new PID[3];
    //pids[0] = new PID(-0.85, 0.5, 0); // throttle
    //pids[1] = new PID(0.7, 0, 0);    // alante atras
    //pids[2] = new PID(0.7, 0, 0);    // izq der
    pids[0] = new PID(pidKs[0][0], pidKs[0][1], pidKs[0][2]); // throttle     y
    //pids[0].setMinMaxOut(50, 127);
    pids[1] = new PID(pidKs[1][0], pidKs[1][1], pidKs[1][2]); // alante atras z
    pids[2] = new PID(pidKs[2][0], pidKs[2][1], pidKs[2][2]); // izq der      x
  }

  void update(PVector setPoint) {
    if (GRAPHS) {
      // Set the current frame on all axis
      for (int i = 0; i < history.length; i++) {
        history[i][graphIndex % history[i].length] = 0;
      }
    }
    // If the drone is not found (not box-tracking)
    if (!foundAtBeginning) {
      // Try to find it with depth-threshold
      currentDronePos = findAtBeginning(FIND_FIRST_THRESHOLD);

      pids[0].integral = 0;
      pids[1].integral = 0;
      pids[2].integral = 0;

      // If it was found
      if (currentDronePos != null) {
        //println("-----------------------");
        foundAtBeginning = true;
        // Initialize prediction stuffs
        predictionObserved = currentDronePos.copy();
        previousDronePos = currentDronePos.copy();
      }

      if (!graphStopped) {
        graphStopped = true;
        graphIndex+=20;
      }
    }
    // If it's already in box-tracking
    else {
      // Update the soon to be previous position
      //if (currentDronePos != null) break BREAK; // skip if null or something idk lol

      previousDronePos = currentDronePos.copy();

      // For future prediction with PID
      // PVector prediction = PVector.add(predObserved, predIdeal);
      // prediction.mult(0.5);

      // Find drone with box-tracking
      currentDronePos = searchDrone(predictionObserved);

      // If it's lost for too long, reset
      if (millis() - lastSeen > MAX_TIME_LOST) {
        foundAtBeginning = false;
      }

      if (GRAPHS) {
        // Update the position in all axis
        for (int i = 0; i < 3; i++) {
          history[i][graphIndex % history[i].length] = currentDronePos.array()[i] / 4 + width / 8;
        }
      }

      // Predict the next position
      predictionObserved = PVector.add(currentDronePos, PVector.sub(currentDronePos, previousDronePos));

      // If the Arduino is ready to recieve
      // (Aduino sends one byte back)
      if (serial.available() > 0) {
        byte[] vals = new byte[4];

        // Fill the array with the calculated PID values
        vals[0] = (byte) map(pids[0].compute(currentDronePos.y, setPoint.y), -127, 127, -127, 70); // y
        vals[1] = (byte) pids[1].compute(currentDronePos.z, setPoint.z);                           // z
        vals[2] = (byte) pids[2].compute(currentDronePos.x, setPoint.x);                           // x
        vals[3] = 0;

        for (int i = 0; i < 3; i++) {
          history[i+3][graphIndex % history[i+3].length] = vals[i];
        }
        graphIndex++;
        graphStopped = false;

        fill(51);
        rect(900, 300, 50, vals[2]); // x
        rect(850, 300, 50, vals[0]); // y
        rect(800, 300, 50, vals[1]); // z

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
  }

  PVector findAtBeginning(int threshold) {
    int[] depth = kinect.getDepth();
    // Create image to pass onto Blob Detection
    PImage blobsImage = createImage(Knct.width, Knct.height, RGB);

    // Create and configure Blob Detection
    BlobDetection blobs = new BlobDetection(Knct.width, Knct.height);
    blobs.setThreshold(0.25);
    blobs.setBlobMaxNumber(1);

    blobsImage.loadPixels();

    int averageDepth = 0, counter = 0;
    // Go throug all depth values
    for (int i = 0; i < depth.length; i++) {
      if (depth[i] < threshold && depth[i] > 0) {
        // Add that pixel to the blob image
        blobsImage.pixels[i] = color(0);
        // Add the depth to the average
        averageDepth += depth[i];
        counter++;
      } else {
        // Make that pixel white
        blobsImage.pixels[i] = color(255);
      }
    }
    // Calculate average
    if (counter > 0) averageDepth /= counter;
    else averageDepth = FIND_FIRST_THRESHOLD;

    blobsImage.updatePixels();
    // Blur to remove noise
    fastblur(blobsImage, 2);

    blobs.computeBlobs(blobsImage.pixels);

    // Draw the blobs image on the screen
    // set(0, 0, kinect.getImage());
    set(0, 0, blobsImage);
    drawBlobsAndEdges(blobs, true, false);

    // If there are any blobs
    if (blobs.getBlobNb() >= 1) {
      Blob b = blobs.getBlob(0);
      // Return the first one with scaled values
      return Knct.kinectToReal(new PVector(b.x * Knct.width, b.y * Knct.height, averageDepth));
    }
    return null;
  }

  PVector searchDrone(PVector prediction) {
    // Transform prediction to pixel units
    prediction = Knct.realToKinect(prediction);
    int[] depth = kinect.getDepth();
    PImage blobsImage = createImage(Knct.width, Knct.height, RGB);

    BlobDetection blobs = new BlobDetection(blobsImage.width, blobsImage.height);
    blobs.setThreshold(0.25);
    blobs.setBlobMaxNumber(1);

    // Start with a small box and make it bigger
    for (int threshold = MIN_BOX_THRESHOLD; threshold < MAX_BOX_THRESHOLD; threshold += BOX_INCREMENT) {
      // Define the minimum point of the box (one corner)
      PVector boxMin = new PVector(
                                   max(prediction.x - threshold, 0),
                                   max(prediction.y - threshold, 0),
                                   max(prediction.z - threshold, 0)
                                   );
      // The opposite corner
      PVector boxMax = new PVector(
                                   min(prediction.x + threshold, Knct.width),
                                   min(prediction.y + threshold, Knct.height),
                                   min(prediction.z + threshold, 7000)
                                   );

      //PVector boxMin = new PVector(max(prediction.x - threshold, 0), max(prediction.y - threshold, 0), FIND_FIRST_THRESHOLD - threshold);
      //PVector boxMax = new PVector(min(prediction.x + threshold, Knct.width), min(prediction.y + threshold, Knct.height), FIND_FIRST_THRESHOLD + threshold);

      // stroke(255, 0, 0);
      // strokeWeight(4);
      // noFill();
      //rect(boxMin.x, boxMin.y, boxMax.x, boxMax.y);

      blobsImage.loadPixels();
      // Clear the blobs image
      for (int i = 0; i < blobsImage.pixels.length; i++) {
        blobsImage.pixels[i] = color(255);
      }

      int averageDepth = 0, counter = 0;
      // For all pixels inside the box
      for (int y = int(boxMin.y); y < boxMax.y; y++) {
        for (int x = int(boxMin.x); x < boxMax.x; x++) {
          // Calculate the index
          int i = x + y * blobsImage.width;
          // If the depth is inside the box
          if (depth[i] > boxMin.z && depth[i] < boxMax.z) {
            // Add the pixels to the blobs image
            blobsImage.pixels[i] = color(0);

            averageDepth += depth[i];
            counter++;
          }
        }
      }

      if (counter > 0) averageDepth /= counter;
      else averageDepth = FIND_FIRST_THRESHOLD;

      blobsImage.updatePixels();
      fastblur(blobsImage, 2);

      blobs.computeBlobs(blobsImage.pixels);

      set(0, 0, kinect.getImage());
      // set(0, 0, blobsImage);
      drawBlobsAndEdges(blobs, true, false);

      if (blobs.getBlobNb() >= 1) {
        Blob b = blobs.getBlob(0);

        // Update the last seen time to now
        lastSeen = millis();
        return Knct.kinectToReal(new PVector(b.x * Knct.width, b.y * Knct.height, averageDepth));
      }

      //println(threshold);
      // If it wasn't found, increase the box size
    }
    // If it wasn't found even with the biggest box size
    return currentDronePos;
  }
}

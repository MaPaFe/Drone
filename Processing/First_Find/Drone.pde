class Drone {
  boolean foundAtBeginning = false;
  PVector currentDronePos, previousDronePos, predictionObserved;

  int averageRadius = 3;

  Drone() {
    currentDronePos = new PVector();
    previousDronePos = new PVector();
    predictionObserved = new PVector();
  }

  void update() {
    if (!foundAtBeginning) {
      currentDronePos = findAtBeginning(2000);

      if (currentDronePos != null) {
        println("-----------------------");
        foundAtBeginning = true;
        predictionObserved = currentDronePos.copy();
        previousDronePos = currentDronePos.copy();
      }
    } else {
      try {
        previousDronePos = currentDronePos.copy();

        //PVector prediction = PVector.add(predObserved, predIdeal);
        //prediction.mult(0.5);

        currentDronePos = searchDrone(predictionObserved);

        predictionObserved = PVector.add(currentDronePos, PVector.sub(currentDronePos, previousDronePos).mult(1));

        //if (currentDronePos == null) foundAtBeginning = false;


        println(predictionObserved, currentDronePos, previousDronePos);
        line(currentDronePos.x, currentDronePos.y, currentDronePos.x+(previousDronePos.x-currentDronePos.x)*-100, currentDronePos.y+(previousDronePos.y-currentDronePos.y)*-100);
        noStroke();
        fill(0, 0, 255);
        ellipse(previousDronePos.x, previousDronePos.y, 8, 8);
        fill(0, 255, 0);
        ellipse(currentDronePos.x, currentDronePos.y, 8, 8);
        fill(255, 0, 0);
        ellipse(predictionObserved.x, predictionObserved.y, 8, 8);
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

    //set(0, 0, kinect.getImage());
    set(0, 0, blobsImage);
    drawBlobsAndEdges(blobs, true, false);

    if (blobs.getBlobNb() >= 1) {
      Blob b = blobs.getBlob(0);
      return new PVector(b.x * kinect.width, b.y * kinect.height, depth[int(b.x + b.y * kinect.width)]);
    } else return null;
  }

  PVector searchDrone(PVector prediction) {
    int[] depth = kinect.getDepth();
    PImage blobsImage = createImage(kinect.width, kinect.height, RGB);

    BlobDetection blobs = new BlobDetection(blobsImage.width, blobsImage.height);
    blobs.setThreshold(0.25);
    blobs.setBlobMaxNumber(1);

    for (int threshold = 20; threshold < 100; threshold += 10) {
      PVector boxMin = new PVector(
        max(prediction.x - threshold, 0), 
        max(prediction.y - threshold, 0), 
        prediction.z - threshold
        );
      PVector boxMax = new PVector(
        min(prediction.x + threshold, kinect.width), 
        min(prediction.y + threshold, kinect.height), 
        prediction.z + threshold
        );
      //PVector boxMin = new PVector(max(prediction.x - threshold, 0), max(prediction.y - threshold, 0), 100 - threshold);
      //PVector boxMax = new PVector(min(prediction.x + threshold, kinect.width), min(prediction.y + threshold, kinect.height), 2000 + threshold);

      stroke(255, 0, 0);
      noFill();
      rect(boxMin.x, boxMin.y, boxMax.x, boxMax.y);

      blobsImage.loadPixels();
      for (int i = 0; i < blobsImage.pixels.length; i++) blobsImage.pixels[i] = color(255);
      for (int y = int(boxMin.y); y < boxMax.y; y++) {
        for (int x = int(boxMin.x); x < boxMax.x; x++) {
          int i = x + y * blobsImage.width;
          if (depth[i] > boxMin.z && depth[i] < boxMax.z) {
            blobsImage.pixels[i] = color(0);
          } else {
            blobsImage.pixels[i] = color(255);
          }
        }
      }

      blobsImage.updatePixels();
      fastblur(blobsImage, 2);

      blobs.computeBlobs(blobsImage.pixels);

      set(0, 0, kinect.getImage());
      //set(0, 0, blobsImage);
      drawBlobsAndEdges(blobs, true, false);

      if (blobs.getBlobNb() >= 1) {
        Blob b = blobs.getBlob(0);

        int averageDepth = 0;
        for (float y = b.y - averageRadius; y < b.y + averageRadius; y++) {
          for (float x = b.x - averageRadius; x < b.x + averageRadius; x++) {
            averageDepth += depth[int(
              (x * kinect.width) + (y * kinect.height) * kinect.width
              )];
          }
        }
        println(averageDepth);

        return new PVector(b.x * kinect.width, b.y * kinect.height, averageDepth);
      }
    }
    return null;
  }
}
static class Knct {
  BufferedReader reader;
  static int width = 512;
  static int height = 424;

  Knct(PApplet pa) {
    frameRate(30);
    reader = createReader("data.txt");
  }

  int[] getDepth() {
    try {
      return int(split(reader.readLine(), ","));
    }
    catch (IOException e) {
      int[] shit = {};
      exit();
      return shit;
    }
    catch (NullPointerException e) {
      int[] shit = {};
      exit();
      return shit;
    }
    //int[] shit = new int[width*height];
    //java.util.Arrays.fill(shit, 2000);
    //      return shit;
  }

  PImage getImage() {
    PImage out = createImage(width, height, RGB);
    int[] frame = getDepth();
    out.loadPixels();
    for (int i = 0; i < frame.length; i++) out.pixels[i] = color(map(frame[i], 0, 4096, 0, 255));
    out.updatePixels();
    return out;
  }

  static PVector kinectToReal(PVector kinect) {
    float focalX = 364.18;
    float focalY = 364.33;
    float principleX = Knct.width/2;
    float principleY = Knct.height/2;
    float x = (kinect.x - principleX) * kinect.z / focalX;
    float y = (kinect.y - principleY) * kinect.z / focalY;

    kinect = new PVector(x, y, kinect.z);
    return kinect;
  }

  static PVector realToKinect(PVector real) {
    float focalX = 364.18;
    float focalY = 364.33;
    float principleX = Knct.width / 2;
    float principleY = Knct.height / 2;
    float x = (real.x * focalX / real.z) + principleX;
    float y = (real.y * focalY / real.z) + principleY;

    real = new PVector(x, y, real.z);
    return real;
  }
}

class Knct {
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
}

BufferedReader reader;
int[] frame;

void setup() {
  size(512, 424, P2D);
  frameRate(30);

  reader = createReader("data.txt");
}

void draw() {
  try {
    frame = int(split(reader.readLine(), ","));
  } 
  catch (IOException e) {
  }

  loadPixels();
  for (int i = 0; i < frame.length; i++) pixels[i] = color(map(frame[i], 0, 4096, 0, 255));
  //pixels = frame;
  updatePixels();

  if (frameCount == 500) exit();
}
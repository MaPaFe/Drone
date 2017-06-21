PVector[] prev;
int history = 20;

void setup() {
  size(600, 600);
  frameRate(4);

  prev = new PVector[history];
  for (int i = 0; i < history; i++) prev[i] = new PVector(0, 0);
}

void draw() {
  background(51);

  //int offset = frameCount % history;
  //prev[offset].set(mouseX, mouseY);

  for (int i = 0; i < history - 1; i++) {
    prev[i] = prev[i + 1];
  }
  prev[history - 1] = new PVector(mouseX, mouseY);

  PVector average = new PVector(0, 0);
  int count = 0;
  for (int i = 0; i < history - 1; i++) {
    average.add(PVector.sub(prev[i + 1], prev[i]));
    int scale = 1+((i+1) / 100);// << 1;
    average.mult(scale);
    count += scale;
  }
  average.div(history + count);
  println(average.mag());
  //average.div(100);
  average.add(prev[history - 1]);

  //fill(255, 0, 0);
  //noStroke();
  //ellipse(average.x, average.y, 16, 16);
  stroke(255, 0, 0);
  line(prev[history - 1].x, prev[history - 1].y, average.x, average.y);

  noFill();
  stroke(255);
  strokeWeight(2);
  beginShape();
  for (PVector v : prev) vertex(v.x, v.y);
  //for (int i = 0; i < history; i++) {
  //  int index = (offset + i) % history;
  //  //int index = i;
  //  //print(prev[index].x, prev[index].y, "| ");
  //  print(prev[index]);
  //  vertex(prev[index].x, prev[index].y);
  //}
  endShape();
}
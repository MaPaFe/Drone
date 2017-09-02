//http://graphics.cs.msu.ru/en/node/909
int amountX, amountY;
int rectSize = 100;

void setup() {
  amountX = 6;
  amountY = 7;

  surface.setSize((amountX + 2) * rectSize, (amountY + 2) * rectSize);
}
void draw() {
  background(255);
  fill(0);
  noStroke();

  int count = 0;
  for (int x = rectSize; x < width - rectSize; x += rectSize) {
    for (int y = rectSize; y < height - rectSize; y += rectSize) {
      if (count % 2 == 0) rect(x, y, rectSize, rectSize);
      count++;
    }
  }

  saveFrame("data/"+amountX+"x"+amountY+".png");
  exit();
}
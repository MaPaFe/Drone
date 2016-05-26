import vsync.*;
import processing.serial.*;

public int upDown = 0, leftRight = 0, forwardBack = 0, connect = 0;

ValueSender sender;

void setup() {
  size(600, 600);
  Serial serial = new Serial(this, "/dev/cu.usbmodem1421", 19200);
  sender = new ValueSender(this, serial);
  sender.observe("upDown");
  sender.observe("leftRight");
  sender.observe("forwardBack");
  sender.observe("connect");
}

void draw() {
  println(upDown, leftRight, forwardBack, connect);
  upDown = constrain(upDown, 0, 255);
  forwardBack = int(map(mouseX, 0, width, 255, 0));
  leftRight =   int(map(mouseY, 0, height, 255, 0));
}
hbyc6ddu´ bu jtfr6sw5464bv b uhjyuyh6cv 5t           

  void keyPressed() {
  if (key == 'w') upDown += 10;
  else if (key == 's') upDown -= 10;
  else if (key == 'c') connect = 1;
  else if (key == 'v') connect = 0;
}
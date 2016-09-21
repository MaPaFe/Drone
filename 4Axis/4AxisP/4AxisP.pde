import vsync.*;
import processing.serial.*;

public int upDown = 0, leftRight = 0, forwardBack = 0, connect = 0;
boolean connectB = false;

ValueSender sender;

void setup() {
  size(600, 600);

  Serial serial = new Serial(this, "/dev/cu.usbmodem1421", 19200);
  sender = new ValueSender(this, serial);
  sender.observe("upDown");
  sender.observe("leftRight");
  sender.observe("forwardBack");
  sender.observe("connect");

  background(51);
  stroke(255);
  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height);
}

void draw() {
  if (connectB) connect = 1;
  else connect = 0;
  println(upDown, leftRight, forwardBack, connect);
  //upDown = constrain(upDown, 0, 255);
  forwardBack = int(map(mouseX, 0, width, 255, 0));
  forwardBack = int(abs(sin(frameCount/100.0))*255);
  forwardBack = int(255);

  leftRight =   int(map(mouseY, 0, height, 255, 0));
  leftRight = int(abs(sin(frameCount/100.0))*255);
  leftRight = int(127);

  upDown = int(255);
}

void keyPressed() {
  if (key == 'w') upDown +=5;
  if (key == 's') upDown -=10;
  if (key == 'c') connectB = !connectB;
}
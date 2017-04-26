import vsync.*;
import processing.serial.*;

ValueSender sender;

void setup() {
  size(400, 150);
  Serial serial = new Serial(this, "/dev/cu.usbmodem1421", 19200);
  sender = new ValueSender(this, serial);
  sender.observe("mouseX");
  sender.observe("mouseY");
}

void draw() {
  println(int(map(mouseX, 0, width, 0, 255)), int(map(mouseY, 0, height, 0, 255)));
}
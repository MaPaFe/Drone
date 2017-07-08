import processing.serial.*;

Serial serial;

void setup() {
  size(600, 600);

  printArray(Serial.list());
  serial = new Serial(this, Serial.list()[1]);
  serial.clear();
}

void draw() {
  if (serial.available() > 0) {
    byte[] vals = {(byte)map(mouseX, 0, width, -127, 127), (byte)map(mouseY, 0, height, -127, 127), 127, -127};
    serial.clear();
    serial.write(vals);
  }
}
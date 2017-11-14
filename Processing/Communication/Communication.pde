import processing.serial.*;

Serial serial;

void setup() {
  size(600, 600);
  //fullScreen();

  printArray(Serial.list());
  serial = new Serial(this, Serial.list()[1]);
}

void draw() {
  if (serial.available() > 0) {
    byte[] vals = {(byte)map(mouseY, 0, height, 127, -127), (byte)map(mouseX, 0, width, 127, -127), 0, 0};
    //byte[] vals = {-127, -127, -127, -127};
    //byte[] vals = {127, 127, 127, 127};
    //if (keyPressed) vals[0] = 0;
    //else vals[0] = -127;
    printArray(vals);
    serial.clear();
    serial.write(vals);
  }
}
//izquierda 46
//medio     51
//derecha   52

#include <SPI.h>
#include <VSync.h>

ValueReceiver<4> receiver;

const int slaveSelectPin = 46;
int upDown = 0, leftRight = 0, forwardBack = 0, con = 0;

void setup() {
  Serial.begin(19200);
  receiver.observe(upDown);
  receiver.observe(leftRight);
  receiver.observe(forwardBack);
  receiver.observe(con);
  pinMode(slaveSelectPin, OUTPUT);
  SPI.begin();
}

void loop() {
  receiver.sync();
  if (con = 1) cani();
  digitalPotWrite(2, upDown);
  digitalPotWrite(1, leftRight);
  digitalPotWrite(0, forwardBack);

  //  for (int level = 0; level < 255; level++) {
  //    digitalPotWrite(2, level);
  //    delay(10);
  //  }
  //  delay(100);
  //  for (int level = 255; level > 0; level--) {
  //    digitalPotWrite(2, level);
  //    delay(10);
  //  }

  //  digitalPotWrite(2, 0);
  //  delay(500);
  //  digitalPotWrite(2, 255);
  //  delay(500);

  //  digitalPotWrite(2, 255 / 128);
  //  delay(100);
}

void digitalPotWrite(int address, int value) {
  digitalWrite(slaveSelectPin, LOW);
  SPI.transfer(address);
  SPI.transfer(value);
  digitalWrite(slaveSelectPin, HIGH);
}

void cani() {
  for (int level = 0; level < 255; level++) digitalPotWrite(2, level); delay(10);
  for (int level = 255; level > 0; level--) digitalPotWrite(2, level); delay(10);
}

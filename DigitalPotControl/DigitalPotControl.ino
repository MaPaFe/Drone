//izquierda 46
//medio     51
//derecha   52

#include <SPI.h>
#include <VSync.h>

ValueReceiver<2> receiver;

const int slaveSelectPin = 46;
int valX = 0, valY = 0;

void setup() {
  Serial.begin(19200);
  receiver.observe(valX);
  receiver.observe(valY);

  pinMode(slaveSelectPin, OUTPUT);
  SPI.begin();
}

void loop() {
  int pValX = valX;
  int pValY = valY;
  receiver.sync();

  if (pValX != valX) valX = map(valX, 0, 400, 255, 0);
  digitalPotWrite(2, valX);

  if (pValY != valY) valY = map(valY, 0, 150, 255, 0);
  digitalPotWrite(1, valY);

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

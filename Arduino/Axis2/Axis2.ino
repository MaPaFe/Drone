//izquierda 46
//medio     51
//derecha   52

#include <SPI.h>
#include <VSync.h>

ValueReceiver<2> receiver;

const int slaveSelectPin = 46;
int valX = 255, valY = 255;

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
  digitalPotWrite(0, valY);
}

void digitalPotWrite(int address, int value) {
  digitalWrite(slaveSelectPin, LOW);
  SPI.transfer(address);
  SPI.transfer(value);
  digitalWrite(slaveSelectPin, HIGH);
}

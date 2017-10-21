#include <SPI.h>

const int slaveSelectPin = 46;

void setup() {
  pinMode(slaveSelectPin, OUTPUT);
  SPI.begin();

  for (int i = 0; i < 255; i++) {
    digitalPotWrite(5, i);
    delay(50);
  }
}

void loop() {
  //    for (int i = 0; i < 255; i++) {
  //      digitalPotWrite(3, i);
  //      delay(50);
  //    }
  //
  //    for (int i = 255; i > 0; i--) {
  //      digitalPotWrite(3, i);
  //      delay(50);
  //    }

  //  digitalPotWrite(3, 255);
}

void digitalPotWrite(int address, int value) {
  digitalWrite(slaveSelectPin, LOW);
  SPI.transfer(address);
  SPI.transfer(255 - value);
  digitalWrite(slaveSelectPin, HIGH);
}

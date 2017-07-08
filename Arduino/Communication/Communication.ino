#include <SPI.h>

const int slaveSelectPin = 46;

void setup() {
  Serial.begin(9600);

  pinMode(slaveSelectPin, OUTPUT);
  SPI.begin();

  Serial.write(' ');
}

void loop() {}

void serialEvent() {
  if (Serial.available() == 4) {
    for (int i = 0; i < 4; i++) digitalPotWrite(i, Serial.read() + 127);
    Serial.write(' ');
  }
}

void digitalPotWrite(int address, int value) {
  digitalWrite(slaveSelectPin, LOW);
  SPI.transfer(address);
  SPI.transfer(value);
  digitalWrite(slaveSelectPin, HIGH);
}

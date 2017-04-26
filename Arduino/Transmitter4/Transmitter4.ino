//#DEFINE gris A
//#DEFINE tipex W
//#DEFINE gelb B

#include <SPI.h>

const int slaveSelectPin = 46;

int chPin[] = {13, 12, 11, 10}, chVal[] = {0, 0, 0, 0};

void setup() {
  for (int i = 0; i < 4; i++) pinMode(chPin[i], INPUT);
  Serial.begin(19200);
  SPI.begin();
}

void loop() {
  for (int i = 0; i < 4; i++) {
    chVal[i] = pulseIn(chPin[i], HIGH);
  }
  for (int i = 0; i < 4; i++) {
    Serial.print(chVal[i]);
    Serial.print(" | ");
  }
  Serial.println();
}

void digitalPotWrite(int address, int value) {
  digitalWrite(slaveSelectPin, LOW);
  SPI.transfer(address);
  SPI.transfer(value);
  digitalWrite(slaveSelectPin, HIGH);
}

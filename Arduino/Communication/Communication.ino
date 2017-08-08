#include <SPI.h>

const int slaveSelectPin = 46;

double lastTime;

void setup() {
  Serial.begin(9600);

  pinMode(slaveSelectPin, OUTPUT);
  SPI.begin();

  Serial.write(' ');
  lastTime = millis();
}

void loop() {
  if (millis() - lastTime > 500) {
    for (int i = 0; i < 4; i++) digitalPotWrite(i, 0);
  }
}

void serialEvent() {
  if (Serial.available() == 4) {
    for (int i = 0; i < 4; i++) digitalPotWrite(i, Serial.read() + 127);
    Serial.write(' ');
    lastTime = millis();
  }
}

void digitalPotWrite(int address, int value) {
  digitalWrite(slaveSelectPin, LOW);
  SPI.transfer(address);
  SPI.transfer(255 - value);
  digitalWrite(slaveSelectPin, HIGH);
}

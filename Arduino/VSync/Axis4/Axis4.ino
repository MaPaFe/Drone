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

  pinMode(13, OUTPUT);
  pinMode(A1, INPUT);
}

void loop() {
  receiver.sync();
  if (con == 1) {
    digitalWrite(13, HIGH);
    digitalPotWrite(3, 0);
    delay(500);
    digitalWrite(13, LOW);
    digitalPotWrite(3, 255);
    delay(500);
  } else {
    digitalWrite(13, LOW);
    digitalPotWrite(3, upDown);
  }

  digitalPotWrite(1, leftRight);
  digitalPotWrite(0, forwardBack);
  digitalPotWrite(2, 127);

  analogWrite(13, map(analogRead(A1), 0, 1023, 0, 255));
}

void digitalPotWrite(int address, int value) {
  digitalWrite(slaveSelectPin, LOW);
  SPI.transfer(address);
  SPI.transfer(value);
  digitalWrite(slaveSelectPin, HIGH);
}

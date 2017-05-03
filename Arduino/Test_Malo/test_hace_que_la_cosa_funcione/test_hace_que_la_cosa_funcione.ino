//#DEFINE gris A
//#DEFINE tipex W
//#DEFINE gelb B

#include <SPI.h>

const int slaveSelectPin = 46;

int chPin[] = {13, 12, 11, 10}, chVal[] = {0, 0, 0, 0};
int ch1 = 13;

void setup() {
  //for (int i = 0; i < 4; i++) pinMode(chPin[i], INPUT);
  pinMode(ch1, INPUT);
  //pinMode(chPin[1], INPUT);
  //pinMode(chPin[2], INPUT);
  //pinMode(chPin[3], INPUT);
  Serial.begin(9600);
  SPI.begin();
}

void loop() {
  //for (int i = 0; i < 4; i++) {
  chVal[0] = pulseIn(ch1, HIGH, 20000);
  //chVal[1] = pulseIn(chPin[1], HIGH);
  //chVal[2] = pulseIn(chPin[2], HIGH);
  //chVal[3] = pulseIn(chPin[3], HIGH);
  //}
  // for (int i = 0; i < 4; i++) {
  Serial.print(chVal[0]);
  Serial.print(" | ");
  //}
  Serial.println();
}

void digitalPotWrite(int address, int value) {
  digitalWrite(slaveSelectPin, LOW);
  SPI.transfer(address);
  SPI.transfer(value);
  digitalWrite(slaveSelectPin, HIGH);
}

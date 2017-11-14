#include <SPI.h>

const int slaveSelectPin = 46;
const int buzzerPin = A0;

int buzzer = 0;
int beeps = 0;
bool on = false;

bool connected = false;

void setup() {
  Serial.begin(9600);

  pinMode(slaveSelectPin, OUTPUT);
  pinMode(buzzerPin, INPUT);

  SPI.begin();
}

void loop() {
  buzzer = analogRead(buzzerPin);
  Serial.println(String(beeps) + " | " + String(buzzer));

  if (buzzer > 400) on = true;

  if (buzzer == 0 && on) {
    Serial.println("piiiiiiipp");
    switch (beeps) {
      case 0:
        Serial.println("0");
        digitalPotWrite(0, 0);
        delay(1000);
        break;
      case 1:
        Serial.println("1");
        delay(2000);
        digitalPotWrite(0, 255);
        break;
      case 2:
        Serial.println("2");
        delay(1000);
        digitalPotWrite(0, 0);
        break;
      case 3:
        Serial.println("3");
        delay(1000);
        connected = true;
    }
    beeps++;
    delay(100);
  }

  if (connected) digitalPotWrite(0, 127);
}

void digitalPotWrite(int address, int value) {
  digitalWrite(slaveSelectPin, LOW);
  SPI.transfer(address);
  SPI.transfer(255 - value);
  digitalWrite(slaveSelectPin, HIGH);
}

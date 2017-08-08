#include <SPI.h>

const int slaveSelectPin = 46;
const int buzzerPin = A0;

int buzzer = 0;
const int beeps = 2;

bool on = false;

void setup() {
  pinMode(buzzerPin, INPUT);

  Serial.begin(9600);
  Serial.println("EPAHA");
}

void loop() {
  buzzer = analogRead(buzzerPin);

  if (buzzer > 400) on = true;
  Serial.println("EPAHA");

  if (on && buzzer == 0 && beeps < 2) {
    //beeps++;
    Serial.println("UP");
    Serial.println(beeps);
    delay(beeps * 1000);
    Serial.println("OK");
  }
  Serial.println("EPAHA");

  if (beeps == 2)   {
    Serial.println("EPAHA");

    digitalPotWrite(0, 255);
    Serial.println("EPAHA");

    Serial.println("2 .");
    delay(1000);
    //beeps++;
  }
  Serial.println("EPAHA");

  if (beeps == 3)  {
    digitalPotWrite(0, 0);
    Serial.println("3 .");
    delay(1000);
    //beeps++;
  }

  Serial.println("EPAHA");


  Serial.println(beeps);
}

void digitalPotWrite(int address, int value) {
  digitalWrite(slaveSelectPin, LOW);
  SPI.transfer(address);
  SPI.transfer(255 - value);
  digitalWrite(slaveSelectPin, HIGH);
}

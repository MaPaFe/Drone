#include <SPI.h>

#define MAX_INTERRUPT_TIME 100

const int slaveSelectPin = 46;
const int buzzerPin = A0;

int buzzer = 0;
int beeps = 0;
bool on = false;

double lastTime;
bool droneConnected = false;

void setup() {
  Serial.begin(9600);

  pinMode(slaveSelectPin, OUTPUT);
  pinMode(buzzerPin, INPUT);
  pinMode(LED_BUILTIN, OUTPUT);

  SPI.begin();

  lastTime = millis();

  //   Controller calibrates the middle at startup
  for (int i = 0; i < 4; i++) digitalPotWrite(i, 127);
}

void loop() {
  buzzer = analogRead(buzzerPin);

  if (buzzer > 400) on = true;

  if (buzzer == 0 && on) {
    switch (beeps) {
      case 0:
        digitalPotWrite(0, 0);
        delay(1000);
        break;
      case 1:
        delay(2000);
        digitalPotWrite(0, 255);
        break;
      case 2:
        delay(1000);
        digitalPotWrite(0, 0);
        break;
      case 3:
        delay(1000);
        droneConnected = true;
        Serial.write(' ');
    }
    beeps++;
    delay(100);
  }

  if (droneConnected && millis() - lastTime > MAX_INTERRUPT_TIME) {
    digitalPotWrite(0, 0);
    Serial.write(' ');
    digitalWrite(LED_BUILTIN, HIGH);
  } else {
    digitalWrite(LED_BUILTIN, LOW);
  }
}

void serialEvent() {
  // throttle min      0 max      255
  // pitch    backward 0 forward  255
  // roll     left     0 right    255
  // yaw      left     0 right    255

  if (droneConnected && Serial.available() == 4) {
    for (int i = 0; i < 4; i++) digitalPotWrite(i, Serial.read() + 127);
    Serial.write(' ');
    lastTime = millis();
  } else {
    for (int i = 1; i < 4; i++) digitalPotWrite(i, 127);
  }
}

void digitalPotWrite(int address, int value) {
  digitalWrite(slaveSelectPin, LOW);
  SPI.transfer(address);
  SPI.transfer(value);
  digitalWrite(slaveSelectPin, HIGH);
}

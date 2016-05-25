#include <VSync.h>

ValueReceiver<1> receiver;
int mouseX;

void setup() {
  Serial.begin(19200);
  receiver.observe(mouseX);

  pinMode(13, OUTPUT);
}

void loop() {
  receiver.sync();

  if (mouseX >= 200) digitalWrite(13, HIGH);
  else digitalWrite(13, LOW);
}

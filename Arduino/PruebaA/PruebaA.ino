#include <SPI.h>

const int pin = 46;

void setup() {
  pinMode(13, OUTPUT);
}

void loop() {
  //marron
  digiPotWrite(1, 255);
  //gris
  digiPotWrite(0, 0);
  //azul
  digiPotWrite(2, 0);
}

void digiPotWrite(int canal, int valor) {
  digitalWrite(pin, LOW);
  SPI.transfer(canal);
  SPI.transfer(valor);
  digitalWrite(pin, HIGH);
}

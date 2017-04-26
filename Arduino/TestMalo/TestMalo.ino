#include <SPI.h>

int num = 0, aux = 0;
const int pin = 46;

void setup() {
  Serial.begin(19200);
}

void loop() {
  digiPotWrite(0, aux);
  digiPotWrite(1, 127.5);
  digiPotWrite(2, 127.5);
  digiPotWrite(3, 127.5);

  if (aux < 255) {
    if (num == 1) {
      aux ++;
    }
  }

  if (aux > 0) {
    if (num == 2) {
      aux --;
    }
  }

  switch (num) {
    case 3:
      digiPotWrite(1, 0);
      break;

    case 4:
      digiPotWrite(1, 255);
      break;

    case 5:
      digiPotWrite(2, 0);
      break;

    case 6:
      digiPotWrite(2, 255);
      break;

    case 7:
      digiPotWrite(3, 0);
      break;

    case 8:
      digiPotWrite(3, 255);
      break;
  }
}

void digiPotWrite(int canal, int valor) {
  digitalWrite(pin, LOW);
  SPI.transfer(canal);
  SPI.transfer(valor);
  digitalWrite(pin, HIGH);
}

int potentPin = A0, ledPin = 13, val = 0;

void setup() {
  Serial.begin(9600);
  pinMode(potentPin, INPUT);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  val = analogRead(potentPin);
  map(val, 0, 1023, 0, 255);
  Serial.println(val);
  analogWrite(ledPin, val);
}

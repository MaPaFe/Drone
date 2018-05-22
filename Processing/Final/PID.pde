class PID {
  float kP, kI, kD;
  float minOutput, maxOutput;
  float prevError, integral;
  float lastTime;

  PID(float kP_, float kI_, float kD_) {
    setKs(kP_, kI_, kD_);

    minOutput = -127;
    maxOutput = 127;

    prevError = 0;
    integral = 0;

    lastTime = millis();
  }

  void setKs(float kP_, float kI_, float kD_) {
    kP = kP_;
    kI = kI_;
    kD = kD_;
  }

  void setMinMaxOut(float min, float max) {
    minOutput = min;
    maxOutput = max;
  }

  float compute(float input, float setPoint) {
    float now = millis();
    float deltaTime = now - lastTime;

    float error = setPoint - input;

    integral += error * deltaTime;
    //integral = constrain(integral, ?, ?);

    float output = error * kP + integral * kI + ((error - prevError) / deltaTime) * kD;

    prevError = error;
    lastTime = now;

    return constrain(output, minOutput, maxOutput);
  }
}

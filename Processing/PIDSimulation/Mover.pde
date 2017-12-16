class Mover {

  PVector pos, vel, acc;
  float mass;

  PID xPid, yPid;

  Mover() {
    pos = new PVector(width/2, height/2);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    mass = 1;

    xPid = new PID(1, 0, 0);
    yPid = new PID(0, 0, 0);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

  void update() {
    applyForce(new PVector(xPid.compute(pos.x, mouseX), yPid.compute(pos.y, mouseY)));
    //applyForce(new PVector(xPid.compute(position.x, width/2), yPid.compute(position.y, height/2)));

    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(pos.x, pos.y, 48, 48);
  }
}
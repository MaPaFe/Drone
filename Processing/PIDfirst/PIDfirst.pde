import processing.serial.*;

final int FIND_FIRST_THRESHOLD = 1400;
final boolean GRAPHS = true;

Drone drone;
Serial serial;

float[][] history;
float pidXP = -200, pidXI = 0, pidXD = 75, pidYP = 30, pidYI = 0, pidYD = 0, pidZP = 30, pidZI = 0, pidZD = 0;

void setup() {
  //Unncomment the next line if GRAPHS == true
  size(1024, 424, FX2D);
  //Unncomment the next line if GRAPHS == false
  //size(512, 424, P2D);

  drone = new Drone(this);
  serial = new Serial(this, Serial.list()[1]);

  if (GRAPHS) history = new float[3][width - Knct.width];
}

void draw() {
  background(0);
  surface.setTitle(getClass().getName() + " [size " + width + "/" +height + "] [frame " + frameCount + "] [frameRate " +frameRate + "]");

  drone.update(new PVector(0, 0, FIND_FIRST_THRESHOLD));

  //drone.foundAtBeginning = false;

  if (GRAPHS) {
    noStroke();
    fill(255);
    rect(512, 0, width, height);
    noFill();

    strokeWeight(3);
    int[] mapMin = {0, 0, 500};
    int[] mapMax = {Knct.width, Knct.height, 4500};
    for (int j = 0; j < history.length; j++) {
      stroke(j==0?255:0, j==1?255:0, j==2?255:0);
      beginShape();
      for (int i = 0; i < history[j].length; i++) {
        vertex(Knct.width + i, map(history[j][i], mapMin[j], mapMax[j], 0, height));
      }
      endShape();
    }
  }
}

void keyPressed() {
  float pidIncrement = 5;

  switch (key) {
  case ' ':
    drone.foundAtBeginning = false;
    break;
  case 'Q':
    pidXP += pidIncrement;
    break;
  case 'A':
    pidXP -= pidIncrement;
    break;
  case 'W':
    pidXI += pidIncrement;
    break;
  case 'S':
    pidXI -= pidIncrement;
    break;
  case 'E':
    pidXD += pidIncrement;
    break;
  case 'D':
    pidXD -= pidIncrement;
    break;
  case 'R':
    pidYP += pidIncrement;
    break;
  case 'F':
    pidYP -= pidIncrement;
    break;
  case 'T':
    pidYI += pidIncrement;
    break;
  case 'G':
    pidYI -= pidIncrement;
    break;
  case 'Y':
    pidYD += pidIncrement;
    break;
  case 'h':
    pidYD -= pidIncrement;
    break;
  case 'U':
    pidZP += pidIncrement;
    break;
  case 'J':
    pidZP -= pidIncrement;
    break;
  case 'I':
    pidZI += pidIncrement;
    break;
  case 'K':
    pidZI -= pidIncrement;
    break;
  case 'O':
    pidZD += pidIncrement;
    break;
  case 'L':
    pidZD -= pidIncrement;
    break;
  default:
    println(key);
    break;
  }

  drone.pids[0].setKs(pidXP, pidXI, pidXD);
  drone.pids[1].setKs(pidYP, pidYI, pidYD);
  drone.pids[2].setKs(pidZP, pidZI, pidZD);

  println(pidXP, pidYP, pidZP);
  println(pidXI, pidYI, pidZI);
  println(pidXD, pidYD, pidZD);
}
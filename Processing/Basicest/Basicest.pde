import processing.serial.*;

final int FIND_FIRST_THRESHOLD = 1800;
final boolean GRAPHS = true;

Drone drone;
Serial serial;

float[][] history;

float[][] pidKs = {{-15, 0, 0}, 
/*             */  {0.5, 0, 0}, 
/*             */  {-0.5, 0, 0}};

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

  if (!keyPressed) drone.update(new PVector(0, 0, 1600));

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
        vertex(Knct.width + i, map(history[j][(frameCount + history[j].length - i) % history[j].length], mapMin[j], mapMax[j], 0, height));
      }
      endShape();
    }
  }
}

void keyPressed() {
  float pidInc = 0.5;

  switch (key) {
  case 'Q':
    pidKs[0][0] += pidInc;
    break;
  case 'A':
    pidKs[0][0] -= pidInc;
    break;
  case 'W':
    pidKs[0][1] += pidInc;
    break;
  case 'S':
    pidKs[0][1] -= pidInc;
    break;
  case 'E':
    pidKs[0][2] += pidInc;
    break;
  case 'D':
    pidKs[0][2] -= pidInc;
    break;
  case 'R':
    pidKs[1][0] += pidInc;
    break;
  case 'F':
    pidKs[1][0] -= pidInc;
    break;
  case 'T':
    pidKs[1][1] += pidInc;
    break;
  case 'G':
    pidKs[1][1] -= pidInc;
    break;
  case 'Y':
    pidKs[1][2] += pidInc;
    break;
  case 'H':
    pidKs[1][2] -= pidInc;
    break;
  case 'U':
    pidKs[2][0] += pidInc;
    break;
  case 'J':
    pidKs[2][0] -= pidInc;
    break;
  case 'I':
    pidKs[2][1] += pidInc;
    break;
  case 'K':
    pidKs[2][1] -= pidInc;
    break;
  case 'O':
    pidKs[2][2] += pidInc;
    break;
  case 'L':
    pidKs[2][2] -= pidInc;
    break;
  default:
    println(key);
    break;
  }

  drone.pids[0].setKs(pidKs[0][0], pidKs[0][1], pidKs[0][2]);
  drone.pids[1].setKs(pidKs[1][0], pidKs[1][1], pidKs[1][2]);
  drone.pids[2].setKs(pidKs[2][0], pidKs[2][1], pidKs[2][2]);

  println(pidKs[0][0], pidKs[1][0], pidKs[2][0]);
  println(pidKs[0][1], pidKs[1][1], pidKs[2][1]);
  println(pidKs[0][2], pidKs[1][2], pidKs[2][2]);
}
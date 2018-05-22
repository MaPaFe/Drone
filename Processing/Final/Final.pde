import processing.serial.*;

final int FIND_FIRST_THRESHOLD = 1200;
final boolean GRAPHS = true;

Drone drone;
Serial serial;

float[][] history;

// Define the K values for the PIDs
float[][] pidKs = {{-0.1, 0.000000001, -0.3},  //y
/*             */  {0.35, 0, 0.3},             //z
/*             */  {-0.1, 0, -0.3}};           //x

int graphIndex = 0;
boolean graphStopped = true;

void setup() {
  //Unncomment the next line if GRAPHS == true
  size(1024, 424, FX2D);
  //Unncomment the next line if GRAPHS == false
  //size(512, 424, P2D);

  drone = new Drone(this);
  // Create the serial object on the second serial port
  // because that's usually the correct one
  printArray(Serial.list());
  serial = new Serial(this, Serial.list()[2]);

  if (GRAPHS) history = new float[6][width - Knct.width];
}

void draw() {
  background(0);
  // Put information on window title
  surface.setTitle(getClass().getName() + " [size " + width + "/" +height + "] [frame " + frameCount + "] [frameRate " +frameRate + "]");

  if (GRAPHS) {
    noStroke();
    fill(255);
    rect(512, 0, width, height);
    noFill();

    strokeWeight(3);
    // Define mapping values for later
    int[] mapMin = {0, 0, 500, 127, 127, 127};
    int[] mapMax = {Knct.width, Knct.height, 4500, -127, -127, -127};
    // Go thorugh the three axis
    for (int j = 0; j < history.length; j++) {
      // X  red
      // Y  green
      // Z  blue
      // Xo cyan
      // Yo yellow
      // Zo pink
      stroke(j==0||j==3||j==4?255:0, j==1||j==3||j==5?255:0, j==2||j==4||j==5?255:0);
      beginShape();
      // Put vertex at every vaule along the array
      for (int i = 0; i < history[j].length; i++) {
        // Map all values to fit on the screen
        if (j < 3) {
          vertex(Knct.width + i, map(history[j][(graphIndex + history[j].length - i) % history[j].length], mapMin[j], mapMax[j], 0, height/2));
        } else {
          vertex(Knct.width + i, map(history[j][(graphIndex + history[j].length - i) % history[j].length], mapMin[j], mapMax[j], height/2, height));
        }
      }
      endShape();
    }
  }

  if (!(keyPressed && key == ' ')) {
    drone.foundAtBeginning = false;
  }

  drone.update(new PVector(0, -30, FIND_FIRST_THRESHOLD));
}

float pidInc = 0.05;
void keyPressed() {
  switch (key) {
// Change Ks
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
    switch(keyCode) {
      case UP:
      pidInc += 0.01;
      println(pidInc);
      break;
      case DOWN:
      pidInc -= 0.01;
      println(pidInc);
      break;
    }
    break;
  }

  // Update Ks
  drone.pids[0].setKs(pidKs[0][0], pidKs[0][1], pidKs[0][2]);
  drone.pids[1].setKs(pidKs[1][0], pidKs[1][1], pidKs[1][2]);
  drone.pids[2].setKs(pidKs[2][0], pidKs[2][1], pidKs[2][2]);

  println(pidKs[0][0], pidKs[1][0], pidKs[2][0]);
  println(pidKs[0][1], pidKs[1][1], pidKs[2][1]);
  println(pidKs[0][2], pidKs[1][2], pidKs[2][2]);
}

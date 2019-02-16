import java.util.Random;
import java.lang.Math;

final int SQUARE_SIZE = 20;
final int SEED = 0;

boolean menuOn;
boolean swarmOn;
boolean geneticOn;

Menu menu;
TestEnvironment testEnv;
Swarm swarm;
Genetic genetic;

void setup() {
  size(800, 600);
  background(255);
  fill(0);
  
  menuOn = true;
  swarmOn = false;
  geneticOn = false;
  
  menu = new Menu();
  testEnv = new TestEnvironment(SQUARE_SIZE);
  swarm = new Swarm(testEnv, SEED);
  genetic = new Genetic(testEnv);
}

void draw() {
  if (menuOn) {
    int which = menu.run();
    switch (which) {
      case 0: break;
      case 1: turnSwarmOn();
      break;
      case 2: turnGeneticOn();
      break;
    }
    delay(50);
  }
  else if (swarmOn) {
    swarm.makeMove();
    //delay(100);
  }
  else if (geneticOn) {
    genetic.makeMove();
    delay(50);
  }
}

void mouseClicked() {
  menu.handleClick();
}

void turnSwarmOn() {
  menuOn = false;
  swarmOn = true;
  geneticOn = false;
}

void turnGeneticOn() {
  menuOn = false;
  swarmOn = false;
  geneticOn = true;
}

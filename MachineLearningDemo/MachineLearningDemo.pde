import java.util.Random;
import java.lang.Math;
import java.util.ArrayList;

final int SQUARE_SIZE = 1;
final int SEED = 0;

boolean menuOn;
boolean swarmOn;
boolean geneticOn;
boolean reinforcementLearnerOn;

Menu menu;
TestEnvironment testEnv;
Swarm swarm;
Genetic genetic;
ReinforcementLearner reinforcementLearner;

void setup() {
  size(800, 600);
  background(255);
  fill(0);
  
  menuOn = true;
  swarmOn = false;
  geneticOn = false;
  reinforcementLearnerOn = false;
  
  menu = new Menu();
  testEnv = new TestEnvironment(SQUARE_SIZE);
  swarm = new Swarm(testEnv, SEED);
  genetic = new Genetic(testEnv);
  reinforcementLearner = new ReinforcementLearner(testEnv, SEED);
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
      case 3: turnReinforcementLearnerOn();
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
  else if (reinforcementLearnerOn) {
    reinforcementLearner.makeMove();
    //delay(100);
  }
}

void mouseClicked() {
  if (menuOn) {
    menu.handleClick();
  }
  else if (reinforcementLearnerOn) {
    //reinforcementLearner.makeMove();
  }
}

void turnSwarmOn() {
  menuOn = false;
  swarmOn = true;
  geneticOn = false;
  reinforcementLearnerOn = false;
}

void turnGeneticOn() {
  menuOn = false;
  swarmOn = false;
  geneticOn = true;
  reinforcementLearnerOn = false;
}

void turnReinforcementLearnerOn() {
  menuOn = false;
  swarmOn = false;
  geneticOn = false;
  reinforcementLearnerOn = true;
}

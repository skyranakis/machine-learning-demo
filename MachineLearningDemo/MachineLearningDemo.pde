import java.util.Random;
import java.lang.Math;

final int SQUARE_SIZE = 20;
final int SEED = 0;
TestEnvironment testEnv;
Swarm swarm;

void setup() {
  size(800, 600);
  background(255);
  fill(0);
  testEnv = new TestEnvironment(SQUARE_SIZE);
  swarm = new Swarm(testEnv, SEED);
}

void draw() {
  swarm.makeMove();
  delay(50);
}

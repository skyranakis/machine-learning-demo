final int SQUARE_SIZE = 20;
TestEnvironment testEnv;
Swarm swarm;

void setup() {
  size(800, 600);
  background(255);
  fill(0);
  testEnv = new TestEnvironment(SQUARE_SIZE);
  swarm = new Swarm(SQUARE_SIZE, testEnv);
}

void draw() {
  swarm.makeMove();
  delay(50);
}

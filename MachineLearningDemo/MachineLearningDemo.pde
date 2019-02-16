int SQUARE_SIZE;
TestEnvironment testEnv;
PheromoneTrail pher;

void setup() {
  size(800, 600);
  background(255);
  fill(0);
  SQUARE_SIZE = 20;
  testEnv = new TestEnvironment(SQUARE_SIZE);
  pher = new PheromoneTrail(SQUARE_SIZE);
}

void draw() {
  delay(50);
  pher.drawPheromones();
  pher.decayPheromones();
  testEnv.drawEnvironment();
}

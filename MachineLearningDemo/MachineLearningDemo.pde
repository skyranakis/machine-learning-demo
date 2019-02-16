int SQUARE_SIZE;
TestEnvironment te;

void setup() {
  size(800, 600);
  background(255);
  fill(0);
  SQUARE_SIZE = 20;
  te = new TestEnvironment(SQUARE_SIZE);
}

void draw() {
  te.drawEnvironment();
}

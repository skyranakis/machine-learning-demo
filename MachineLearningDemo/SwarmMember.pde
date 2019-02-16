public class SwarmMember {
  
  private final int LOOK_AHEAD_AMOUNT;
  private final int HUNGRY_TRAIL;
  private final int FULL_TRAIL;
  private final double FULL_WEAR_OFF;
  private final int SQUARE_SIZE;
  
  private boolean full;
  private double trailAmount;
  private int[] position;
  private TestEnvironment testEnv;
  private PheromoneTrail pher;
  private Random rand;
  
  public SwarmMember(int[] pos, TestEnvironment env, PheromoneTrail pherTrail, Random r) {
    LOOK_AHEAD_AMOUNT = 3;
    HUNGRY_TRAIL = 10;
    FULL_TRAIL = 100;
    FULL_WEAR_OFF = 0.9;
    SQUARE_SIZE = env.getSquareSize();
    
    full = false;
    trailAmount = HUNGRY_TRAIL;
    position = pos;
    testEnv = env;
    pher = pherTrail;
    rand = r;
  }
  
  public void takeTurn() {
    handlePheromoneTrail();
    move();
    drawMember();
  }
  
  private void handlePheromoneTrail() {
    pher.putPheromone(position[0], position[1], trailAmount);
    if (full) {
      trailAmount *= FULL_WEAR_OFF;
      if (trailAmount <= HUNGRY_TRAIL) {
        trailAmount = HUNGRY_TRAIL;
        full = false;
      }
    }
  }
  
  public void move() {
    double upVal = 0;
    for (int i = 1; i <= LOOK_AHEAD_AMOUNT; i++) {
      upVal += pher.getPheromone(position[0], position[1] - 1);
    }
    double downVal = 0;
    for (int i = 1; i <= LOOK_AHEAD_AMOUNT; i++) {
      downVal += pher.getPheromone(position[0], position[1] + 1);
    }
    double leftVal = 0;
    for (int i = 1; i <= LOOK_AHEAD_AMOUNT; i++) {
      leftVal += pher.getPheromone(position[0] - 1, position[1]);
    }
    double rightVal = 0;
    for (int i = 1; i <= LOOK_AHEAD_AMOUNT; i++) {
      rightVal += pher.getPheromone(position[0] + 1, position[1]);
    }
    
    int[] target = new int[2];
    double total = upVal + downVal + leftVal + rightVal;
    double decider = rand.nextDouble() * total;
    if (decider < upVal) {
      target[0] = position[0];
      target[1] = position[0] - 1;
    }
    else if (decider < downVal + upVal) {
      target[0] = position[0];
      target[1] = position[0] + 1;
    }
    else if (decider < leftVal + downVal + upVal) {
      target[0] = position[0] - 1;
      target[1] = position[0];
    }
    else {
      target[0] = position[0];
      target[1] = position[0] + 1;
    }
    
    if (testEnv.isEnterable(target[0], target[1])) {
      print("enterable\n");
      position[0] = target[0];
      position[1] = target[1];
    }
  }
  
  public void drawMember() {
    stroke(100, 100, 100);
    fill(100, 100, 100);
    rect(position[0]*SQUARE_SIZE, position[1]*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
  }
}

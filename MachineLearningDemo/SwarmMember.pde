public class SwarmMember {
  
  private final int LOOK_AHEAD_AMOUNT;
  private final double HUNGRY_TRAIL;
  private final double FULL_TRAIL;
  private final double FULL_WEAR_OFF;
  private final int SQUARE_SIZE;
  private final double HUNGRY_EXPLORATION;
  private final double FULL_EXPLORATION;
  private final boolean FIND_PATHWAY;
  
  private boolean full;
  private boolean lastAtStart;
  private boolean lastAtGoal;
  private double trailAmount;
  private double explorationRate;
  private int[] position;
  
  private TestEnvironment testEnv;
  private PheromoneTrail pher;
  private Random rand;
  
  public SwarmMember(int[] pos, TestEnvironment env, PheromoneTrail pherTrail, Random r, boolean pathway) {
    
    LOOK_AHEAD_AMOUNT = 3;
    HUNGRY_TRAIL = 0;
    FULL_TRAIL = 100;
    FULL_WEAR_OFF = 0.99;
    SQUARE_SIZE = env.getSquareSize();
    HUNGRY_EXPLORATION = 0.2;
    FULL_EXPLORATION = 0.8;
    FIND_PATHWAY = pathway;
    
    full = false;
    lastAtStart = true;
    lastAtGoal = false;
    trailAmount = HUNGRY_TRAIL;
    explorationRate = HUNGRY_EXPLORATION;
    position = new int[2];
    position[0] = pos[0];
    position[1] = pos[1];
    
    testEnv = env;
    pher = pherTrail;
    rand = r;
  }
  
  public void takeTurn() {
    move();
    handlePheromoneTrail();
    drawMember();
  }
  
  private void move() {
    double upVal = 0;
    for (int i = 1; i <= LOOK_AHEAD_AMOUNT; i++) {
      upVal += pher.getPheromone(position[0], position[1] - i)[0];
    }
    double downVal = 0;
    for (int i = 1; i <= LOOK_AHEAD_AMOUNT; i++) {
      downVal += pher.getPheromone(position[0], position[1] + i)[0];
    }
    double leftVal = 0;
    for (int i = 1; i <= LOOK_AHEAD_AMOUNT; i++) {
      leftVal += pher.getPheromone(position[0] - i, position[1])[0];
    }
    double rightVal = 0;
    for (int i = 1; i <= LOOK_AHEAD_AMOUNT; i++) {
      rightVal += pher.getPheromone(position[0] + i, position[1])[0];
    }
    
    int[] target = new int[2];
    double explore = rand.nextDouble();
    if (explore < explorationRate) {
      target = explore();
    }
    else {
      target = exploit(upVal, downVal, leftVal, rightVal);
    }
    
    
    if (testEnv.isEnterable(target[0], target[1])) {
      position[0] = target[0];
      position[1] = target[1];
    }
  }
  
  private int[] explore() {
    int[] target = new int[2];
    double decider = rand.nextDouble();
    if (decider < 0.25) {
      target[0] = position[0];
      target[1] = position[1] - 1;
    }
    else if (decider < 0.5) {
      target[0] = position[0];
      target[1] = position[1] + 1;
    }
    else if (decider < 0.75) {
      target[0] = position[0] - 1;
      target[1] = position[1];
    }
    else {
      target[0] = position[0] + 1;
      target[1] = position[1];
    }
    return target;
  }
  
  private int[] exploit(double upVal, double downVal, double leftVal, double rightVal) {
    double total = upVal + downVal + leftVal + rightVal;
    if (total == 0) {
      return explore();
    }
    int[] target = new int[2];
    double decider = rand.nextDouble() * total;
    if (decider < upVal) {
      target[0] = position[0];
      target[1] = position[1] - 1;
    }
    else if (decider < downVal + upVal) {
      target[0] = position[0];
      target[1] = position[1] + 1;
    }
    else if (decider < leftVal + downVal + upVal) {
      target[0] = position[0] - 1;
      target[1] = position[1];
    }
    else {
      target[0] = position[0] + 1;
      target[1] = position[1];
    }
    return target;
  }
  
  private void handlePheromoneTrail() {
    double[] pherDeposit = {trailAmount, 0};
    pher.putPheromone(position[0], position[1], pherDeposit);
    if (full) {
      trailAmount *= FULL_WEAR_OFF;
      if (trailAmount <= HUNGRY_TRAIL) {
        full = false;
        trailAmount = HUNGRY_TRAIL;
        explorationRate = HUNGRY_EXPLORATION;
      }
    }
    if (testEnv.getReward(position[0], position[1]) > 0 && !FIND_PATHWAY) {
      makeFull();
      lastAtStart = false;
      lastAtGoal = true;
    }
    else if (testEnv.getReward(position[0], position[1]) > 0 && lastAtStart) {
      makeFull();
      lastAtStart = false;
      lastAtGoal = true;
    }
    else if (testEnv.getStartPosition()[0] == position[0] && testEnv.getStartPosition()[1] == position[1] && lastAtGoal) {
      makeFull();
      lastAtStart = true;
      lastAtGoal = false;
    }
  }
  
  private void makeFull() {
    full = true;
    trailAmount = FULL_TRAIL;
    explorationRate = FULL_EXPLORATION;
  }
  
  private void drawMember() {
    stroke(100, 100, 100);
    fill(100, 100, 100);
    rect(position[0] * SQUARE_SIZE, position[1] * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
  }
}

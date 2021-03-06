public class SwarmMember {
  
  private final int LOOK_AHEAD_AMOUNT;
  private final double HUNGRY_TRAIL;
  private final double FULL_TRAIL;
  private final double FULL_WEAR_OFF;
  private final int SQUARE_SIZE;
  private final boolean FIND_PATHWAY;
  private final double EXPLORE_DECAY;
  
  private double hungryExploration;
  private double fullExploration;
  private boolean full;
  private boolean lastAtStart;
  private boolean lastAtGoal;
  private double trailAmount;
  private double explorationRate;
  private int[] position;
  private int relevantIndex;
  private int recordTime;
  private int currentTime;
  
  private TestEnvironment testEnv;
  private PheromoneTrail pher;
  private Random rand;
  
  public SwarmMember(int[] pos, TestEnvironment env, PheromoneTrail pherTrail, Random r, boolean pathway) {
    
    LOOK_AHEAD_AMOUNT = 1;
    HUNGRY_TRAIL = 0;
    FULL_TRAIL = 100;
    FULL_WEAR_OFF = 0.99999; //0.99;
    SQUARE_SIZE = env.getSquareSize();
    FIND_PATHWAY = pathway;
    EXPLORE_DECAY = 0.8;
    
    hungryExploration = 0.4;
    fullExploration = 0.2;
    full = FIND_PATHWAY;
    lastAtStart = true;
    lastAtGoal = false;
    trailAmount = (FIND_PATHWAY) ? FULL_TRAIL : HUNGRY_TRAIL;
    explorationRate = (FIND_PATHWAY) ? fullExploration : hungryExploration;
    position = new int[2];
    position[0] = pos[0];
    position[1] = pos[1];
    relevantIndex = 0;
    recordTime = MAX_INT;
    currentTime = 0;
    
    testEnv = env;
    pher = pherTrail;
    rand = r;
  }
  
  public void takeTurn() {
    move();
    handlePheromoneTrail();
    //drawMember();
  }
  
  private void move() {
    
    int[] target = new int[2];
    double explore = rand.nextDouble();
    if (explore < explorationRate) {
      target = explore();
    }
    else {
      target = exploit();
    }
    
    
    if (testEnv.isEnterable(target[0], target[1])) {
      position[0] = target[0];
      position[1] = target[1];
    }
    currentTime++;
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
  
  private int[] exploit() {
    
    double upVal = 0;
    for (int i = 1; i <= LOOK_AHEAD_AMOUNT; i++) {
      upVal += pher.getPheromone(position[0], position[1] - i)[relevantIndex];
    }
    double downVal = 0;
    for (int i = 1; i <= LOOK_AHEAD_AMOUNT; i++) {
      downVal += pher.getPheromone(position[0], position[1] + i)[relevantIndex];
    }
    double leftVal = 0;
    for (int i = 1; i <= LOOK_AHEAD_AMOUNT; i++) {
      leftVal += pher.getPheromone(position[0] - i, position[1])[relevantIndex];
    }
    double rightVal = 0;
    for (int i = 1; i <= LOOK_AHEAD_AMOUNT; i++) {
      rightVal += pher.getPheromone(position[0] + i, position[1])[relevantIndex];
    }
    
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
    
    double[] pherDeposit = new double[2];
    pherDeposit[0] = 0;
    pherDeposit[1] = 0;
    if (lastAtGoal) {
      pherDeposit[0] = trailAmount;
    }
    else if (lastAtStart) {
      pherDeposit[1] = trailAmount;
    }
    pher.putPheromone(position[0], position[1], pherDeposit);
    
    if (full) {
      trailAmount *= FULL_WEAR_OFF;
      if (trailAmount <= HUNGRY_TRAIL) {
        full = false;
        trailAmount = HUNGRY_TRAIL;
        explorationRate = hungryExploration;
      }
    }
    
    int[] start = testEnv.getStartPosition();
    if (testEnv.getReward(position[0], position[1]) > 0 && !FIND_PATHWAY) {
      makeFull();
    }
    else if (testEnv.getReward(position[0], position[1]) > 0 && lastAtStart && FIND_PATHWAY) {
      hitEndpoint();
      lastAtStart = false;
      lastAtGoal = true;
      relevantIndex = 1;
    }
    else if (start[0] == position[0] && start[1] == position[1] && lastAtGoal && FIND_PATHWAY) {
      hitEndpoint();
      lastAtStart = true;
      lastAtGoal = false;
      relevantIndex = 0;
    }
    
  }
  
  private void hitEndpoint() {
    makeFull();
    if (currentTime <= recordTime) {
      recordTime = currentTime;
    }
    currentTime = 0;
    hungryExploration *= EXPLORE_DECAY;
    fullExploration *= EXPLORE_DECAY;
  }
  
  private void makeFull() {
    full = true;
    trailAmount = FULL_TRAIL;
    explorationRate = fullExploration;
  }
  
  private void drawMember() {
    stroke(100, 100, 100);
    fill(100, 100, 100);
    rect(position[0] * SQUARE_SIZE, position[1] * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
  }
}

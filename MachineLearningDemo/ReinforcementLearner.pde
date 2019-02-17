public class ReinforcementLearner {
  
  private final int SIGHT_DISTANCE;
  private final int SQUARE_SIZE;
  private final int[] START;
  private final double INITIAL_PUNISHMENT_FROM_TIME;
  private final int AMOUNT_OF_RECENT;
  private final double RECENT_PUNISHMENT;
  private final double EXPLORATION_DECAY;
  private final double HISTORY_DECAY;
  private final int NUM_PREVIOUS_USED;
  
  private double rewardScaler;
  private int[] position;
  private boolean shouldReset;
  private int timeTaken;
  private int[][] recent;
  private double exploration;
  private int recordTime;
  private int giveUpRatio;
  private double giveUpPunishment;
  
  //First layer: row in the environment
  //Second layer: column in the environment
  //Third layer: type of square in environment: 0 => "Open"  1=> "Wall"  2 => "Start"  3 => "Goal"
  //Fourth layer: actual weight for the move types: 0 => "Up"  1=> "Down"  2 => "Left"  3 => "Right"
  private double[][][][] weights;
  private int[][][] previousDirectionWeights;
  
  private ArrayList<int[]> historicPositions;
  private ArrayList<Integer> historicDirections;
  
  private Random rand;
  private TestEnvironment testEnv;
  
  public ReinforcementLearner(TestEnvironment env, int seed) {
    SIGHT_DISTANCE = 5;
    START = new int[2];
    START[0] = env.getStartPosition()[0];
    START[1] = env.getStartPosition()[1];
    INITIAL_PUNISHMENT_FROM_TIME = -3;
    AMOUNT_OF_RECENT = 3;
    RECENT_PUNISHMENT = -20;
    EXPLORATION_DECAY = 0.9;
    HISTORY_DECAY = 0.9;
    NUM_PREVIOUS_USED = 5;
    
    rewardScaler = 0.2;
    position = new int[2];
    position[0] = START[0];
    position[1] = START[1];
    shouldReset = false;
    timeTaken = 0;
    recent = new int[AMOUNT_OF_RECENT][2];
    exploration = 0.5;
    recordTime = MAX_INT;
    giveUpRatio = 5;
    giveUpPunishment = -100;
    
    weights = new double[2 * SIGHT_DISTANCE + 1][2 * SIGHT_DISTANCE + 1][4][4];
    for (int i = 0; i < weights.length; i++) {
      for (int j = 0; j < weights[0].length; j++) {
        for (int k = 0; k < weights[0][0].length; k++) {
          for (int n = 0; n < weights[0][0][0].length; n++) {
            weights[i][j][k][n] = 0;
          }
        }
      }
    }
    
    previousDirectionWeights = new int[NUM_PREVIOUS_USED][4][4];
    for (int i = 0; i < previousDirectionWeights.length; i++) {
      for (int j = 0; j < previousDirectionWeights[0].length; j++) {
        for (int k = 0; k < previousDirectionWeights[0][0].length; k++) {
          previousDirectionWeights[i][j][k] = 0;
        }
      }
    }
    
    historicPositions = new ArrayList<int[]>();
    historicDirections = new ArrayList<Integer>();
    
    testEnv = env;
    SQUARE_SIZE = testEnv.getSquareSize();
    rand = new Random(seed);
  }
  
  public void makeMove() {
    testEnv.drawEnvironment();
    int[] target;
    int direction;
    double shouldExplore = rand.nextDouble();
    if (shouldExplore < exploration) {
      target = explore();
      direction = -1;
    }
    else {
      direction = decide();
      target = getTargetFromDirection(direction);
      double rew = calculateReward(target);
      reward(rew, direction);
    }
    move(target);
    checkForAndHandleGoal(direction);
    drawAgent();
    //print("Down after Up: " + previousDirectionWeights[0][0][1] + "\n");
    //print("Up after Down: " + previousDirectionWeights[0][1][0] + "\n");
    //print("Right after Left: " + previousDirectionWeights[0][2][3] + "\n");
    //print("Left after Right: " + previousDirectionWeights[0][3][2] + "\n\n");
  }
  
  private int[] explore() {
    int direction = (int)(rand.nextDouble()*4);
    historicDirections.add(-1);    //Should be skipped by reward, since no decision was made
    return getTargetFromDirection(direction);
  }
  
  private void move(int[] target) {
    if (testEnv.isEnterable(target[0], target[1])) {
      position[0] = target[0];
      position[1] = target[1];
      for (int i = recent.length - 2; i >= 0; i--) {
        recent[i + 1][0] = recent[i][0];
        recent[i + 1][1] = recent[i][1];
      }
      recent[0][0] = position[0];
      recent[0][1] = position[1];
    }
    timeTaken++;
    int[] curPos = new int[2];
    curPos[0] = position[0];
    curPos[1] = position[1];
    historicPositions.add(curPos);
    
  }
  
  private int decide() {
    
    double[] directionValue = new double[4];    //Uses "Up", "Down", "Left", and "Right" in that order
    for (int i = 0; i < weights.length; i++) {
      for (int j = 0; j < weights[0].length; j++) {
        String s = testEnv.getType(i + position[0] - SIGHT_DISTANCE, j + position[1] - SIGHT_DISTANCE);
        int squareType = -1;
        if (s.equals("Open")) {
          squareType = 0;
        }
        else if (s.equals("Wall")) {
          squareType = 1;
        }
        else if (s.equals("Start")) {
          squareType = 2;
        }
        else if (s.equals("Goal")) {
          squareType = 3;
        }
        for (int k = 0; k < directionValue.length; k++) {
          directionValue[k] = weights[i][j][squareType][k];
        }
      }
    }
    
    //for (int i = 0; i < Math.min(NUM_PREVIOUS_USED, historicDirections.size()); i++) {
    //  int direction = historicDirections.get(historicDirections.size() - 1 - i);
    //  if (direction < 0) {
    //    continue;
    //  }
    //  for (int k = 0; k < previousDirectionWeights[0][0].length; k++) {
    //    directionValue[k] += previousDirectionWeights[i][direction][k];
    //  }
    //}
    
    int maxInd = 0;
    for (int i = 1; i < directionValue.length; i++) {
      if (directionValue[i] > directionValue[maxInd]) {
        maxInd = i;
      }
    }
    historicDirections.add(maxInd);
    return maxInd;
  }
  
  private int[] getTargetFromDirection(int direction) {
    
    int[] target = new int[2];
    target[0] = position[0];
    target[1] = position[1];
    
    switch(direction) {
      case 0: target[1]--;    //Up
      break;
      case 1: target[1]++;    //Down
      break;
      case 2: target[0]--;   //Left
      break;
      case 3: target[0]++;    //Right
      break;
    }
    
    return target;
  }
  
  private double calculateReward(int[] target) {
    double rewardFromEnvironment = testEnv.getReward(target[0], target[1]);
    double punishmentFromTime = INITIAL_PUNISHMENT_FROM_TIME; //* Math.exp(-1 * timeTaken);
    double punishmentFromRecent = 0;
    if (!testEnv.isEnterable(target[0], target[1])) {
      punishmentFromRecent += RECENT_PUNISHMENT;
      for (int i = 0; i < recent.length; i++) {
        if (position[0] == recent[i][0] && position[1] == recent[i][1]) {
          punishmentFromRecent += RECENT_PUNISHMENT;
        }
      }
    }
    else {
      for (int i = 0; i < recent.length; i++) {
        if (target[0] == recent[i][0] && target[1] == recent[i][1]) {
          punishmentFromRecent += RECENT_PUNISHMENT;
        }
      }
    }
    //print(punishmentFromRecent + "\n");
    double reward = rewardFromEnvironment + punishmentFromTime + punishmentFromRecent;
    return reward;
  }
  
  private void reward(double reward, int direction) {
    if (direction >= 0) {
      rewardIndividualDecision(reward, direction, position, 0);
    }
    for (int i = historicPositions.size() - 1; i >= 0; i--) {
      int[] pos = historicPositions.get(i);
      int[] safePos = new int[2];
      safePos[0] = pos[0];
      safePos[1] = pos[1];
      int dir = historicDirections.get(i);
      if (dir < 0) {
        continue;
      }
      reward *= HISTORY_DECAY;
      rewardIndividualDecision(reward, dir, safePos, i);
    }
    
  }
  
  private void rewardIndividualDecision(double reward, int direction, int[] pos, int howFarBack) {
    for (int i = 0; i < weights.length; i++) {
      for (int j = 0; j < weights[0].length; j++) {
        String s = testEnv.getType(i + pos[0] - SIGHT_DISTANCE, j + pos[1] - SIGHT_DISTANCE);
        int squareType = -1;
        if (s.equals("Open")) {
          squareType = 0;
        }
        else if (s.equals("Wall")) {
          squareType = 1;
        }
        else if (s.equals("Start")) {
          squareType = 2;
        }
        else if (s.equals("Goal")) {
          squareType = 3;
        }
        try {
          weights[i][j][squareType][direction] += (reward * rewardScaler);
        } catch (Exception e) {
          print("Sqaure is " + s + "\tDirection is " + direction + "\n");
        }
      }
    }
    
    //for (int i = howFarBack; i < Math.min(NUM_PREVIOUS_USED, historicDirections.size()); i++) {
    //  int dir = historicDirections.get(historicDirections.size() - 1 - i);
    //  if (dir < 0) {
    //    continue;
    //  }
    //  previousDirectionWeights[i][dir][direction] += (reward * rewardScaler);
    //}
    
  }
  
  private void checkForAndHandleGoal(int direction){
    if (shouldReset) {
      shouldReset = false;
      position[0] = START[0];
      position[1] = START[1];
      timeTaken = 0;
      historicPositions = new ArrayList<int[]>();
      historicDirections = new ArrayList<Integer>();
      delay(2000);
    }
    if (testEnv.getType(position[0], position[1]).equals("Goal")) {
      shouldReset = true;
      if (timeTaken <= recordTime) {
        recordTime = timeTaken;
        exploration *= EXPLORATION_DECAY;
      }
    }
    if (timeTaken >= recordTime * giveUpRatio) {
      shouldReset = true;
      reward(giveUpPunishment, direction);
    }
  }
  
  private void drawAgent() {
    stroke(255, 0, 0);
    fill(255, 0, 0);
    rect(position[0] * SQUARE_SIZE, position[1] * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
  }
  
}

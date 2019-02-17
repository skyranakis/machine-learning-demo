public class ReinforcementLearner {
  
  private final int SIGHT_DISTANCE;
  private final int SQUARE_SIZE;
  private final int[] START;
  private final double INITIAL_PUNISHMENT_FROM_TIME;
  private final int AMOUNT_OF_HISTORY;
  private final double HISTORY_PUNISHMENT;
  
  private double rewardScaler;
  private int[] position;
  private boolean shouldReset;
  private int timeTaken;
  private int[][] history;
  
  //First layer: row in the environment
  //Second layer: column in the environment
  //Third layer: type of square in environment: 0 => "Open"  1=> "Wall"  2 => "Start"  3 => "Goal"
  //Fourth layer: actual weight for the move types: 0 => "Up"  1=> "Down"  2 => "Left"  3 => "Right"
  private double[][][][] weights;
  
  private TestEnvironment testEnv;
  
  public ReinforcementLearner(TestEnvironment env) {
    SIGHT_DISTANCE = 1;
    START = new int[2];
    START[0] = env.getStartPosition()[0];
    START[1] = env.getStartPosition()[1];
    INITIAL_PUNISHMENT_FROM_TIME = -0.01;
    AMOUNT_OF_HISTORY = 3;
    HISTORY_PUNISHMENT = -0.5;
    
    rewardScaler = 0.002;
    position = new int[2];
    position[0] = START[0];
    position[1] = START[1];
    shouldReset = false;
    timeTaken = 0;
    history = new int[AMOUNT_OF_HISTORY][2];
    
    weights = new double[2 * SIGHT_DISTANCE + 1][2 * SIGHT_DISTANCE + 1][4][4];
    for (int i = 0; i < weights.length; i++) {
      for (int j = 0; j < weights[0].length; j++) {
        for (int k = 0; k < weights[0][0].length; k++) {
          for (int n = 0; n < weights[0][0].length; n++) {
            weights[i][j][k][n] = 1;
          }
        }
      }
    }
    
    testEnv = env;
    SQUARE_SIZE = testEnv.getSquareSize();
  }
  
  public void makeMove() {
    testEnv.drawEnvironment();
    int direction = decide();
    int[] target = getTargetFromDirection(direction);
    double rew = calculateReward(target, direction);
    reward(rew, direction);
    move(target);
    drawAgent();
  }
  
  private int decide() {
    
    double[] directionValue = new double[4];    //Uses "Up", "Down", "Left", and "Right" in that order
    for (int k = 0; k < directionValue.length; k++) {
      print(directionValue[k] + " ");
    }
    print("\n");
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
    
    int maxInd = 0;
    print(directionValue[0] + " ");
    for (int i = 1; i < directionValue.length; i++) {
      if (directionValue[i] > directionValue[maxInd]) {
        maxInd = i;
      }
      print(directionValue[i] + " ");
    }
    print("\n");
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
  
  private double calculateReward(int[] target, int direction) {
    print(direction + "\n");
    print(target[0] + " " + target[1] + "\n\n");
    double rewardFromEnvironment = testEnv.getReward(target[0], target[1]);
    double punishmentFromTime = INITIAL_PUNISHMENT_FROM_TIME; //* Math.exp(-1 * timeTaken);
    double punishmentFromHistory = 0;
    if (!testEnv.isEnterable(target[0], target[1])) {
      punishmentFromHistory += HISTORY_PUNISHMENT;
      for (int i = 0; i < history.length; i++) {
        if (position[0] == history[i][0] && position[1] == history[i][1]) {
          punishmentFromHistory += HISTORY_PUNISHMENT;
        }
      }
    }
    else {
      for (int i = 0; i < history.length; i++) {
        if (target[0] == history[i][0] && target[1] == history[i][1]) {
          punishmentFromHistory += HISTORY_PUNISHMENT;
        }
      }
    }
    double reward = rewardFromEnvironment + punishmentFromTime + punishmentFromHistory;
    return reward;
  }
  
  private void reward(double reward, int direction) {
    
    print(reward + "\n");
    
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
        print(s + " promoting " + direction + "\t");
        weights[i][j][squareType][direction] += (reward * rewardScaler);
      }
      print("\n");
    }
  }
  
  private void move(int[] target) {
    
    if (testEnv.isEnterable(target[0], target[1])) {
      position[0] = target[0];
      position[1] = target[1];
      for (int i = history.length - 2; i >= 0; i--) {
        history[i + 1][0] = history[i][0];
        history[i + 1][1] = history[i][1];
      }
      history[0][0] = position[0];
      history[0][1] = position[1];
    }
    
    if (shouldReset) {
      shouldReset = false;
      position[0] = START[0];
      position[1] = START[1];
      delay(2000);
    }
    timeTaken++;
    if (testEnv.getType(target[0], target[1]).equals("Goal")) {
      shouldReset = true;
      timeTaken = 0;
    }
  }
  
  private void drawAgent() {
    stroke(255, 0, 0);
    fill(255, 0, 0);
    rect(position[0] * SQUARE_SIZE, position[1] * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
  }
  
}

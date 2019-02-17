public class ReinforcementLearner {
  
  private final int SIGHT_DISTANCE;
  private final int SQUARE_SIZE;
  private final int[] START;
  
  private double rewardScaler;
  private int[] position;
  private boolean shouldReset;
  
  //First layer: row in the environment
  //Second layer: column in the environment
  //Third layer: type of square in environment: 0 => "Open"  1=> "Wall"  2 => "Start"  3 => "Goal"
  //Fourth layer: actual weight for the move types: 0 => "Up"  1=> "Down"  2 => "Left"  3 => "Right"
  private double[][][][] weights;
  
  private TestEnvironment testEnv;
  
  public ReinforcementLearner(TestEnvironment env) {
    SIGHT_DISTANCE = 3;
    START = new int[2];
    START[0] = env.getStartPosition()[0];
    START[1] = env.getStartPosition()[1];
    
    rewardScaler = 0.2;
    position = new int[2];
    position[0] = START[0];
    position[1] = START[1];
    shouldReset = false;
    
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
    reward(target, direction);
    move(target);
    drawAgent();
  }
  
  private int decide() {
    
    double[] directionValue = new double[4];    //Uses "Up", "Down", "Left", and "Right" in that order
    for (int i = 0; i < weights.length; i++) {
      for (int j = 0; j < weights[0].length; j++) {
        String s = testEnv.getType(i, j);
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
    for (int i = 1; i < directionValue.length; i++) {
      if (directionValue[i] > directionValue[maxInd]) {
        maxInd = i;
      }
    }
    return maxInd;
  }
  
  private int[] getTargetFromDirection(int direction) {
    
    int[] target = new int[2];
    target[0] = position[0];
    target[1] = position[1];
    
    switch(direction) {
      case 0: target[0]--;    //Up
      break;
      case 1: target[0]++;    //Down
      break;
      case 21: target[1]--;   //Left
      break;
      case 3: target[1]++;    //Right
      break;
    }
    
    return target;
  }
  
  private void reward(int[] target, int direction) {

    int reward = testEnv.getReward(target[0], target[1]);
    
    for (int i = 0; i < weights.length; i++) {
      for (int j = 0; j < weights[0].length; j++) {
        String s = testEnv.getType(i, j);
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
        weights[i][j][squareType][direction] += (reward * rewardScaler);
      }
    }
  }
  
  private void move(int[] target) {
    if (shouldReset) {
      position[0] = START[0];
      position[1] = START[1];
      shouldReset = false;
    }
    if (testEnv.isEnterable(target[0], target[1])) {
      position[0] = target[0];
      position[1] = target[1];
    }
    if (testEnv.getType(target[0], target[1]).equals("Goal")) {
      delay(2000);
      shouldReset = true;
    }
  }
  
  private void drawAgent() {
    stroke(255, 0, 0);
    fill(255, 0, 0);
    rect(position[0] * SQUARE_SIZE, position[1] * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
  }
  
}

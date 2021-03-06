public class TestEnvironment {
  
  private String[][] env;
  private final int SQUARE_SIZE;
  private int[] startPosition;
  private int[] goalPosition;
  
  public TestEnvironment(int size) {
    SQUARE_SIZE = size;
    startPosition = new int[2];
    goalPosition = new int[2];
    int numHoriz = width/SQUARE_SIZE;
    int numVert = height/SQUARE_SIZE;
    env = new String[numHoriz][numVert];
    
    for (int i = 0; i < env.length; i++) {
      for (int j = 0; j < env[0].length; j++) {
        env[i][j] = "Open";
      }
    }
    for (int i = 0; i < env.length; i++) {
      env[i][0] = "Wall";
      env[i][env[0].length-1] = "Wall";
    }
    for (int i = 0; i < env[0].length; i++) {
      env[0][i] = "Wall";
      env[env.length-1][i] = "Wall";
    }
    for (int i = (int)(env.length / 10); i < (int)(env.length * 0.9); i++) {
      env[i][(int)(env[0].length/3)] = "Wall";
      env[i][(int)(env[0].length/3)+1] = "Wall";
      env[i][(int)(env[0].length/3)+2] = "Wall";
      env[i][(int)(env[0].length/3)+3] = "Wall";
      env[i][(int)(env[0].length/3)+4] = "Wall";
    }
    for (int i = (int)(env.length / 10); i < env.length; i++) {
      env[i][(int)(2*env[0].length/3)] = "Wall";
      env[i][(int)(2*env[0].length/3)+1] = "Wall";
      env[i][(int)(2*env[0].length/3)+2] = "Wall";
      env[i][(int)(2*env[0].length/3)+3] = "Wall";
      env[i][(int)(2*env[0].length/3)+4] = "Wall";
    }
    for (int i = 1; i < (int)(env[0].length/3); i++) {
      env[(int)(3 * env.length/8)][i] = "Wall";
      env[(int)(3 * env.length/8)+1][i] = "Wall";
      env[(int)(3 * env.length/8)+2][i] = "Wall";
      env[(int)(3 * env.length/8)+3][i] = "Wall";
      env[(int)(3 * env.length/8)+4][i] = "Wall";
    }
    
    env[1][env[0].length-2] = "Start";
    startPosition[0] = 1;
    startPosition[1] = env[0].length-2;
    
    env[env.length-2][1] = "Goal";
    goalPosition[0] = env.length-2;
    goalPosition[1] = 1;
    
    //env[9][9] = "Goal";
    //goalPosition[0] = 9;
    //goalPosition[1] = 9;
    
    //env[8][5] = "Goal";
    //goalPosition[0] = 8;
    //goalPosition[1] = 5;
  }
  
  public boolean isEnterable(int r, int c) {
    if (r < 0 || c < 0 || r >= env.length || c >= env[0].length) {
      return false;
    }
    return !env[r][c].equals("Wall");
  }
  
  public int getReward(int r, int c) {
    String square = env[r][c];
    if (square.equals("Open")) {
      return 0;
    }
    else if (square.equals("Wall")) {
      return -1;
    }
    else if (square.equals("Goal")) {
      return 100;
    }
    return 0;
  }
  
  public String getType(int r, int c) {
    if (r < 0 || c < 0 || r >= env.length || c >= env[0].length) {
      return "Wall";
    }
    return env[r][c];
  }
  
  public int[] getStartPosition() {
    return startPosition;
  }
  
  public int[] getGoalPosition() {
    return goalPosition;
  }
  
  public int getSquareSize() {
    return SQUARE_SIZE;
  }
  
  public void drawEnvironment() {
    for (int i = 0; i < env.length; i++) {
      for (int j = 0; j < env[0].length; j++) {
        if (env[i][j].equals("Open")) {
          fill(255);
          stroke(255);
        }
        else if (env[i][j].equals("Wall")) {
          fill(0);
          stroke(0);
        }
        else if (env[i][j].equals("Goal")) {
          fill(0, 255, 0);
          stroke(0, 255, 0);
        }
        else if (env[i][j].equals("Start")) {
          fill(255, 255, 0);
          stroke(255, 255, 0);
        }
        rect(i*SQUARE_SIZE, j*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
      }
    }
  }
  
}

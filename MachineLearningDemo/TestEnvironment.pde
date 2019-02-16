public class TestEnvironment {
  
  String[][] env;
  int SQUARE_SIZE;
  int[] startPosition;
  
  public TestEnvironment(int size) {
    SQUARE_SIZE = size;
    startPosition = new int[2];
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
    for (int i = 4; i < env.length-4; i++) {
      env[i][10] = "Wall";
      env[i][20] = "Wall";
    }
    
    env[env.length-2][1] = "Goal";
    env[1][env[0].length-2] = "Start";
    startPosition[0] = 1;
    startPosition[1] = env[0].length-2;
  }
  
  public boolean isEnterable(int r, int c) {
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
      return 10;
    }
    return 0;
  }
  
  public int[] getStartPosition() {
    return startPosition;
  }
  
  public int getSquareSize() {
    return SQUARE_SIZE;
  }
  
  public void drawEnvironment() {
    for (int i = 0; i < env.length; i++) {
      for (int j = 0; j < env[0].length; j++) {
        if (env[i][j].equals("Open")) {
          continue;
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
          fill(255, 0, 0);
          stroke(255, 0, 0);
        }
        rect(i*SQUARE_SIZE, j*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
      }
    }
  }
  
}

public class PheromoneTrail {
  
  private final int SQUARE_SIZE;
  private final double DECAY_AMOUNT;
  private double[][] trails;
  
  public PheromoneTrail(int size) {
    SQUARE_SIZE = size;
    DECAY_AMOUNT = 0.995;
    int numHoriz = width/SQUARE_SIZE;
    int numVert = height/SQUARE_SIZE;
    trails = new double[numHoriz][numVert];
    for (int i = 0; i < trails.length; i++) {
      for (int j = 0; j < trails[0].length; j++) {
        trails[i][j] = 100;
      }
    }
  }
  
  public double getPheromone(int r, int c) {
    if (r < 0 || c < 0 || r >= trails.length || c >= trails[0].length) {
      return 0;
    }
    return trails[r][c];
  }
  
  public void putPheromone(int r, int c, double amount) {
    trails[r][c] += amount;
  }
  
  public void decayPheromones() {
    for (int i = 0; i < trails.length; i++) {
      for (int j = 0; j < trails[0].length; j++) {
        trails[i][j] *= DECAY_AMOUNT;
      }
    }
  }
  
  public void drawPheromones() {
    for (int i = 0; i < trails.length; i++) {
      for (int j = 0; j < trails[0].length; j++) {
        int val = (int)trails[i][j];
        if (val > 255) {
          if (val > 510) {
            val = 510;
          }
          val -= 255;
          int amountBlue = 255 - val;
          stroke(0, 0, amountBlue);
          fill(0, 0, amountBlue);
        }
        else {
          if (val < 0) {
            val = 0;
          }
          int amountColor = 255 - val;
          stroke(amountColor, amountColor, 255);
          fill(amountColor, amountColor, 255);
        }
        rect(i*SQUARE_SIZE, j*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
      }
    }
  }
  
}

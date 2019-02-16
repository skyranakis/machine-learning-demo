public class PheromoneTrail {
  
  private final int SQUARE_SIZE;
  private final double DECAY_AMOUNT;
  private double[][][] trails;
  
  public PheromoneTrail(int size) {
    SQUARE_SIZE = size;
    DECAY_AMOUNT = 0.9995;
    int numHoriz = width/SQUARE_SIZE;
    int numVert = height/SQUARE_SIZE;
    trails = new double[numHoriz][numVert][2];
    for (int i = 0; i < trails.length; i++) {
      for (int j = 0; j < trails[0].length; j++) {
        trails[i][j][0] = 100;
        trails[i][j][1] = 100;
      }
    }
  }
  
  public double[] getPheromone(int r, int c) {
    if (r < 0 || c < 0 || r >= trails.length || c >= trails[0].length) {
      return new double[2];
    }
    return trails[r][c];
  }
  
  public void putPheromone(int r, int c, double[] amount) {
    trails[r][c][0] += amount[0];
    if (trails[r][c][0] > 500) {
      trails[r][c][0] = 500;
    }
    trails[r][c][1] += amount[1];
    if (trails[r][c][1] > 500) {
      trails[r][c][1] = 500;
    }
  }
  
  public void decayPheromones() {
    for (int i = 0; i < trails.length; i++) {
      for (int j = 0; j < trails[0].length; j++) {
        trails[i][j][0] *= DECAY_AMOUNT;
        trails[i][j][1] *= DECAY_AMOUNT;
      }
    }
  }
  
  public void drawPheromones() {
    for (int i = 0; i < trails.length; i++) {
      for (int j = 0; j < trails[0].length; j++) {
        
        if (get(i * SQUARE_SIZE + 1, j * SQUARE_SIZE + 1) != color(255)) {
          continue;
        }
        
        int initBlueVal = (int)trails[i][j][0];
        int[] blueColor = getBlueColor(initBlueVal);
        int initRedVal = (int)trails[i][j][1];
        int[] redColor = getRedColor(initRedVal);
        
        int[] finalColor = new int[3];
        finalColor[0] = Math.min( Math.min(blueColor[0], redColor[0]), 255);
        finalColor[1] = 255 - initBlueVal - initRedVal;
        finalColor[1] = (finalColor[1] < 0) ? 0 : finalColor[1];
        finalColor[2] = Math.min( Math.min(blueColor[2], redColor[2]), 255);
        
        stroke(finalColor[0], finalColor[1], finalColor[2]);
        fill(finalColor[0], finalColor[1], finalColor[2]);
        rect(i*SQUARE_SIZE, j*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
      }
    }
  }
  
  private int[] getBlueColor(int initBlueVal) {
    
    int[] blueColor = new int[3];
        
    if (initBlueVal > 255) {
      if (initBlueVal > 450) {
         initBlueVal = 450;
       }
       initBlueVal -= 255;
       blueColor[0] = 0;
       blueColor[1] = 0;
       blueColor[2] = 255 - initBlueVal;
     }
     else {
       if (initBlueVal < 0) {
         initBlueVal = 0;
       }
       blueColor[0] = 255 - initBlueVal;
       blueColor[1] = 255 - initBlueVal;
       blueColor[2] = 255;
     }
     
     return blueColor;
  }
  
  private int[] getRedColor(int initRedVal) {
    
    int[] redColor = new int[3];
        
    if (initRedVal > 255) {
      if (initRedVal > 450) {
         initRedVal = 450;
       }
       initRedVal -= 255;
       redColor[0] = 255 - initRedVal;
       redColor[1] = 0;
       redColor[2] = 0;
     }
     else {
       if (initRedVal < 0) {
         initRedVal = 0;
       }
       redColor[0] = 255;
       redColor[1] = 255 - initRedVal;
       redColor[2] = 255 - initRedVal;
     }
     
     return redColor;
  }
  
}

public class SwarmMember {
  
  private final int LOOK_AHEAD_AMOUNT;
  private final int HUNGRY_TRAIL;
  private final int FULL_TRAIL;
  private final double FULL_WEAR_OFF;
  private final int SQUARE_SIZE;
  
  private double trailAmount;
  private int[] position;
  private TestEnvironment testEnv;
  private PheromoneTrail pher;
  
  public SwarmMember(int[] pos, TestEnvironment env, PheromoneTrail pherTrail, int size) {
    LOOK_AHEAD_AMOUNT = 3;
    HUNGRY_TRAIL = 10;
    FULL_TRAIL = 100;
    FULL_WEAR_OFF = 0.9;
    SQUARE_SIZE = size;
    
    trailAmount = HUNGRY_TRAIL;
    position = pos;
    testEnv = env;
    pher = pherTrail;
  }
  
  public void move() {
  }
  
  public void drawMember() {
    stroke(100, 100, 100);
    fill(100, 100, 100);
    rect(position[0]*SQUARE_SIZE, position[1]*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
  }
}

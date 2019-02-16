public class Swarm {
  
  private final int SQUARE_SIZE;
  private final int NUM_MEMBERS;
  private TestEnvironment testEnv;
  private PheromoneTrail pher;
  
  public Swarm(int size, TestEnvironment env) {
    SQUARE_SIZE = size;
    NUM_MEMBERS = 100;
    pher = new PheromoneTrail(SQUARE_SIZE);
    testEnv = env;
  }
  
  public void makeMove(){
    pher.drawPheromones();
    pher.decayPheromones();
    testEnv.drawEnvironment();
  }
  
}

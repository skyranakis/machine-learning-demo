public class Swarm {
  
  private final int NUM_MEMBERS;
  private final int RELEASE_FREQUENCY;
  
  private int currentlyOut;
  private int timeUntilNext;
  
  private TestEnvironment testEnv;
  private PheromoneTrail pher;
  private SwarmMember[] members;
  
  public Swarm(TestEnvironment env, int seed) {
    NUM_MEMBERS = 5;
    RELEASE_FREQUENCY = 15;
    
    currentlyOut = 1;
    timeUntilNext = RELEASE_FREQUENCY;
    
    pher = new PheromoneTrail(SQUARE_SIZE);
    testEnv = env;
    members = new SwarmMember[NUM_MEMBERS];
    for (int i = 0; i < NUM_MEMBERS; i++) {
      members[i] = new SwarmMember(env.getStartPosition(), env, pher, new Random(seed + i));
    }
  }
  
  public void makeMove(){
    pher.drawPheromones();
    for (int i = 0; i < currentlyOut; i++) {
      members[i].takeTurn();
    }
    if (currentlyOut < NUM_MEMBERS) {
      if (timeUntilNext == 0) {
        currentlyOut++;
        timeUntilNext = RELEASE_FREQUENCY;
      }
      else {
        timeUntilNext--;
      }
    }
    pher.decayPheromones();
    testEnv.drawEnvironment();
  }
  
}

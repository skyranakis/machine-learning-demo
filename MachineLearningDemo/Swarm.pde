public class Swarm {
  
  private final int NUM_MEMBERS;
  private final int RELEASE_FREQUENCY;
  private final boolean FIND_PATHWAY;
  
  private int currentlyOut;
  private int timeUntilNext;
  
  private TestEnvironment testEnv;
  private PheromoneTrail pher;
  private SwarmMember[] members;
  
  public Swarm(TestEnvironment env, int seed) {
    NUM_MEMBERS = 10000; //100;
    RELEASE_FREQUENCY = 5; //1;
    FIND_PATHWAY = true;
    
    currentlyOut = 1;
    timeUntilNext = RELEASE_FREQUENCY;
    
    pher = new PheromoneTrail(SQUARE_SIZE);
    testEnv = env;
    members = new SwarmMember[NUM_MEMBERS];
    for (int i = 0; i < NUM_MEMBERS; i++) {
      members[i] = new SwarmMember(env.getStartPosition(), env, pher, new Random(seed + i), FIND_PATHWAY);
    }
  }
  
  public void makeMove(){
    testEnv.drawEnvironment();
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
  }
  
}

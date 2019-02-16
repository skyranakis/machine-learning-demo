public class Swarm {
  
  private final int NUM_MEMBERS;
  private final int SEED;
  
  private int currentlyOut;
  private TestEnvironment testEnv;
  private PheromoneTrail pher;
  private SwarmMember[] members;
  
  public Swarm(TestEnvironment env, int seed) {
    NUM_MEMBERS = 5;
    SEED = seed;
    currentlyOut = 1;
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
      currentlyOut++;
    }
    pher.decayPheromones();
    testEnv.drawEnvironment();
  }
  
}

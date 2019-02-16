public class Swarm {
  
  private final int NUM_MEMBERS;
  private final int SEED;
  
  private TestEnvironment testEnv;
  private PheromoneTrail pher;
  private SwarmMember[] members;
  
  public Swarm(TestEnvironment env, int seed) {
    NUM_MEMBERS = 20;
    SEED = seed;
    pher = new PheromoneTrail(SQUARE_SIZE);
    testEnv = env;
    members = new SwarmMember[NUM_MEMBERS];
    for (int i = 0; i < NUM_MEMBERS; i++) {
      members[i] = new SwarmMember(env.getStartPosition(), env, pher, new Random(seed + i));
    }
  }
  
  public void makeMove(){
    for (int i = 0; i < NUM_MEMBERS; i++) {
      members[i].takeTurn();
    }
    pher.drawPheromones();
    pher.decayPheromones();
    testEnv.drawEnvironment();
  }
  
}

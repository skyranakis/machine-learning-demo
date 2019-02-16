public class Genetic {
  
  private final int SQUARE_SIZE;
  private final int NUM_MEMBERS;
  private Random r;
  private TestEnvironment testEnv;
  private Organism[] organisms;
  private Organism[] selected;
  
  public Genetic(TestEnvironment env) {
    this.SQUARE_SIZE = env.getSquareSize();
    this.NUM_MEMBERS = 100;
    this.testEnv = env;
    this.creation();
    this.r = new Random(SEED);
  }
  
  public void makeMove(){
    this.testEnv.drawEnvironment();
  }
  
  private void reproduce(Organism[] orgs) {}
  
  private void creation() {}
  
  private void selection() {}
  
  private boolean growOrganism(Organism O) {
    return true;
  }
  
}
public class Genetic {
  
  private final int SQUARE_SIZE;
  private final int NUM_MEMBERS;
  private Random r;
  private TestEnvironment testEnv;
  private Organism[] organisms;
  private Organism[] selected;
  private Organism winner;
  
  public Genetic(TestEnvironment env) {
    this.SQUARE_SIZE = env.getSquareSize();
    this.NUM_MEMBERS = 50;
    this.testEnv = env;
    this.r = new Random(SEED);
    this.create();
  }
  
  public void makeMove(){
    this.testEnv.drawEnvironment();
    if(this.isPath()) {
      int[] path = this.winner.getMoves();
      int[] position = new int[2];
      position[0] = this.testEnv.getStartPosition()[0];
      position[1] = this.testEnv.getStartPosition()[1];
      int[] end = this.testEnv.getGoalPosition();
      for(int i = 0; i < path.length; i++) {
        int move = path[i];
        if(move == 0) {
          position[1] -= 1;
        } else if (move == 1) {
          position[1] += 1;
        } else if (move == 2) {
          position[0] -= 1;
        } else {
          position[0] += 1;
        }
        stroke(100, 100, 100);
        fill(100, 100, 100);
        rect(position[0]*SQUARE_SIZE, position[1]*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
        if (position[0] == end[0] && position[1] == end[1]) {
           break; 
        }
      }
    } else {
      this.drawOrganisms();
      this.select();
      this.reproduce();
    }
  }
  
  private void reproduce() {
    Organism[] newOrgs = new Organism[NUM_MEMBERS];
    for (int i = 0; i < NUM_MEMBERS; i++) {
      int[] moves = this.selected[Math.abs(this.r.nextInt() % 5)].getMoves();
      int[] newMoves = new int[150];
      for(int x = 0; x < 150; x++) {
        newMoves[x] = moves[x];
      }
      newOrgs[i] = new Organism(newMoves); //initialize move sequence to the moves of a random member of selected set
      int[] index_changes = new int[10];
      for (int x = 0; x < index_changes.length; x++) {
        index_changes[x] = Math.abs(this.r.nextInt() % 125); //select a random index to mutate
        //System.out.println(index_changes[x]);
        newOrgs[i].setMove(index_changes[x], this.r.nextInt() % 4); //mutate index to a random value
      }
    }
    this.organisms = newOrgs;
  }
  
  private void create() {
    this.organisms = new Organism[this.NUM_MEMBERS]; //Creates initial array of organisms for first generation
    for(int i = 0; i < 50; i++) { 
      int[] moves = new int[150];
      for(int x = 0; x < 150; x++) {
        moves[x] = r.nextInt() % 4; //Creates a path of length 50 for this organism to travel with 0, 1, 2, and 3 representing Down, Up, Left, and Right, respectively
      }
      this.organisms[i] = new Organism(moves);
    }
  }
  
  private void select() {
    Organism[] closestOrgs = new Organism[5]; //initial array of best organisms this generation
    int[] initialEnds = new int[2];
    initialEnds[0] = MAX_INT/2;
    initialEnds[1] = MAX_INT/2;
    for(int i = 0; i < 5; i++) {
      closestOrgs[i] = new Organism(new int[150]); 
      closestOrgs[i].setEnd(initialEnds); //initialize each starting organism to an impossibly large position 
    }
    for(int i = 0; i < this.NUM_MEMBERS; i++) {
      boolean avoidsWalls = growOrganism(this.organisms[i]); //simulate path for organism to determine wall collisions and set ending position
      if(avoidsWalls) {
        int[] goal = this.testEnv.getGoalPosition();
        for(int x = 0; x < 5; x++) { //loop through current best organisms and check if our current organism is better
          int[] current_end = closestOrgs[x].getEnd();
          int[] new_end = this.organisms[i].getEnd();
          int diff_current = (Math.abs(goal[0] - current_end[0])) + (Math.abs(goal[1] - current_end[1]));
          int diff_new = (Math.abs(goal[0] - new_end[0])) + (Math.abs(goal[1] - new_end[1]));
          if (diff_new < diff_current) { //if current organism is better, select for it
            closestOrgs[x] = this.organisms[i];
            break;
          }
        }
      }
    }
    this.selected = closestOrgs;
  }
  
  private boolean growOrganism(Organism O) {
    int[] current_square = new int[2];
    current_square[0] = this.testEnv.getStartPosition()[0];
    current_square[1] = this.testEnv.getStartPosition()[1];
    for(int i = 0; i < 150; i++) {
      int move = O.getMove(i);
      if(move == 0) {
        current_square[1] -= 1;
      } else if (move == 1) {
        current_square[1] += 1;
      } else if (move == 2) {
        current_square[0] -= 1;
      } else {
        current_square[0] += 1;
      }
      if (!this.testEnv.isEnterable(current_square[1], current_square[0])) { //instantly reject if organism moves out of bounds or into a wall
        return false;
      }
    }
    O.setEnd(current_square);
    return true;
  }
  
  private boolean isPath() {
    for(int i = 0; i < NUM_MEMBERS; i++) {
      int[] current_square = new int[2];
      current_square[0] = this.testEnv.getStartPosition()[0];
      current_square[1] = this.testEnv.getStartPosition()[1];
      for(int x = 0; x < 150; x++) {
        int move = this.organisms[i].getMove(x);
        if(move == 0) {
          current_square[1] -= 1;
        } else if (move == 1) {
          current_square[1] += 1;
        } else if (move == 2) {
          current_square[0] -= 1;
        } else {
          current_square[0] += 1;
        }
        int[] end = this.testEnv.getGoalPosition();
        if(current_square[0] == end[0] && current_square[1] == end[1]) {
          this.winner = this.organisms[i];
          return true;
        }
      }
    }
    return false;
  }
  
  private void drawOrganisms() {
      for(int i = 0; i < NUM_MEMBERS; i++) {
        int[] path = this.organisms[i].getMoves();
        int[] position = new int[2];
        position[0] = this.testEnv.getStartPosition()[0];
        position[1] = this.testEnv.getStartPosition()[1];
        int[] end = this.testEnv.getGoalPosition();
        for(int x = 0; x < path.length; x++) {
          int move = path[x];
          if(move == 0) {
            position[1] -= 1;
          } else if (move == 1) {
            position[1] += 1;
          } else if (move == 2) {
            position[0] -= 1;
          } else {
            position[0] += 1;
          }
          stroke(100, 100, 100);
          fill(100, 100, 100);
          rect(position[0]*SQUARE_SIZE, position[1]*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE);
          if (position[0] == end[0] && position[1] == end[1]) {
            break; 
          }
        }
      }
  }
  
}
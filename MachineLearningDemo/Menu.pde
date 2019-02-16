public class Menu {
  
  private int TIME_UNTIL_SWITCH;
  
  private boolean swarmSelected;
  private boolean geneticSelected;
  private int timeSinceSelected;
  
  public Menu() {
    TIME_UNTIL_SWITCH = 1;
    
    swarmSelected = false;
    geneticSelected = false;
    timeSinceSelected = MAX_INT;
  }
  
  public int run() {
    drawMenu();
    if (swarmSelected && timeSinceSelected == 0) {
      return 1;
    }
    else if (geneticSelected && timeSinceSelected == 0) {
      return 2;
    }
    else {
      if (timeSinceSelected != MAX_INT) {
        timeSinceSelected--;
      }
      return 0;
    }
  }
  
  public void handleClick() {
    if (mouseX >= 50 && mouseX <= 250 && mouseY >= 50 && mouseY <= 100) {
      swarmSelected = true;
      timeSinceSelected = TIME_UNTIL_SWITCH;
    }
    else if (mouseX >= 50 && mouseX <= 250 && mouseY >= 150 && mouseY <= 200) {
      geneticSelected = true;
      timeSinceSelected = TIME_UNTIL_SWITCH;
    }
  }
  
  private void drawMenu() {
    background(255);
    drawSwarmButton();
    drawGeneticButton();
  }
  
  private void drawSwarmButton() {
    stroke(0, 0, 180);
    fill(0, 0, 180);
    if (swarmSelected) {
      stroke(0, 180, 255);
      fill(0, 180, 255);
    }
    rect(50, 50, 200, 50);
    fill(255);
    textSize(30);
    text("Swarm", 60, 90);
  }
  
  private void drawGeneticButton() {
    stroke(0, 0, 180);
    fill(0, 0, 180);
    if (geneticSelected) {
      stroke(0, 180, 255);
      fill(0, 180, 255);
    }
    rect(50, 150, 200, 50);
    fill(255);
    textSize(30);
    text("Genetic", 60, 190);
  }
}

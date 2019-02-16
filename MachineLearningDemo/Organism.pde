public class Organism {
   private int[] _moves;
   private int[] _end;
   public Organism(int[] moves) {
     this._moves = moves;
   } 
   
   public void setEnd(int[] end) {
     this._end = end;
   }
   
   public int[] getEnd() {
     return this._end;
   }
   
   public int getMove(int pos) {
     return this._moves[pos];
   }
   
   public int[] getMoves() {
     return this._moves;
   }
   
   public void setMove(int pos, int val) {
     this._moves[pos] = val;
   }
}
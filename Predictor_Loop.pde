//PREDICTOR LOOPS can be used to predict the results (wins or point distribution) of a specific tournament by running the tournament a large number of times.
//The higher the number of runs, the closer the results should get to the exact probability of each event.
//Suggested that you set narrate to false for looped tournament and for number of runs to use 10000 - 1000000 for round robin, 1000 - 10000 for Swiss

class loop {
  //FIELDS
  Tournament tournament;  //tournament being looped
  int numRuns;            //how many times the tournament will be looped
  float[] scores;         //final scores after looped numRuns times
  int numPlay;            //number of players in the looped tournament
  String type;            //predict outcome for either point distribution ("points") or probability of winning ("wins")
  
  //CONSTRUCTOR
  loop(Tournament t, int n, String ty) {
    this.tournament = t;
    this.numRuns = n;
    this.type = ty;
    this.numPlay = this.tournament.participants.size();
    
    float[] sc = new float[numPlay];  //build list of total scores for each player
    
    for (int i = 0; i < numPlay; i++) {
      sc[i] = 0;  //set each score at 0 initially
    }
    
    this.scores = sc;    
  }
  
  //START THE LOOP
  void runLoop() {
    float[] currentScores = new float[this.numPlay];  //used at a given iteration of the loop
    float total = 0;  //keep track of total amount of points scored if this.type is "points"
    
    for (int i = 0; i < this.numRuns; i++) {  //rerun tournament numRuns times; greater numRuns --> more accurate predictions of distribution
      currentScores = this.tournament.runTourney();  //currentScores is now results of this tournament run
      
      if (this.type.equals("points")) {
        for (int j = 0; j < numPlay; j++) {
          scores[j] += currentScores[j];  //add each player's score in this run to their total
          total += currentScores[j];      //add all scores to the total score
        }     
      }
      
      else {  //type is "wins"
        float maxScore = max(currentScores);
                
        for (int k = 0; k < numPlay; k++) {
          if (this.tournament.playerScores[k] == maxScore) { //add a win for for ALL players with top score, not just first one.
            scores[k]++;
          }
        }
      }      
      this.tournament.reset();  //set player elos back to what they were, scores back to 0
    }
    
    println();
    println("**************************");
    println("After running the", this.tournament.name, this.numRuns, "times, the results were as follows:");
    
    for (int i = 0; i < this.numPlay; i++) {  //output each player's expected results
      float winPercent;
      
      if (this.type.equals("points")) {
        winPercent = this.scores[i] * 100.0 / total;  //percent won is sum of all tournament runs scores for tha player divided by total (x 100)
        println("-------------------------------------------------");
        println(this.tournament.participants.get(i).name, "is expected to win the", winPercent, "% of the points.");
      }
      
      else {
        if (i == 0) 
          println("(Note that the total could be more than 100%, since some tournaments result in a tie for first.)");

        println("-------------------------------------------------");
        winPercent = this.scores[i] * 100.0 / numRuns;  //tournaments won by player divided by numRuns (number of tournaments run)
        println(this.tournament.participants.get(i).name, "is expected to win", this.tournament.name, winPercent, "% of the time."); 
      }
    }
    
  }
}

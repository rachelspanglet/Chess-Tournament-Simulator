class Tournament {
  //FIELDS
  String name;
  String date;
  String format;       //swiss or round robin
  String timeControl;  //classical, rapid, blitz
  int K;               //elo change factor per match
  ArrayList<Player> participants = new ArrayList<Player>();      //all participating players
  ArrayList<Integer> playerStartElos = new ArrayList<Integer>(); //players' elos at the beginning of tournament
  float[] playerScores;  //scores of players throughout tournament
  boolean narrate;       //whether or not the results of each match are printed to the screen
  
  //CONSTRUCTOR 1
  Tournament(String n, String d, String f, int t, int i, int k, boolean na) {
    this.name = n;
    this.date = d;
    this.format = f;
    this.K = k;
    this.narrate = na;
    
    //determine time format from base time and increment
    float totalTime = t + i/20;
    
    if (totalTime > 30)
      this.timeControl = "classical";
    
    else if (totalTime > 5)
      this.timeControl = "rapid";
    
    else
      this.timeControl = "blitz"; 
  }
  
  //CONSTRUCTOR 2
  Tournament(String n, String d, String f, int t, int k, boolean na) {
    this.name = n;
    this.date = d;
    this.format = f;
    this.K = k;
    this.narrate = na;
    
    //determine time format from base time and increment 
    if (t > 30)
      this.timeControl = "classical";
    
    else if (t > 5)
      this.timeControl = "rapid";
    
    else
      this.timeControl = "blitz"; 
  }
  
  
  //METHODS
  
  //INTRODUCE TOURNAMENT along with participating players
  void introduce() {
    if (this.participants.size() > 0) {
      println();
      println("********************************");
      println("Welcome to the", this.name + "! This tournament runs on", this.date + ".");
      println("The time format is", this.timeControl, "and the style is", this.format + ".");
      println("The players are:");
      println("--------------");
      
      for (int i = 0; i < participants.size(); i++) {  //describe every participant
        participants.get(i).describe();
      }
    }
    else  //size of tournament is 0
      println("Nobody is signed up for this tournament yet.");
  }

//RUN TOURNAMENT
float[] runTourney() {  //return a float[] of scores in the tournament for each player; used for predictor loops
    int numPlayers = participants.size();
    this.playerScores = new float[numPlayers];
    
    for (int i = 0; i < numPlayers; i++) {
      this.playerScores[i] = 0;  //initially set each player's score to 0
    }
    
    if (this.format.equals("swiss")) {  //swiss format
      //swiss has many constraints for match pairings, so runs until possible tournament is made
      boolean tournamentFinished = false;  //viable tournament not yet found
      boolean firstRound = true;           //if swiss needs to run more than once, set to false
      while (!tournamentFinished) {  //keep trying this block again until tournament finishes
        if (!firstRound && this.narrate) {
          for (int i = 0; i < 1000; i++) {  //way of "deleting" past run from the screen
            println(" ");
          }
          this.introduce();    
        }
        
        firstRound = false;  //after running at least once, no longer the first try running tourney
        int numGamesPerRound = numPlayers/2;
        float differenceChecked;  //for trying to assign players each round with similar scores
        int numRounds = ceil(log(numPlayers)/log(2));  //swiss tournaments work on logarithmic number of rounds
        boolean[] byes = new boolean[numPlayers];      //keep track of which players have received byes
        boolean[][] alreadyPlayed = new boolean[numPlayers][numPlayers];  //ensure nobody plays each other twice
        
        for (int i = 0; i < numPlayers; i++) {
          this.playerScores[i] = 0;  //initially set each player's score to 0
        }
         
        for (int i = 0; i < numPlayers; i++) {
          byes[i] = false;  //initially nobody has received a bye
          for (int j = 0; j < numPlayers; j++) {
            alreadyPlayed[i][j] = false;  //initially nobody has played anybody else
          }
        }      
              
        for (int m = 0; m < numRounds; m++) {  //assign pairings for every round
          if (this.narrate) {
            println();
            println("---------");
            println("ROUND", m+1);
            println("---------");
          }
          
          differenceChecked = 0;  //at first, try to pair players with the same score  
          
          //ArrayLists identical in content to playerScores, participants, but to be manipulated during pairing.
          ArrayList<Float> allScores = new ArrayList<Float>();
          ArrayList<Player> allPlayers = new ArrayList<Player>();
          ArrayList<Integer> originalOrder = new ArrayList<Integer>();  //keep track of original position of items in allScores and allPlayers     
  
          for (int x = 0; x < playerScores.length; x++) {
            originalOrder.add(x);  //start off with every original index in its original place
          }
            
          originalOrder = shuffle(originalOrder);  //shuffle order; eliminates bias caused by players being in the same particular spot every round
            
          //Add scores and players in the correct order based on shuffling of order
          for (int i = 0; i < numPlayers; i++) {
            allScores.add(this.playerScores[originalOrder.get(i)]);
            allPlayers.add(this.participants.get(originalOrder.get(i)));
          }
  
          if (numPlayers%2 == 1) {  //if odd number of players, every round will assign a bye
            if (m == 0) {  //first round, lowest rated player receives a bye according to Swiss rules
              int[] playerElos = new int[numPlayers];
              
              //get correct elo for the tournament's time format
              for (int i = 0; i < numPlayers; i++) {
                if (this.timeControl.equals("classical"))
                  playerElos[i] = allPlayers.get(i).classicalElo;
              
                else if (this.timeControl.equals("rapid"))
                  playerElos[i] = allPlayers.get(i).rapidElo;
                
                else 
                  playerElos[i] = allPlayers.get(i).blitzElo;                        
              }
              
              int lowestElo = min(playerElos);  //determine lowest elo of all players to give first bye
              
              for (int i = 0; i < numPlayers; i++) {
                if (playerElos[i] == lowestElo) {  //if player i is the one with the lowest elo, give bye
                  this.playerScores[originalOrder.get(i)] += 1;  //bye = 1 point (note use of originalOrder since shuffled)
                  byes[originalOrder.get(i)] = true;  //ensure they don't get another bye
                  
                  if (this.narrate)
                    println(allPlayers.get(i).name, "received a bye.");
                  
                  //remove items associated with bye player when determning pairings later
                  allScores.remove(allScores.get(i));
                  allPlayers.remove(allPlayers.get(i));
                  originalOrder.remove(originalOrder.get(i));
                  i = numPlayers;  //break out of loop
                }
               }
              }
              
              else { //determine byes in subsequent rounds
                boolean byeDetermined = false;
                float lowestScore;  //bye awarded to player with lowest score
                float[] modScores = this.playerScores;  //will manipulate later
                int c = 0;  //use as looping variable for while loop
      
                while (!byeDetermined) {  //repeat until bye has been determined
                  lowestScore = min(modScores);
                  
                  if (modScores[originalOrder.get(c)] == lowestScore && !byes[originalOrder.get(c)]) {  //player has lowest score and hasn't received a bye yet
                    this.playerScores[originalOrder.get(c)] += 1;
                    
                    if (this.narrate) 
                      println(allPlayers.get(c).name, "received a bye.");
                    
                    //remove player with bye from round's pairings
                    allScores.remove(allScores.get(c));
                    allPlayers.remove(allPlayers.get(c));
                    byes[originalOrder.get(c)] = true;
                    originalOrder.remove(originalOrder.get(c));
                    
                    byeDetermined = true;
                  }
                  
                  else if (modScores[originalOrder.get(c)] == lowestScore) {  //player with lowest score has already received a bye
                    modScores[originalOrder.get(c)] = numRounds;  //assign value to number of rounds so this value won't be detected as lowest in next iteration of while loop
                    c = -1;  //try again on this iteration
                  }
                              
                  c++;  //move on to check next player
                }          
             }
          }
          
          //create pairings for this round
          for (int i = 0; i < numGamesPerRound; i++) {        
            for (int j = 0; j < allPlayers.size() - 1; j++) {  //check every player
              for (int k = j+1; k < allPlayers.size(); k++) {  //with every other player to see if they should play each other this round
                
                boolean same = allPlayers.get(j).equals(allPlayers.get(k));  //ensure player doesn't play themself
                boolean alrPlayed;
                alrPlayed = alreadyPlayed[originalOrder.get(j)][originalOrder.get(k)];  //ensure same match doesn't occur more than once
                
                //only runs if scores separated by lowest possible diffence (differenceChecked), not a player playing themself, match hasn't occured yet
                if ((allScores.get(j) == allScores.get(k) + differenceChecked || allScores.get(j) + differenceChecked == allScores.get(k)) && !same && !alrPlayed) {
                  Player p1 = allPlayers.get(j);
                  Player p2 = allPlayers.get(k);
  
                  float winner = p1.playAgainst(p2, this.timeControl, this.K);
                  //players have now already played each other
                  alreadyPlayed[originalOrder.get(j)][originalOrder.get(k)] = true;
                  alreadyPlayed[originalOrder.get(k)][originalOrder.get(j)] = true;
                  
                  if (winner == 1) {  //p1 wins
                    if (this.narrate)
                      println(p1.name, "-", p2.name, "resulted in a win for", p1.name);
                    this.playerScores[originalOrder.get(j)] += 1;
                  }
                  
                  else if (winner == 0) {  //p2 wins
                    if (this.narrate)
                      println(p1.name, "-", p2.name, "resulted in a win for", p2.name);
                    this.playerScores[originalOrder.get(k)] += 1;
                  }
                  
                  else {  //draw
                    if (this.narrate)
                      println(allPlayers.get(j).name, "-", allPlayers.get(k).name, "resulted in a draw");
                    this.playerScores[originalOrder.get(j)] += 0.5;
                    this.playerScores[originalOrder.get(k)] += 0.5;
                  }
                  
                  //once paired, remove players from the pool of players still needing to be assigned an opponent
                  originalOrder.remove(originalOrder.get(j));
                  originalOrder.remove(originalOrder.get(k-1));
                  allScores.clear();
                  allPlayers.clear();
                  
                  if (originalOrder.size() == 0 && m == numRounds - 1) {  //pairing for entire tournament successful
                    tournamentFinished = true;
                    j = allPlayers.size();
                    k = allPlayers.size();
                    m = numRounds;
                    i = numGamesPerRound;
                    if (this.narrate) {
                      println();
                      println("The final rankings for", this.name, "are as follows:");
                      println("--------------------------------------------------------");
                      //create new float[] to not mess with playerScores in declareRankings (it could be needed later)
                      float[] sc = new float[numPlayers];
                      for (int q = 0; q < numPlayers; q++) {
                        sc[q] = this.playerScores[q];
                      }
                      
                      this.declareRankings(sc);                
                    } 
                  }
                  
                  //break out of loops and move on to next match assignment
                  j = allPlayers.size();
                  k = allPlayers.size();
                  
                  originalOrder = shuffle(originalOrder);  //shuffle order again for no bias towards order
                  
                  //refill allScores and allPlayers with remaning unpaired values in correct order
                  for (int p = 0; p < originalOrder.size(); p++) {
                    allScores.add(this.playerScores[originalOrder.get(p)]);
                    allPlayers.add(this.participants.get(originalOrder.get(p)));
                  }
                }
                
                else if (k == allPlayers.size()-1 && j == allPlayers.size()-2) {  //tried to pair players with a separation of differenceChecked, but was impossible
                  differenceChecked += 0.5;  //increase the difference between scores to be paired
                  i -= 1;  //try again to make a match
                  
                  if (differenceChecked > numRounds + 0.5) {
                    j = allPlayers.size();
                    k = allPlayers.size();
                    m = numRounds;
                    i = numGamesPerRound;
                    this.reset();
                  }
                }
              }
            }
          }
        }        
      }
    }
    
    else if (this.format.equals("round robin")) {  //round robin format, every player plays everyone else
      for (int i = 0; i < numPlayers - 1; i++) {
        for (int j = i+1; j < numPlayers; j++) {
          float winner = participants.get(i).playAgainst(participants.get(j), this.timeControl, this.K);
          
          if (winner == 1) {  //player i wins
            if (this.narrate)
              println(participants.get(i).name, "-", participants.get(j).name, "resulted in a win for", participants.get(i).name);
            this.playerScores[i]++;
          }
          
          else if (winner == 0) {  //player j wins
            if (this.narrate)
              println(participants.get(i).name, "-", participants.get(j).name, "resulted in a win for", participants.get(j).name);;
            this.playerScores[j]++;
          }
          
          else {  //draw
            if (this.narrate)
              println(participants.get(i).name, "-", participants.get(j).name, "resulted in a draw");
            this.playerScores[i] += 0.5;
            this.playerScores[j] += 0.5;
          }
         
        }
        
      }
      
      if (this.narrate) {
        println();
        println("The final rankings for", this.name, "are as follows:");
        println("--------------------------------------------------------");
        //create new float[] to not mess with playerScores in declareRankings (it could be needed later)
        float[] sc = new float[numPlayers];
        for (int i = 0; i < numPlayers; i++) {
          sc[i] = this.playerScores[i];
        }
        
        this.declareRankings(sc);                
      }
    }
    
    else 
      println("Unsuitable tournament type");
      
    return this.playerScores;  //use in predictor loops
  }
  
  //DECLARE TOURNAMENT RANKINGS
  void declareRankings(float[] scores) { 
    int numPlayers = participants.size();
    
    for (int i = 0; i < numPlayers; i++) {  //assign ranking to every player     
      float highest = max(scores);  //highest of remaining scores to be ranked
      
      for (int j = 0; j < scores.length; j++) {
        if (scores[j] == highest) {  //current score being checked is highest
          if (this.narrate) 
            println(str(i+1) + ".", participants.get(j).name, "with a score of", scores[j]);
          
          scores[j] = -1;  //set to -1 so doesn't get picked again as the next ranking          
          j = scores.length;  //break out of loop and move on to next ranking
        }
      }
    }
    println();
  }
  
  //STATE FINAL ELO CHANGES
  void stateEloChanges() {
    println("These are the elo changes for the", this.name + ":");
    println("--------------------------------------------------------");
    int[] playerEndElos = new int[this.participants.size()];  //store players' end-of-tournament elos
    
    for (int i = 0; i < this.participants.size(); i++) {
      if (this.timeControl.equals("classical")) {
        playerEndElos[i] = this.participants.get(i).classicalElo;
      }
      
      else if (this.timeControl.equals("rapid")) {
        playerEndElos[i] = this.participants.get(i).rapidElo;
      }
      
      else {
        playerEndElos[i] = this.participants.get(i).blitzElo;
      }
      
      int eloChange = playerEndElos[i] - playerStartElos.get(i);  //final elo - initial elo
      
      println(participants.get(i).name, "gained", eloChange, "elo points at the", this.name + ".");     
    }
    
    println("********************************");
  }
  
  //RESET TOURNAMENT
  void reset() {  //used in predictor loop to clear last tournament's data and start again
    for (int i = 0; i < this.participants.size(); i++) {
      this.playerScores[i] = 0;  //set all player scores to 0
      
      //set all elos back to their initial value
      if (this.timeControl.equals("classical"))
        this.participants.get(i).classicalElo = playerStartElos.get(i);
      
      else if (this.timeControl.equals("rapid"))
        this.participants.get(i).rapidElo = playerStartElos.get(i);
      
      else
        this.participants.get(i).blitzElo = playerStartElos.get(i);
    }
  }  
}

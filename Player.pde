class Player {
  //FIELDS
  String name;
  int classicalElo; 
  int rapidElo;
  int blitzElo;
  ArrayList<Tournament> tournaments = new ArrayList<Tournament>(); //tournaments the player is participating in
  
  //CONSTRUCTOR 1 (for titled players)
  Player(String n, String t, int e1, int e2, int e3) {
    this.name = t + " " + n;  //consider name of a titled player to be their title plus their name
    this.classicalElo = e1;
    this.rapidElo = e2;
    this.blitzElo = e3; 
  }
  
  //CONSTRUCTOR 2 (for untitled players)
  Player(String n, int e1, int e2, int e3) {
    this.name = n;
    this.classicalElo = e1;
    this.rapidElo = e2;
    this.blitzElo = e3;
  }
  
  //DESCRIBE PLAYER
  void describe() { //used to introduce players 
    if (this.classicalElo > 0) //many players tend to be unrated in classical chess
      println(this.name + ",", this.classicalElo, "classical,", this.rapidElo, "rapid,", this.blitzElo, "blitz");
    else
      println(this.name + ", UNR. classical,", this.rapidElo, "rapid,", this.blitzElo, "blitz");
    
    println("--------------");
  }
  
  //PLAYER JOINS TOURNAMENT
  void joinTourney(Tournament T) {  //player joins a tournament
    boolean alreadyPlaying = false; //assume to begin with that the player isn't in the tournament or one on the same day yet
    
    for (int i = 0; i < this.tournaments.size(); i++) { //check if player already in tournament, and if any tournaments in the player's list are the same day
      if (this.tournaments.get(i).equals(T)) {
        alreadyPlaying = true;  //so if(!alreadyPlaying) block doesn't run
        println(this.name, "is already in", T.name + ", so he can't join again.");
        println("-------------------------------------------------");
        i = this.tournaments.size();  //looping variable set such that loop breaks once condition is met once
      }
      
      else if (this.tournaments.get(i).date.equals(T.date)) {
        alreadyPlaying = true;
        println(this.name, "is already playing in", this.tournaments.get(i).name, "on", T.date + ", so he cannot play in", T.name, "that day.");
        println("-------------------------------------------------");
        i = this.tournaments.size(); 
      }
    }
    
    if (!alreadyPlaying) {      //if alreadyPlaying hasn't already been set to true, ie not in the tournament (or one the same day) yet, so can join
      this.tournaments.add(T);  //add tournament to the player's list
      T.participants.add(this); //add player to the tournament's list of particpants
      
      int elo; //player's elo for tournament different depending what time control it is
      if (T.timeControl.equals("classical")) {
        elo = this.classicalElo;
      }
      
      else if (T.timeControl.equals("rapid")) {
        elo = this.rapidElo;
      }
      
      else {
        elo = this.blitzElo;
      }
      
      T.playerStartElos.add(elo);  //add player's elo to tournament's list of participants' elos
      
      println(this.name, "has been added to the", T.name + ".");
      println("-------------------------------------------------");
    }
  }
  
  //PLAYER QUITS TOURNAMENT
  void quitTournament(Tournament T) { 
    for (int i = 0; i < tournaments.size(); i++) {  //check to make sure that the player was signed up for tournament before trying to remove
      
      if (T.equals(tournaments.get(i))) {  //found tournament in the list that is trying to be removed
        this.tournaments.remove(T);
        T.participants.remove(this);
        
        int elo;
        if (T.timeControl.equals("classical")) {
          elo = this.classicalElo;
        }
        
        else if (T.timeControl.equals("rapid")) {
          elo = this.rapidElo;
        }
        
        else {
          elo = this.blitzElo;
        }
      
        T.playerStartElos.remove(Integer.valueOf(elo));  //also remove player's elo from tournament's list of elos
        println(this.name, "has been removed from the", T.name + ".");
        println("-------------------------------------------------");
        i = tournaments.size();
      }
    }
  }
  
  //TWO PLAYERS PLAY EACH OTHER
  float playAgainst(Player opponent, String time, int k) { //used in Tournament class runTourney() function to determine match outcomes
    int playerElo;
    int oppElo;
    
    if (time.equals("classical")) {
      playerElo = this.classicalElo;
      oppElo = opponent.classicalElo;
    }
    
    else if (time.equals("rapid")) {
      playerElo = this.rapidElo;
      oppElo = opponent.rapidElo;
    }
    
    else {
      playerElo = this.blitzElo;
      oppElo = opponent.blitzElo;
    }
    
    int deltaElo = playerElo - oppElo;  //elo diference    
    float expectedResult = 1/(1 + pow(10, (-deltaElo/400.0)));  //formula for expected outcome based on elo differences 
    float chooseResult = random(1);  //will determine match result
    float result;  //use to output match result
    float drawRange;  //probability of draw; to be calculated
    
    int[] elos = {playerElo, oppElo};
    int high = max(elos);
    
    if (abs(deltaElo) < 150)  //players rated within 150 of each other
      drawRange = -830.762/(846.561 + exp(high/389.017)) + 0.995639;
   
    else if (abs(deltaElo) < 400)  //players rated more than 150, less than 400 apart
      drawRange = (-830.762/(846.561 + exp(high/389.017)) + 0.995639)/3;
    
    else //players more than 400 elo apart, draw highly unlikely
      drawRange = 0;
        
    drawRange /= 2.0;  //to be both added and subtracted from expectedResult to create range that indicates a draw
    
    if (chooseResult <= expectedResult - drawRange)  //randomly chosen chooseResult below expectedResult = win for player 1
      result = 1;
    
    else if (chooseResult >= expectedResult + drawRange)  //chooseResult above expectedResult = loss for player 1
      result = 0;
    
    else  //chooseResult fell in drawing range, match a draw
      result = 0.5; 
    
    this.updateElo(result, opponent, expectedResult, time, k);  //update elos after match
    return result;  //pass result back to tournament runTourney() method after match
  }
  
  //UPDATE ELOS AFTER A MATCH
  void updateElo(float result, Player opponent, float expecResult, String time, int k) {
    
    //update appropriate elo depending on format of the tournament match was played in
    if (time.equals("classical")) {
      this.classicalElo += round(k*(result - expecResult));      //formula for updating elo after a match
      opponent.classicalElo += round(k*(expecResult - result));  //inverse of formula
    }
    
    else if (time.equals("rapid")) {
      this.rapidElo += k*(result - expecResult);
      opponent.rapidElo += k*(expecResult - result);
    }
    
    else {
      this.blitzElo += k*(result - expecResult);
      opponent.blitzElo += k*(expecResult - result);     
    }
  }
}

void setup() {
  //create players: (name, title, classical rating, rapid rating, blitz rating)
  Player magnus = new Player("Magnus Carlsen", "GM", 2900, 2900, 2900);
  Player rachel = new Player("Rachel Spanglet", 0, 1950, 1730);
  Player eric = new Player("Eric Pundsack", 0, 2000, 1700);
  Player offir = new Player("Offir Spanglet", 0, 1500, 700);
  Player stacey = new Player("Stacey Hubay", 0, 1400, 900);
  Player pratham = new Player("Pratham Chauhan", 0, 1500, 1100);
  Player natan = new Player("Natan Spanglet", 0, 800, 600);
  Player schattman = new Player("Mr. Schattman", 2400, 2400, 2400);
  Player tara = new Player("Tara Wong", 1000, 900, 800);
  Player jen = new Player("Jen Rozental", 1000, 900, 800);
  Player liliana = new Player("Liliana Patru", 1100, 850, 750);
  Player judit = new Player("Judit Polgar", "GM", 2800, 2800, 2800);
  Player paul = new Player("Paul Morphy", 2650, 2650, 2650);
  Player francois = new Player("Francois-Andre Philidor", 2400, 2400, 2400);
  Player levy = new Player("Levy Rozman", "IM", 2500, 2500, 2500);
  Player alex = new Player("Alexandra Botez", "WFM", 2200, 2200, 2200);
  Player william = new Player("William Davies Evans", 2100, 2000, 1500);
  Player gary = new Player("Gary Kasparov", "GM", 2750, 2700, 2650);
  Player ruy = new Player("Ruy Lopez", 2400, 2300, 1900);
  Player shayan = new Player("Shayan Nezhad-Ahmadi", 0, 1600, 1400);
  Player jacob = new Player("Jacob Bakker", 0, 1800, 1700);
  Player joshua = new Player("Joshua Dierickse", 0, 1800, 1700);
  Player anastasija = new Player("Anastasija Kovacevic", 0, 700, 500);
  Player marcel = new Player("Marcel Duchamp", 2300, 2200, 2000);
  Player jay = new Player("Jay Ren", 0, 1220, 1000);
  Player kate = new Player("Kate Gazzola", 0, 800, 600);
  
  //create tournaments: (name, date, style, time format in minutes, increment in seconds, elo change factor, narrate or not)
  Tournament laurelHeightsInv = new Tournament("Laurel Heights Invitational", "April 10, 2023", "swiss", 10, 0, 16, false);
  Tournament boringTournament = new Tournament("Officially Boring Tournament", "April 1, 2023", "round robin", 100, 50, true);

  println("**************************");
  //add players to tournaments
  natan.joinTourney(laurelHeightsInv);
  natan.joinTourney(laurelHeightsInv);  //won't allow adding player to same tournament twice
  magnus.joinTourney(laurelHeightsInv);
  eric.joinTourney(laurelHeightsInv);
  schattman.joinTourney(laurelHeightsInv);
  rachel.joinTourney(laurelHeightsInv);
  offir.joinTourney(laurelHeightsInv);
  pratham.joinTourney(laurelHeightsInv);
  
  magnus.quitTournament(laurelHeightsInv);  //quitTournament removes player from tournament
  
  magnus.joinTourney(boringTournament);
  pratham.joinTourney(boringTournament);
  natan.joinTourney(boringTournament);
  eric.joinTourney(boringTournament);
  schattman.joinTourney(boringTournament);
  rachel.joinTourney(boringTournament);
  offir.joinTourney(boringTournament);
  tara.joinTourney(boringTournament);
  liliana.joinTourney(boringTournament);
  jen.joinTourney(boringTournament);
  judit.joinTourney(boringTournament);
  paul.joinTourney(boringTournament);
  francois.joinTourney(boringTournament);
  gary.joinTourney(boringTournament);
  william.joinTourney(boringTournament);
  alex.joinTourney(boringTournament);
  shayan.joinTourney(boringTournament);
  ruy.joinTourney(boringTournament);
  levy.joinTourney(boringTournament);
  jacob.joinTourney(boringTournament);
  joshua.joinTourney(boringTournament);
  anastasija.joinTourney(boringTournament);
  kate.joinTourney(boringTournament);
  stacey.joinTourney(boringTournament);
  jay.joinTourney(boringTournament);
  marcel.joinTourney(boringTournament);
  
  //RUNNING TWO TOURNAMENTS: boring tournament just once, laurel heights invitational in a loop to predict outcomes
  //introduce boring tournament, run it once, then state elo changes 
  boringTournament.introduce();
  boringTournament.runTourney();
  boringTournament.stateEloChanges();
  
  loop loopLaurelPoints = new loop(laurelHeightsInv, 1000, "points");  //loop laurel heights invitational
  loopLaurelPoints.runLoop();
  
  loop loopLaurelWins = new loop(laurelHeightsInv, 1000, "wins");
  loopLaurelWins.runLoop();
  
}

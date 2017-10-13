import java.util.Collections;

boolean inMenu;

String nickname;

int difficulty = 1;

Game game;
PrintWriter output;

color[][] difficultyColor = new color[][]{
  {color(40, 40, 80),color(60, 60, 140)},
  {color(80,40,40), color(140,60,60)},
  {color(40,80,40), color(60,140,60)},
  {color(0,0,0), color(0,0,0)}
};

void setup() {
  size(1280, 720, P2D); // make sure using P2D renderer as it is fastest
  frameRate(120); // use a higher framerate as very fast paced
  nickname = "";
  inMenu = true; // start in menu
  // create game with difficulty and set colours
  game = new Game(difficulty, difficultyColor[difficulty-1]); 
  game.playing = false;
}
void draw() {
  // background(0);
  if (game.playing) {
    inMenu = false; // playing so not in menu
    background(0); // clear screen
    game.draw(); // draw game
  }
  else{
    if(inMenu){ // draw menu and text
      background(difficultyColor[difficulty-1][0]);

      textAlign(CENTER, CENTER);
      textSize(50);
      text("Decent Hexajon",width/2,height/2);
      textSize(24);
      text("Not quite Super Hexagon",width/2,(height/2)+40);
      textSize(15);
      
      String diffString = "";

      if(difficulty == 1){ // difficulty string selection
        diffString = "< Easy >";
      }else if(difficulty == 2){
        diffString = "< Kinda hard >";
      }else if(difficulty == 3){
        diffString = "< Hard >";
      }
      else if(difficulty == 4){
        diffString = "< Silly >";
      }
      text(diffString,width/2,(height/2)+65);
    }else{
      // game is lost, load & show leaderboard and nickname input
      background(50);

      LeaderboardEntry le = new LeaderboardEntry(game.timeInSeconds, nickname, difficulty);
      
      textAlign(CENTER,CENTER);
      text("GAME OVER",width/2,100);
      text("Space to restart | Type name to save score", width/2, 150);
      text(le.formatted(),width/2,200);

      String[] leaderboardLines = loadStrings("leaderboard.csv");
      ArrayList<LeaderboardEntry> entries = new ArrayList<LeaderboardEntry>();
      
      // add saved entries to array of entries
      for(String line: leaderboardLines){
        entries.add(new LeaderboardEntry(line));
      }
      
      int displayedCount=0; // number of displayed entries of played difficulty

      for (int i = 0; i < entries.size(); i++) {
        // display all leaderboard entries of the same difficulty as played
        if(entries.get(i).difficulty == difficulty){
          text(entries.get(i).formatted(),width/2,200+((2+displayedCount)*40));
          displayedCount++;
        }
      }
      
    }
  }
}
void keyPressed(){
  if(!game.playing && !inMenu){

    String[] leaderboardLines = loadStrings("leaderboard.csv");
    ArrayList<LeaderboardEntry> entries = new ArrayList<LeaderboardEntry>();

    for(String line: leaderboardLines){
      // add leaderboard entries to leaderboard arraylist
      entries.add(new LeaderboardEntry(line));
    }
    
    if(keyCode == BACKSPACE && nickname.length() > 0){
      // remove last char from nickname
      nickname = nickname.substring(0,nickname.length()-1);
    }else if(key == ESC){
      // back out to menu
      key=0; // disable built in ESC exit from game
      inMenu = true;
    }
    else if(key == ENTER || key == RETURN || key == ' '){
      // if new game started
      if(nickname == ""){
        // add new leaderboard entry without nickname
        entries.add(new LeaderboardEntry(game.timeInSeconds, "Unnamed", difficulty)); 
        
      }else{
        // add new leaderboard entry with nickname
        entries.add(new LeaderboardEntry(game.timeInSeconds, nickname, difficulty)); 
        Collections.sort(entries); // sort leaderboard with new entry
        PrintWriter output = createWriter("leaderboard.csv");
        for(LeaderboardEntry l : entries){
          output.println(l.asCSVEntry()); // add new entry to leaderboard file
        }
        output.close();
        nickname = "";
      }
      game = new Game(difficulty, difficultyColor[difficulty-1]);
      
    }else{
      if(!(key == CODED)){
        // add ascii keys to nickname string
        nickname += key;
      }
    }
    
  }else if(!game.playing && inMenu){
    // difficulty selection controls
    if(key == CODED){
      if(keyCode == LEFT){
        // wrap if less than 1 or subtract
        if(difficulty > 1){
          difficulty--;
        }else{
          difficulty = 4;
        }
      }else if(keyCode == RIGHT){
        // wrap if more than 3 or increase
        if(difficulty < 4){
          difficulty++;
        }else{
          difficulty = 1;
        }
      }
    }else{
      // start game with selected difficulty
      if(key == ' ' || key == RETURN || key == ENTER){
        game = new Game(difficulty, difficultyColor[difficulty-1]);
      }
    }
  }
}
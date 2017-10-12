import java.util.Collections;
Game game;
PrintWriter output;
String nickname;

int difficulty = 1;
color[][] difficultyColor = new color[][]{
  {color(40, 40, 80),color(60, 60, 140)},
  {color(80,40,40), color(140,60,60)},
  {color(40,80,40), color(60,140,60)},
  {color(#D364FF), color(#3DC1FF)}
};
boolean inMenu;

void setup() {
  size(1280, 720, P2D);
  frameRate(120);
  nickname = "";
  inMenu = true;
  game = new Game(difficulty, difficultyColor[difficulty-1]);
  game.playing = false;
}
void draw() {
  // background(0);
  if (game.playing) {
    inMenu = false;
    background(0);
    game.draw();
  }
  else{
    if(inMenu){
      background(difficultyColor[difficulty-1][0]);
      textAlign(CENTER, CENTER);
      textSize(50);
      text("Decent Hexajon",width/2,height/2);
      textSize(24);
      text("Not quite Super Hexagon",width/2,(height/2)+40);
      textSize(15);
      String diffString = "";
      if(difficulty == 1){
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
      background(50);
      LeaderboardEntry le = new LeaderboardEntry(game.timeInSeconds, nickname, difficulty);
      textAlign(CENTER,CENTER);
      text("GAME OVER",width/2,100);
      text("Space to restart | Type name to save score", width/2, 150);
      text(le.formatted(),width/2,200);

      String[] leaderboardLines = loadStrings("leaderboard.csv");
      ArrayList<LeaderboardEntry> entries = new ArrayList<LeaderboardEntry>();
      for(String line: leaderboardLines){
        entries.add(new LeaderboardEntry(line));
      }
      int displayedCount=0;
      for (int i = 0; i < entries.size(); i++) {
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
      entries.add(new LeaderboardEntry(line));
    }
    
    if(keyCode == BACKSPACE && nickname.length() > 0){
      nickname = nickname.substring(0,nickname.length()-1);
    }else if(key == ESC){
      key=0;
      inMenu = true;
    }
    else if(key == ENTER || key == RETURN || key == ' '){
      if(nickname == ""){
        entries.add(new LeaderboardEntry(game.timeInSeconds, "Unnamed", difficulty));
        
      }else{
        entries.add(new LeaderboardEntry(game.timeInSeconds, nickname, difficulty));
        Collections.sort(entries);
        PrintWriter output = createWriter("leaderboard.csv");
        for(LeaderboardEntry l : entries){
          output.println(l.asCSVEntry());
        }
        output.close();
        nickname = "";
      }
      game = new Game(difficulty, difficultyColor[difficulty-1]);
      // leaderboard
    }else{
      if(!(key == CODED)){
        nickname += key;
      }
    }
    
  }else if(!game.playing && inMenu){
    if(key == CODED){
      if(keyCode == LEFT){
        if(difficulty > 1){
          difficulty--;
        }else{
          difficulty = 4;
        }
      }else if(keyCode == RIGHT){
        if(difficulty < 4){
          difficulty++;
        }else{
          difficulty = 1;
        }
      }
    }else{
      if(key == ' ' || key == RETURN || key == ENTER){
        game = new Game(difficulty, difficultyColor[difficulty-1]);
      }
    }
  }
}
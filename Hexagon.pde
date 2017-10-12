Game game;
void setup() {
  size(1280, 720, P2D);
  frameRate(120);
  game = new Game();
}
void draw() {
  //background(0);
  if (game.playing) {
    background(0);
    game.draw();
  }
  else{
    // display leaderboard
  }
}
void keyPressed(){
  if(!game.playing){
    if(key == ' '){
      game = new Game();
      
    }
  }
  if(key=='m'){
    //println(maxMemory);
    //println(allocatedMemory);
    //println(freeMemory);
  }
}
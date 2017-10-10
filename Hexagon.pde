Game game;
void setup() {
  size(1280, 720, P2D);
  frameRate(120);
  game = new Game();
}
void draw() {
  //background(0);
  if (game.playing) {
    game.draw();
  }
}
import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Collections; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Hexagon extends PApplet {


Game game;
PrintWriter output;
String nickname;

int difficulty = 1;
int[][] difficultyColor = new int[][]{
  {color(40, 40, 80),color(60, 60, 140)},
  {color(80,40,40), color(140,60,60)},
  {color(40,80,40), color(60,140,60)},
  {color(0xffD364FF), color(0xff3DC1FF)}
};
boolean inMenu;

public void setup() {
  
  frameRate(120);
  nickname = "";
  inMenu = true;
  game = new Game(difficulty, difficultyColor[difficulty-1]);
  game.playing = false;
}
public void draw() {
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
public void keyPressed(){
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
class Game {
  boolean playing;
  boolean colorFlip;
  int laneCount;
  int direction = 1;

  float difficulty;
  float startTime;
  float timePlaying;
  float timeInSeconds;
  float timerTextWidth;
  float gameRotationSpeed;
  float playerRotationSpeed;
  float laneAngle;
  float rotation;
  
  int c1, c2;

  String timeString;
  
  PVector center;
  PShape hexagon;
  
  Player player;
  ArrayList<Obstacle> obstacles;

  Game(int diff, int[] colors) {
    keyPressed = false;
    colorFlip = false;
    difficulty = diff/2f;
    
    c1 = colors[0];
    c2 = colors[1];

    laneCount = 6;
    laneAngle = TAU/laneCount;
    player = new Player(laneAngle, laneCount);
    obstacles = new ArrayList<Obstacle>();
    
    center = new PVector(width/2, height/2);
    playing = true;
    startTime = millis();
    hexagon = createHexagon();
    gameRotationSpeed = 0.02f*difficulty;
    playerRotationSpeed = gameRotationSpeed*1.75f;
    textSize(30); 
    textAlign(LEFT, TOP);
    textFont(createFont("Arial Black", 30));
    timerTextWidth = textWidth(nf(100.999f, 2, 2));
  }

  public PShape createHexagon() {
    PShape hexagon = createShape();
    hexagon.beginShape();
    hexagon.noFill();
    hexagon.strokeWeight(4);
    for ( int i = 0; i < laneCount; i++ ) {
      float x = cos( rotation + (i * laneAngle) ) * 20;
      float y = sin( rotation + (i * laneAngle) ) * 20;
      hexagon.vertex( x, y );
    }
    hexagon.endShape( CLOSE );

    
    hexagon.setStroke( color(255));
    return hexagon;
  }

  public void draw() {
    // Handle user input
    if (keyPressed) {
      if (keyCode == LEFT || key == 'a') {
        player.move(playerRotationSpeed);
      } else if (keyCode == RIGHT || key == 'd') {
        player.move(-playerRotationSpeed);
      }
    }

    float newRotation = rotation+gameRotationSpeed*direction;
    rotation = newRotation;
  
    player.rotate(-gameRotationSpeed*direction);
    
    if (obstacles.size()<7.5f*difficulty) {
      obstacles.add(new Obstacle(round(random(laneCount)), rotation, laneAngle, difficulty));
    }

    noStroke();
    for (int i=0; i<laneCount; i++) {
      if(colorFlip){
        if (i%2==0) {
          fill(c1);
        } else {
          fill(c2);
        }
      } else {
        if (i%2==0) {
          fill(c2);
        } else {
          fill(c1);
        }
      }
      triangle(width/2, height/2, center.x+cos(rotation + (i * laneAngle)) * 900, center.y+sin(rotation+((i) * laneAngle)) * 900, center.x+cos(rotation + ((i+1) * laneAngle)) * 900, center.y+sin(rotation+((i+1) * laneAngle)) * 900);
    }
    
    stroke(255);
    shape(createHexagon(), width/2, height/2);
    
    player.draw();
    
    
    for (int i=obstacles.size()-1; i>=0; i--) {
      Obstacle ob = obstacles.get(i);
      if (ob.distance >= player.radius-ob.size && ob.distance <= player.radius+player.size && player.lane%laneCount == ob.lane-1) {
        playing = false;
      } else {
        if (ob.distance > 4) {

          ob.update(gameRotationSpeed*direction);
          ob.draw();
        } else {
          obstacles.remove(i);
        }
      }
    }

    drawTimer();

    if(frameCount%100==0 && random(2)<1){
      colorFlip = !colorFlip;
    }

    if (frameCount%400==0){
      if(random(2)<1) {
        direction = -direction;
      }
      gameRotationSpeed+=0.001f;
    }
  }
  public void drawTimer() {
    timePlaying = millis()-startTime;
    timeInSeconds = timePlaying/1000;
    timeString = nf(timeInSeconds, 2, 2);


    text(timeString, width-(timerTextWidth+5), 5);
  }
}
class LeaderboardEntry implements Comparable<LeaderboardEntry> {
	Float timeSeconds;
	String name;
	int difficulty;
	LeaderboardEntry(String line){
		String[] tokens = line.split(",");
		float t = PApplet.parseFloat(tokens[0]);
		timeSeconds = new Float(t);

		name = tokens[1];
		difficulty = PApplet.parseInt(tokens[2]);
	}
	LeaderboardEntry(float time, String n, int diff){
		name = n;
		timeSeconds = new Float(time);
		difficulty = diff;
	}
	public String formatted(){
		return nf(timeSeconds,2,2) + " - " + name;
	}
	public String asCSVEntry(){
		return timeSeconds+","+name+","+difficulty;
	}
	public int compareTo(LeaderboardEntry other){
		return other.timeSeconds.compareTo(timeSeconds);
	}
}
class Obstacle {
  int lane;

  float distance;
  float rotation;
  float laneAngle;
  float cosVal1, cosVal2;
  float sinVal1, sinVal2;
  float speed;
  float x1, x2, x3, x4;
  float y1, y2, y3, y4;
  float start,end;
  float size = 20;

  PVector center;

  Obstacle(int laneNo, float currentRotation,float laneAng, float difficulty) {
    speed = 3*difficulty;
    lane = laneNo;
    laneAngle = laneAng;
    rotation = currentRotation;

    center = new PVector(width/2, height/2); // set center to middle of screen.
    
    distance = random(800,1500); // set random distance from center
  }

  public void wallQuad() {

    fill(180, 180, 200);
    start = rotation + (lane * laneAngle);
    end = rotation + ((lane+1) * laneAngle);
    cosVal1 = cos(start);
    cosVal2 = cos(end);
    sinVal1 = sin(start);
    sinVal2 = sin(end);

    x1 = center.x + (cosVal1 * (distance+size));
    y1 = center.y + (sinVal1 * (distance+size));

    x2 = center.x + (cosVal2 * (distance+size));
    y2 = center.y + (sinVal2 * (distance+size));

    x3 = center.x + (cosVal2 * distance);
    y3 = center.y + (sinVal2 * distance);

    x4 = center.x + (cosVal1 * distance);
    y4 = center.y + (sinVal1 * distance);

    quad(x1, y1, x2, y2, x3, y3, x4, y4);
  }
  public void update(float r) {
    rotation += r;
    
    distance -= speed;
  }
  public void draw() {
    noStroke();
    wallQuad();
  }
}
class Pattern {
  int length;
  private int obstacleCount;
  String[] lanes;
  float rotation;
  float laneAngle;

  Pattern() {
    lanes = new String[6];
    float r = random(10);
    if (r<7) {
      lanes[0] = "|-----";
      lanes[1] = "-|----";
      lanes[2] = "--|---";
      lanes[3] = "---|--";
      lanes[4] = "----|-";
      lanes[5] = "-----|";
    } else if (r<2) {
      lanes[0] = "|-";
      lanes[1] = "|-";
      lanes[2] = "--";
      lanes[3] = "|-";
      lanes[4] = "|-";
      lanes[5] = "|-";
    }

    obstacleCount = countObstacles();
  }
  public void setLength() {
    length = lanes[0].length();
  }

  public int countObstacles() {
    int count = 0;
    for (String lane : lanes) {
      
        for (int i=0; i<lane.length(); i++) {
          if (lane.charAt(i)=='|') {
            count++;
          }
        }
    }
    return count;
  }

  public ArrayList<Obstacle> generateObstacles(float rotation) {
    ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
    for (int laneIndex=0; laneIndex<lanes.length; laneIndex++) {
      String lane = lanes[laneIndex];
      for (int characterIndex=0; characterIndex<lane.length(); characterIndex++) {
        char c = lane.charAt(characterIndex);
        if (c == '|') {
          obstacles.add(new Obstacle(laneIndex, rotation, 1000+(characterIndex*50), laneAngle));
        }
      }
    }
    return obstacles;
    // return obstacles array
  }
}
class Player {
  float rotation;
  float radius;
  float size;
  int lane;
  PVector position;
  PVector centerPoint;
  float gameRotation;
  int laneCount;
  float laneAngle=1;

  Player(float laneAng, int laneC){
    laneCount = laneC;
    laneAngle = laneAng;
    size = 5;
    rotation = 0;
    radius = 35;
    position = new PVector();
    centerPoint = new PVector(width/2,height/2);
    updatePosition();
    lane = 0;
  }
  
  public void updatePosition(){
    position.x = centerPoint.x + sin(rotation)*radius;
    position.y = centerPoint.y + cos(rotation)*radius;
    lane = -(round((rotation-gameRotation)/(laneAngle))%laneCount);
    if(lane<0){ 
      lane = laneCount+lane;
    }
  }

  public void move(float direction){
    if(rotation+direction > TAU){
      rotation = rotation+direction-TAU;
    }else{
      rotation+=direction;
    }
    updatePosition();
  }

  public void rotate(float direction){
    gameRotation +=direction;
    if(rotation+direction > TAU){
      rotation = rotation+direction-TAU;
    }else{
      rotation+=direction;
    }
    updatePosition();
  }
  public void draw(){
    ellipse(position.x,position.y,size,size);
  }
  
}
  public void settings() {  size(1280, 720, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Hexagon" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

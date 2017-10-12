import java.util.Iterator; //<>// //<>//
class Game {
  Player player;
  int laneCount;
  float rotation;
  ArrayList<Obstacle> obstacles;
  PVector center;
  boolean playing;
  float startTime;
  float timePlaying;
  int direction = 1;
  PShape hexagon;
  String timeString;
  float timeInSeconds;
  float timerTextWidth;
  float gameRotationSpeed;
  float playerRotationSpeed;
  Game() {
    player = new Player(1,1);
    laneCount = 6;
    obstacles = new ArrayList<Obstacle>();
    //obstacles.add(new Obstacle(2, 0));
    center = new PVector(width/2, height/2);
    playing = true;
    startTime = millis();
    hexagon = createHexagon();
    gameRotationSpeed = 0.03;
    playerRotationSpeed = gameRotationSpeed*1.75;
    textSize(30); 
    textAlign(LEFT, TOP);
    textFont(createFont("Arial Black", 30));
    timerTextWidth = textWidth(nf(100.999, 2, 2));
  }

  PShape createHexagon() {
    PShape hexagon = createShape();
    hexagon.beginShape();
    hexagon.noFill();
    hexagon.strokeWeight(4);
    for ( int i = 0; i < 6; i++ ) {
      float x = cos( rotation + (i * THIRD_PI) ) * 20;
      float y = sin( rotation + (i * THIRD_PI) ) * 20;
      hexagon.vertex( x, y );
    }
    hexagon.endShape( CLOSE );

    //hexagon.setFill( color( 255, 64 ) )
    hexagon.setStroke( color(255));
    return hexagon;
  }

  void draw() {
    // Handle user input
    if (keyPressed) {
      if (keyCode == LEFT || key == 'a') {
        player.move(playerRotationSpeed);
      } else if (keyCode == RIGHT || key == 'd') {
        player.move(-playerRotationSpeed);
      }
    }

    noStroke();
    for (int i=1; i<7; i++) {
      if (i%2==0) {
        fill(40, 40, 80);
      } else {
        fill(60, 60, 140);
      }
      triangle(center.x+cos(rotation + (i * THIRD_PI)) * 900, center.y+sin(rotation+((i) * THIRD_PI)) * 900, center.x+cos(rotation + ((i+1) * THIRD_PI)) * 900, center.y+sin(rotation+((i+1) * THIRD_PI)) * 900, width/2, height/2);
    }
    stroke(255);
    shape(createHexagon(), width/2, height/2);
    player.draw();
    
    float newRotation = rotation+gameRotationSpeed*direction;
    
    if (newRotation > TAU) {
      rotation = rotation+gameRotationSpeed-TAU;
    } else if (newRotation<0) {
      rotation = TAU-(rotation-gameRotationSpeed);
    } else {
      rotation = newRotation;
    }
    player.rotate(-gameRotationSpeed*direction);
    if (obstacles.size()<10) {
      //Pattern p = new Pattern();
      //obstacles.addAll(p.generateObstacles(rotation));
      obstacles.add(new Obstacle(round(random(6)), rotation));
      //obstacles.add(new Obstacle(2, rotation));
    }
    
    for (int i=obstacles.size()-1; i>=0; i--) {
      Obstacle ob = obstacles.get(i);
      if (ob.distance >= player.radius-ob.size && ob.distance <= player.radius+player.size && player.lane%laneCount == ob.lane-1) {
        playing = false;
      } else {
        if (ob.distance > 4) {
          ob.draw();
          ob.update(gameRotationSpeed*direction);
        } else {
          obstacles.remove(i);
        }
      }
    }


    drawTimer();

    if (frameCount%400==0 && random(2)<1) {
      direction = -direction;
    }
  }
  void drawTimer() {
    timePlaying = millis()-startTime;
    timeInSeconds = timePlaying/1000;
    timeString = nf(timeInSeconds, 2, 2);


    text(timeString, width-(timerTextWidth+5), 5);
  }
}
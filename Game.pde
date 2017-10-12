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
  
  color c1, c2;

  String timeString;
  
  PVector center;
  PShape hexagon;
  
  Player player;
  ArrayList<Obstacle> obstacles;

  Game(int diff, color[] colors) {
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
    gameRotationSpeed = 0.02*difficulty;
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
    for ( int i = 0; i < laneCount; i++ ) {
      float x = cos( rotation + (i * laneAngle) ) * 20;
      float y = sin( rotation + (i * laneAngle) ) * 20;
      hexagon.vertex( x, y );
    }
    hexagon.endShape( CLOSE );

    
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

    float newRotation = rotation+gameRotationSpeed*direction;
    rotation = newRotation;
  
    player.rotate(-gameRotationSpeed*direction);
    
    if (obstacles.size()<7.5*difficulty) {
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
      gameRotationSpeed+=0.001;
    }
  }
  void drawTimer() {
    timePlaying = millis()-startTime;
    timeInSeconds = timePlaying/1000;
    timeString = nf(timeInSeconds, 2, 2);


    text(timeString, width-(timerTextWidth+5), 5);
  }
}
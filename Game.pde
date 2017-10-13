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
    keyPressed = false; // prevent erroneous input carried over from previous game
    colorFlip = false; // are lane colours flipped?

    difficulty = diff/2f; // difficulty multiplier
    // difficulty = diff;
    
    c1 = colors[0]; // lane colour 1
    c2 = colors[1]; // lane colour 2

    laneCount = 6; // use 6 lanes, can change but is sometimes glitchy

    laneAngle = TAU/laneCount; // angle between start and finish of lane

    player = new Player(laneAngle, laneCount); // instantiate player object

    obstacles = new ArrayList<Obstacle>();
    
    center = new PVector(width/2, height/2);

    playing = true; // game has begun & not lost

    startTime = millis(); // set start time of timer;

    hexagon = createHexagon(); // create center hexagon shape

    gameRotationSpeed = 0.02*difficulty; // set rotation speeds
    playerRotationSpeed = gameRotationSpeed*1.75;
    
    // setup for timer text
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
      // add each corner for number of lanes
      float x = cos( rotation + (i * laneAngle) ) * 20;
      float y = sin( rotation + (i * laneAngle) ) * 20;
      hexagon.vertex( x, y );
    }
    hexagon.endShape( CLOSE );

    
    hexagon.setStroke( color(255));
    return hexagon;
  }

  void draw() {
    // Handle in-game user input
    if (keyPressed) {
      if (keyCode == LEFT || key == 'a') {
        player.move(playerRotationSpeed);
      } else if (keyCode == RIGHT || key == 'd') {
        player.move(-playerRotationSpeed);
      }
    }

    // update game rotation
    float newRotation = rotation+gameRotationSpeed*direction;
    rotation = newRotation;
    
    // update player rotation
    player.rotate(-gameRotationSpeed*direction);
    
    // add new obstacles? count based on difficulty
    if (obstacles.size()<7.5*difficulty) {
      obstacles.add(new Obstacle(round(random(laneCount)), rotation, laneAngle, difficulty));
    }

    noStroke();
    // draw each lane using triangle from center to point off screen. 
    for (int i=0; i<laneCount; i++) {
      // select correct fill for alternating lanes
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
    
    // draw center hexagon(or whatever other polygon is made using amount of sides)
    stroke(255);
    shape(createHexagon(), width/2, height/2);
    
    // draw player
    player.draw();
    
    
    for (int i=obstacles.size()-1; i>=0; i--) {
      Obstacle ob = obstacles.get(i);
      // check collisions for each obstacle with player (if in same lane at similar distance, collision must have occurred. End game if true
      if (ob.distance >= player.radius-ob.size && ob.distance <= player.radius+player.size && player.lane%laneCount == ob.lane-1) { 
        playing = false;
      
      } else {

        if (ob.distance > 4) {
          // if still in play, update rotation & position and draw

          ob.update(gameRotationSpeed*direction);
          ob.draw();
        } else {
          // remove from play if already past player
          obstacles.remove(i);
        }
      }
    }

    drawTimer(); // obvious

    if(frameCount%100==0 && random(2)<1){
      // randomly flip colours after minimum 100 frames(just under 1 second)
      colorFlip = !colorFlip;
    }

    if (frameCount%400==0){
      if(random(2)<1) {
        // randomly decide whether to flip rotation
        direction = -direction;
      }
      // increase rotation speed through time
      gameRotationSpeed+=0.001;
    }
  }
  
  void drawTimer() {
    timePlaying = millis()-startTime; // calculate new time played
    timeInSeconds = timePlaying/1000; // convert from millis to seconds
    timeString = nf(timeInSeconds, 2, 2); // format as string with 2 digits before decimal point, 2 after


    text(timeString, width-(timerTextWidth+5), 5); // draw timer text
  }
}
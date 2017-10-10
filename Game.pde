import java.util.Iterator;
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
  Game() {
    player = new Player();
    laneCount = 6;
    obstacles = new ArrayList<Obstacle>();
    //obstacles.add(new Obstacle(2, 0));
    center = new PVector(width/2, height/2);
    playing = true;
    startTime = millis();
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
        player.move(0.05);
      } else if (keyCode == RIGHT || key == 'd') {
        player.move(-0.05);
      }
    }

    noStroke();
    for (int i=1; i<7; i++) {
      //shape(createLane(i), width/2, height/2);
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
    float newRotation = rotation+0.01*direction;
    if (newRotation > TAU) {
      rotation = rotation+0.01-TAU;
    } else if(newRotation<0) {
      rotation = TAU-(rotation-0.01);
    }else{
      rotation = newRotation;
    }
    player.rotate(-0.01*direction);
    if (obstacles.size()<10) {
      obstacles.add(new Obstacle(round(random(6)), rotation));
      //obstacles.add(new Obstacle(2, rotation));
    }

    for (Iterator<Obstacle> iterator = obstacles.iterator(); iterator.hasNext(); ) {
      Obstacle ob = iterator.next();
      if (ob.distance >= player.radius-ob.size && ob.distance <= player.radius+player.size && player.lane%6 == ob.lane-1) {
        playing = false;
      } else {
        if (ob.distance > 4) {
          ob.draw();
          ob.update(0.01*direction);
        } else {
          iterator.remove();
        }
      }
    }
    
    
    drawTimer();
   
    if(frameCount%400==0 && random(2)<1){
      direction = -direction;
    }
  }
  void drawTimer() {
    timePlaying = millis()-startTime;
    float timeInSeconds = timePlaying/1000;
    String timeString = nf(timeInSeconds,2,2);

    textSize(30); 
    textAlign(LEFT,TOP);
    textFont(createFont("Arial Black",30));
    text(timeString, width-(textWidth(timeString)+5), 5);
  }
}
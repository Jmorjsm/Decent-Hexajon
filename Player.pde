class Player {
  float rotation;
  float radius;
  float size;
  float gameRotation;
  float laneAngle=1; // immediately initialising to avoid NullPointerException
  
  int laneCount;
  int lane;
  
  PVector centerPoint;
  PVector position;

  Player(float laneAng, int laneC){
    laneCount = laneC; // taking lane count from game to calculate which lane currently in
    laneAngle = laneAng;
    size = 5; // diameter of player circle
    rotation = 0;
    radius = 35; // distance to display from center
    position = new PVector();
    centerPoint = new PVector(width/2,height/2); // center of screen
    updatePosition();
    lane = 0;
  }
  
  void updatePosition(){
    // setting new x and y co-ordinates using trig and current rotation
    position.x = centerPoint.x + sin(rotation)*radius;
    position.y = centerPoint.y + cos(rotation)*radius;

    // calculating lane based on current rotation
    lane = -(round((rotation-gameRotation)/(laneAngle))%laneCount); 

    if(lane<0){ // wrapping if less than 0 to be in range 0<lane<=laneCount
      lane = laneCount+lane;
    }
  }

  void move(float direction){

    if(rotation+direction > TAU){ // wrap to be between 0 and 2pi(0-360º)
      rotation = rotation+direction-TAU;
    }else{
      rotation+=direction;
    }
    updatePosition(); // update position to new x and y
  }

  void rotate(float direction){

    gameRotation +=direction; // update local record of game rotation

    if(rotation+direction > TAU){ // wrap to be between 0 and 2pi(0-360º)
      rotation = rotation+direction-TAU;
    }else{
      rotation+=direction;
    }
    updatePosition(); // update position to new x and y
  }
  void draw(){
    // fill white and draw player ellipse
    fill(255); 
    ellipse(position.x,position.y,size,size);
  }
  
}
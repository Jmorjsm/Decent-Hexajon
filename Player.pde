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
  void updatePosition(){
    position.x = centerPoint.x + sin(rotation)*radius;
    position.y = centerPoint.y + cos(rotation)*radius;
    lane = -(round((rotation-gameRotation)/(THIRD_PI))%6);
    if(lane<0){ lane = 6+lane;}
    //println(lane);
  }
  void move(float direction){
    if(rotation+direction > TAU){
      rotation = rotation+direction-TAU;
    }else{
      rotation+=direction;
    }
    updatePosition();
  }
  void rotate(float direction){
    gameRotation +=direction;
    if(rotation+direction > TAU){
      rotation = rotation+direction-TAU;
    }else{
      rotation+=direction;
    }
    updatePosition();
  }
  void draw(){
    ellipse(position.x,position.y,size,size);
  }
  
}
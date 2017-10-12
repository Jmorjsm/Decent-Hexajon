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

  void wallQuad() {

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
  void update(float r) {
    rotation += r;
    
    distance -= speed;
  }
  void draw() {
    noStroke();
    wallQuad();
  }
}
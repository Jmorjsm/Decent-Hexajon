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
    speed = 3*difficulty; // speed to fall towards center
    lane = laneNo; // lane to spawnin
    laneAngle = laneAng; // inner angle of a single lane
    rotation = currentRotation; // current rotation offset from game rotation

    center = new PVector(width/2, height/2); // set center to middle of screen.
    
    distance = random(800,1500); // set random distance from center
  }

  void wallQuad() { // method to calculate corners of and draw obstacle quad

    fill(180, 180, 200);

    // furthest anticlockwise angle in radians
    start = rotation + (lane * laneAngle); 
    // furthest clockwise angle in radians
    end = rotation + ((lane+1) * laneAngle);

    // calculating trig values to sub in to find lengths and co-ordinates later.
    cosVal1 = cos(start);
    cosVal2 = cos(end);
    sinVal1 = sin(start);
    sinVal2 = sin(end);

    x1 = center.x + (cosVal1 * (distance+size)); // top-left co-ordinate
    y1 = center.y + (sinVal1 * (distance+size));

    x2 = center.x + (cosVal2 * (distance+size)); // top-right co-ordinate
    y2 = center.y + (sinVal2 * (distance+size));

    x3 = center.x + (cosVal2 * distance); // bottom-right co-ordinate
    y3 = center.y + (sinVal2 * distance);

    x4 = center.x + (cosVal1 * distance); // bottom-left co-ordinate
    y4 = center.y + (sinVal1 * distance);

    quad(x1, y1, x2, y2, x3, y3, x4, y4); // draw quad with above co-ordinates
  }
  void update(float r) {
    // rotate and decrease distance from center
    rotation += r;
    
    distance -= speed;
  }

  void draw() {
    noStroke();
    wallQuad();
  }
}
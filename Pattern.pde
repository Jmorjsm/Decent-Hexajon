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
  void setLength() {
    length = lanes[0].length();
  }

  int countObstacles() {
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

  ArrayList<Obstacle> generateObstacles(float rotation) {
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
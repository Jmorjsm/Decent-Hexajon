class LeaderboardEntry implements Comparable<LeaderboardEntry> {
	Float timeSeconds;
	String name;
	int difficulty;
	LeaderboardEntry(String line){
		String[] tokens = line.split(",");
		float t = float(tokens[0]);
		timeSeconds = new Float(t);

		name = tokens[1];
		difficulty = int(tokens[2]);
	}
	LeaderboardEntry(float time, String n, int diff){
		name = n;
		timeSeconds = new Float(time);
		difficulty = diff;
	}
	String formatted(){
		return nf(timeSeconds,2,2) + " - " + name;
	}
	String asCSVEntry(){
		return timeSeconds+","+name+","+difficulty;
	}
	public int compareTo(LeaderboardEntry other){
		return other.timeSeconds.compareTo(timeSeconds);
	}
}
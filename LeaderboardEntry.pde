class LeaderboardEntry implements Comparable<LeaderboardEntry> {
	Float timeSeconds;
	String name;
	int difficulty;
	LeaderboardEntry(String line){
		// convert from CSV string
		String[] tokens = line.split(",");
		float t = float(tokens[0]);
		timeSeconds = new Float(t);

		name = tokens[1];
		difficulty = int(tokens[2]);
	}
	LeaderboardEntry(float time, String n, int diff){
		// create from individual values
		name = n;
		timeSeconds = new Float(time);
		difficulty = diff;
	}
	String formatted(){
		// return as a formatted string ready for display
		return nf(timeSeconds,2,2) + " - " + name;
	}
	String asCSVEntry(){ 
		// return as a comma separated string ready for saving
		return timeSeconds+","+name+","+difficulty;
	}
	public int compareTo(LeaderboardEntry other){
		// used to sort leaderboard entries
		return other.timeSeconds.compareTo(timeSeconds);
	}
}
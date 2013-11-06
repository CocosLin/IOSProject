package com.gitom.hb.db.bean;

public class LogLocationBean extends AbstractBean {
	private long logTime;
	private String username;
	private double longitude;
	private double latitude;
	private String location;

	public long getLogTime() {
		return logTime;
	}

	public void setLogTime(long logTime){
		this.logTime = logTime;
	}
	
	public String getUsername() {
		return username;
	}

	public void setUsername(String arg0) {
		this.username = arg0;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	
	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

}


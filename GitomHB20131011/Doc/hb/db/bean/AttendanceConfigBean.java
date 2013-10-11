package com.gitom.hb.db.bean;


public class AttendanceConfigBean extends AbstractBean {
	private long organizationId;
	private int inMinute;
	private int outMinute;
	private int distance;
	private double longitude;
	private double latitude;
	private int orgunitId;

	public long getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(long organizationId) {
		this.organizationId = organizationId;
	}

	public int getOrgunitId() {
		return orgunitId;
	}

	public void setOrgunitId(int orgunitId) {
		this.orgunitId = orgunitId;
	}

	public int getInMinute() {
		return inMinute;
	}

	public void setInMinute(int inMinute) {
		this.inMinute = inMinute;
	}

	public int getOutMinute() {
		return outMinute;
	}

	public void setOutMinute(int outMinute) {
		this.outMinute = outMinute;
	}

	public int getDistance() {
		return distance;
	}

	public void setDistance(int distance) {
		this.distance = distance;
	}

	public double getLongitude() throws Exception {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public double getLatitude() throws Exception {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

}

package com.gitom.hb.api.bean.atten;

import java.util.List;

public class AttenInfo {
	private int organizationId;
	private int orgunitId;
	private int inMinute;
	private int outMinute;
	private int distance;
	private double longitude;
	private double latitude;
	private String updateUser;
	private List<Worktime> worktimes;

	public int getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(int organizationId) {
		this.organizationId = organizationId;
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

	public int getOrgunitId() {
		return orgunitId;
	}

	public void setOrgunitId(int orgunitId) {
		this.orgunitId = orgunitId;
	}

	public List<Worktime> getWorktimes() {
		return worktimes;
	}

	public void setWorktimes(List<Worktime> worktimes) {
		this.worktimes = worktimes;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}
	
}

package com.gitom.hb.db.bean;

import java.sql.Time;

public class AttendanceBean extends AbstractBean {
	private long attenLogId;
	private long organizationId;
	private String note;
	private int ordinal;
	private int distance;
	private double longitude;
	private double latitude;
	private Time createTime;
	private long abnormalTime;
	private String attenType;
	private String username;
	private boolean voidFlag;
	private int orgunitId;

	public long getAttenLogId() {
		return attenLogId;
	}

	public void setAttenLogId(long attenLogId) {
		this.attenLogId = attenLogId;
	}

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

	public int getOrdinal() {
		return ordinal;
	}

	public void setOrdinal(int ordinal) {
		this.ordinal = ordinal;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
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

	public Time getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Time createTime) {
		this.createTime = createTime;
	}

	public long getAbnormalTime() {
		return abnormalTime;
	}

	public void setAbnormalTime(long abnormalTime) {
		this.abnormalTime = abnormalTime;
	}

	public String getAttenType() {
		return attenType;
	}

	public void setAttenType(String attenType) {
		this.attenType = attenType;
	}

	public boolean getVoidFlag() {
		return voidFlag;
	}

	public void setVoidFlag(boolean voidFlag) {
		this.voidFlag = voidFlag;
	}
}

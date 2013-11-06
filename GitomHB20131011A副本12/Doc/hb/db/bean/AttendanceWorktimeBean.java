package com.gitom.hb.db.bean;

import java.sql.Time;

public class AttendanceWorktimeBean extends AbstractBean {

	private long organizationId;
	private int orgunitId;
	private boolean voidFlag;
	private Time onTime;
	private Time offTime;
	private int ordinal;

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

	public Time getOnTime() {
		return onTime;
	}

	public void setOnTime(Time onTime) {
		this.onTime = onTime;
	}

	public Time getOffTime() {
		return offTime;
	}

	public void setOffTime(Time offTime) {
		this.offTime = offTime;
	}

	public boolean getVoidFlag() {
		return voidFlag;
	}

	public void setVoidFlag(boolean voidFlag) {
		this.voidFlag = voidFlag;
	}

}

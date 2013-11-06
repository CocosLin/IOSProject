package com.gitom.hb.db.bean;


public class ReportBean extends AbstractBean {
	private long reportId;
	private long organizationId;
	private String note;
	private String address;
	private String imageUrl;
	private String soundUrl;
	private double longitude;
	private double latitude;
	private String reportType;
	private int orgunitId;
	private boolean voidFlag;

	public boolean getVoidFlag() {
		return voidFlag;
	}

	public void setVoidFlag(boolean voidFlag) {
		this.voidFlag = voidFlag;
	}

	public long getReportId() {
		return reportId;
	}

	public void setReportId(long reportId) {
		this.reportId = reportId;
	}

	public long getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(long companyId) {
		this.organizationId = companyId;
	}

	public int getOrgunitId() {
		return orgunitId;
	}

	public void setOrgunitId(int orgunitId) {
		this.orgunitId = orgunitId;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public String getSoundUrl() {
		return soundUrl;
	}

	public void setSoundUrl(String soundUrl) {
		this.soundUrl = soundUrl;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
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

	public String getReportType() {
		return reportType;
	}

	public void setReportType(String reportType) {
		this.reportType = reportType;
	}
}

package com.gitom.hb.api.bean.login;

import java.util.List;

import com.gitom.hb.db.bean.UserBean;

public class LoginInfo {
	private AppVersion appVersion;
	private UserBean user;
	private List<Organization> organizations;
	private long serverDate;
	private String mustUpdate;
	private String cookie;

	public AppVersion getAppVersion() {
		return appVersion;
	}

	public void setAppVersion(AppVersion appVersionInfo) {
		this.appVersion = appVersionInfo;
	}

	public List<Organization> getOrganizations() {
		return organizations;
	}

	public void setOrganizations(List<Organization> organizationInfo) {
		this.organizations = organizationInfo;
	}

	public long getServerDate() {
		return serverDate;
	}

	public void setServerDate(long serverDate) {
		this.serverDate = serverDate;
	}

	public String getMustUpdate() {
		return mustUpdate;
	}

	public void setMustUpdate(String mustUpdate) {
		this.mustUpdate = mustUpdate;
	}

	public UserBean getUser() {
		return user;
	}

	public void setUser(UserBean user) {
		this.user = user;
	}

	public String getCookie() {
		return cookie;
	}

	public void setCookie(String cookie) {
		this.cookie = cookie;
	}
}

package com.gitom.hb.api.bean.login;

import java.util.List;

public class Organization {
	private int organizationId;
	private int orgunitId;
	private int roleId;
	private String creator;
	private String name;
	private String appLevelCode;
	private List<UserPrivilege>  userPrivileges;

	public int getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(int organizationId) {
		this.organizationId = organizationId;
	}

	public int getOrgunitId() {
		return orgunitId;
	}

	public void setOrgunitId(int orgunitId) {
		this.orgunitId = orgunitId;
	}

	public int getRoleId() {
		return roleId;
	}

	public void setRoleId(int roleId) {
		this.roleId = roleId;
	}

	public String getCreator() {
		return creator;
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAppLevelCode() {
		return appLevelCode;
	}

	public void setAppLevelCode(String appLevelCode) {
		this.appLevelCode = appLevelCode;
	}

	public List<UserPrivilege> getUserPrivileges() {
		return userPrivileges;
	}

	public void setUserPrivileges(List<UserPrivilege> userPrivileges) {
		this.userPrivileges = userPrivileges;
	}
	
}

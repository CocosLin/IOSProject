package com.gitom.hb.api.bean;

import com.gitom.hb.db.bean.UserBean;


public class UserInfo extends UserBean {
	private int orgunitId;
	private int roleId;

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
	
}

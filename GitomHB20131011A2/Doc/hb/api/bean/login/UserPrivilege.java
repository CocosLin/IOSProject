package com.gitom.hb.api.bean.login;


public class UserPrivilege {
	private int roleId;
	private String operations;

	public int getRoleId() {
		return roleId;
	}

	public void setRoleId(int roleId) {
		this.roleId = roleId;
	}

	public String getOperations() {
		return operations;
	}

	public void setOperations(String operations) {
		this.operations = operations;
	}

}

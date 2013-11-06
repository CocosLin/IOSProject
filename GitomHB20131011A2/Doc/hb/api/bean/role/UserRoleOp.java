package com.gitom.hb.role;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class UserRoleOp implements Serializable {

	private static final long serialVersionUID = -2276412470208929609L;

	public static final UserRoleOp PUBLISH_NEWS = new UserRoleOp(
			"PUBLISH_NEWS", "发布公告", 3, VersionLevelEnum.BASE.name());
	
	public static final UserRoleOp EDIT_PRIVILEGE = new UserRoleOp(
			"EDIT_PRIVILEGE", "编辑权限", 7, VersionLevelEnum.BASE.name());
	
	public static final UserRoleOp EDIT_ROLE = new UserRoleOp(
			"EDIT_ROLE", "编辑职位", 8, VersionLevelEnum.BASE.name());

	private static Map<String, UserRoleOp> values;
	
	private final String name;						
	private final String description;			
	private final int opId;
	private final String appLevelCode;

	public static UserRoleOp valueOf(String argName) {
		if (argName == null) {
			return null;
		}
		UserRoleOp found = values.get(argName);
		if (found == null) {
			System.out.println("There is no instance of ["
					+ UserRoleOp.class.getName() + "] named [" + argName
					+ "].");
		}
		return found;
	}
	
	public static UserRoleOp[] values() {
		return values.values().toArray(new UserRoleOp[values.size()]);
	}


	protected UserRoleOp(String argName, String description, int id, String appLevelCode) {
		this.name = argName;
		this.description = description;
		this.opId = id;
		this.appLevelCode = appLevelCode;
		
		if (values == null) {
			values = new HashMap<String, UserRoleOp>();
		}
		values.put(name, this);
	}

	public String name() {
		return getName();
	}
	
	public String getName() {
		return name;
	}
	
	public String getAppLevelCode() {
		return appLevelCode;
	}
	
	public String getDescription() {
		return description;
	}

	public int getOpId() {
		return opId;
	}
	
	public boolean matches(String argName) {
		if (argName == null) {
			return false;
		}
		return name.equalsIgnoreCase(argName.trim());
	}

	@Override
	public String toString() {
		return name;
	}
}

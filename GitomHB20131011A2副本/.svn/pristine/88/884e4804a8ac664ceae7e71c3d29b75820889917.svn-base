package com.gitom.hb.role;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

@SuppressWarnings("serial")
public class UserRole implements Serializable {

	public static final UserRole ORG_OWNER = new UserRole("ORG_OWNER", "创建者", 1, "1,2,3,4,5,6,7,8,9,10,11,12,13,14");
	
	public static final UserRole ORG_ADMIN = new UserRole("ORG_ADMIN", "主管", 2, "1,2,3,4,8,9,12,13,14");
	
	public static final UserRole ORG_USER = new UserRole("ORG_USER", "员工", 4, "9");

	private static Map<String, UserRole> values;

	public static UserRole valueOf(String argName) {
		if (argName == null) {
			return null;
		}
		
		UserRole found = values.get(argName);
		if (found == null) {
			System.out.println("There is no instance of [" + UserRole.class.getName() + "] named [" + argName + "].");
		}
		
		return found;
	}

	public static UserRole[] values() {
		return values.values().toArray(new UserRole[values.size()]);
	}

	private final String name;
	private final String description;
	private final int roleId;
	private final String deftOps;

	protected UserRole(String argName, String description, int id,
			String deftOps) {
		this.name = argName;
		this.description = description;
		this.roleId = id;
		this.deftOps = deftOps;

		if (values == null) {
			values = new HashMap<String, UserRole>();
		}
		values.put(name, this);
	}

	public String name() {
		return getName();
	}

	public String getName() {
		return name;
	}

	public String getDescription() {
		return description;
	}

	public String getDefaultOps() {
		return deftOps;
	}

	public int getRoleId() {
		return roleId;
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

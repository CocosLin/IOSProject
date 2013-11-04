package com.gitom.hb.role;

public enum VersionLevelEnum implements IVersion {
	
	BASE("BASE", "标准版", LEVEL_BASE),
	ADVANCE("ADVANCE", "高级版", LEVEL_ADVANCE),
	ENTERPRISE("ENTERPRISE", "企业版", LEVEL_ENTERPRISE);

	private String code;
	private String description;
	private int level;
	
	private VersionLevelEnum(String code, String description, int level) {
		this.code = code;
		this.description = description;
		this.level = level;
	}

	public String getCode() {
		return code;
	}

	public String getDescription() {
		return description;
	}

	public int getLevel() {
		return level;
	}
	
}

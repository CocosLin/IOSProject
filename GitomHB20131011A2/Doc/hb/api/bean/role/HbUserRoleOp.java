package com.gitom.hb.role;


public class HbUserRoleOp extends UserRoleOp {
	
	private static final long serialVersionUID = 4634258421954054104L;

	public static final UserRoleOp VERIFY_USER = new HbUserRoleOp(
			"VERIFY_USER", "验证绑定申请", 1, VersionLevelEnum.BASE.name());
	
	public static final UserRoleOp LOGIN_CONSOLE = new HbUserRoleOp(
			"LOGIN_CONSOLE", "接收消息通知", 2, VersionLevelEnum.BASE.name());
	
	public static final UserRoleOp DELETE_USER = new HbUserRoleOp(
			"DELETE_USER", "删除员工", 4, VersionLevelEnum.BASE.name());
	
	public static final UserRoleOp UPDATE_ORGANIZATION = new HbUserRoleOp(
			"UPDATE_ORGANIZATION", "修改公司资料设置", 5, VersionLevelEnum.BASE.name());
	
	public static final UserRoleOp UPDATE_ATTENDANCE = new HbUserRoleOp(
			"UPDATE_ATTENDANCE", "修改考勤设置", 6, VersionLevelEnum.BASE.name());
	
	public static final UserRoleOp VIEW_LOCATION = new HbUserRoleOp(
			"VIEW_LOCATION", "查看用户实时位置", 9, VersionLevelEnum.ADVANCE.name());
	
	public static final UserRoleOp SHARE_LOCATION = new HbUserRoleOp(
			"SHARE_LOCATION", "启用位置共享", 10, VersionLevelEnum.ADVANCE.name());
	
	public static final UserRoleOp CREATE_OR_DELETE_ORGUNIT = new HbUserRoleOp(
			"CREATE_OR_DELETE_ORGUNIT", "创建部门/删除部门", 11, VersionLevelEnum.BASE.name());
	
	public static final UserRoleOp UPDATE_ORGUNIT = new HbUserRoleOp(
			"UPDATE_ORGUNIT", "更改部门名称", 12, VersionLevelEnum.BASE.name());
	
	public static final UserRoleOp MOVE_USER = new HbUserRoleOp(
			"MOVE_USER", "移动用户", 13, VersionLevelEnum.BASE.name());

	// 数据库初始化加
	public static final UserRoleOp VERIFY_WAY = new HbUserRoleOp(
			"VERIFY_WAY", "设置验证方式", 14, VersionLevelEnum.BASE.name());

	protected HbUserRoleOp(String argName, String description, int id, String levelCode) {
		super(argName, description, id, levelCode);
	}

}

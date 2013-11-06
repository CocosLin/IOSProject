package com.gitom.hb.http;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.entity.mime.content.ByteArrayBody;
import org.apache.http.entity.mime.content.ContentBody;
import org.apache.http.entity.mime.content.FileBody;

import com.alibaba.fastjson.JSON;
import com.gitom.hb.api.bean.UploadFileInfo;
import com.gitom.hb.api.bean.UserInfo;
import com.gitom.hb.api.bean.atten.AttenConfig;
import com.gitom.hb.api.bean.atten.AttenInfo;
import com.gitom.hb.api.bean.login.LoginInfo;
import com.gitom.hb.api.bean.org.OrganizationsInfo;
import com.gitom.hb.db.bean.ApplyBean;
import com.gitom.hb.db.bean.AttendanceBean;
import com.gitom.hb.db.bean.LogLocationBean;
import com.gitom.hb.db.bean.OrgNewsBean;
import com.gitom.hb.db.bean.OrganizationBean;
import com.gitom.hb.db.bean.OrgunitBean;
import com.gitom.hb.db.bean.ReportBean;
import com.gitom.hb.exception.FourZeroFourException;
import com.gitom.hb.exception.ServerException;
import com.gitom.hb.exception.WarningException;
import com.gitom.hb.http.HttpConnectionKit.HttpMethod;
import com.gitom.hb.http.message.Body;
import com.gitom.hb.http.message.Head;
import com.gitom.hb.http.message.Message;
import com.gitom.hb.upload.ProgressListener;

/**
 * 程序启动时候必须初始化 username, password, versionCode
 */
public class HBServerKit implements IHttpUrls {
	
	protected static final String COOKIE = "cookie";

//	private static final String NOT_LOGGED_IN = "notLoggedIn";
	
	private static final String INVALID_COOKIE = "invalidCookie";
	
	private static String cookie = "67554195-9CA7-444D-9904-789693420241"; 
	
	private static String username;
	
	private static String password;
	
	private static String versionCode;
	
	public static String getUsername() {
		return username;
	}

	public static void setUsername(String username) {
		HBServerKit.username = username;
	}

	public static String getPassword() {
		return password;
	}

	public static void setPassword(String password) {
		HBServerKit.password = password;
	}

	public static String getVersionCode() {
		return versionCode;
	}

	public static void setVersionCode(String version) {
		HBServerKit.versionCode = version;
	}

	private static String getUrl() {
		return URL_BASE_IP;
	}
	
	private static Map<String, String> createParamMap() {
		Map<String, String> params = new HashMap<String, String>();
		params.put(COOKIE, cookie);
		return params;
	}
	
	
	public static LoginInfo login() throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = new HashMap<String, String>();
		if (null == getUsername() ||
			null == getPassword() ||
			null == getVersionCode()) {
			throw new NullPointerException("username or passowrd or versionCode is null");
		}
		
		params.put(USERNAME, getUsername());
		params.put(PASSWORD, getPassword());
		params.put(VERSION_CODE, getVersionCode());
		
		Message message = HttpConnectionKit.connect(getUrl() + "/util/login", params, HttpMethod.GET);
		
		handleResult(message);
		
		LoginInfo result = JSON.parseObject((String)message.getBody().getData(), LoginInfo.class);
		
		cookie = result.getCookie();
		
		return result;
	}

	public static void changePwd(final String username, final String oldPwd, final String newPwd) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(USERNAME, username);
		params.put(OLD_PASSWORD, oldPwd);
		params.put(NEW_PASSWORD, newPwd);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/util/changePwd", params, HttpMethod.GET);
		
		handleResult(message);
	}
	
	public static AttenConfig attendanceConfig(final int organizationId, final int orgunitId) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/attendance/attendanceConfig", params, HttpMethod.GET);
		
		handleResult(message);
		
		return JSON.parseObject((String)message.getBody().getData(), AttenConfig.class);
	}
	
	public static List<AttendanceBean> userAttendance(final int organizationId, final int orgunitId, final String username, final long beginDate, final long endDate, final int first, final int max) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(USERNAME, username);
		params.put(BEGIN_DATE, String.valueOf(beginDate));
		params.put(END_DATE, String.valueOf(endDate));
		params.put(FIRST, String.valueOf(first));
		params.put(MAX, String.valueOf(max));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/attendance/userAttendance", params, HttpMethod.GET);
		
		handleResult(message);
		
		return JSON.parseArray((String)message.getBody().getData(), AttendanceBean.class);
	}
	
	public static OrganizationBean organization(final int organizationId) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/organization", params, HttpMethod.GET);
		
		handleResult(message);
		
		List<OrganizationBean> list = JSON.parseArray((String)message.getBody().getData(), OrganizationBean.class);
		
		return list == null ? null : list.get(0);
	}
	
	public static void updateOrganization(final int organizationId, final String username, final String name) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(USERNAME, username);
		params.put(NAME, name);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/updateOrganization", params, HttpMethod.POST);
		
		handleResult(message);
	}
	
	public static List<OrgNewsBean> organizationNews(final int organizationId, final int first, final int max) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(FIRST, String.valueOf(first));
		params.put(MAX, String.valueOf(max));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/organizationNews", params, HttpMethod.GET);
		
		handleResult(message);
		
		return JSON.parseArray((String)message.getBody().getData(), OrgNewsBean.class);
	}
	
	public static List<OrgNewsBean> orgunitNews(final int organizationId, final int orgunitId, final int first, final int max) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID , String.valueOf(orgunitId));
		params.put(FIRST, String.valueOf(first));
		params.put(MAX, String.valueOf(max));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/orgunitNews", params, HttpMethod.GET);
		
		handleResult(message);
		
		return JSON.parseArray((String)message.getBody().getData(), OrgNewsBean.class);
	}
	
	public static void saveNews(final int organizationId, final int orgunitId, final String newsType, final String title, final String content, final String username) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID , String.valueOf(orgunitId));
		params.put(NEWS_TYPE, newsType);
		params.put(TITLE, title);
		params.put(CONTENT, content);
		params.put(USERNAME, username);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/saveNews", params, HttpMethod.POST);
		
		handleResult(message);
	}
	
	public static List<OrgunitBean> rootOrgunits(final int organizationId, final boolean voidFlag) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(VOID_FLAG , String.valueOf(voidFlag));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/rootOrgunits", params, HttpMethod.GET);
		
		handleResult(message);	
		
		return JSON.parseArray((String)message.getBody().getData(), OrgunitBean.class);
	}
	
	public static List<OrgunitBean> orgunitByUsername(final int organizationId, final String username) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(USERNAME , username);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/orgunitByUsername", params, HttpMethod.GET);
		
		handleResult(message);	
		
		return JSON.parseArray((String)message.getBody().getData(), OrgunitBean.class);
		
	}
	
	public static void saveOrgunit(final long organizationId, final int pid, final String username, final String name) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(PID , String.valueOf(pid));
		params.put(USERNAME, username);
		params.put(NAME, name);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/saveOrgunit", params, HttpMethod.POST);
		
		handleResult(message);
	}
	
	public static void updateOrgunit(final long organizationId, final int orgunitId, final String username, final String name) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(USERNAME, username);
		params.put(NAME, name);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/updateOrgunit", params, HttpMethod.POST);
		
		handleResult(message);
	}
	
	public static void deleteOrgunit(final long organizationId, final int orgunitId, final String username) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(USERNAME, username);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/deleteOrgunit", params, HttpMethod.POST);
		
		handleResult(message);
	}
	
	public static List<ReportBean> findReport(final long organizationId, final int orgunitId, final long reportId) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID , String.valueOf(orgunitId));
		params.put(REPORT_ID, String.valueOf(reportId));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/report/findReport", params, HttpMethod.GET);
		
		handleResult(message);	
		
		return JSON.parseArray((String)message.getBody().getData(), ReportBean.class);
	}
	
	public static List<ReportBean> findReports(long organizationId, int orgunitId, String username, String type, 
											long beginDate, long endDate, final int first, final int max) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID , String.valueOf(orgunitId));
		params.put(USERNAME, username);
		params.put(REPORT_TYPE, type);
		params.put(BEGIN_DATE, String.valueOf(beginDate));
		params.put(END_DATE, String.valueOf(endDate));
		params.put(FIRST, String.valueOf(first));
		params.put(MAX, String.valueOf(max));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/report/findReports", params, HttpMethod.GET);
		
		handleResult(message);	
		
		return JSON.parseArray((String)message.getBody().getData(), ReportBean.class);
	}
	
	public static UserInfo findUser(final long organizationId, final int orgunitId, final String username) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(USERNAME, username);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/user/findUser", params, HttpMethod.GET);
		
		handleResult(message);
		
		List<UserInfo> list = JSON.parseArray((String)message.getBody().getData(), UserInfo.class);
		
		return list == null ? null : list.get(0);
	}
	
	public static List<UserInfo> findUsers(final long organizationId, final int orgunitId, final boolean voidFlag) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(VOID_FLAG, String.valueOf(voidFlag));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/user/findUsers", params, HttpMethod.GET);
		
		handleResult(message);
		
		return JSON.parseArray((String)message.getBody().getData(), UserInfo.class);
	}
	
	public static void updateUser(final String username, final String realname, final String phone) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(USERNAME, username);
		params.put(REALNAME, realname);
		params.put(TELEPHONE, phone);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/user/updateUser", params, HttpMethod.POST);
		
		handleResult(message);
	}
	
	public static void saveOrgunitUser(final int organizationId, final int orgunitId, final String username, final int roleId, final String updateUser) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(USERNAME, username);
		params.put(ROLE_ID, String.valueOf(roleId));
		params.put(UPDATE_USER, updateUser);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/saveOrgunitUser", params, HttpMethod.POST);
		
		handleResult(message);
	}
	
	public static void deleteOrgunitUser(final int organizationId, final int orgunitId, final String username, final String updateUser) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(USERNAME, username);
		params.put(UPDATE_USER, updateUser);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/deleteOrgunitUser", params, HttpMethod.GET);
		
		handleResult(message);
	}
	
	public static void moveOrgunitUser(final int organizationId, final int orgunitId, final int tarOrgunitId, final String username, final String updateUser) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(TARGET_ORGUNIT_ID, String.valueOf(tarOrgunitId));
		params.put(USERNAME, username);
		params.put(UPDATE_USER, updateUser);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/moveOrgunitUser", params, HttpMethod.GET);
		
		handleResult(message);	
	}
	
	
	public static List<OrganizationsInfo> organizations(final String key, final int first, final int max) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(KEY, key);
		params.put(FIRST, String.valueOf(first));
		params.put(MAX, String.valueOf(max));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/organizations", params, HttpMethod.GET);
		
		handleResult(message);	
		
		return JSON.parseArray((String)message.getBody().getData(), OrganizationsInfo.class);
	}
	
	public static void saveApply(final int organizationId, final int orgunitId, final String username, final String note, final String verifyType) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(USERNAME, username);
		params.put(NOTE, note);
		params.put(VERIFY_TYPE, verifyType);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/user/saveApply", params, HttpMethod.GET);
		
		handleResult(message);	
	}
	
	public static List<ApplyBean> applys(final int organizationId, final int orgunitId) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/applys", params, HttpMethod.GET);
		
		handleResult(message);	
		
		return JSON.parseArray((String)message.getBody().getData(), ApplyBean.class);
	}
	
	public static void saveOrganization(final long organizationId, final String name, final String regulation, final String creator) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(NAME, name);
		params.put(REGULATION, regulation);
		params.put(CREATOR, creator);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/saveOrganization", params, HttpMethod.GET);
		
		handleResult(message);
	}
	
	public static void saveLocation(final String username, final String location, final double longitude, final double latitude) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(USERNAME, username);
		params.put(LOCATION, location);
		params.put(LONGITUDE, String.valueOf(longitude));
		params.put(LATITUDE, String.valueOf(latitude));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/util/saveLocation", params, HttpMethod.GET);
		
		handleResult(message);
	}
	
	public static List<LogLocationBean> locations(final String username, final long beginTime, final long endTime) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(USERNAME, username);
		params.put(BEGIN_TIME, String.valueOf(beginTime));
		params.put(END_TIME, String.valueOf(endTime));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/util/locations", params, HttpMethod.GET);
		
		handleResult(message);	
		
		return JSON.parseArray((String)message.getBody().getData(), LogLocationBean.class);
	}
	
	public static void saveRolePrivilege(final int organizationId, final int roleId, final String operations, final String updateUser) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ROLE_ID, String.valueOf(roleId));
		params.put(OPERATIONS, operations);
		params.put(UPDATE_USER, updateUser);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/userRole/saveRolePrivilege", params, HttpMethod.GET);
		
		handleResult(message);	
	}
	
	public static void updateAttendanceConfig(final AttenInfo attenInfo) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ATTEN_INFO, JSON.toJSONString(attenInfo));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/attendance/updateAttendanceConfig", params, HttpMethod.POST);
		
		handleResult(message);	
	}
	
	public static void saveVerifyMethod(final int organizationId, final int orgunitId, final String method, final String question, final String answer, final String updateUser) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(METHOD, method);
		
		if (null != question) {
			params.put(QUESTION, question);
		}
		
		if (null != answer) {
			params.put(ANSWER, answer);
		}
		
		params.put(UPDATE_USER, updateUser);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/organization/saveVerifyMethod", params, HttpMethod.POST);
		
		handleResult(message);	
	}
	
	public static void saveReport(final int organizationId, final int orgunitId, final String username, 
			final String note, final String address, final String imgUrl, final String soundUrl, 
			final double longitude, final double latitude, final String reportType) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(USERNAME, username);
		params.put(NOTE, note);
		params.put(ADDRESS, address);
		
		if (null != imgUrl) {
			params.put(IMG_URL, imgUrl);
		} else {
			params.put(IMG_URL, "{\"imageUrl\":[]}");
		}
		
		if (null != soundUrl) {
			params.put(SOUND_URL, soundUrl);
		} else {
			params.put(SOUND_URL, "{\"soundUrl\":[]}");
		}
		
		params.put(LONGITUDE, String.valueOf(longitude));
		params.put(LATITUDE, String.valueOf(latitude));
		params.put(REPORT_TYPE, reportType);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/report/saveReport", params, HttpMethod.POST);
		
		handleResult(message);	
	}
	
	public static void saveUploadLocationTime(final int organizationId, final int orgunitId, final long time, final String updateUser) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(MILLISECOND, String.valueOf(time));
		params.put(UPDATE_USER, updateUser);
		
		Message message = HttpConnectionKit.connect(getUrl() + "/util/saveUploadLocationTime", params, HttpMethod.GET);
		
		handleResult(message);	
	}
	
	
	public static void saveAttendance(final int organizationId, final int orgunitId, final String username, final double longitude, final double latitude) throws IllegalStateException, FourZeroFourException, IOException, WarningException, ServerException {
		Map<String, String> params = createParamMap();
		params.put(ORGANIZATION_ID, String.valueOf(organizationId));
		params.put(ORGUNIT_ID, String.valueOf(orgunitId));
		params.put(USERNAME, username);
		params.put(LONGITUDE, String.valueOf(longitude));
		params.put(LATITUDE, String.valueOf(latitude));
		
		Message message = HttpConnectionKit.connect(getUrl() + "/attendance/saveAttendance", params, HttpMethod.GET);
		
		handleResult(message);	
	}
	
	
	public static List<UploadFileInfo> photoUpload(ByteArrayBody byteArrayBody, int thumbWidth, int thumbHeight, ProgressListener progressListenner) throws Exception {
		List<ContentBody> byteArrayBodys = new ArrayList<ContentBody>();
		byteArrayBodys.add(byteArrayBody);
	
		return photoUpload(byteArrayBody, thumbWidth, thumbHeight, progressListenner);
	}
	
	public static List<UploadFileInfo> photoUpload(List<ContentBody> byteArrayBodys, int thumbWidth, int thumbHeight, ProgressListener progressListenner) throws Exception {
		Message message = HttpConnectionKit.fileUpload(getUrl() + "/util/fileUpload", byteArrayBodys, "width=" + thumbWidth + "&height=" + thumbHeight, progressListenner);
		
		handleResult(message);
		
		return JSON.parseArray((String)message.getBody().getData(), UploadFileInfo.class);
	}
	
	public static List<UploadFileInfo> voiceUpload(File file, ProgressListener progressListenner) throws Exception {
		List<ContentBody> fileBodys = new ArrayList<ContentBody>();
		fileBodys.add(new FileBody(file));
		
		return voiceUpload(fileBodys, progressListenner);
	}
	
	public static List<UploadFileInfo> voiceUpload(List<ContentBody> fileBodys, ProgressListener progressListenner) throws Exception {
		 Message message = HttpConnectionKit.fileUpload(getUrl() + "/util/fileUpload", fileBodys, null, progressListenner);
		 
		 handleResult(message);
		 
		 return JSON.parseArray((String)message.getBody().getData(), UploadFileInfo.class);
	}

	private static void handleResult(Message message) throws WarningException, ServerException {
		Head head = message.getHead();
		Body body = message.getBody();
		
		// 发生异常
		if (!head.isSuccess()) {
			
			// 如果 cookie 已经过期， 则重新登录
			if (head.getCause().equals(INVALID_COOKIE)) {
				try {
					login();
				} catch (IllegalStateException e) {
				} catch (FourZeroFourException e) {
				} catch (IOException e) {
				}
			} else {
				throw new ServerException(head.getCause());
			}
		}
		
		// 比如查询不到, 给出的提示
		if (!body.isSuccess()) {
			throw new WarningException(body.getWarning());
		}
	}
	  
	
}

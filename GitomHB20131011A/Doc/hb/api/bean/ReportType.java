package com.gitom.panch.xxx;

import java.io.Serializable;

public enum ReportType implements Serializable {
	
	REPORT_TYPE_GO_OUT("REPORT_TYPE_GO_OUT", "外出汇报"), 
	REPORT_TYPE_TRAVEL("REPORT_TYPE_TRAVEL","出差汇报"),
	REPORT_TYPE_DAY_REPORT("REPORT_TYPE_DAY_REPORT","工作汇报"),
	REPORT_TYPE_ALL("*","全部汇报");
	
	private ReportType(String type, String title) {
		this.type_ = type;
		this.title_ = title;
	}

	public String getType() {
		return type_;
	}

	public String getTitle() {
		return title_;
	}
	
	private final String title_;
	private String type_;
	
}

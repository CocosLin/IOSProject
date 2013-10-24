package com.gitom.hb.api.bean.org;

import java.io.Serializable;

public class OrgunitProp implements Serializable {

	private static final long serialVersionUID = 5918397316740682880L;

	private String propCode;
	private String propValue;

	public String getPropCode() {
		return propCode;
	}

	public void setPropCode(String propCode) {
		this.propCode = propCode;
	}
	
	public String getPropValue() {
		return propValue;
	}

	public void setPropValue(String propType) {
		this.propValue = propType;
	}
}

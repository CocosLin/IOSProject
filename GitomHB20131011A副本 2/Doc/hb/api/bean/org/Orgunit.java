package com.gitom.hb.api.bean.org;

import java.util.List;

public class Orgunit {
	private int orgunitId;
	private String name;
	private List<OrgunitProp> orgunitProps;

	public int getOrgunitId() {
		return orgunitId;
	}

	public void setOrgunitId(int orgunitId) {
		this.orgunitId = orgunitId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<OrgunitProp> getOrgunitProps() {
		return orgunitProps;
	}

	public void setOrgunitProps(List<OrgunitProp> orgunitProps) {
		this.orgunitProps = orgunitProps;
	}
}

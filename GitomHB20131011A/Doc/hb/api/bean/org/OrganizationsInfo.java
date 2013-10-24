package com.gitom.hb.api.bean.org;

import java.util.List;

public class OrganizationsInfo {
	private long organizationId;
	private String name;
	private List<Orgunit> orgunitList;

	public long getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(long organizationId) {
		this.organizationId = organizationId;
	}

	public List<Orgunit> getOrgunitList() {
		return orgunitList;
	}

	public void setOrgunitList(List<Orgunit> orgunitList) {
		this.orgunitList = orgunitList;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

}

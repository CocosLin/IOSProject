package com.gitom.hb.db.bean;


public class UserBean extends AbstractBean {
	private String username;
	private String password;
	private String realname;
	private String telephone;
	private String cellphone;
	private String address;
	private String photo;
	private String hobby;
	
	public String getUsername() {
		return username;
	}

	public void setUsername(String arg0) {
		this.username = arg0;
	}
	
	public String getPassword() {
		return password;
	}

	public void setPassword(String arg0) {
		this.password = arg0;
	}
	
	public String getCellphone() {
		return cellphone;
	}

	public void setCellphone(String cellphone) {
		this.cellphone = cellphone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getRealname() {
		return realname;
	}

	public void setRealname(String realname) {
		this.realname = realname;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	
	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}
	
	public String getHobby() {
		return hobby;
	}

	public void setHobby(String hobby) {
		this.hobby = hobby;
	}

}

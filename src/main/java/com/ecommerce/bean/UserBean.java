package com.ecommerce.bean;

public class UserBean {
	
	private int id;
	private String name      = null;
	private String email     = null;
	private String password  = null;
	private String phone     = null;
	private String userpic   = null;
	private String location  = null;
	private String usertype  = null;
	
	public UserBean() {
		
	}

	public UserBean(String name, String email, String password, String phone, String userpic, String location) {
		this.name = name;
		this.email = email;
		this.password = password;
		this.phone = phone;
		this.userpic = userpic;
		this.location = location;
	}

	public UserBean(int id, String name, String email, String password, String phone, String userpic, String location) {
		this.id = id;
		this.name = name;
		this.email = email;
		this.password = password;
		this.phone = phone;
		this.userpic = userpic;
		this.location = location;
	}

	public UserBean(int id, String name, String email, String password, String phone, String userpic, String location,
			String usertype) {
		this.id = id;
		this.name = name;
		this.email = email;
		this.password = password;
		this.phone = phone;
		this.userpic = userpic;
		this.location = location;
		this.usertype = usertype;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getUserpic() {
		return userpic;
	}

	public void setUserpic(String userpic) {
		this.userpic = userpic;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}
	
	public void setUserType(String user) {
		this.usertype = user;
	}

	public String getUserType() {
		return usertype;
	}
	
}

package com.ecommerce.bean;

import java.util.List;

public class CategoryBean {
	
	private int id;
	private String title = null;
	private String description = null;
	private List<ProductBean> products = null;
	
	public CategoryBean() {
		
	}
	
	public CategoryBean(String title, String description) {
		this.title = title;
		this.description = description;
	}

	public CategoryBean(int id, String title, String description) {
		this.id = id;
		this.title = title;
		this.description = description;
	}
	
	

	public CategoryBean(String title, String description, List<ProductBean> products) {
		super();
		this.title = title;
		this.description = description;
		this.products = products;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public List<ProductBean> getProducts() {
		return products;
	}

	public void setProducts(List<ProductBean> products) {
		this.products = products;
	}	

}

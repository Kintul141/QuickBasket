package com.ecommerce.bean;

public class ProductBean {
	
	private int id;
	private String title          = null;
    private String description    = null;
    private String prodimage      = null;
    private int price;
    private int discount;
    private int qnty;
    private int cid;
    
    public ProductBean() {
    	
    }

	public ProductBean(int id, String title, String description, String prodimage, int price, int discount, int qnty,
			int cid) {
		this.id = id;
		this.title = title;
		this.description = description;
		this.prodimage = prodimage;
		this.price = price;
		this.discount = discount;
		this.qnty = qnty;
		this.cid = cid;
	}

	public ProductBean(String title, String description, String prodimage, int price, int discount, int qnty,
			int cid) {
		this.title = title;
		this.description = description;
		this.prodimage = prodimage;
		this.price = price;
		this.discount = discount;
		this.qnty = qnty;
		this.cid = cid;
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

	public String getProdimage() {
		return prodimage;
	}

	public void setProdimage(String prodimage) {
		this.prodimage = prodimage;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public int getDiscount() {
		return discount;
	}

	public void setDiscount(int discount) {
		this.discount = discount;
	}

	public int getQnty() {
		return qnty;
	}

	public void setQnty(int qnty) {
		this.qnty = qnty;
	}

	public int getCid() {
		return cid;
	}

	public void setCid(int cid) {
		this.cid = cid;
	}
    
}

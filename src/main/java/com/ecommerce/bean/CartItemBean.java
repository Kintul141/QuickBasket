package com.ecommerce.bean;

public class CartItemBean {

    private ProductBean product;
    private int quantity;

    public CartItemBean() {
    }

    public CartItemBean(ProductBean product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    public ProductBean getProduct() {
        return product;
    }

    public void setProduct(ProductBean product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getDiscountedPrice() {
        if (product == null) {
            return 0.0;
        }
        double discountValue = product.getPrice() * (product.getDiscount() / 100.0);
        return product.getPrice() - discountValue;
    }

    public double getLineTotal() {
        return getDiscountedPrice() * quantity;
    }
}

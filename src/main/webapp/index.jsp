<%@page import="com.ecommerce.bean.CategoryBean"%>
<%@page import="com.ecommerce.dao.CategoryDao"%>
<%@page import="com.ecommerce.bean.ProductBean"%>
<%@page import="com.ecommerce.dao.ProductDao"%>
<%@page import="com.ecommerce.bean.UserBean"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Shop – QuickBasket Fresh Grocery Store</title>
<meta name="description" content="Browse and shop fresh groceries at QuickBasket. Fruits, vegetables, dairy, snacks and more.">
<%@include file="/components/common_css.jsp"%>
<style>
  .hero-store {
    background: linear-gradient(135deg, #0a1a0e 0%, #0d2514 100%);
    border: 1px solid var(--qb-green-border);
    border-radius: 18px;
    padding: 28px 30px;
    position: relative; overflow: hidden;
  }
  .hero-store::after {
    content: '🛒'; position: absolute; right: 20px; top: 50%;
    transform: translateY(-50%); font-size: 6rem; opacity: 0.07; user-select: none;
  }
  .product-card { height: 100%; }
  .stock-info { font-size: 0.75rem; color: #5a7a64; }
  .original-price { text-decoration: line-through; color: #5a7a64; font-size: 0.82rem; }
  .search-bar {
    background: rgba(255,255,255,0.04);
    border: 1px solid var(--qb-green-border);
    border-radius: 50px;
    padding: 10px 20px;
    color: var(--qb-text);
    width: 100%;
  }
  .search-bar:focus { outline: none; border-color: var(--qb-green); box-shadow: 0 0 0 3px rgba(34,197,94,0.15); }
  .search-bar::placeholder { color: #4a7055; }
</style>
</head>
<body>
<%@include file="/components/navbar.jsp"%>

<div class="container mt-4 mb-5">
    <%@include file="/components/message.jsp"%>

    <%
    UserBean currentUser = (UserBean) session.getAttribute("current_user");
    String selectedCategoryParam = request.getParameter("categoryId");
    Integer selectedCategoryId = null;
    if (selectedCategoryParam != null) {
        try { selectedCategoryId = Integer.parseInt(selectedCategoryParam); }
        catch (NumberFormatException ex) { selectedCategoryId = null; }
    }
    %>

    <!-- Store Hero -->
    <div class="hero-store mb-4 fade-in-up">
        <h2 class="fw-bold mb-1" style="color:#fff;">🛍️ Fresh Grocery Store</h2>
        <p class="mb-2" style="color:#7aad8e;font-size:0.95rem;">QuickBasket: fruits, vegetables, dairy, snacks and home essentials — delivered fast.</p>
        <div class="d-flex align-items-center gap-2 flex-wrap">
            <% if (currentUser == null) { %>
            <a href="login.jsp" class="btn custom-bg btn-sm px-4" style="border-radius:50px;">
                <i class="bi bi-cart-plus me-1"></i> Login to Add to Cart
            </a>
            <% } %>
            <% if (currentUser != null && !"admin".equalsIgnoreCase(currentUser.getUserType())) { %>
            <a href="cart.jsp" class="btn btn-outline-success btn-sm px-4" style="border-radius:50px;">
                <i class="bi bi-cart3 me-1"></i> View My Cart
            </a>
            <% } %>
        </div>
    </div>

    <div class="row g-4">
        <%
        ArrayList<CategoryBean> categorylist = CategoryDao.getAllCategories();
        if (categorylist != null && !categorylist.isEmpty()) {
        %>
        <!-- Category Sidebar -->
        <div class="col-md-2">
            <div class="category-panel">
                <div style="padding:12px 16px;border-bottom:1px solid rgba(255,255,255,0.06);font-size:0.78rem;font-weight:700;text-transform:uppercase;letter-spacing:0.8px;color:#4a7055;">
                    <i class="bi bi-funnel me-1"></i>Filter
                </div>
                <a href="index.jsp" class="list-group-item list-group-item-action <%=selectedCategoryId == null ? "active" : ""%>">
                    <i class="bi bi-grid me-2"></i>All Products
                </a>
                <%
                for (CategoryBean cat : categorylist) {
                %>
                <a href="index.jsp?categoryId=<%= cat.getId() %>"
                   class="list-group-item list-group-item-action <%=selectedCategoryId != null && selectedCategoryId == cat.getId() ? "active" : ""%>">
                    <i class="bi bi-tag me-2"></i><%= cat.getTitle() %>
                </a>
                <% } %>
            </div>
        </div>
        <% } %>

        <!-- Products Grid -->
        <%
        ArrayList<ProductBean> productlist = ProductDao.getAllProducts();
        int colClass = (categorylist != null && !categorylist.isEmpty()) ? 10 : 12;
        %>
        <div class="col-md-<%= colClass %>">
            <!-- Search bar -->
            <div class="mb-3">
                <div class="position-relative">
                    <i class="bi bi-search position-absolute" style="left:16px;top:50%;transform:translateY(-50%);color:#4a7055;"></i>
                    <input type="text" class="search-bar" id="productSearch" placeholder="Search products..." style="padding-left:42px;">
                </div>
            </div>

            <div class="row g-3" id="productsGrid">
            <%
            if (productlist != null && !productlist.isEmpty()) {
                boolean hasVisibleProducts = false;
                for (ProductBean prod : productlist) {
                    if (selectedCategoryId != null && prod.getCid() != selectedCategoryId) continue;
                    hasVisibleProducts = true;
                    double dis = prod.getPrice() * (prod.getDiscount() / 100.0);
                    double updatedPrice = prod.getPrice() - dis;
            %>
            <div class="col-sm-6 col-md-4 col-lg-3 product-item fade-in-up">
                <div class="card product-card border-0 h-100">
                    <img src="assets/products/<%= prod.getProdimage() %>"
                         class="card-img-top" alt="<%= prod.getTitle() %>"
                         onerror="this.src='assets/placeholder.png'">
                    <div class="card-body">
                        <h6 class="product-title"><%= prod.getTitle() %></h6>
                        <p class="product-description"><%= prod.getDescription() %></p>
                        <div class="stock-info">
                            <i class="bi bi-box-seam me-1"></i>Stock: <%= prod.getQnty() %>
                            <% if (prod.getDiscount() > 0) { %>
                            &nbsp;|&nbsp;<span class="discount-badge"><%= prod.getDiscount() %>% OFF</span>
                            <% } %>
                        </div>
                    </div>
                    <div class="product-footer">
                        <div>
                            <% if (prod.getDiscount() > 0) { %>
                            <div class="original-price">₹<%= prod.getPrice() %></div>
                            <% } %>
                            <div class="price-tag">₹<%= String.format("%.0f", updatedPrice) %></div>
                        </div>
                        <% if (currentUser != null && !"admin".equalsIgnoreCase(currentUser.getUserType())) { %>
                        <form action="CartServlet" method="post" class="d-inline">
                            <input type="hidden" name="operation" value="add">
                            <input type="hidden" name="productId" value="<%= prod.getId() %>">
                            <input type="hidden" name="quantity" value="1">
                            <button class="btn custom-bg btn-sm" type="submit" style="border-radius:50px;font-size:0.78rem;">
                                <i class="bi bi-cart-plus me-1"></i>Add
                            </button>
                        </form>
                        <% } else if (currentUser == null) { %>
                        <a href="login.jsp" class="btn btn-sm" style="border:1px solid var(--qb-green-border);color:#4a7055;border-radius:50px;font-size:0.78rem;">
                            <i class="bi bi-lock me-1"></i>Login
                        </a>
                        <% } else { %>
                        <span class="badge" style="background:rgba(239,68,68,0.1);color:#f87171;font-size:0.72rem;">Admin View</span>
                        <% } %>
                    </div>
                </div>
            </div>
            <%
                }
                if (!hasVisibleProducts) {
            %>
            <div class="col-12">
                <div class="alert alert-light border text-center py-5">
                    <i class="bi bi-inbox fs-1 d-block mb-2" style="color:#4a7055;"></i>
                    No products found for this category.
                    <a href="index.jsp" class="qb-link d-block mt-2">Clear filter</a>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <div class="col-12">
                <div class="alert alert-light text-center py-5">
                    <i class="bi bi-shop fs-1 d-block mb-2" style="color:#4a7055;"></i>
                    No products available yet. Check back soon!
                </div>
            </div>
            <% } %>
            </div><!-- /productsGrid -->
        </div>
    </div><!-- /row -->
</div><!-- /container -->

<script>
// Live product search filter
document.getElementById('productSearch').addEventListener('input', function() {
    const q = this.value.toLowerCase();
    document.querySelectorAll('.product-item').forEach(function(item) {
        const title = item.querySelector('.product-title')?.textContent.toLowerCase() || '';
        const desc = item.querySelector('.product-description')?.textContent.toLowerCase() || '';
        item.style.display = (title.includes(q) || desc.includes(q)) ? '' : 'none';
    });
});
</script>
</body>
</html>

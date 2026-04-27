<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.ecommerce.bean.BillRecordBean"%>
<%@page import="com.ecommerce.bean.CartItemBean"%>
<%@page import="com.ecommerce.bean.UserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    UserBean user = (UserBean) session.getAttribute("current_user");
    if (user == null) {
        request.setAttribute("loginErr", "Please login first to view your cart.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }
    if ("admin".equalsIgnoreCase(user.getUserType())) {
        response.sendRedirect("adminuser.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    Map<Integer, CartItemBean> cart = (Map<Integer, CartItemBean>) session.getAttribute("cart");
    if (cart == null) {
        cart = new java.util.LinkedHashMap<>();
        session.setAttribute("cart", cart);
    }

    @SuppressWarnings("unchecked")
    List<BillRecordBean> myBills = (List<BillRecordBean>) session.getAttribute("myBills");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Cart – QuickBasket</title>
<%@include file="/components/common_css.jsp"%>
<style>
  .cart-empty-state { text-align: center; padding: 60px 20px; }
  .cart-empty-state .empty-icon { font-size: 4rem; margin-bottom: 12px; opacity: 0.5; }
  .qty-control { display: flex; align-items: center; gap: 8px; }
  .qty-btn { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); color: var(--qb-text); width: 28px; height: 28px; border-radius: 6px; display: flex; align-items: center; justify-content: center; cursor: pointer; font-size: 0.9rem; transition: all 0.2s; }
  .qty-btn:hover { background: var(--qb-green-soft); border-color: var(--qb-green-border); color: var(--qb-green); }
  .bill-card { background: rgba(34,197,94,0.06); border: 1px solid var(--qb-green-border); border-radius: 12px; padding: 16px 20px; margin-bottom: 10px; transition: all 0.2s; }
  .bill-card:hover { background: rgba(34,197,94,0.10); }
  .bill-id { font-family: 'Courier New', monospace; font-weight: 700; color: var(--qb-green); font-size: 0.92rem; }
  .summary-box {
    background: linear-gradient(135deg, #0a2213, #0d3018);
    border: 1px solid var(--qb-green-border);
    border-radius: 16px; padding: 24px;
    position: sticky; top: 80px;
  }
  .summary-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 0.9rem; }
  .summary-row.total { border-top: 1px solid rgba(255,255,255,0.08); padding-top: 12px; margin-top: 4px; font-weight: 800; font-size: 1.05rem; color: var(--qb-green); }
</style>
</head>
<body>
<%@include file="/components/navbar.jsp"%>

<div class="container mt-4 mb-5 fade-in-up">
    <%@include file="/components/message.jsp"%>

    <!-- Header -->
    <div class="hero-store mb-4" style="background: linear-gradient(135deg, #0a1a0e 0%, #0d2514 100%); border: 1px solid var(--qb-green-border); border-radius: 18px; padding: 24px 28px;">
        <h2 class="fw-bold mb-1" style="color:#fff;">🛒 My Shopping Cart</h2>
        <p class="mb-0" style="color:#7aad8e;font-size:0.9rem;">Review your items, adjust quantities, and checkout securely.</p>
    </div>

    <div class="row g-4">
        <!-- Cart Items -->
        <div class="col-lg-8">
            <div class="page-section">
                <h5 class="section-title mb-3"><i class="bi bi-cart3 me-2"></i>Cart Items</h5>

                <% if (cart.isEmpty()) { %>
                <div class="cart-empty-state">
                    <div class="empty-icon">🛒</div>
                    <h5 style="color:var(--qb-text-muted);">Your cart is empty</h5>
                    <p style="color:#4a7055;font-size:0.9rem;">Add products from the store to start shopping!</p>
                    <a href="index.jsp" class="btn custom-bg px-4" style="border-radius:50px;">
                        <i class="bi bi-shop me-2"></i>Browse Products
                    </a>
                </div>
                <% } else {
                    double grandTotal = 0.0;
                    int totalItems = 0;
                    for (CartItemBean item : cart.values()) {
                        grandTotal += item.getLineTotal();
                        totalItems += item.getQuantity();
                    }
                %>
                <div class="table-responsive themed-table mb-3">
                    <table class="table align-middle mb-0">
                        <thead>
                            <tr>
                                <th><i class="bi bi-box-seam me-1"></i>Product</th>
                                <th>Unit Price</th>
                                <th>Qty</th>
                                <th>Line Total</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (CartItemBean item : cart.values()) { %>
                            <tr>
                                <td>
                                    <div style="font-weight:600;color:#e2f5e9;"><%= item.getProduct().getTitle() %></div>
                                    <% if (item.getProduct().getDiscount() > 0) { %>
                                    <small class="discount-badge"><%= item.getProduct().getDiscount() %>% OFF</small>
                                    <% } %>
                                </td>
                                <td style="color:var(--qb-green);font-weight:700;">₹<%= String.format("%.2f", item.getDiscountedPrice()) %></td>
                                <td>
                                    <div class="qty-control">
                                        <form action="CartServlet" method="post" style="display:inline;">
                                            <input type="hidden" name="operation" value="remove">
                                            <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                            <button class="qty-btn" type="submit" title="Remove item">
                                                <i class="bi bi-trash3" style="font-size:0.75rem;"></i>
                                            </button>
                                        </form>
                                        <span style="font-weight:700;min-width:20px;text-align:center;"><%= item.getQuantity() %></span>
                                    </div>
                                </td>
                                <td style="color:#fff;font-weight:700;">₹<%= String.format("%.2f", item.getLineTotal()) %></td>
                                <td>
                                    <form action="CartServlet" method="post" class="d-inline">
                                        <input type="hidden" name="operation" value="remove">
                                        <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                        <button class="btn btn-danger btn-sm" type="submit" style="border-radius:6px;font-size:0.78rem;">
                                            <i class="bi bi-x-lg"></i> Remove
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Clear Cart -->
                <form action="CartServlet" method="post" class="d-inline">
                    <input type="hidden" name="operation" value="clear">
                    <button class="btn btn-sm" style="border:1px solid rgba(239,68,68,0.3);color:#f87171;border-radius:50px;font-size:0.82rem;"
                            type="submit" onclick="return confirm('Clear all items from cart?')">
                        <i class="bi bi-trash me-1"></i> Clear Cart
                    </button>
                </form>
                <a href="index.jsp" class="btn btn-sm btn-outline-success ms-2" style="border-radius:50px;font-size:0.82rem;">
                    <i class="bi bi-plus-circle me-1"></i> Continue Shopping
                </a>
            <% } %>
            </div>
        </div>

        <!-- Order Summary Sidebar -->
        <div class="col-lg-4">
            <div class="summary-box">
                <h5 class="section-title mb-3"><i class="bi bi-receipt me-2"></i>Order Summary</h5>
                <% if (!cart.isEmpty()) {
                    double grandTotal = 0; int totalItems = 0;
                    for (CartItemBean item : cart.values()) { grandTotal += item.getLineTotal(); totalItems += item.getQuantity(); }
                %>
                <div class="summary-row"><span style="color:var(--qb-text-muted);">Items</span><span><%= cart.size() %> product(s)</span></div>
                <div class="summary-row"><span style="color:var(--qb-text-muted);">Quantity</span><span><%= totalItems %> units</span></div>
                <div class="summary-row total">
                    <span>Grand Total</span>
                    <span>₹<%= String.format("%.2f", grandTotal) %></span>
                </div>
                <form action="CartServlet" method="post" class="mt-3">
                    <input type="hidden" name="operation" value="checkout">
                    <button class="btn custom-bg w-100" type="submit" style="border-radius:50px;font-size:1rem;padding:12px;"
                            onclick="return confirm('Confirm checkout and generate bill?')">
                        <i class="bi bi-bag-check me-2"></i> Checkout & Pay
                    </button>
                </form>
                <% } else { %>
                <div style="color:var(--qb-text-muted);text-align:center;padding:20px 0;font-size:0.9rem;">Cart is empty</div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- My Bills -->
    <div class="page-section mt-4" id="bills">
        <h5 class="section-title mb-3"><i class="bi bi-receipt-cutoff me-2"></i>My Order History</h5>
        <% if (myBills == null || myBills.isEmpty()) { %>
        <div style="text-align:center;padding:40px;color:var(--qb-text-muted);">
            <i class="bi bi-inbox fs-2 d-block mb-2"></i>
            No orders yet. Start shopping to generate your first bill!
        </div>
        <% } else { %>
        <%
            for (BillRecordBean bill : myBills) {
        %>
        <div class="bill-card">
            <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                <div>
                    <div class="bill-id"><i class="bi bi-receipt me-2"></i><%= bill.getBillId() %></div>
                    <small style="color:var(--qb-text-muted);"><i class="bi bi-calendar3 me-1"></i><%= bill.getCreatedAt() %></small>
                </div>
                <div class="text-end">
                    <div style="color:var(--qb-green);font-weight:800;font-size:1.05rem;">₹<%= String.format("%.2f", bill.getTotalAmount()) %></div>
                    <small style="color:var(--qb-text-muted);"><%= bill.getTotalItems() %> item(s)</small>
                </div>
            </div>
            <% if (bill.getItems() != null && !bill.getItems().isEmpty()) { %>
            <div class="mt-2" style="font-size:0.8rem;color:#5a7a64;">
                Items: <%= bill.getItems().stream().map(i -> i.getProduct().getTitle() + " ×" + i.getQuantity()).collect(java.util.stream.Collectors.joining(", ")) %>
            </div>
            <% } %>
        </div>
        <% } %>
        <% } %>
    </div>
</div>
</body>
</html>

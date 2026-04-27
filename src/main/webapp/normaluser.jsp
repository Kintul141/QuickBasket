<%@page import="com.ecommerce.bean.UserBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    UserBean user = (UserBean) session.getAttribute("current_user");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if ("admin".equalsIgnoreCase(user.getUserType())) {
        response.sendRedirect("adminuser.jsp");
        return;
    }

    Map cartMap = (Map) session.getAttribute("cart");
    int totalCartItems = (cartMap != null) ? cartMap.size() : 0;

    List billList = (List) session.getAttribute("myBills");
    int totalBills = (billList != null) ? billList.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Dashboard - QuickBasket</title>
    <%@include file="/components/common_css.jsp"%>
</head>
<body>

<%@include file="/components/navbar.jsp"%>

<div class="container mt-4 mb-5">
    <%@include file="/components/message.jsp"%>

    <!-- Welcome Card -->
    <div class="user-welcome-card mb-4">
        <div class="row align-items-center">
            <div class="col">
                <span class="role-normal">Normal User</span>
                <h2 class="mt-2 mb-1" style="font-weight:800; color:#fff;">
                    Welcome, <%= user.getName() %>!
                </h2>
                <p style="color:#7aad8e; margin:0;">
                    Browse products, add to cart, and checkout easily.
                </p>
            </div>
            <div class="col-auto d-none d-md-block" style="font-size:4rem; opacity:0.5;">
                &#128722;
            </div>
        </div>
    </div>

    <!-- Stats Row -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="dash-card p-4 text-center">
                <div class="count"><%= totalCartItems %></div>
                <div class="label">Items in Cart</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="dash-card p-4 text-center">
                <div class="count"><%= totalBills %></div>
                <div class="label">Orders Placed</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="dash-card p-4 text-center">
                <div class="count">
                    <i class="bi bi-patch-check-fill" style="color:#22c55e;"></i>
                </div>
                <div class="label">Account Active</div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="page-section mb-4">
        <h5 class="section-title mb-3">
            <i class="bi bi-lightning-charge me-2"></i>Quick Actions
        </h5>
        <div class="row g-3">
            <div class="col-6 col-md-3">
                <a href="index.jsp" class="quick-action-btn">
                    <span class="icon">&#128717;</span>
                    Browse Products
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="cart.jsp" class="quick-action-btn">
                    <span class="icon">&#128722;</span>
                    My Cart
                    <% if (totalCartItems > 0) { %>
                    <span class="badge bg-success rounded-pill"><%= totalCartItems %></span>
                    <% } %>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="cart.jsp" class="quick-action-btn">
                    <span class="icon">&#129534;</span>
                    My Orders
                    <% if (totalBills > 0) { %>
                    <span class="badge bg-success rounded-pill"><%= totalBills %></span>
                    <% } %>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="LogoutServlet" class="quick-action-btn" style="border-color:rgba(239,68,68,0.25);">
                    <span class="icon">&#128274;</span>
                    Sign Out
                </a>
            </div>
        </div>
    </div>

    <!-- Account Info -->
    <div class="page-section">
        <h5 class="section-title mb-3">
            <i class="bi bi-person me-2"></i>Account Information
        </h5>
        <div class="row g-2">
            <div class="col-md-6">
                <div style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.07); border-radius:10px; padding:14px;">
                    <small style="color:#4a7055; text-transform:uppercase; letter-spacing:0.5px;">Full Name</small>
                    <div style="color:#e2f5e9; font-weight:600; margin-top:4px;">
                        <i class="bi bi-person me-2" style="color:#22c55e;"></i>
                        <%= user.getName() %>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.07); border-radius:10px; padding:14px;">
                    <small style="color:#4a7055; text-transform:uppercase; letter-spacing:0.5px;">Email</small>
                    <div style="color:#e2f5e9; font-weight:600; margin-top:4px;">
                        <i class="bi bi-envelope me-2" style="color:#22c55e;"></i>
                        <%= user.getEmail() %>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.07); border-radius:10px; padding:14px;">
                    <small style="color:#4a7055; text-transform:uppercase; letter-spacing:0.5px;">Phone</small>
                    <div style="color:#e2f5e9; font-weight:600; margin-top:4px;">
                        <i class="bi bi-telephone me-2" style="color:#22c55e;"></i>
                        <% if (user.getPhone() != null && user.getPhone().length() > 0) { %>
                            <%= user.getPhone() %>
                        <% } else { %>
                            Not set
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.07); border-radius:10px; padding:14px;">
                    <small style="color:#4a7055; text-transform:uppercase; letter-spacing:0.5px;">Location</small>
                    <div style="color:#e2f5e9; font-weight:600; margin-top:4px;">
                        <i class="bi bi-geo-alt me-2" style="color:#22c55e;"></i>
                        <% if (user.getLocation() != null && user.getLocation().length() > 0) { %>
                            <%= user.getLocation() %>
                        <% } else { %>
                            Not set
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
</body>
</html>
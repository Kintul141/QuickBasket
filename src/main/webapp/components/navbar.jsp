<%@page import="com.ecommerce.bean.UserBean"%>
<%@page import="com.ecommerce.bean.CategoryBean"%>
<%@page import="com.ecommerce.dao.CategoryDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    UserBean navUser = (UserBean) session.getAttribute("current_user");
    ArrayList<CategoryBean> navCategories = CategoryDao.getAllCategories();

    int navCartCount = 0;
    if (navUser != null && !"admin".equalsIgnoreCase(navUser.getUserType())) {
        Map navCartMap = (Map) session.getAttribute("cart");
        if (navCartMap != null) {
            navCartCount = navCartMap.size();
        }
    }

    String navUserType = "";
    if (navUser != null && navUser.getUserType() != null) {
        navUserType = navUser.getUserType();
    }
%>
<nav class="navbar navbar-expand-lg navbar-dark custom-bg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="home.jsp">QuickBasket
            <small style="font-size:0.6rem;font-weight:400;color:#4a7055;"> GROCERY</small>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarMain" aria-controls="navbarMain"
                aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarMain">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <li class="nav-item">
                    <a class="nav-link" href="index.jsp">
                        <i class="bi bi-shop me-1"></i>Shop
                    </a>
                </li>

                <% if (navUser != null && "admin".equalsIgnoreCase(navUserType)) { %>
                <li class="nav-item">
                    <a class="nav-link" href="adminuser.jsp">
                        <i class="bi bi-speedometer2 me-1"></i>Admin Panel
                    </a>
                </li>
                <% } %>

                <% if (navUser != null && !"admin".equalsIgnoreCase(navUserType)) { %>
                <li class="nav-item">
                    <a class="nav-link" href="normaluser.jsp">
                        <i class="bi bi-person-circle me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="cart.jsp">
                        <i class="bi bi-cart3 me-1"></i>Cart
                        <% if (navCartCount > 0) { %>
                        <span class="cart-count-badge"><%= navCartCount %></span>
                        <% } %>
                    </a>
                </li>
                <% } %>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="catDropdown"
                       role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-grid-3x3-gap me-1"></i>Categories
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="catDropdown">
                        <li><a class="dropdown-item" href="index.jsp">
                            <i class="bi bi-house me-1"></i>All Products
                        </a></li>
                        <li><hr class="dropdown-divider" style="border-color:rgba(255,255,255,0.08)"></li>
                        <% if (navCategories != null) {
                            for (CategoryBean nc : navCategories) { %>
                        <li><a class="dropdown-item" href="index.jsp?categoryId=<%= nc.getId() %>">
                            <i class="bi bi-tag me-1"></i><%= nc.getTitle() %>
                        </a></li>
                        <% } } %>
                    </ul>
                </li>

            </ul>

            <ul class="navbar-nav ms-auto align-items-center gap-1">
                <% if (navUser == null) { %>
                <li class="nav-item">
                    <a class="nav-link" href="login.jsp">
                        <i class="bi bi-box-arrow-in-right me-1"></i>Login
                    </a>
                </li>
                <li class="nav-item">
                    <a href="register.jsp" class="btn custom-bg btn-sm px-3" style="border-radius:50px;">
                        <i class="bi bi-person-plus me-1"></i>Sign Up
                    </a>
                </li>
                <% } else { %>
                <li class="nav-item">
                    <span class="nav-link" style="color:#4ade80;font-weight:600;">
                        <i class="bi bi-person-check me-1"></i><%= navUser.getName() %>
                        <% if ("admin".equalsIgnoreCase(navUserType)) { %>
                        <span class="badge ms-1 role-admin" style="font-size:0.65rem;">ADMIN</span>
                        <% } else { %>
                        <span class="badge ms-1 role-normal" style="font-size:0.65rem;">USER</span>
                        <% } %>
                    </span>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="LogoutServlet" style="color:#f87171;">
                        <i class="bi bi-box-arrow-right me-1"></i>Logout
                    </a>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

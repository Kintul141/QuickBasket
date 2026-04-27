<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%
    // If already logged in, redirect appropriately
    com.ecommerce.bean.UserBean existingUser = (com.ecommerce.bean.UserBean) session.getAttribute("current_user");
    if (existingUser != null) {
        if ("admin".equalsIgnoreCase(existingUser.getUserType())) {
            response.sendRedirect("adminuser.jsp");
        } else {
            response.sendRedirect("normaluser.jsp");
        }
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Sign Up – QuickBasket</title>
<meta name="description" content="Create your QuickBasket account and start shopping fresh groceries today.">
<%@include file="/components/common_css.jsp"%>
<style>
  body { min-height: 100vh; display: flex; flex-direction: column; }
  .register-wrapper {
    flex: 1;
    display: flex; align-items: center; justify-content: center;
    padding: 80px 16px 40px;
    background: radial-gradient(ellipse 70% 60% at 70% 40%, rgba(34,197,94,0.07) 0%, transparent 70%);
  }
  .register-card {
    width: 100%; max-width: 500px;
    background: var(--qb-bg-card);
    border: 1px solid var(--qb-green-border);
    border-radius: 20px;
    padding: 40px 36px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.4);
    animation: fadeInUp 0.4s ease both;
  }
  .reg-icon { font-size: 2.8rem; text-align: center; margin-bottom: 6px; }
  .reg-title { font-size: 1.5rem; font-weight: 800; color: #fff; text-align: center; margin-bottom: 4px; }
  .reg-sub { text-align: center; color: var(--qb-text-muted); font-size: 0.88rem; margin-bottom: 28px; }
  .input-group-icon { position: relative; }
  .input-group-icon .form-control { padding-left: 42px; }
  .input-group-icon .input-icon {
    position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
    color: #4a7055; font-size: 1rem; z-index: 5;
  }
  .btn-register {
    width: 100%;
    background: linear-gradient(135deg, #16a34a, #22c55e);
    color: #fff; border: none; font-weight: 700; font-size: 1rem;
    padding: 12px; border-radius: 50px;
    transition: all 0.25s;
    box-shadow: 0 6px 20px rgba(34,197,94,0.32);
  }
  .btn-register:hover { transform: translateY(-1px); box-shadow: 0 10px 28px rgba(34,197,94,0.42); color: #fff; }
  .error-msg { color: #f87171; font-size: 0.82rem; font-weight: 500; margin-top: 4px; }
  .back-home { text-align: center; margin-top: 16px; }
  .back-home a { color: var(--qb-text-muted); font-size: 0.85rem; text-decoration: none; }
  .back-home a:hover { color: var(--qb-green); }
</style>
</head>
<body>
<%@include file="/components/navbar.jsp"%>

<div class="register-wrapper">
  <div class="register-card">
    <%@include file="/components/message.jsp"%>

    <div class="reg-icon">🛒</div>
    <div class="reg-title">Create Account</div>
    <div class="reg-sub">Join QuickBasket and shop fresh groceries instantly</div>

    <%
        String regErr = (String) request.getAttribute("regErr");
        if (regErr != null) {
    %><div class="alert alert-danger py-2 text-center mb-3"><%= regErr %></div>
    <% } %>

    <form action="RegisterServlet" method="post" id="regForm">

      <!-- Full Name -->
      <div class="mb-3">
        <label class="form-label">Full Name</label>
        <div class="input-group-icon">
          <i class="bi bi-person input-icon"></i>
          <input type="text" name="username" class="form-control" placeholder="Enter Your Name" value="${ubean.name}" required>
        </div>
        <%
            String nameErr = (String) request.getAttribute("nameErr");
            if (nameErr != null) {
        %><div class="error-msg"><i class="bi bi-exclamation-circle me-1"></i><%= nameErr %></div>
        <% } %>
      </div>

      <!-- Email -->
      <div class="mb-3">
        <label class="form-label">Email Address</label>
        <div class="input-group-icon">
          <i class="bi bi-envelope input-icon"></i>
          <input type="email" name="email" class="form-control" placeholder="you@example.com" value="${ubean.email}" required>
        </div>
        <%
            String emailErr = (String) request.getAttribute("emailErr");
            if (emailErr != null) {
        %><div class="error-msg"><i class="bi bi-exclamation-circle me-1"></i><%= emailErr %></div>
        <% } %>
      </div>

      <!-- Password -->
      <div class="mb-3">
        <label class="form-label">Password</label>
        <div class="input-group-icon">
          <i class="bi bi-lock input-icon"></i>
          <input type="password" name="password" id="regPwd" class="form-control" placeholder="Choose a strong password" required>
        </div>
        <%
            String pwdErr = (String) request.getAttribute("pwdErr");
            if (pwdErr != null) {
        %><div class="error-msg"><i class="bi bi-exclamation-circle me-1"></i><%= pwdErr %></div>
        <% } %>
      </div>

      <!-- Phone -->
      <div class="mb-3">
        <label class="form-label">Phone Number</label>
        <div class="input-group-icon">
          <i class="bi bi-telephone input-icon"></i>
          <input type="tel" name="phone" class="form-control" placeholder="10-digit number" pattern="[0-9]{10}" value="${ubean.phone}" required>
        </div>
        <%
            String phoneErr = (String) request.getAttribute("phoneErr");
            if (phoneErr != null) {
        %><div class="error-msg"><i class="bi bi-exclamation-circle me-1"></i><%= phoneErr %></div>
        <% } %>
      </div>

      <!-- Location -->
      <div class="mb-4">
        <label class="form-label">Location / City</label>
        <div class="input-group-icon">
          <i class="bi bi-geo-alt input-icon"></i>
          <input type="text" name="location" class="form-control" placeholder="Mumbai, Delhi, ..." value="${ubean.location}" required>
        </div>
        <%
            String addressErr = (String) request.getAttribute("addressErr");
            if (addressErr != null) {
        %><div class="error-msg"><i class="bi bi-exclamation-circle me-1"></i><%= addressErr %></div>
        <% } %>
      </div>

      

      <button type="submit" class="btn btn-register" id="regBtn">
        <i class="bi bi-person-plus me-2"></i>Create Account
      </button>
    </form>

    <div class="divider-text my-4">or</div>

    <div class="text-center">
      <span style="color:var(--qb-text-muted);font-size:0.88rem;">Already have an account?</span>
      <a href="login.jsp" class="qb-link ms-1" style="font-size:0.88rem;">Sign in →</a>
    </div>

    <div class="back-home">
      <a href="home.jsp"><i class="bi bi-arrow-left me-1"></i>Back to Home</a>
    </div>
  </div>
</div>

<script>
document.getElementById('regForm').addEventListener('submit', function(e) {
  const btn = document.getElementById('regBtn');
  btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Creating account...';
  btn.disabled = true;
});
</script>
</body>
</html>

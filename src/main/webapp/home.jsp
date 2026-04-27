<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/components/common_css.jsp"%>
<%
    com.ecommerce.bean.UserBean homeUser = (com.ecommerce.bean.UserBean) session.getAttribute("current_user");
    if (homeUser != null) {
        if ("admin".equalsIgnoreCase(homeUser.getUserType())) {
            response.sendRedirect("adminuser.jsp");
            return;
        } else {
            response.sendRedirect("normaluser.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>QuickBasket – Fresh Groceries Delivered Fast</title>
<meta name="description" content="Shop fresh groceries, dairy, fruits, vegetables, and home essentials at QuickBasket. Fast checkout, great prices.">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
  * { font-family: 'Inter', sans-serif; }
  body { background: #0a1a0e; color: #f0f9f3; overflow-x: hidden; margin: 0; }

  /* ── HERO ── */
  .hero-section {
    min-height: 100vh;
    background: linear-gradient(135deg, #0a1a0e 0%, #0f2d18 50%, #0a1a0e 100%);
    display: flex; align-items: center; position: relative; overflow: hidden;
  }
  .hero-section::before {
    content: '';
    position: absolute; inset: 0;
    background: radial-gradient(ellipse 80% 60% at 60% 40%, rgba(34,197,94,0.12) 0%, transparent 70%);
    pointer-events: none;
  }
  .hero-badge {
    display: inline-flex; align-items: center; gap: 8px;
    background: rgba(34,197,94,0.12); border: 1px solid rgba(34,197,94,0.25);
    color: #4ade80; border-radius: 100px; padding: 6px 16px; font-size: 0.82rem; font-weight: 600;
    letter-spacing: 0.5px; margin-bottom: 1.5rem;
  }
  .hero-badge span { width: 7px; height: 7px; background: #4ade80; border-radius: 50%; display: inline-block; animation: pulse-dot 1.8s ease-in-out infinite; }
  @keyframes pulse-dot { 0%,100%{opacity:1;transform:scale(1)} 50%{opacity:0.5;transform:scale(1.4)} }

  .hero-title {
    font-size: clamp(2.6rem, 6vw, 4.2rem); font-weight: 900; line-height: 1.1;
    color: #fff; margin-bottom: 1.2rem;
  }
  .hero-title .accent { color: #4ade80; }
  .hero-sub {
    font-size: 1.15rem; color: #9dcfac; max-width: 520px; line-height: 1.7; margin-bottom: 2.2rem;
  }
  .btn-hero-primary {
    background: linear-gradient(135deg, #16a34a, #22c55e);
    color: #fff; border: none; padding: 14px 36px; font-size: 1.05rem; font-weight: 700;
    border-radius: 50px; cursor: pointer; transition: all 0.3s; box-shadow: 0 8px 24px rgba(34,197,94,0.35);
    text-decoration: none; display: inline-block;
  }
  .btn-hero-primary:hover { transform: translateY(-2px); box-shadow: 0 12px 32px rgba(34,197,94,0.45); color: #fff; }
  .btn-hero-secondary {
    background: transparent; color: #86efac; border: 2px solid rgba(134,239,172,0.35);
    padding: 12px 32px; font-size: 1.05rem; font-weight: 600;
    border-radius: 50px; cursor: pointer; transition: all 0.3s;
    text-decoration: none; display: inline-block;
  }
  .btn-hero-secondary:hover { background: rgba(134,239,172,0.08); color: #86efac; border-color: rgba(134,239,172,0.6); }

  /* floating grocery emojis */
  .floating-item { position: absolute; font-size: 2.8rem; animation: float-up 8s ease-in-out infinite; opacity: 0.18; user-select: none; pointer-events: none; }
  @keyframes float-up { 0%,100%{transform:translateY(0) rotate(0deg)} 33%{transform:translateY(-20px) rotate(5deg)} 66%{transform:translateY(-10px) rotate(-3deg)} }

  /* hero stats */
  .stat-pill {
    display: inline-flex; flex-direction: column; align-items: center;
    background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.09);
    border-radius: 14px; padding: 14px 24px; backdrop-filter: blur(8px);
  }
  .stat-pill .num { font-size: 1.6rem; font-weight: 800; color: #4ade80; }
  .stat-pill .lbl { font-size: 0.78rem; color: #86efac; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }

  /* ── FEATURES ── */
  .features-section { background: #0e2316; padding: 90px 0; }
  .section-tag { color: #4ade80; font-weight: 700; font-size: 0.82rem; text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 0.5rem; }
  .section-title { font-size: 2.2rem; font-weight: 800; color: #f0f9f3; margin-bottom: 1rem; }
  .section-sub { color: #7ab893; font-size: 1rem; max-width: 550px; margin: 0 auto 3rem; }

  .feature-card {
    background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08);
    border-radius: 20px; padding: 32px 28px; transition: all 0.3s; height: 100%;
  }
  .feature-card:hover { transform: translateY(-6px); border-color: rgba(74,222,128,0.3); background: rgba(74,222,128,0.05); box-shadow: 0 20px 40px rgba(0,0,0,0.3); }
  .feature-icon { font-size: 2.4rem; margin-bottom: 16px; }
  .feature-card h5 { color: #e2faea; font-weight: 700; font-size: 1.1rem; margin-bottom: 8px; }
  .feature-card p { color: #7ab893; font-size: 0.9rem; line-height: 1.65; margin: 0; }

  /* ── CATEGORIES PREVIEW ── */
  .categories-section { background: #0a1a0e; padding: 80px 0; }
  .cat-badge {
    background: rgba(74,222,128,0.08); border: 1px solid rgba(74,222,128,0.2);
    border-radius: 16px; padding: 24px 20px; text-align: center;
    transition: all 0.3s; cursor: pointer; text-decoration: none; display: block;
  }
  .cat-badge:hover { background: rgba(74,222,128,0.15); border-color: rgba(74,222,128,0.45); transform: scale(1.04); }
  .cat-badge .emoji { font-size: 2.5rem; margin-bottom: 8px; display: block; }
  .cat-badge .name { color: #86efac; font-weight: 600; font-size: 0.88rem; }

  /* ── CTA ── */
  .cta-section {
    background: linear-gradient(135deg, #14532d 0%, #166534 50%, #14532d 100%);
    padding: 90px 0; position: relative; overflow: hidden;
  }
  .cta-section::before {
    content: ''; position: absolute; inset: 0;
    background: radial-gradient(ellipse 60% 80% at 50% 50%, rgba(74,222,128,0.15) 0%, transparent 70%);
  }
  .cta-title { font-size: 2.6rem; font-weight: 900; color: #fff; margin-bottom: 1rem; }
  .cta-sub { color: #bbf7d0; font-size: 1.05rem; margin-bottom: 2.2rem; }

  /* ── NAVBAR ── */
  .home-navbar {
    position: fixed; top: 0; left: 0; right: 0; z-index: 1000;
    padding: 18px 0;
    background: rgba(10, 26, 14, 0.85); backdrop-filter: blur(12px);
    border-bottom: 1px solid rgba(255,255,255,0.06);
    transition: all 0.3s;
  }
  .home-navbar.scrolled { padding: 12px 0; background: rgba(10,26,14,0.98); }
  .nav-brand { font-size: 1.3rem; font-weight: 800; color: #4ade80 !important; text-decoration: none; letter-spacing: -0.5px; }
  .nav-brand span { color: #fff; }
  .nav-links { display: flex; align-items: center; gap: 28px; list-style: none; margin: 0; padding: 0; }
  .nav-links a { color: #9dcfac; font-weight: 500; text-decoration: none; font-size: 0.92rem; transition: color 0.2s; }
  .nav-links a:hover { color: #4ade80; }
  .nav-cta { display: flex; align-items: center; gap: 12px; }
  .btn-nav-login { color: #86efac; background: transparent; border: 1px solid rgba(134,239,172,0.3); padding: 8px 22px; border-radius: 50px; font-weight: 600; font-size: 0.88rem; text-decoration: none; transition: all 0.2s; }
  .btn-nav-login:hover { border-color: #4ade80; color: #4ade80; }
  .btn-nav-signup { color: #fff; background: linear-gradient(135deg, #16a34a, #22c55e); border: none; padding: 8px 22px; border-radius: 50px; font-weight: 700; font-size: 0.88rem; text-decoration: none; transition: all 0.2s; }
  .btn-nav-signup:hover { box-shadow: 0 4px 16px rgba(34,197,94,0.4); color: #fff; }

  /* ── FOOTER ── */
  .home-footer { background: #050f08; padding: 40px 0; border-top: 1px solid rgba(255,255,255,0.06); }
  .footer-text { color: #4a7055; font-size: 0.88rem; }
  .footer-brand { color: #4ade80; font-weight: 700; }
</style>
</head>
<body>

<!-- Fixed Navbar -->
<nav class="home-navbar" id="homeNav">
  <div class="container d-flex align-items-center justify-content-between">
    <a class="nav-brand" href="home.jsp">Quick<span>Basket</span></a>
    <ul class="nav-links d-none d-lg-flex">
      <li><a href="#features">Features</a></li>
      <li><a href="#categories">Categories</a></li>
      <li><a href="index.jsp">Shop Now</a></li>
    </ul>
    <div class="nav-cta">
      <a href="login.jsp" class="btn-nav-login">Login</a>
      <a href="register.jsp" class="btn-nav-signup">Sign Up Free</a>
    </div>
  </div>
</nav>

<!-- ── HERO ── -->
<section class="hero-section" id="hero">
  <!-- floating emojis -->
  <span class="floating-item" style="top:15%;left:5%;animation-delay:0s;">🥦</span>
  <span class="floating-item" style="top:70%;left:8%;animation-delay:1.5s;">🍎</span>
  <span class="floating-item" style="top:25%;right:6%;animation-delay:0.7s;">🥕</span>
  <span class="floating-item" style="top:60%;right:10%;animation-delay:2.2s;">🧀</span>
  <span class="floating-item" style="top:80%;right:3%;animation-delay:1s;">🍌</span>
  <span class="floating-item" style="top:10%;right:20%;animation-delay:3s;">🍓</span>

  <div class="container" style="position:relative;z-index:2;">
    <div class="row align-items-center min-vh-100 py-5">
      <div class="col-lg-7 py-5">
        <div class="hero-badge"><span></span> Fresh · Local · Fast Delivery</div>
        <h1 class="hero-title">
          Your Daily Groceries,<br>
          <span class="accent">One Basket Away</span>
        </h1>
        <p class="hero-sub">
          Shop fresh fruits, vegetables, dairy, snacks, and home essentials — 
          all in one place. Simple cart, instant checkout, and real-time billing.
        </p>
        <div class="d-flex flex-wrap gap-3 mb-5">
          <a href="register.jsp" class="btn-hero-primary">
            🛒 &nbsp;Start Shopping Free
          </a>
          <a href="login.jsp" class="btn-hero-secondary">
            Already a Member? Login →
          </a>
        </div>
        <div class="d-flex flex-wrap gap-3">
          <div class="stat-pill"><span class="num">500+</span><span class="lbl">Products</span></div>
          <div class="stat-pill"><span class="num">10K+</span><span class="lbl">Happy Users</span></div>
          <div class="stat-pill"><span class="num">24/7</span><span class="lbl">Support</span></div>
        </div>
      </div>
      <div class="col-lg-5 d-none d-lg-flex align-items-center justify-content-center">
        <div style="font-size: 9rem; text-align: center; line-height: 1.2; filter: drop-shadow(0 0 40px rgba(74,222,128,0.3));">
          🛒<br>
          <span style="font-size:5rem;">🥬🍊🥛</span>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ── FEATURES ── -->
<section class="features-section" id="features">
  <div class="container">
    <div class="text-center mb-5">
      <div class="section-tag">Why QuickBasket?</div>
      <h2 class="section-title">Everything You Need, Simplified</h2>
      <p class="section-sub">A smooth grocery experience built for speed, simplicity, and freshness.</p>
    </div>
    <div class="row g-4">
      <div class="col-md-6 col-lg-3">
        <div class="feature-card">
          <div class="feature-icon">🚀</div>
          <h5>Instant Add to Cart</h5>
          <p>Add any product to your cart in one click. Quantities update in real time with your session.</p>
        </div>
      </div>
      <div class="col-md-6 col-lg-3">
        <div class="feature-card">
          <div class="feature-icon">💰</div>
          <h5>Auto Discount Pricing</h5>
          <p>Discounts are applied automatically. See your savings clearly before you checkout.</p>
        </div>
      </div>
      <div class="col-md-6 col-lg-3">
        <div class="feature-card">
          <div class="feature-icon">🧾</div>
          <h5>Instant Bill Generation</h5>
          <p>After checkout, get a unique bill ID with itemised totals — stored for your reference.</p>
        </div>
      </div>
      <div class="col-md-6 col-lg-3">
        <div class="feature-card">
          <div class="feature-icon">🔒</div>
          <h5>Secure Role-Based Access</h5>
          <p>Shoppers and admins have separate dashboards. Sessions are protected per user login.</p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ── CATEGORIES PREVIEW ── -->
<section class="categories-section" id="categories">
  <div class="container">
    <div class="text-center mb-5">
      <div class="section-tag">Browse by Category</div>
      <h2 class="section-title">Fresh in Every Section</h2>
    </div>
    <div class="row g-3 justify-content-center">
      <div class="col-6 col-md-4 col-lg-2">
        <a class="cat-badge" href="index.jsp"><span class="emoji">🥦</span><span class="name">Vegetables</span></a>
      </div>
      <div class="col-6 col-md-4 col-lg-2">
        <a class="cat-badge" href="index.jsp"><span class="emoji">🍊</span><span class="name">Fruits</span></a>
      </div>
      <div class="col-6 col-md-4 col-lg-2">
        <a class="cat-badge" href="index.jsp"><span class="emoji">🥛</span><span class="name">Dairy</span></a>
      </div>
      <div class="col-6 col-md-4 col-lg-2">
        <a class="cat-badge" href="index.jsp"><span class="emoji">🍪</span><span class="name">Snacks</span></a>
      </div>
      <div class="col-6 col-md-4 col-lg-2">
        <a class="cat-badge" href="index.jsp"><span class="emoji">🧴</span><span class="name">Essentials</span></a>
      </div>
      <div class="col-6 col-md-4 col-lg-2">
        <a class="cat-badge" href="index.jsp"><span class="emoji">🥩</span><span class="name">Meat & Fish</span></a>
      </div>
    </div>
    <div class="text-center mt-4">
      <a href="index.jsp" class="btn-hero-secondary" style="font-size:0.95rem; padding:12px 30px;">View All Products →</a>
    </div>
  </div>
</section>

<!-- ── CTA ── -->
<section class="cta-section">
  <div class="container text-center" style="position:relative;z-index:2;">
    <div class="cta-title">Ready to Fill Your Basket?</div>
    <p class="cta-sub">Join thousands of happy customers shopping fresh every day.</p>
    <div class="d-flex justify-content-center gap-3 flex-wrap">
      <a href="register.jsp" class="btn-hero-primary">Create Free Account</a>
      <a href="index.jsp" class="btn-hero-secondary" style="color:#bbf7d0;border-color:rgba(187,247,208,0.35);">Browse Without Account</a>
    </div>
  </div>
</section>

<!-- ── FOOTER ── -->
<footer class="home-footer">
  <div class="container text-center">
    <p class="footer-text mb-1">© 2026 <span class="footer-brand">QuickBasket</span> — Fresh Groceries for Everyone</p>
    <p class="footer-text mb-0" style="font-size:0.8rem;">Built with ☕ Java Servlets + JSP + Bootstrap 5 + MySQL</p>
  </div>
</footer>

<script>
  const nav = document.getElementById('homeNav');
  window.addEventListener('scroll', () => {
    nav.classList.toggle('scrolled', window.scrollY > 60);
  });
</script>
</body>
</html>

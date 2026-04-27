<%@page import="com.ecommerce.dao.ProductDao"%>
<%@page import="com.ecommerce.bean.ProductBean"%>
<%@page import="com.ecommerce.dao.CategoryDao"%>
<%@page import="com.ecommerce.bean.CategoryBean"%>
<%@page import="com.ecommerce.dao.UserDao"%>
<%@page import="com.ecommerce.bean.BillRecordBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.ecommerce.bean.UserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    UserBean user = (UserBean) session.getAttribute("current_user");
    if (user == null) {
        request.setAttribute("loginErr", "You must be logged in to access admin panel.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }
    if (!"admin".equalsIgnoreCase(user.getUserType())) {
        request.setAttribute("loginErr", "Access denied. Admin only area.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }

    ArrayList<UserBean> users       = UserDao.getAllUsers();
    ArrayList<CategoryBean> catlist = CategoryDao.getAllCategories();
    ArrayList<ProductBean> products = ProductDao.getAllProducts();
    int userCount     = users    == null ? 0 : users.size();
    int categoryCount = catlist  == null ? 0 : catlist.size();
    int productCount  = products == null ? 0 : products.size();

    @SuppressWarnings("unchecked")
    List<BillRecordBean> allBills = (List<BillRecordBean>) application.getAttribute("allBills");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Dashboard – QuickBasket</title>
<%@include file="/components/common_css.jsp"%>
<style>
  .admin-welcome {
    background: linear-gradient(135deg, #0a1a0e 0%, #14532d 100%);
    border: 1px solid var(--qb-green-border);
    border-radius: 18px; padding: 28px 30px;
    position: relative; overflow: hidden;
  }
  .admin-welcome::after { content: '⚙️'; position: absolute; right: 24px; top: 50%; transform: translateY(-50%); font-size: 5rem; opacity: 0.08; user-select: none; }
  .tab-nav { border-bottom: 1px solid rgba(255,255,255,0.08); margin-bottom: 20px; }
  .tab-nav .nav-link { color: var(--qb-text-muted); font-weight: 600; font-size: 0.88rem; border: none; padding: 10px 18px; border-radius: 0; border-bottom: 2px solid transparent; }
  .tab-nav .nav-link.active, .tab-nav .nav-link:hover { color: var(--qb-green); border-bottom-color: var(--qb-green); background: transparent; }
</style>
</head>
<body>
<%@include file="/components/navbar.jsp"%>

<div class="container mt-4 mb-5 fade-in-up">
    <%@include file="/components/message.jsp"%>

    <!-- Admin Welcome -->
    <div class="admin-welcome mb-4">
        <div class="d-flex align-items-start justify-content-between flex-wrap gap-3">
            <div>
                <div class="mb-2"><span class="role-admin"><i class="bi bi-shield-check me-1"></i>Administrator</span></div>
                <h2 class="fw-bold mb-1" style="color:#fff;">Admin Control Panel</h2>
                <p class="mb-0" style="color:#7aad8e;font-size:0.9rem;">
                    Manage products, categories, users and monitor all generated bills.
                </p>
            </div>
            <div style="color:#fff;font-size:0.88rem;font-weight:600;opacity:0.7;">
                <i class="bi bi-person-circle me-1"></i><%= user.getName() %>
            </div>
        </div>
    </div>

    <!-- Stats -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="dash-card p-4 text-center">
                <div class="count"><%= userCount %></div>
                <div class="label"><i class="bi bi-people me-1"></i>Users</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="dash-card p-4 text-center">
                <div class="count"><%= categoryCount %></div>
                <div class="label"><i class="bi bi-grid me-1"></i>Categories</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="dash-card p-4 text-center">
                <div class="count"><%= productCount %></div>
                <div class="label"><i class="bi bi-box-seam me-1"></i>Products</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="dash-card p-4 text-center">
                <div class="count"><%= allBills == null ? 0 : allBills.size() %></div>
                <div class="label"><i class="bi bi-receipt me-1"></i>Bills Generated</div>
            </div>
        </div>
    </div>

    <!-- Quick Action Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="dash-card action-card p-4 text-center" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                <div style="font-size:2.5rem;margin-bottom:12px;">📂</div>
                <h6 class="section-title mb-1">Add Category</h6>
                <small class="muted-small">Create new grocery category</small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="dash-card action-card p-4 text-center" data-bs-toggle="modal" data-bs-target="#addProductModal">
                <div style="font-size:2.5rem;margin-bottom:12px;">📦</div>
                <h6 class="section-title mb-1">Add Product</h6>
                <small class="muted-small">Publish a new product</small>
            </div>
        </div>
        <div class="col-md-3">
            <a href="#usersSection" class="dash-card action-card p-4 text-center d-block text-decoration-none">
                <div style="font-size:2.5rem;margin-bottom:12px;">👥</div>
                <h6 class="section-title mb-1">Manage Users</h6>
                <small class="muted-small">View &amp; update roles</small>
            </a>
        </div>
        <div class="col-md-3">
            <a href="#billsSection" class="dash-card action-card p-4 text-center d-block text-decoration-none">
                <div style="font-size:2.5rem;margin-bottom:12px;">🧾</div>
                <h6 class="section-title mb-1">View Bills</h6>
                <small class="muted-small">All orders &amp; revenue</small>
            </a>
        </div>
    </div>

    <!-- ── PRODUCTS TABLE ── -->
    <div class="page-section mb-4" id="productsSection">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="section-title mb-0"><i class="bi bi-box-seam me-2"></i>Product Catalogue</h5>
            <button class="btn custom-bg btn-sm px-3" data-bs-toggle="modal" data-bs-target="#addProductModal" style="border-radius:50px;">
                <i class="bi bi-plus-lg me-1"></i>Add Product
            </button>
        </div>
        <div class="table-responsive themed-table">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Title</th>
                        <th>Price</th>
                        <th>Discount</th>
                        <th>Stock</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (products != null && !products.isEmpty()) {
                       for (ProductBean p : products) {
                           double finalPrice = p.getPrice() - (p.getPrice() * p.getDiscount() / 100.0);
                    %>
                    <tr>
                        <td style="color:var(--qb-text-muted);font-size:0.8rem;">#<%= p.getId() %></td>
                        <td>
                            <div style="font-weight:600;color:#e2f5e9;"><%= p.getTitle() %></div>
                            <small style="color:var(--qb-text-muted)"><%= p.getDescription().length() > 50 ? p.getDescription().substring(0,50) + "…" : p.getDescription() %></small>
                        </td>
                        <td>
                            <span style="color:var(--qb-green);font-weight:700;">₹<%= String.format("%.0f", finalPrice) %></span>
                            <% if (p.getDiscount() > 0) { %>
                            <small style="color:#5a7a64;text-decoration:line-through;margin-left:4px;">₹<%= p.getPrice() %></small>
                            <% } %>
                        </td>
                        <td>
                            <% if (p.getDiscount() > 0) { %>
                            <span class="discount-badge"><%= p.getDiscount() %>% OFF</span>
                            <% } else { %><span style="color:#4a7055;">—</span><% } %>
                        </td>
                        <td>
                            <span style="color:<%= p.getQnty() > 5 ? "#4ade80" : p.getQnty() > 0 ? "#f59e0b" : "#ef4444" %>;font-weight:600;">
                                <%= p.getQnty() %>
                            </span>
                        </td>
                        <td>
                            <button class="btn btn-sm btn-outline-success me-1" style="border-radius:6px;font-size:0.75rem;"
                                    data-bs-toggle="modal" data-bs-target="#editProductModal"
                                    onclick="fillEditModal(<%= p.getId() %>, '<%= p.getTitle().replace("'", "\\'") %>', '<%= p.getDescription().replace("'", "\\'") %>', <%= p.getPrice() %>, <%= p.getDiscount() %>, <%= p.getQnty() %>, <%= p.getCid() %>)">
                                <i class="bi bi-pencil-square"></i> Edit
                            </button>
                            <form action="ProductOperationServlet" method="post" class="d-inline">
                                <input type="hidden" name="operation" value="deleteproduct">
                                <input type="hidden" name="productId" value="<%= p.getId() %>">
                                <button class="btn btn-sm btn-danger" style="border-radius:6px;font-size:0.75rem;"
                                        type="submit" onclick="return confirm('Delete product: <%= p.getTitle().replace("'", "\\'") %>?')">
                                    <i class="bi bi-trash3"></i> Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                    <%
                       }
                    } else { %>
                    <tr><td colspan="6" class="text-center" style="color:var(--qb-text-muted);padding:30px;">No products yet. Add your first product above.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ── USERS TABLE ── -->
    <div class="page-section mb-4" id="usersSection">
        <h5 class="section-title mb-3"><i class="bi bi-people me-2"></i>Registered Users</h5>
        <div class="table-responsive themed-table">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th>#ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Location</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (users != null) {
                       for (UserBean u : users) {
                           String role = u.getUserType() != null ? u.getUserType() : "normal";
                    %>
                    <tr>
                        <td style="color:var(--qb-text-muted);font-size:0.8rem;">#<%= u.getId() %></td>
                        <td style="font-weight:600;color:#e2f5e9;"><%= u.getName() %></td>
                        <td style="font-size:0.85rem;"><%= u.getEmail() %></td>
                        <td style="font-size:0.85rem;"><%= u.getPhone() != null ? u.getPhone() : "—" %></td>
                        <td style="font-size:0.85rem;"><%= u.getLocation() != null ? u.getLocation() : "—" %></td>
                        <td>
                            <% if (u.getId() == user.getId()) { %>
                            <span class="role-admin"><%= role.toUpperCase() %> (You)</span>
                            <% } else { %>
                            <span class="<%= "admin".equalsIgnoreCase(role) ? "role-admin" : "role-normal" %>">
                                <%= role.toUpperCase() %>
                            </span>
                            <% } %>
                        </td>
                        <td>
                            <% if (u.getId() != user.getId()) { %>
                            <form action="UserManagementServlet" method="post" class="d-inline">
                                <input type="hidden" name="operation" value="updateRole">
                                <input type="hidden" name="userId" value="<%= u.getId() %>">
                                <input type="hidden" name="newRole" value="<%= "admin".equalsIgnoreCase(role) ? "normal" : "admin" %>">
                                <button class="btn btn-sm btn-outline-success me-1" style="border-radius:6px;font-size:0.75rem;" type="submit"
                                        onclick="return confirm('Change role of <%= u.getName().replace("'", "\\'") %> to <%= "admin".equalsIgnoreCase(role) ? "normal" : "admin" %>?')">
                                    <i class="bi bi-arrow-repeat me-1"></i>
                                    Make <%= "admin".equalsIgnoreCase(role) ? "Normal" : "Admin" %>
                                </button>
                            </form>
                            <form action="UserManagementServlet" method="post" class="d-inline">
                                <input type="hidden" name="operation" value="deleteUser">
                                <input type="hidden" name="userId" value="<%= u.getId() %>">
                                <button class="btn btn-sm btn-danger" style="border-radius:6px;font-size:0.75rem;" type="submit"
                                        onclick="return confirm('Delete user: <%= u.getName().replace("'", "\\'") %>? This cannot be undone.')">
                                    <i class="bi bi-person-dash"></i> Delete
                                </button>
                            </form>
                            <% } else { %>
                            <span class="badge bg-secondary" style="font-size:0.72rem;">Current Admin</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                       }
                    } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ── BILLS TABLE ── -->
    <div class="page-section" id="billsSection">
        <h5 class="section-title mb-3"><i class="bi bi-receipt-cutoff me-2"></i>All Customer Orders / Bills</h5>
        <% if (allBills == null || allBills.isEmpty()) { %>
        <div style="text-align:center;padding:40px;color:var(--qb-text-muted);">
            <i class="bi bi-inbox fs-2 d-block mb-2"></i>No bills generated yet.
        </div>
        <% } else { %>
        <div class="table-responsive themed-table">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th>Bill ID</th>
                        <th>Customer</th>
                        <th>Email</th>
                        <th>Date</th>
                        <th>Items</th>
                        <th>Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (BillRecordBean bill : allBills) { %>
                    <tr>
                        <td style="font-family:'Courier New',monospace;font-weight:700;color:var(--qb-green);font-size:0.85rem;"><%= bill.getBillId() %></td>
                        <td style="font-weight:600;"><%= bill.getUserName() %></td>
                        <td style="font-size:0.85rem;"><%= bill.getUserEmail() %></td>
                        <td style="font-size:0.82rem;color:var(--qb-text-muted);"><%= bill.getCreatedAt() %></td>
                        <td><%= bill.getTotalItems() %></td>
                        <td style="color:var(--qb-green);font-weight:700;">₹<%= String.format("%.2f", bill.getTotalAmount()) %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>

<!-- ══ MODAL: Add Category ══ -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCatLabel" aria-hidden="true">
    <div class="modal-dialog modal-md">
        <div class="modal-content">
            <div class="modal-header custom-bg text-white">
                <h5 class="modal-title" id="addCatLabel"><i class="bi bi-folder-plus me-2"></i>Add Category</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="ProductOperationServlet" method="post">
                    <input type="hidden" name="operation" value="addcategory">
                    <div class="mb-3">
                        <label class="form-label">Category Title</label>
                        <input type="text" class="form-control" name="title" placeholder="e.g. Fruits & Vegetables" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea rows="4" class="form-control" name="description" placeholder="Brief category description..." required></textarea>
                    </div>
                    <div class="d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button class="btn custom-bg px-4" type="submit"><i class="bi bi-plus-lg me-1"></i>Add Category</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- ══ MODAL: Add Product ══ -->
<div class="modal fade" id="addProductModal" tabindex="-1" aria-labelledby="addProdLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header custom-bg text-white">
                <h5 class="modal-title" id="addProdLabel"><i class="bi bi-box-seam me-2"></i>Add New Product</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="ProductOperationServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="operation" value="addproduct">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Product Title</label>
                            <input type="text" class="form-control" name="title" placeholder="Fresh Mango, etc." required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Category</label>
                            <select class="form-select" name="catId" required>
                                <option value="" selected disabled>-- Select Category --</option>
                                <% if (catlist != null) { for (CategoryBean cbean : catlist) { %>
                                <option value="<%= cbean.getId() %>"><%= cbean.getTitle() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Description</label>
                            <textarea rows="3" class="form-control" name="description" placeholder="Product description..." required></textarea>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Price (₹)</label>
                            <input type="number" class="form-control" name="price" min="0" placeholder="120" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Discount (%)</label>
                            <input type="number" class="form-control" name="discount" min="0" max="100" placeholder="10" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Stock Quantity</label>
                            <input type="number" class="form-control" name="qnty" min="0" placeholder="50" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Product Image</label>
                            <input type="file" class="form-control" name="prodimage" accept="image/*" required>
                        </div>
                    </div>
                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button class="btn custom-bg px-4" type="submit"><i class="bi bi-upload me-1"></i>Add Product</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- ══ MODAL: Edit Product ══ -->
<div class="modal fade" id="editProductModal" tabindex="-1" aria-labelledby="editProdLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header custom-bg text-white">
                <h5 class="modal-title" id="editProdLabel"><i class="bi bi-pencil-square me-2"></i>Edit Product</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="ProductOperationServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="operation" value="editproduct">
                    <input type="hidden" name="productId" id="editProductId">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Product Title</label>
                            <input type="text" class="form-control" name="title" id="editTitle" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Category</label>
                            <select class="form-select" name="catId" id="editCatId" required>
                                <% if (catlist != null) { for (CategoryBean cbean : catlist) { %>
                                <option value="<%= cbean.getId() %>"><%= cbean.getTitle() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Description</label>
                            <textarea rows="3" class="form-control" name="description" id="editDescription" required></textarea>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Price (₹)</label>
                            <input type="number" class="form-control" name="price" id="editPrice" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Discount (%)</label>
                            <input type="number" class="form-control" name="discount" id="editDiscount" min="0" max="100" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Stock Quantity</label>
                            <input type="number" class="form-control" name="qnty" id="editQnty" min="0" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label">New Product Image <small class="text-muted">(optional)</small></label>
                            <input type="file" class="form-control" name="prodimage" accept="image/*">
                        </div>
                    </div>
                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button class="btn custom-bg px-4" type="submit"><i class="bi bi-check-circle me-1"></i>Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
function fillEditModal(id, title, description, price, discount, qnty, catId) {
    document.getElementById('editProductId').value   = id;
    document.getElementById('editTitle').value        = title;
    document.getElementById('editDescription').value  = description;
    document.getElementById('editPrice').value        = price;
    document.getElementById('editDiscount').value     = discount;
    document.getElementById('editQnty').value         = qnty;
    const catSelect = document.getElementById('editCatId');
    if (catSelect) {
        for (let opt of catSelect.options) {
            opt.selected = (parseInt(opt.value) === catId);
        }
    }
}
</script>
</body>
</html>

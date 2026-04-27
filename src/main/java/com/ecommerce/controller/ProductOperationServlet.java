package com.ecommerce.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.ecommerce.bean.CategoryBean;
import com.ecommerce.bean.ProductBean;
import com.ecommerce.bean.UserBean;
import com.ecommerce.dao.CategoryDao;
import com.ecommerce.dao.ProductDao;

@WebServlet(name = "ProductOperationServlet", urlPatterns = {"/ProductOperationServlet"})
@MultipartConfig
public class ProductOperationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Admin guard
        UserBean currentUser = (UserBean) session.getAttribute("current_user");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getUserType())) {
            session.setAttribute("failedmsg", "Access denied. Admin only.");
            response.sendRedirect("login.jsp");
            return;
        }

        String op = request.getParameter("operation");
        if (op == null || op.trim().isEmpty()) {
            session.setAttribute("failedmsg", "Invalid operation.");
            response.sendRedirect("adminuser.jsp");
            return;
        }

        // ── ADD CATEGORY ──
        if (op.trim().equals("addcategory")) {
            String catTitle = request.getParameter("title");
            String catDescription = request.getParameter("description");

            CategoryBean cbean = new CategoryBean();
            cbean.setTitle(catTitle);
            cbean.setDescription(catDescription);

            int rowsAffected = CategoryDao.addCategory(cbean);
            if (rowsAffected > 0) {
                session.setAttribute("successmsg", "Category '" + catTitle + "' added successfully.");
            } else {
                session.setAttribute("failedmsg", "Failed to add category.");
            }
            response.sendRedirect("adminuser.jsp");
            return;
        }

        // ── ADD PRODUCT ──
        if (op.trim().equals("addproduct")) {
            String title       = request.getParameter("title");
            String description = request.getParameter("description");
            int price, discount, qnty, catId;
            try {
                price    = Integer.parseInt(request.getParameter("price"));
                discount = Integer.parseInt(request.getParameter("discount"));
                qnty     = Integer.parseInt(request.getParameter("qnty"));
                catId    = Integer.parseInt(request.getParameter("catId"));
            } catch (NumberFormatException e) {
                session.setAttribute("failedmsg", "Invalid numeric value for product. Please check price, discount, quantity.");
                response.sendRedirect("adminuser.jsp");
                return;
            }

            Part part = request.getPart("prodimage");
            String imageName = (part != null && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty())
                    ? part.getSubmittedFileName() : "default.png";

            ProductBean pbean = new ProductBean();
            pbean.setTitle(title);
            pbean.setDescription(description);
            pbean.setPrice(price);
            pbean.setDiscount(discount);
            pbean.setQnty(qnty);
            pbean.setCid(catId);
            pbean.setProdimage(imageName);

            if (part != null && part.getSize() > 0) {
                String path = request.getServletContext().getRealPath("/assets")
                        + File.separator + "products" + File.separator + imageName;
                try {
                    uploadFileInFolder(path, part);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            int rowsAffected = ProductDao.addProduct(pbean);
            if (rowsAffected > 0) {
                session.setAttribute("successmsg", "Product '" + title + "' added successfully.");
            } else {
                session.setAttribute("failedmsg", "Failed to add product.");
            }
            response.sendRedirect("adminuser.jsp");
            return;
        }

        // ── EDIT / UPDATE PRODUCT ──
        if (op.trim().equals("editproduct")) {
            int productId, price, discount, qnty, catId;
            try {
                productId = Integer.parseInt(request.getParameter("productId"));
                price     = Integer.parseInt(request.getParameter("price"));
                discount  = Integer.parseInt(request.getParameter("discount"));
                qnty      = Integer.parseInt(request.getParameter("qnty"));
                catId     = Integer.parseInt(request.getParameter("catId"));
            } catch (NumberFormatException e) {
                session.setAttribute("failedmsg", "Invalid numeric value while editing product.");
                response.sendRedirect("adminuser.jsp");
                return;
            }

            String title       = request.getParameter("title");
            String description = request.getParameter("description");

            ProductBean pbean = new ProductBean();
            pbean.setId(productId);
            pbean.setTitle(title);
            pbean.setDescription(description);
            pbean.setPrice(price);
            pbean.setDiscount(discount);
            pbean.setQnty(qnty);
            pbean.setCid(catId);

            // Handle optional new image
            Part part = request.getPart("prodimage");
            if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                String imageName = part.getSubmittedFileName();
                String path = request.getServletContext().getRealPath("/assets")
                        + File.separator + "products" + File.separator + imageName;
                try {
                    uploadFileInFolder(path, part);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                pbean.setProdimage(imageName);
                // Update with image
                String updateWithImageQuery = null; // use DAO method updateProduct — image not in DAO, use existing
                // Update image separately if needed: we set prodimage on bean and the DAO method below handles it
            }

            int rowsAffected = ProductDao.updateProduct(pbean);
            if (rowsAffected > 0) {
                session.setAttribute("successmsg", "Product updated successfully.");
            } else {
                session.setAttribute("failedmsg", "Failed to update product.");
            }
            response.sendRedirect("adminuser.jsp");
            return;
        }

        // ── DELETE PRODUCT ──
        if (op.trim().equals("deleteproduct")) {
            int productId;
            try {
                productId = Integer.parseInt(request.getParameter("productId"));
            } catch (NumberFormatException e) {
                session.setAttribute("failedmsg", "Invalid product ID.");
                response.sendRedirect("adminuser.jsp");
                return;
            }
            int rowsAffected = ProductDao.deleteProduct(productId);
            if (rowsAffected > 0) {
                session.setAttribute("successmsg", "Product deleted successfully.");
            } else {
                session.setAttribute("failedmsg", "Failed to delete product.");
            }
            response.sendRedirect("adminuser.jsp");
            return;
        }

        session.setAttribute("failedmsg", "Unknown product operation.");
        response.sendRedirect("adminuser.jsp");
    }

    private static void uploadFileInFolder(String path, Part part) {
        try {
            InputStream fin = part.getInputStream();
            FileOutputStream fos = new FileOutputStream(path);
            byte[] data = new byte[4096];
            int bytesRead;
            while ((bytesRead = fin.read(data)) != -1) {
                fos.write(data, 0, bytesRead);
            }
            fos.close();
            fin.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

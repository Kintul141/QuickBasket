package com.ecommerce.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.bean.BillRecordBean;
import com.ecommerce.bean.CartItemBean;
import com.ecommerce.bean.ProductBean;
import com.ecommerce.bean.UserBean;
import com.ecommerce.dao.ProductDao;

@WebServlet(name = "CartServlet", urlPatterns = { "/CartServlet" })
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @SuppressWarnings("unchecked")
    private Map<Integer, CartItemBean> getOrCreateCart(HttpSession session) {
        Map<Integer, CartItemBean> cart = (Map<Integer, CartItemBean>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<Integer, CartItemBean>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    @SuppressWarnings("unchecked")
    private List<BillRecordBean> getOrCreateMyBills(HttpSession session) {
        List<BillRecordBean> myBills = (List<BillRecordBean>) session.getAttribute("myBills");
        if (myBills == null) {
            myBills = new ArrayList<BillRecordBean>();
            session.setAttribute("myBills", myBills);
        }
        return myBills;
    }

    @SuppressWarnings("unchecked")
    private List<BillRecordBean> getOrCreateAllBills(HttpServletRequest request) {
        List<BillRecordBean> allBills = (List<BillRecordBean>) request.getServletContext().getAttribute("allBills");
        if (allBills == null) {
            allBills = new ArrayList<BillRecordBean>();
            request.getServletContext().setAttribute("allBills", allBills);
        }
        return allBills;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserBean currentUser = (UserBean) session.getAttribute("current_user");

        if (currentUser == null) {
            session.setAttribute("failedmsg", "Please login first to use cart.");
            response.sendRedirect("login.jsp");
            return;
        }

        if ("admin".equalsIgnoreCase(currentUser.getUserType())) {
            session.setAttribute("failedmsg", "Admin users cannot use customer cart.");
            response.sendRedirect("adminuser.jsp");
            return;
        }

        String op = request.getParameter("operation");
        if (op == null || op.trim().isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        String ownerEmail = (String) session.getAttribute("cartOwnerEmail");
        if (ownerEmail != null && !ownerEmail.equals(currentUser.getEmail())) {
            session.removeAttribute("cart");
            session.removeAttribute("myBills");
        }
        session.setAttribute("cartOwnerEmail", currentUser.getEmail());

        Map<Integer, CartItemBean> cart = getOrCreateCart(session);

        if ("add".equalsIgnoreCase(op)) {
            int productId;
            int quantity;
            try {
                productId = Integer.parseInt(request.getParameter("productId"));
                quantity = Integer.parseInt(request.getParameter("quantity"));
            } catch (NumberFormatException e) {
                session.setAttribute("failedmsg", "Invalid add to cart request.");
                response.sendRedirect("index.jsp");
                return;
            }

            if (quantity <= 0) {
                quantity = 1;
            }

            ProductBean product = ProductDao.getProductById(productId);
            if (product == null) {
                session.setAttribute("failedmsg", "Product not found.");
                response.sendRedirect("index.jsp");
                return;
            }

            CartItemBean item = cart.get(productId);
            if (item == null) {
                cart.put(productId, new CartItemBean(product, quantity));
            } else {
                item.setQuantity(item.getQuantity() + quantity);
            }

            session.setAttribute("successmsg", "Product added to your cart.");
            response.sendRedirect("index.jsp");
            return;
        }

        if ("remove".equalsIgnoreCase(op)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                cart.remove(productId);
                session.setAttribute("successmsg", "Item removed from cart.");
            } catch (NumberFormatException e) {
                session.setAttribute("failedmsg", "Invalid remove request.");
            }
            response.sendRedirect("cart.jsp");
            return;
        }

        if ("clear".equalsIgnoreCase(op)) {
            cart.clear();
            session.setAttribute("successmsg", "Your cart is now empty.");
            response.sendRedirect("cart.jsp");
            return;
        }

        if ("checkout".equalsIgnoreCase(op)) {
            if (cart.isEmpty()) {
                session.setAttribute("failedmsg", "Cart is empty. Add products first.");
                response.sendRedirect("cart.jsp");
                return;
            }

            BillRecordBean bill = new BillRecordBean();
            bill.setBillId("BILL-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            bill.setUserId(currentUser.getId());
            bill.setUserName(currentUser.getName());
            bill.setUserEmail(currentUser.getEmail());
            bill.setCreatedAt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

            List<CartItemBean> billItems = new ArrayList<CartItemBean>();
            double totalAmount = 0.0;
            int totalItems = 0;

            for (CartItemBean cartItem : cart.values()) {
                ProductBean p = cartItem.getProduct();
                CartItemBean copy = new CartItemBean(p, cartItem.getQuantity());
                billItems.add(copy);
                totalItems += copy.getQuantity();
                totalAmount += copy.getLineTotal();
            }

            bill.setItems(billItems);
            bill.setTotalItems(totalItems);
            bill.setTotalAmount(totalAmount);

            List<BillRecordBean> myBills = getOrCreateMyBills(session);
            myBills.add(0, bill);

            List<BillRecordBean> allBills = getOrCreateAllBills(request);
            synchronized (allBills) {
                allBills.add(0, bill);
            }

            cart.clear();
            session.setAttribute("successmsg", "Checkout successful. Bill generated: " + bill.getBillId());
            response.sendRedirect("cart.jsp");
            return;
        }

        session.setAttribute("failedmsg", "Unknown cart operation.");
        response.sendRedirect("cart.jsp");
    }
}

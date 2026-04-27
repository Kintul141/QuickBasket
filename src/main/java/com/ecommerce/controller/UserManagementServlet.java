package com.ecommerce.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.bean.UserBean;
import com.ecommerce.dao.UserDao;

@WebServlet(name = "UserManagementServlet", urlPatterns = {"/UserManagementServlet"})
public class UserManagementServlet extends HttpServlet {

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
        UserBean currentUser = (UserBean) session.getAttribute("current_user");

        // Guard: admin only
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getUserType())) {
            session.setAttribute("failedmsg", "Access denied. Admin only.");
            response.sendRedirect("login.jsp");
            return;
        }

        String op = request.getParameter("operation");
        if (op == null || op.trim().isEmpty()) {
            session.setAttribute("failedmsg", "Invalid user operation.");
            response.sendRedirect("adminuser.jsp");
            return;
        }

        // ── DELETE USER ──
        if ("deleteUser".equalsIgnoreCase(op)) {
            int userId;
            try {
                userId = Integer.parseInt(request.getParameter("userId"));
            } catch (NumberFormatException e) {
                session.setAttribute("failedmsg", "Invalid user ID.");
                response.sendRedirect("adminuser.jsp");
                return;
            }

            if (currentUser.getId() == userId) {
                session.setAttribute("failedmsg", "Admin cannot delete their own account while logged in.");
                response.sendRedirect("adminuser.jsp");
                return;
            }

            int rowsAffected = UserDao.deleteUserById(userId);
            if (rowsAffected > 0) {
                session.setAttribute("successmsg", "User deleted successfully.");
            } else {
                session.setAttribute("failedmsg", "Unable to delete user.");
            }
            response.sendRedirect("adminuser.jsp");
            return;
        }

        // ── CHANGE ROLE (promote to admin / demote to normal) ──
        if ("updateRole".equalsIgnoreCase(op)) {
            int userId;
            String newRole = request.getParameter("newRole");
            try {
                userId = Integer.parseInt(request.getParameter("userId"));
            } catch (NumberFormatException e) {
                session.setAttribute("failedmsg", "Invalid user ID.");
                response.sendRedirect("adminuser.jsp");
                return;
            }

            if (currentUser.getId() == userId) {
                session.setAttribute("failedmsg", "You cannot change your own role while logged in.");
                response.sendRedirect("adminuser.jsp");
                return;
            }

            if (!"admin".equalsIgnoreCase(newRole) && !"normal".equalsIgnoreCase(newRole)) {
                session.setAttribute("failedmsg", "Invalid role value.");
                response.sendRedirect("adminuser.jsp");
                return;
            }

            int rowsAffected = UserDao.updateUserRole(userId, newRole.toLowerCase());
            if (rowsAffected > 0) {
                session.setAttribute("successmsg", "User role updated to '" + newRole + "' successfully.");
            } else {
                session.setAttribute("failedmsg", "Unable to update user role.");
            }
            response.sendRedirect("adminuser.jsp");
            return;
        }

        session.setAttribute("failedmsg", "Unknown user operation.");
        response.sendRedirect("adminuser.jsp");
    }
}

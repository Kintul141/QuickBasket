package com.ecommerce.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.bean.UserBean;
import com.ecommerce.dao.UserDao;
import com.ecommerce.util.StringUtils;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String phone    = request.getParameter("phone");
        String location = request.getParameter("location");

        boolean flag = false;
        UserBean ubean = new UserBean();

        if (!StringUtils.isValidString(username)) {
            flag = true;
            request.setAttribute("nameErr", "<span class='text-danger small'>Please enter a valid name.</span>");
        } else {
            ubean.setName(username);
        }

        if (!StringUtils.isValidString(email)) {
            flag = true;
            request.setAttribute("emailErr", "<span class='text-danger small'>Please enter a valid email.</span>");
        } else {
            ubean.setEmail(email);
        }

        if (!StringUtils.isValidString(password)) {
            flag = true;
            request.setAttribute("pwdErr", "<span class='text-danger small'>Please enter a valid password.</span>");
        } else {
            ubean.setPassword(password);
        }

        if (!StringUtils.isValidString(phone)) {
            flag = true;
            request.setAttribute("phoneErr", "<span class='text-danger small'>Please enter a valid phone.</span>");
        } else {
            ubean.setPhone(phone);
        }

        if (!StringUtils.isValidString(location)) {
            flag = true;
            request.setAttribute("addressErr", "<span class='text-danger small'>Please enter a valid location.</span>");
        } else {
            ubean.setLocation(location);
        }

        // Always assign "normal" role on signup
        ubean.setUserType("normal");

        RequestDispatcher rd;
        request.setAttribute("ubean", ubean);

        if (flag) {
            rd = request.getRequestDispatcher("register.jsp");
            rd.forward(request, response);
        } else {
            int rowsAffected = UserDao.insertNewUser(ubean);
            if (rowsAffected > 0) {
                System.out.println("User registered successfully: " + rowsAffected);
                HttpSession session = request.getSession();
                session.setAttribute("msg", "Registration successful! Please login to continue.");
                response.sendRedirect("login.jsp");
            } else {
                System.out.println("User registration failed: " + rowsAffected);
                request.setAttribute("regErr", "<span class='text-danger small'>Registration failed. Email may already be in use.</span>");
                rd = request.getRequestDispatcher("register.jsp");
                rd.forward(request, response);
            }
        }
    }
}

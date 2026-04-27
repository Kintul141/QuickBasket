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

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet{
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		
		RequestDispatcher rd = null;
		boolean hasError = false;
		
		if(!StringUtils.isValidString(email)) {
			request.setAttribute("emailErr", "<font color='red'>Please enter valid email address.</font>");
			hasError = true;
		}

		if(!StringUtils.isValidString(password)) {
			request.setAttribute("pwdErr", "<font color='red'>Please enter valid password.</font>");
			hasError = true;
		}

		if(hasError) {
			rd = request.getRequestDispatcher("login.jsp");
			rd.forward(request, response);
		}else {
			if(UserDao.authenticateUser(email, password)) {
				
				UserBean ubean = UserDao.getUserByEmail(email);
				
				HttpSession session = request.getSession();
				
				if(ubean != null) {
					String userType = ubean.getUserType();
					if (userType == null || userType.trim().isEmpty()) {
						userType = "normal";
						ubean.setUserType(userType);
					}

					Object existingCartOwner = session.getAttribute("cartOwnerEmail");
					if (existingCartOwner != null && !email.equals(existingCartOwner.toString())) {
						session.removeAttribute("cart");
						session.removeAttribute("myBills");
					}

					session.setAttribute("current_user", ubean);
					session.setAttribute("cartOwnerEmail", ubean.getEmail());

					if("admin".equalsIgnoreCase(userType)) {
						response.sendRedirect("adminuser.jsp");
					}else {
						response.sendRedirect("normaluser.jsp");
					}
				} else {
					request.setAttribute("loginErr", "<font color='red'>User details not found.</font>");
					rd = request.getRequestDispatcher("login.jsp");
					rd.forward(request, response);
					return;
				}
				
				System.out.println("login successfull.");
				
				
			}else {
				request.setAttribute("loginErr", "<font color='red'>Login credentials invalid.</font>");
				rd = request.getRequestDispatcher("login.jsp");
				System.out.println("login failed.");
				rd.forward(request, response);
			}
		}
		
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}
}

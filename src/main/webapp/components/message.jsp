<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%
	String message = (String) session.getAttribute("msg");
	if (message != null) {
	%>
	<div class="alert alert-success alert-dismissible fade show"
		role="alert">
		<strong><%=message %></strong>
		<button type="button" class="btn-close" data-bs-dismiss="alert"
			aria-label="Close"></button>
	</div>
	<%
	session.removeAttribute("msg");
	}
	%>
	<%
	String message2 = (String) session.getAttribute("successmsg");
	if (message2 != null) {
	%>
	<div class="alert alert-success alert-dismissible fade show text-center"
		role="alert">
		<strong><%=message2 %></strong>
		<button type="button" class="btn-close" data-bs-dismiss="alert"
			aria-label="Close"></button>
	</div>
	<%
	session.removeAttribute("successmsg");
	}
	%>
	<%
	String message3 = (String) session.getAttribute("failedmsg");
	if (message3 != null) {
	%>
	<div class="alert alert-danger alert-dismissible fade show text-center"
		role="alert">
		<strong><%=message3 %></strong>
		<button type="button" class="btn-close" data-bs-dismiss="alert"
			aria-label="Close"></button>
	</div>
	<%
	session.removeAttribute("failedmsg");
	}
	%>

package com.ecommerce.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.ecommerce.bean.UserBean;
import com.ecommerce.util.DBConnectionUtil;

public class UserDao {
	
	public static int insertNewUser(UserBean ubean) {
		String insertQuery = "INSERT INTO users (name, email, password, phone, location, usertype) values (?,?,?,?,?,?)";
		
		Connection conn = DBConnectionUtil.getConnection();
		
		int rowsAffected = 0;
		
		PreparedStatement pstmt = null;
		
		if(conn != null) {
			try {
				pstmt = conn.prepareStatement(insertQuery);
				
				pstmt.setString(1, ubean.getName());
				pstmt.setString(2, ubean.getEmail());
				pstmt.setString(3, ubean.getPassword());
				pstmt.setString(4, ubean.getPhone());
				pstmt.setString(5, ubean.getLocation());
				pstmt.setString(6, ubean.getUserType() != null ? ubean.getUserType() : "normal");
				
				rowsAffected = pstmt.executeUpdate();
				
				return rowsAffected;
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}else {
			System.out.println("DB-Connection-Error");
		}
		
		return 0;
	}
	
	public static UserBean getUserByEmail(String email) {
		String getQuery = "SELECT * FROM users where email = ?";
		
		Connection conn = DBConnectionUtil.getConnection();
		
		ResultSet rs = null;
		
		PreparedStatement pstmt = null;
		
		UserBean ubean = null;
		
		if(conn != null) {
			try {
				pstmt = conn.prepareStatement(getQuery);
				
				pstmt.setString(1, email);
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					ubean = new UserBean(rs.getInt("id"), rs.getString("name"), rs.getString("email"), rs.getString("password"), rs.getString("phone"), rs.getString("userpic"), rs.getString("location"),rs.getString("usertype"));
					return ubean;
				}
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}else {
			System.out.println("DB-Connection-Error.");
		}
		return null;
		
	}
	
	public static boolean authenticateUser(String email, String password) {
		String selectQuery = "SELECT * FROM users where email = ? and password = ?";
		
		Connection conn = DBConnectionUtil.getConnection();
		
		ResultSet rs = null;
		
		PreparedStatement pstmt = null;
		
		if(conn != null) {
			try {
				pstmt = conn.prepareStatement(selectQuery);
				
				pstmt.setString(1, email);
				pstmt.setString(2, password);
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					return true;
				}
				
			} catch (SQLException e) {
				
				e.printStackTrace();
			}
		}else {
			System.out.println("DB-Connection-Err");
		}
		return false;
		
	}

	public static ArrayList<UserBean> getAllUsers() {
		String getQuery = "SELECT * FROM users ORDER BY id DESC";

		Connection conn = DBConnectionUtil.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<UserBean> users = new ArrayList<UserBean>();

		if (conn != null) {
			try {
				pstmt = conn.prepareStatement(getQuery);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					UserBean ubean = new UserBean(rs.getInt("id"), rs.getString("name"), rs.getString("email"),
							rs.getString("password"), rs.getString("phone"), rs.getString("userpic"),
							rs.getString("location"), rs.getString("usertype"));
					users.add(ubean);
				}

			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return users;
	}

	public static int deleteUserById(int userId) {
		String deleteQuery = "DELETE FROM users WHERE id = ?";

		Connection conn = DBConnectionUtil.getConnection();
		PreparedStatement pstmt = null;

		if (conn != null) {
			try {
				pstmt = conn.prepareStatement(deleteQuery);
				pstmt.setInt(1, userId);
				return pstmt.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return 0;
	}

	public static int updateUserRole(int userId, String newRole) {
		String updateQuery = "UPDATE users SET usertype = ? WHERE id = ?";
		Connection conn = DBConnectionUtil.getConnection();
		PreparedStatement pstmt = null;
		if (conn != null) {
			try {
				pstmt = conn.prepareStatement(updateQuery);
				pstmt.setString(1, newRole);
				pstmt.setInt(2, userId);
				return pstmt.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return 0;
	}

}

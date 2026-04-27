package com.ecommerce.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.ecommerce.bean.CategoryBean;
import com.ecommerce.util.DBConnectionUtil;

public class CategoryDao {
	
	public static int addCategory(CategoryBean cbean) {
		String insertQuery = "INSERT INTO category (title, description) values (?,?)";
		
		Connection conn = DBConnectionUtil.getConnection();
		
		PreparedStatement pstmt = null;
		
		int rowsAffected = 0;
		
		if(conn != null) {
			try {
				pstmt = conn.prepareStatement(insertQuery);
				
				pstmt.setString(1, cbean.getTitle());
				pstmt.setString(2, cbean.getDescription());
				
				rowsAffected = pstmt.executeUpdate();
				
				return rowsAffected;
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}else {
			System.out.println("DB-Connection-Error.");
		}
		
		return 0;
	}

	public static CategoryBean getCategoryId(String catTitle) {
		
		String selectQuery = "SELECT * FROM category where title = ?";
		
		Connection conn = DBConnectionUtil.getConnection();
		
		PreparedStatement pstmt = null;
		
		ResultSet rs = null;
		
		CategoryBean cbean = null;
		
		if(conn != null) {
			try {
				pstmt = conn.prepareStatement(selectQuery);
				
				pstmt.setString(1, catTitle);
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					cbean = new CategoryBean(rs.getInt("id"), rs.getString("title"), rs.getString("description"));
					return cbean;
				}
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}else {
			System.out.println("DB-Connection-Error.");
		}
		
		return null;
	}
	
	public static CategoryBean getCategoryById(int id) {
		String getQuery = "SELECT * FROM category WHERE id = ?";
		
		Connection conn = DBConnectionUtil.getConnection();
		
		PreparedStatement pstmt = null;
		
		ResultSet rs = null;
		
		CategoryBean cbean = null;
		
		if(conn != null) {
			
			try {
				pstmt = conn.prepareStatement(getQuery);
				
				pstmt.setInt(1, id);
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					cbean = new CategoryBean(rs.getInt("id"), rs.getString("title"), rs.getString("description"));
				}
				
				return cbean;
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}else {
			System.out.println("DB-Connection-Err");
		}
		
		return null;
		
	}
	
	public static ArrayList<CategoryBean> getAllCategories() {
		String getQuery = "SELECT * FROM category";
		
		Connection conn = DBConnectionUtil.getConnection();
		
		PreparedStatement pstmt = null;
		
		ResultSet rs = null;
		
		CategoryBean cbean = null;
		
		ArrayList<CategoryBean> catList = new ArrayList<CategoryBean>();
		
		if(conn != null) {
			
			try {
				pstmt = conn.prepareStatement(getQuery);
				
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					cbean = new CategoryBean(rs.getInt("id"), rs.getString("title"), rs.getString("description"));
					catList.add(cbean);
				}
				
				return catList;
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}else {
			System.out.println("DB-Connection-Err");
		}
		
		return null;
	}

}

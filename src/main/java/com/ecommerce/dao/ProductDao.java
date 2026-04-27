package com.ecommerce.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.ecommerce.bean.ProductBean;
import com.ecommerce.util.DBConnectionUtil;

public class ProductDao {
	
	public static int addProduct(ProductBean pbean) {
		String insertQuery = "INSERT INTO product (title, description, prodimage, price, discount, qnty, cid) values (?,?,?,?,?,?,?)";
		
		Connection conn = DBConnectionUtil.getConnection();
		
		PreparedStatement pstmt = null;
		
		int rowsAffected = 0;
		
		if(conn != null) {
			
			try {
				pstmt = conn.prepareStatement(insertQuery);
				
				pstmt.setString(1, pbean.getTitle());
				pstmt.setString(2, pbean.getDescription());
				pstmt.setString(3, pbean.getProdimage());
				pstmt.setInt(4, pbean.getPrice());
				pstmt.setInt(5, pbean.getDiscount());
				pstmt.setInt(6, pbean.getQnty());
				pstmt.setInt(7, pbean.getCid());
				
				rowsAffected = pstmt.executeUpdate();
				
				return rowsAffected;
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}else {
			System.out.println("DB-Connection-Err");
		}
		
		return 0;
	}
	
	public static ArrayList<ProductBean> getAllProducts(){
		String getQuery = "SELECT * FROM product";
		
		Connection conn = DBConnectionUtil.getConnection();
		
		PreparedStatement pstmt = null;
		
		ResultSet rs = null;
		
		ProductBean pbean = null;
		
		ArrayList<ProductBean> productlist = new ArrayList<ProductBean>();
		
		if(conn != null) {
			
			try {
				pstmt = conn.prepareStatement(getQuery);
				
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					pbean = new ProductBean(rs.getInt("id"), rs.getString("title"), rs.getString("description"), rs.getString("prodimage"), rs.getInt("price"), rs.getInt("discount"), rs.getInt("qnty"), rs.getInt("cid"));
					productlist.add(pbean);
				}
				
				return productlist;
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}else {
			System.out.println("DB-Connection-Err");
		}
		
		return null;
	}

	public static ProductBean getProductById(int id) {
		String getQuery = "SELECT * FROM product WHERE id = ?";

		Connection conn = DBConnectionUtil.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		if (conn != null) {
			try {
				pstmt = conn.prepareStatement(getQuery);
				pstmt.setInt(1, id);
				rs = pstmt.executeQuery();

				if (rs.next()) {
					return new ProductBean(rs.getInt("id"), rs.getString("title"), rs.getString("description"),
							rs.getString("prodimage"), rs.getInt("price"), rs.getInt("discount"),
							rs.getInt("qnty"), rs.getInt("cid"));
				}

			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return null;
	}

	public static int updateProduct(ProductBean pbean) {
		String updateQuery = "UPDATE product SET title=?, description=?, price=?, discount=?, qnty=?, cid=? WHERE id=?";
		Connection conn = DBConnectionUtil.getConnection();
		PreparedStatement pstmt = null;
		if (conn != null) {
			try {
				pstmt = conn.prepareStatement(updateQuery);
				pstmt.setString(1, pbean.getTitle());
				pstmt.setString(2, pbean.getDescription());
				pstmt.setInt(3, pbean.getPrice());
				pstmt.setInt(4, pbean.getDiscount());
				pstmt.setInt(5, pbean.getQnty());
				pstmt.setInt(6, pbean.getCid());
				pstmt.setInt(7, pbean.getId());
				return pstmt.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return 0;
	}

	public static int deleteProduct(int productId) {
		String deleteQuery = "DELETE FROM product WHERE id = ?";
		Connection conn = DBConnectionUtil.getConnection();
		PreparedStatement pstmt = null;
		if (conn != null) {
			try {
				pstmt = conn.prepareStatement(deleteQuery);
				pstmt.setInt(1, productId);
				return pstmt.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return 0;
	}

}

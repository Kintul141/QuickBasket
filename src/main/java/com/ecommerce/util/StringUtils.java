package com.ecommerce.util;

public class StringUtils {
	
	public static boolean isValidString(String value) {
		return (value != null && value.trim().length()>0) ? true : false;
	}
	
//	public static void main(String[] args) {
//		System.out.println(StringUtils.isValidString("Meet"));
//	}

}

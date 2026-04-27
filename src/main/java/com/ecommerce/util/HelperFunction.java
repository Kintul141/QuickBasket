package com.ecommerce.util;

public class HelperFunction {
	
	public static String get10Words(String desc) {
		
		String[] words = desc.split(" ");
		
		if(words.length > 10) {
			String res = "";
			
			for(int i=0;i<10;i++) {
				res = res + words[i] + " ";
			}
			
			return res + " ...";
		}else {
			return desc+" ...";
		}
	}

}

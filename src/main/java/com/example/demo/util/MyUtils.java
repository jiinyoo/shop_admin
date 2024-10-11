package com.example.demo.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import org.springframework.util.ResourceUtils;

//자주 사용하는 메소드를 정의
public class MyUtils {
	//경로와 파일명이 존재하면 파일명을 중복체크를 하여
	//중복되지 않은 파일명을 리턴해주는 메소드
	public static String getFileName(String fname, String str, int n) throws Exception {
		File ff=new File(str);
		
		while(ff.exists())
		{
			String code="";
			for(int i=1; i<=n; i++)
			{
				int random=(int)(Math.random()*62);
				int num;
				if(0<=random && random<=9)
				{
					num=random+48;
				}else if(10<=random && random<=35)
				{
					num=random+55;
				} else {
					num=random+61;
				}
				
				code=code+(char)num;
			}	
			System.out.println(code);
			String[] imsi=fname.split("[.]");
			String newfname=imsi[0]+code+"."+imsi[1];
			str=ResourceUtils.getFile("classpath:static/product").toPath().toString()+"/"+newfname;
			ff=new File(str);
		}
		return str;
	}

}

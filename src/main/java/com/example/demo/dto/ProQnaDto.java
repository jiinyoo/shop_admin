package com.example.demo.dto;

import lombok.Data;

@Data
public class ProQnaDto {
	private int id,qna,ref;
	private String userid,pcode,content,writeday;
	
	//상품명을 저장할 필드를 만든다.
	private String title;
}

package com.example.demo.dto;

import lombok.Data;

@Data
public class MemberDto {
	private int id,juk,state;
	private String userid,pwd,name,email;
	private String phone,writeday;

}

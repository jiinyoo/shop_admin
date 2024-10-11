package com.example.demo.controller;

import java.io.FileNotFoundException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.example.demo.dto.JungDto;
import com.example.demo.dto.ProQnaDto;
import com.example.demo.dto.ProductDto;
import com.example.demo.dto.SoDto;
import com.example.demo.mapper.AdminMapper;
import com.example.demo.util.MyUtils;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class AdminController {
	
	@Autowired
	private AdminMapper mapper;
	
	
	//상품추가 문서
	@RequestMapping("/product/productAdd")
	public String productAdd(Model model)
	{
		
		//대분류는 dae테이블의 정보를 가져와서 넘겨준다.
		model.addAttribute("daeAll",mapper.getDae());
		model.addAttribute("companyAll",mapper.getCompany());
		mapper.getDae();
		//제조회사 company테이블의 정보를 가져와서 넘겨준다.
		mapper.getCompany();
		return "/product/productAdd";
	}
	
	
	@RequestMapping("/product/getJung")
	public @ResponseBody ArrayList<JungDto> getJung(HttpServletRequest request)
	{
		String daecode=request.getParameter("daecode");
		ArrayList<JungDto> jungAll=mapper.getJung(daecode);
		return jungAll;
	
	}
	
	@RequestMapping("/product/getSo")
	public @ResponseBody ArrayList<SoDto> getSo(HttpServletRequest request)
	{
		String daecode=request.getParameter("daecode");
		String jungcode=request.getParameter("jungcode");
		
		ArrayList<SoDto> soAll=mapper.getSo(daecode+jungcode);
		return soAll;
	
	}
	
	
	@RequestMapping("/product/genPcode")
	public @ResponseBody String genPcode(HttpServletRequest request)
	{
		String pcode=request.getParameter("pcode");
		int num= mapper.genPcode(pcode);
		//3자리 스트링으로 변경
		pcode=pcode+String.format("%03d", num);
		return pcode;
	
	}
	
	
	@RequestMapping("/product/productAddOk")
	public String productAddOk(ProductDto pdto,MultipartHttpServletRequest multi) throws Exception
	{	
		Iterator<String> imsi=multi.getFileNames(); //tyle="file"의 name
		
		String pimg="";
		String dimg="";
		while(imsi.hasNext())
		{
			String name=imsi.next();
			MultipartFile file=multi.getFile(name);
			String oname=file.getOriginalFilename();
		
			if(!file.isEmpty())
			{
				//저장될 경로와 파일명
				String str=ResourceUtils.getFile("classpath:static/product").toString()+"/"+oname;
				System.out.println(str);
				
				//MyUtils.getFileName()을 통해 파일명이 존재한다면 다른 이름으로 변경
				str=MyUtils.getFileName(oname, str, 4);
				System.out.println(str);
				//데이터베이스 product테이블에 pimg필드와 , dimg필드의 값을 생성
				
				//str은 MyUtils클래스를 통과한 후 저장할 경로 <c:/...../static/product/중복 없는 파일명>
				
				
				//if문의 위치 
				if(name.equals("dimgName"))
				{
					dimg=str.substring(str.lastIndexOf("/")+1);
				}
				else
				{
					pimg=pimg+str.substring(str.lastIndexOf("/")+1)+"/";
				}
				
			
				
				
				Path path=Paths.get(str);
				
				Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
				
			}
			//상품 정보를 product테이블에 저장

		} //while문의 끝
		
		
		
		System.out.println(pimg);
		System.out.println(dimg);
		
		pdto.setPimg(pimg);
		pdto.setDimg(dimg);
		
	
		
		mapper.productAddOk(pdto);
		
		
		
		return "redirect:/product/productlist";
		
	}
	
	
	@RequestMapping("/gumae/gumaeAll")
	public String gumaeAll(Model model)
	{
		ArrayList<HashMap> mapAll=mapper.gumaeAll();
		for(int i=0;i<mapAll.size();i++)
		{
			// state의 값을 문자열로 변경후 저장
			String state=mapAll.get(i).get("state").toString();
			String stateMsg=null;
			switch(state)
			{
			   case "0": stateMsg="결제완료"; break;
			   case "1": stateMsg="상품준비중"; break;
			   case "2": stateMsg="배송중"; break;
			   case "3": stateMsg="배송완료"; break;
			   case "4": stateMsg="취소완료"; break;
			   case "5": stateMsg="반품신청"; break;
			   case "6": stateMsg="반품완료"; break;
			   case "7": stateMsg="교환신청"; break;
			   case "8": stateMsg="교환완료"; break;
			   default: stateMsg="문의바람";
			}
			mapAll.get(i).put("stateMsg", stateMsg);
		}
		model.addAttribute("mapAll",mapAll);
		return "/gumae/gumaeAll";
	}

	@GetMapping("/gumae/chgState")
	public String chgState(HttpServletRequest request)
	{
		String state=request.getParameter("state");
		String id=request.getParameter("id");
		
		mapper.chgState(state,id);
		return "redirect:/gumae/gumaeAll";
	}
	
	
	@RequestMapping("/qna/qnaList")
	public String qnaList(Model model) 
	{
		ArrayList<ProQnaDto> plist=mapper.qnaList();
		model.addAttribute("plist",plist);		
		return "/qna/qnaList";
	}
	
	
	
	@RequestMapping("/qna/writeAnswerOk")
	public String writeAnswerOk(ProQnaDto pdto) 
	{
		pdto.setUserid("admin");
		mapper.writeAnswerOk(pdto);
		return "redirect:/qna/qnaList";
	}
	
	
	
	
	
	
	
}

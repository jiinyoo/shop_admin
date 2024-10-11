package com.example.demo.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.dto.*;

@Mapper
public interface AdminMapper {
	public ArrayList<DaeDto> getDae();
	public ArrayList<CompanyDto> getCompany();
	public ArrayList<JungDto> getJung(String daecode);
	public ArrayList<SoDto> getSo(String daejung);
	public int genPcode(String pcode);
	public void productAddOk(ProductDto pdto);
	public ArrayList<HashMap> gumaeAll();
	public void chgState(String state, String id);
	public ArrayList<ProQnaDto> qnaList();
	public void writeAnswerOk(ProQnaDto pdto);

	
}

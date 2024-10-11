<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	section table{
		border-spacing:0px;
	}
	
	section table td{
		border-bottom:1px solid black;
	}
</style>
<script>
	function getJung(daecode)
	{
		//소분류를 초기화
		
		//상품코드를 초기화 => 코드발생 후 대, 중, 소 제조회사가 변경된다면 
		document.pform.pcode.value="";
		if(document.pform.so.options.lenth!=1)
			document.pform.so.options.length=1;
	
		//비동기방식으로 서버에 접근하여 jung테이블에서 해당 dae코드가 맞는 레코드를 전부 읽어오기
		var chk=new XMLHttpRequest();
		chk.onload=function()
		{
			var jungAll=JSON.parse(chk.responseText);
			document.pform.jung.options.length=jungAll.length+1;
			var i=1;
			for(jung of jungAll)
				{
				 	
				 	//하나의 jung값을 가지고 option태그 하나를 생성
				 	document.pform.jung.options[i].value=jung.code;
				 	document.pform.jung.options[i].text=jung.name;
				 	i++;
				}
		
		}
		//option태그로 만들어 주기
		chk.open("get","getJung?daecode="+daecode);
		chk.send();
	}
	
	function getSo(jungcode)
	{
		
		
		document.pform.pcode.value="";
		var daecode=document.pform.dae.value;
		//alert(socode);
		//비동기방식으로 서버에 접근하여 jung테이블에서 해당 dae코드가 맞는 레코드를 전부 읽어오기
		var chk=new XMLHttpRequest();
		chk.onload=function()
		{
			var soAll=JSON.parse(chk.responseText);
			document.pform.so.options.length=soAll.length+1;
			var i=1;
			for(so of soAll)
				{
				 	
				 	//하나의 jung값을 가지고 option태그 하나를 생성
				 	document.pform.so.options[i].value=so.code;
				 	document.pform.so.options[i].text=so.name;
				 	i++;
				}
		
		}
		//option태그로 만들어 주기
		chk.open("get","getSo?daecode="+daecode+"&jungcode="+jungcode);
		chk.send();
	}
	
	
	function genPcode()
	{
		
		var d=document.pform.dae.value;
		var j=document.pform.jung.value;
		var s=document.pform.so.value;
		var c=document.pform.company.value;
		var pcode="p"+d+j+s+c;
		var chk=new XMLHttpRequest();
		chk.onload=function()
		{
			document.pform.pcode.value=chk.responseText;
		}
		chk.open("get","genPcode?pcode="+pcode);
		chk.send();
	}

	
	function init()
	{
		document.pform.pcode.value="";
	}
	
	
	
	
	


	function add()
	{
		var len=document.getElementsByClassName("one").length;
		
		var copy=document.getElementById("one").cloneNode(true);
		outer=document.getElementById("outer");
		outer.appendChild(copy);
		
		document.getElementsByClassName("file")[len].name="fname"+len;
		document.getElementsByClassName("file")[len].value="";
	}
	
	function viewSrc() {
	    document.getElementById("src").innerText = document.getElementById("outer").innerHTML;
	}
	
	function del()
	{
		var len=document.getElementsByClassName("one").length;
		if(len>1)
			document.getElementsByClassName("one")[len-1].remove();
		
	}
	
	
	
	function check()
	{
		if(documet.pform.pcode.value=="")
			{
				alert("상품코드가 없어요");
				return false;
			
			}
		else if(document.pform.price.value==""){
			alert("상품가격을 입력하세요");
			return false;
		}
		else
			return true;
		
	}
	
	function numCheck(my)
	{
		my.value=my.value.replace(/[^0-9]/g,"");
	}
	
	
	
</script>
</head>
<body>
<input type="button" onclick="viewSrc()" value="소스보기">
<div id="src"></div>
<section>
	<form name="pform" method="post" action="productAddOk" enctype="multipart/form-data" onsubmit="return check()">
		<table width="800" align="center">
			<caption><h3>상품등록</h3></caption>		
		 <tr>
           <td> 상품코드 </td>
           <td> 
           		<input type="text" name="pcode" readonly>
           		<select name="dae" onchange="getJung(this.value)">
           		<option value="0">선택</option>
           		<c:forEach items="${daeAll}" var="dae">
					<option value="${dae.code}">${dae.name}</option>	           		
           		</c:forEach>
           		</select>
           		<select name="jung" onchange="getSo(this.value)">
           		<option value="0">선택</option>
           		
           		
           		</select>
           		<select name="so" onchange="init()">
           		<option value="0">선택</option>
           		
           		</select>
           		<select name="company" onchange="init()">
           		<option value="0">선택</option>
           		<c:forEach items="${companyAll}" var="company">
           			<option value="${company.code}">${company.name}</option>
           		</c:forEach>
           		</select>
           		<input type="button" onclick="genPcode()" value="상품코드발생">
           
           </td>
         </tr>
         <tr>
           <td> 상품이미지 </td>
           <td> 
				<input type="button" value="사진 추가" onclick="add()">
				<input type="button" value="사진 삭제" onclick="del()">
				<div id="outer">
				<p id="one" class="one"><input type="file" name="fname0" class="file"></p>
				</div>           
           </td>
         </tr>
         <tr>
           <td> 상품상세정보 </td>
           <td><input type="file" name="dimgName"></td>
         </tr>
         <tr>
           <td> 상품명 </td>
           <td><input type="text" name="title"> </td>
         </tr>
         <tr>
           <td> 상품가격 </td>
           <td><input type="text" name="price" onkeyup="numCheck(this)"> </td>
         </tr>
         <tr>
           <td> 상품할인율 </td>
           <td> <input type="text" name="halin" onkeyup="numCheck(this)"></td>
         </tr>
         <tr>
           <td> 입고수량 </td>
           <td><input type="text" name="su" onkeyup="numCheck(this)"> </td>
         </tr>
         <tr>
           <td> 상품배송비 </td>
           <td> <input type="text" name="baeprice" onkeyup="numCheck(this)"></td>
         </tr>
         <tr>
           <td> 배송기간 </td>
           <td> <input type="text" name="baeday" onkeyup="numCheck(this)"></td>
         </tr>
         <tr>
           <td> 적립률 </td>
           <td> <input type="text" name="juk" onkeyup="numCheck(this)"></td>
         </tr>
         <tr>
           <td colspan="2" align="center"> <input type="submit" value="상품 등록"> </td>
         </tr>
		
		
		
		</table>
	</form>


</section>
</body>
</html>
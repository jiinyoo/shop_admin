<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<style>
	table {
		border-spacing:0px;
	}
	
	table tr td {
		border-bottom:1px solid purple;
		height:100px;
	
	}
	
	table tr:first-child td {
		border-top:2px solid purple;
	}
	
	
	table tr:last-child td {
		border-bottom:2px solid purple;
	}
	
	
	table .answer {
		position:relative;
	}
	
	table .aform {
		position:absolute;
		left:100px;
		width:300px;
		height:150px;
		border:1px solid purple;
		visibility:hidden;
	
	}
	
	
	table textarea {
	
		width:295px;
		height:100px;
	}
	
	table input[type=submit] {
		width:295px;
		height:36px;
		background-color:purple;
		color:white;
		border:none;
	
	}
	
	
</style>
<script>

function writeAnswer(n) {
	//얘는 순서대로 인덱스를 불러서 폼을 출력해주는거야
	var aform=document.getElementsByClassName("aform");
	for(i=0; i<aform.length; i++) {
		aform[i].style.visibility="hidden";
	}
	aform[n].style.visibility="visible";
}



</script>

<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table width="1100" align="center">
		<tr>
			<td width="200">상품평</td>
			<td width="100">질문/답변</td>
			<td>내용</td>
			<td width="100">작성자</td>
			<td width="100">등록일</td>
		</tr>
<%-- 		<c:set var="ck" value="0"/> --%>
		<c:forEach items="${plist}" var="pdto" varStatus="sts">
		<tr>
			<td>${pdto.title}</td>
			<td align="center" class="answer">
			<c:if test="${pdto.qna==0}">
			<!-- 얘는  -->
				<a href="javascript:writeAnswer(${sts.index})">질문</a>
				<!-- form이 매번 안생김 -->
				<form name="aform" method="post" action="writeAnswerOk" class="aform">
					<input type="hidden" name="ref" value="${pdto.ref}">
					<input type="hidden" name="pcode" value="${pdto.pcode}">
				
					<textarea name="content"></textarea><br>
					<input type="submit" value="답변 달기">				
				</form>
				
			</c:if>
			<c:if test="${pdto.qna==1 }">
				답변<span class="aform" style="display:none;"></span>
			</c:if>
			</td>
			
			<td>${pdto.content}</td>
			<td>${pdto.userid}</td>
			<td>${pdto.writeday }</td>
		</tr>
	<%-- 	<c:if test="${pdto.qna==0}">
			<c:set var="ck" value="${ck+1}"/>
		</c:if> --%>
		</c:forEach>
	<!-- 호출되는 form은 sts에 따라 인덱스가 2번인데 출력되어 있는 from은 인덱스가 1번이다. -->
	</table>

</body>
</html>
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	dim num,path
	num = request.querystring("num")  '文件数
	path = request.querystring("path")  '哪个文件夹
%>
<!--#include file="conn.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
<script type="text/javascript">
	function g(q) {
		//window.opener.document.reg.face.value=face
		//window.opener.document.reg.faceimg.src=face
		window.opener.document.post.content.value+="[img code="+q+"]";
	}
</script>
</head>
<body style="width:auto;">
	
	<div id="face">
		<h1>请选择你要的Q图</h1>
		<%
			for i = 1 to num
		%>
		<ul>
			<li style="float:left;padding-right:40px;padding-bottom:10px;"><img style="cursor:pointer;" src="qpic/<%=path%>/<%=i%>.gif" onclick="g('qpic/<%=path%>/<%=i%>.gif')" /></li>
		</ul>
		<%
			next
		%>

	</div>
	
</body>
</html>
<%
	call close_conn
%>
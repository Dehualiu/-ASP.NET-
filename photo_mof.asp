<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if session("Admin") = "" then
		response.write "<script>alert('不是管理员不能进!');history.back();</script>"
		response.end
	end if
	
	dim showid
	showid = request.querystring("ShowId")
	
	'非法操作
	if showid = "" or not isnumeric(showid) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
<%
	dim rs,sql,photoname,photoclass,photopassword,photocontent
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Photo where G_ID="&showid
	rs.open sql,conn,1,1
	
	'不存在此数据，返回
	if rs.eof then
		call close_rs
		call close_conn
		response.write "<script>alert('不存在此数据');history.back();</script>"
		response.end
	else
		photoname = rs("G_PhotoName")
		photoclass = rs("G_PhotoClass")
		photopassword = rs("G_PhotoPassWord")
		photocontent = rs("G_PhotoContent")
		photopic = rs("G_PhotoPic")
	end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
<script type="text/javascript" src="js/target.js"></script>
</head>
<body>
<!--#include file="header.asp"-->


<div id="photo">
	<h1>添加相册</h1>	
	<div>
		<form style="padding-left:260px;padding-top:30px;" method="post" action="photo_mof_do.asp">
			<input type="hidden" value="<%=showid%>" name="ShowId" />
			<dl>
				<dd>相册名称：<input type="text" name="photoname" value="<%=photoname%>" /></dd>
				<dd>相册类型：<input type="radio" <%if photoclass = 0 then response.write "checked='checked'"%> onclick="targetv(1)" name="photoclass" value="0" /> 公开 <input type="radio" <%if photoclass = 1 then response.write "checked='checked'"%> onclick="targetv(0)" name="photoclass" value="1" /> 私密</dd>
				<dd id="password" <%if photoclass = 0 then response.write "style='display:none;'"%>>相册密码：<input type="password" name="photopassword" /> (*如果不修改密码，请留空)</dd>
				<dd>相册封面：<input type="text" value="<%=photopic%>" name="photopic" />(*请键入相册地址)</dd>
				<dd>相册简介：<textarea rows="8" cols="35" name="photocontent"><%=photocontent%></textarea></dd>
				<dd><input type="submit" value="修改目录" /></dd>
			</dl>
		</form>
	</div>
</div>

<!--#include file="footer.asp"-->	
</body>
</html>
<%
	call close_conn
%>
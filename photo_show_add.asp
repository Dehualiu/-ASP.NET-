<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	dim sid
	sid = request.querystring("Sid")
	
	'非法操作
	if sid = "" or not isnumeric(sid) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	'必须是会员
	if request.cookies("guest")("username")="" then
		response.write "<script>alert('不是会员不能进!');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
<%
	dim rs,sql
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Photo where G_ID="&sid
	rs.open sql,conn,1,1
	
	'不存在此数据，返回
	if rs.eof then
		call close_rs
		call close_conn
		response.write "<script>alert('不存在此目录');history.back();</script>"
		response.end
	else
		picdir = rs("G_PhotoDir")
	end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
</head>
<body>
<!--#include file="header.asp"-->

<div id="photo">
	<h1>添加图片</h1>	
	<div>
		<form name="form1" style="padding-left:260px;padding-top:30px;" method="post" action="photo_show_add_do.asp">
			<input type="hidden" value="<%=sid%>" name="sid" />
			<dl>
				<dd>图片名称：<input type="text" name="picname" /></dd>
				<dd>图片路径：<input type="text" readonly="readonly" id="picdir" name="picdir" /> <a href="###" onclick="javascript:open('upfile.asp?picdir=<%=picdir%>','upfile','width=400,height=100')">上传</a></dd>
				<dd><input type="submit" value="添加图片" name="send" /></dd>
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
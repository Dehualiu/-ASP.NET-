<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if session("Admin") = "" then
		response.write "<script>alert('不是管理员不能进!');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
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
		<form style="padding-left:260px;padding-top:30px;" method="post" action="photo_add_do.asp">
			<dl>
				<dd>相册名称：<input type="text" name="photoname" /></dd>
				<dd>相册类型：<input type="radio" checked="checked" onclick="targetv(1)" name="photoclass" value="0" /> 公开 <input type="radio" onclick="targetv(0)" name="photoclass" value="1" /> 私密</dd>
				<dd id="password" style="display:none;">相册密码：<input type="password" name="photopassword" /></dd>
				<dd>相册简介：<textarea rows="8" cols="35" name="photocontent"></textarea></dd>
				<dd><input type="submit" value="创建目录" /></dd>
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
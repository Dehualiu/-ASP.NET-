<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.cookies("guest")("username")<>"" then
		response.write"<script>alert('你已处在登录状态,请退出再登录');history.back();</script>"
		response.end
		end if
%>
<!--#include file="conn.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
<script type="text/javascript" src="js/login.js"></script>
</head>

<body>
<!--#include file="header.asp"-->

<div id="login">
	<h1>找回密码 -- 确认用户名</h1>	
	<div>
		<form method="post" action="find2.asp">
			<p style="text-align:center;height:30px;line-height:30px;">请输入您的用户名：</p>
			<p style="text-align:center;height:30px;line-height:30px;">用户名：<input type="text" name="username" /> <input type="submit" value="确定" name="send" /></p>
		</form>
	</div>
</div>

<!--#include file="footer.asp"-->	
</body>
</html>
<%
	call close_conn
%>

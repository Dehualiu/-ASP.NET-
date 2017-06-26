<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.cookies("guest")("username")<>"" then
		response.write"<script>alert('你已处在登录状态,请退出再登录');history.back();</script>"
		response.end
		end if
	
	dim username,passd
	 
	if request.form("send") <> "确定" then
		response.write "<script>alert('非法操作！');history.back();</script>"
		response.end
	end if
	
	username = request.form("username")
	passd = request.form("passd")
	
	if username = "" or len(username) < 2 then
		response.write "<script>alert('用户名不合法！');history.back();</script>"
		response.end
	end if
	
	if passd = "" then
		response.write "<script>alert('密码回答不得为空');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
<!--#include file="md5.asp"-->
<%
	'判断数据库里有无这个用户名,并且这个用户名相对的密码回答是否正确
	dim rs,sql,passt
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_User where G_PassD='"&md5(passd)&"' and G_UserName='"&username&"'"
	rs.open sql,conn,1,1
	
	if rs.eof then
		'不存在
		call close_rs
		call close_conn
		response.write "<script>alert('密码回答不正确！');history.back();</script>"
		response.end
	end if
	
	call close_rs
	call close_conn
%>
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
	<h1>找回密码 -- 请输入新密码</h1>	
	<div>
		<form method="post" action="find4.asp">
		<input type="hidden" name="username" value="<%=username%>" />
		<p style="text-align:center;height:30px;line-height:30px;">您的用户是：<%=username%></p>
        <p style="text-align:center;height:30px;line-height:30px;">
        请输入您的新密码：<input type="password" name="password" /></p>
		<p style="text-align:center;height:30px;line-height:30px;">
        再次确认您的新密码：<input type="password" name="notpassword" /></p>
        <p style="text-align:center;height:30px;line-height:30px;padding-top:5px;"> <input type="submit" value="确认新密码" name="send" /></p>
		</form>
	</div>
</div>

<!--#include file="footer.asp"-->	
</body>
</html>
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.cookies("guest")("username")<>"" then
		response.write"<script>alert('你已处在登录状态,请退出再登录');history.back();</script>"
		response.end
		end if
	
	
	dim username,password,sql,notpassword
	username = request.form("username")
	password = request.form("password")
	notpassword = request.form("notpassword")
	 
	if request.form("send") <> "确认新密码" then
		response.write "<script>alert('非法操作！');history.back();</script>"
		response.end
	end if
	
	
	if username = "" or len(username) < 2 then
		response.write "<script>alert('用户名不合法！');history.back();</script>"
		response.end
	end if
	
	if password = "" or len(password) < 6 then
		response.write "<script>alert('密码设置不合法');history.back();</script>"
		response.end
	end if
	
	if password <> notpassword then
		response.write"<script>alert('两次输入的密码不一致!');history.back();</script>"
		response.end
	end if
	
%>
<!--#include file="conn.asp"-->
<!--#include file="md5.asp"-->
<%
	'修改密码
	sql = "update G_User set G_PassWord='"&md5(password)&"' where G_UserName='"&username&"'"
	conn.execute(sql)
	
	call close_conn
	
	'密码修改成功后，跳转到登陆页，继续登录
	response.write "<script>alert('密码设置成功\n请用新密码重新登陆');location.href='login.asp';</script>"
%>

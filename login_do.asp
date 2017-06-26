<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.form("send")="" then
		response.write"<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	dim username,password,rs,sql,login,yzm,ipsql
	username=request.form("username")
	password=request.form("password")
	yzm=request.form("yzm")
	login=request.form("login")
'用户名验证
	if username="" or len(username)<2 then
		response.write"<script>alert('用户名不得为空或者少于两位!');history.back();</script>"
		response.end
	end if
'密码验证
	if password="" or len(password)<6 then
		response.write"<script>alert('密码不得为空或者少于六位!');history.back();</script>"
		response.end
	end if
'验证码验证
	if yzm <> Session("cnbruce.com_ValidateCode") then
		response.write"<script>alert('验证码错误!');history.back();</script>"
		response.end
	end if	

%>
<!--#include file="conn.asp" -->
<!--#include file="md5.asp" -->
<%
'判断用户名和密码是否正确
'将加密后的密码也进行判断
	set rs =server.createobject("adodb.recordset")
	sql="select * from [G_User] where G_UserName='"&username&"' and G_PassWord='"&md5(password)&"'"
	rs.open sql,conn,1,1
	
	if rs.eof then   '如果没有数据
		call close_rs
		call close_conn
		response.write"<script>alert('用户名或密码不正确!');history.back();</script>"
		response.end
	else
	'如果有数据，就生成cookies，完成登陆
	'如果登陆用户名和密码都正确，则判断Level,为1，则为管理员，生成session
	if rs("G_Level")=1 then
		session("Admin")=rs("G_UserName")
	end if
	
	
		select case login            '设置登录保留状态
			case 1:
				response.cookies("guest")("username")=rs("G_UserName")
			case 2:
				response.cookies("guest")("username")=rs("G_UserName")
				response.cookies("guest").expires=Date()+1     '保留一天
			case 3:
				response.cookies("guest")("username")=rs("G_UserName")
				response.cookies("guest").expires=Date()+30     '保留一月
			case 4:
				response.cookies("guest")("username")=rs("G_UserName")
				response.cookies("guest").expires=Date()+365    '保留一年
			case else
				response.cookies("guest")("username")=rs("G_UserName")
		end select
		
	
		call close_rs
		call close_conn
	'登陆成功跳转到首页
		response.redirect "index.asp"
	end if
	
%>










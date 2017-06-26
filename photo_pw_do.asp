<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	dim pass,sid
	if request.form("send") = "确定" then
		pass = request.form("password")
		sid = request.form("sid")
	end if
%>
<!--#include file="conn.asp"-->
<!--#include file="md5.asp"-->
<%
	dim rs,sql
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Photo where G_PhotoPassWord='"&md5(pass)&"' and G_ID="&sid
	rs.open sql,conn,1,1
	
	'不存在此数据，返回
	if rs.eof then
		call close_rs
		call close_conn
		response.write "<script>alert('不存在此数据或密码不正确');history.back();</script>"
		response.end
	else
		call close_rs
		call close_conn
		'正确了之后，生成session
		session("phtotopass") = request.cookies("guest")("username")
		response.redirect "photo_show.asp?ShowId="&sid
	end if

%>

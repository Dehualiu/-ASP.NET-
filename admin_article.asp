<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	'必须是会员
	if request.cookies("guest")("username")="" then
		response.write "<script>alert('不是会员不能进!');history.back();</script>"
		response.end
	end if
	
	'而且还是管理员
	if session("Admin") = "" then
		response.write "<script>alert('不是管理员不能进!');history.back();</script>"
		response.end
	end if
	
%>
<!--#include file="conn.asp"-->
<%
	dim rs,sql
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Article where G_SID=0 and G_Del<>0"
	rs.open sql,conn,1,1
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
</head>
<body>
<!--#include file="header.asp"-->
<div id="sidebarmember">
	<h1>后台管理</h1>	
<!--#include file="admin_sidebar.asp"-->
</div>

<div id="contentmember">
	<h1>后台首页 -- 主题管理</h1>	
	<div>
	
		<table style="margin-top:40px;">
			<tr><th>发帖人</th><th>主题标题</th><th>操作</th></tr>
			<%do while not rs.eof%>
			<tr><td><%=rs("G_UserName")%></td><td><strong title="<%=rs("G_Content")%>"><%=rs("G_Title")%></strong></td><td><a href="admin_ar_del.asp?ShowId=<%=rs("G_ID")%>">永久删除</a> <a href="admin_re_hy.asp?ShowId=<%=rs("G_ID")%>">还原</a><td></tr>
			<%
					rs.movenext
				loop
			%>
		</table>
	</div>
</div>

<!--#include file="footer.asp"-->	
</body>
</html>
<%
	call close_conn
%>
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<!--#include file="conn.asp"-->
<%
	dim rs,sql
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Photo"
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

<div id="photo">
	<h1>相 册 列 表</h1>	
	<div>
		<%
			do while not rs.eof
				dim a,photoclass
				photoclass = rs("G_PhotoClass")
				if photoclass = 0 then
					a = "(公开)"
				elseif photoclass = 1 then
					a = "(私密)"
				end if
		%>
		<dl id="photodl">
			<dt><a href="photo_show.asp?ShowId=<%=rs("G_ID")%>"><img style="padding:10px 0 0 13px;" src="<%=rs("G_PhotoPic")%>" alt="封面" /></a></dt>
			<dd><a href="photo_show.asp?ShowId=<%=rs("G_ID")%>" style="color:#333;text-decoration:none;"><%=rs("G_PhotoName")%><%=a%></a></dd>
			<%if session("Admin") <> "" then%>
			<dd style="font-size:12px;">[<a href="photo_mof.asp?ShowId=<%=rs("G_ID")%>">修改</a>] [<a href="photo_dir_del.asp?ShowId=<%=rs("G_ID")%>">删除</a>]</dd>
			<%end if%>
	  </dl>
		<%
				rs.movenext
			loop
		%>
		<%if session("Admin") <> "" then%>
		<p style="clear:both;text-align:center;margin-top:20px;"><a href="photo_add.asp">添加目录</a></p>
		<%end if%>
	</div>
</div>

<!--#include file="footer.asp"-->	
</body>
</html>
<%
	call close_conn
%>
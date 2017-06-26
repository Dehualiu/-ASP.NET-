<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
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
	dim rs,sql,picname,picdir,picdate
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Pic where G_ID="&showid
	rs.open sql,conn,1,1
	
	'不存在此数据，返回
	if rs.eof then
		call close_rs
		call close_conn
		response.write "<script>alert('不存在此数据');history.back();</script>"
		response.end
	else
		picname = rs("G_PicName")
		picdir = rs("G_PicDir")
		picdate = rs("G_Date")
		picsid = rs("G_PicSid")
	end if
	
	call close_rs
	
	
	'去查找G_Photo表
	set rs2 = server.createobject("adodb.recordset")
	sql2 = "select * from G_Photo where G_ID="&picsid
	rs2.open sql2,conn,1,1
	
	if not rs2.eof then
		
		psclass2 = rs2("G_PhotoClass")		
		
	end if
	
	rs2.close
	set rs2 = nothing
	
	'判断是相册是否解密
	if psclass2 = 1 then
		if session("Admin") = "" then
			if session("phtotopass") = "" then
				response.write "<script>alert('此照片为私有照片，需要输入密码');location.href='photo_pw.asp?ShowId="&showid&"';</script>"
				response.end
			end if
		end if
	end if
	
	
	
	
	'求出上一张图片的ID
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Pic where G_PicSid="&picsid&" and G_ID>"&showid&" order by G_Date asc"
	rs.open sql,conn,1,1
	
	if not rs.eof then
		pa = "<a href='photo_show_detail.asp?ShowId="&rs("G_ID")&"#1'>上一张</a>"
	else
		pa = "到顶了"
	end if
	
	call close_rs
	
	'求下一张的ID
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Pic where G_PicSid="&picsid&" and G_ID<"&showid&" order by G_Date desc"
	rs.open sql,conn,1,1
	
	if not rs.eof then
		na = "<a href='photo_show_detail.asp?ShowId="&rs("G_ID")&"#1'>下一张</a>"
	else
		na = "到底了"
	end if
	
	rs.close
	set rs = nothing
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
</head>
<body>
<!--#include file="header.asp"-->

<div id="photo" style="height:1500px;"> <a name="1"></a>
	<h1>图片详细信息</h1>	
	<div style="height:1450px;">
		<p style="text-align:center;margin:20px;"><a href="photo_show.asp?ShowId=<%=picsid%>">返回目录</a></p>
		<p style="text-align:center;margin:20px;">
			<%=pa%> <img src="<%=picdir%>" alt="<%=picname%>" /> <%=na%>
		</p>
		<p style="text-align:center;margin:20px;"><%=picname%></p>


		
	</div>
</div>

<!--#include file="footer.asp"-->	
</body>
</html>
<%
	call close_conn
%>
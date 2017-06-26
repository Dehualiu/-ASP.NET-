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
	
	'会员才能进
	if request.cookies("guest")("username") = "" then
		response.write "<script>alert('非会员无法查看');history.back();</script>"
		response.end
	end if
	

	
%>
<!--#include file="conn.asp"-->
<%
	dim rs,sql,psclass,rs2,sql2,psclass2
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Photo where G_ID="&showid
	rs.open sql,conn,1,1
	
	'不存在此数据，返回
	if rs.eof then
		call close_rs
		call close_conn
		response.write "<script>alert('不存在此数据');history.back();</script>"
		response.end
	end if
	
	call close_rs
	
	'查找图片信息
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Pic where G_PicSid="&showid&" order by G_Date desc"
	rs.open sql,conn,1,1
	
	if not rs.eof then
		psclass = rs("G_PicSid")
	end if
	
	'去查找G_Photo表
	set rs2 = server.createobject("adodb.recordset")
	sql2 = "select * from G_Photo where G_ID="&psclass
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
				response.write "<script>alert('此相册为私有相册，请输入密码');location.href='photo_pw.asp?ShowId="&showid&"';</script>"
				response.end
			end if
		end if
	end if
	
%>
<!--#include file="images.asp"-->
<%
	dim img,w,h,t
	set img = new cnGhostImage   
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
	<h1>图片列表</h1>	
	<div>
		
		<%
			do while not rs.eof
				
				img.Path = Server.MapPath(rs("G_PicDir"))   
				w = img.W()
				h = img.H()
				h = h*0.3
				t = 0
				if (t < h) then
					t = h  '循环到最后，t可以得到最高的图片的高度
				end if
				t = t + 100
				rs.movenext
			loop
		
			rs.movefirst
		
			do while not rs.eof
				img.Path = Server.MapPath(rs("G_PicDir"))   
				w = img.W()
				h = img.H()
		%>
		<dl style="float:left;margin:12px;height:<%=t%>px">
			<dt><a href="photo_show_detail.asp?ShowId=<%=rs("G_ID")%>"><img src="<%=rs("G_PicDir")%>" alt="<%=rs("G_PicName")%>" style="width:<%=w*0.3%>px;height:<%=h*0.3%>px;border-radius: 10px;box-shadow:0px 0px 10px #000;" /></a></dt>
			<dd style="text-align:center;"><a href="photo_show_detail.asp?ShowId=<%=rs("G_ID")%>"><%=rs("G_PicName")%></a></dd>
		</dl>
		<%
				rs.movenext
			loop
		%>

		
		<p style="clear:both;text-align:center;padding:20px;"><a href="photo_show_add.asp?Sid=<%=showid%>">我要上传</a></p>
	</div>
</div>

<!--#include file="footer.asp"-->	
</body>
</html>
<%
	call close_rs
	call close_conn
%>
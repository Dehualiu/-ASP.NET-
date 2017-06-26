<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	dim photoname,photoclass,photopassword,photocontent,photopic,showid
	showid = request.form("ShowId")
	
	if showid = "" or not isnumeric(showid) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	photoname = request.form("photoname")
	photopassword = request.form("photopassword")
	photoclass = request.form("photoclass")
	photocontent = request.form("photocontent")
	photopic = request.form("photopic")
	
	if photoname = "" or len(photoname) < 3 then
		response.write "<script>alert('相册名称不能少于3位!');history.back();</script>"
		response.end
	end if
	
	if len(photocontent) > 200 then
		response.write "<script>alert('相册简介不得大于200位!');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
<!--#include file="md5.asp"-->
<%
	dim rs,sql
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
	
	
	
	'如果验证存在，就修改相册信息
	if photoclass = 0 then
		sql = "update G_Photo set G_PhotoName='"&photoname&"',G_PhotoPic='"&photopic&"',G_PhotoContent='"&photocontent&"',G_PhotoClass=0,G_PhotoPassWord=null where G_ID="&showid
	else
		if photoclass = 1 and photopassword = "" then
			sql = "update G_Photo set G_PhotoName='"&photoname&"',G_PhotoPic='"&photopic&"',G_PhotoContent='"&photocontent&"',G_PhotoClass=1 where G_ID="&showid
		else
			sql = "update G_Photo set G_PhotoName='"&photoname&"',G_PhotoPic='"&photopic&"',G_PhotoContent='"&photocontent&"',G_PhotoClass=1,G_PhotoPassWord='"&md5(photopassword)&"' where G_ID="&showid
		end if
	end if
	conn.execute(sql)
	

	call close_conn
	response.write "<script>alert('相册修改完毕!');location.href='photo.asp';</script>"
%>
%>
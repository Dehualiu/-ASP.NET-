<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	
	if request.form("send") = "" then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if

	dim sid,picname,picdir
	sid = request.form("sid")
	picname  = request.form("picname")
	picdir = request.form("picdir")
	
	if sid = "" or not isnumeric(sid) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	if picname = "" then
		response.write "<script>alert('图片名不得为空');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
<%
	dim rs,sql
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Photo where G_ID="&sid
	rs.open sql,conn,1,1
	
	'不存在此数据，返回
	if rs.eof then
		call close_rs
		call close_conn
		response.write "<script>alert('不存在此目录');history.back();</script>"
		response.end
	end if
	
	'全部验证完毕，新增图片
	sql = "insert into G_Pic (G_PicSid,G_PicName,G_PicDir,G_Date) values ("&sid&",'"&picname&"','"&picdir&"',now())"
	conn.execute(sql)
	
	response.write "<script>alert('图片新增成功');location.href='photo_show.asp?ShowId="&sid&"';</script>"
%>

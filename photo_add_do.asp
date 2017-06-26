<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	
	dim photoname,photoclass,photopassword,photocontent
	photoname = request.form("photoname")
	photopassword = request.form("photopassword")
	photoclass = request.form("photoclass")
	photocontent = request.form("photocontent")
	
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
	'全部接受到之后，怎么处理？
	
	
	'服务器创建文件夹
	dim fso,tdate
	tdate = year(date) & month(date) & day(date) & hour(time) & minute(time) & second(time)
	set fso = server.createobject("scripting.filesystemobject")
	
	'判断当前时间的目录是否存在
	if fso.folderexists(server.mappath("upload\" & tdate)) then
		response.write "<script>alert('出错！相册目录已存在!');history.back();</script>"
		response.end
	else
		fso.createfolder server.mappath("upload\" & tdate)
	end if
	
	set fso = nothing
	
	
	'将相册信息写入数据库
	dim sql
	if photopassword = "" and photoclass = 0 then
		sql = "insert into G_Photo (G_PhotoDir,G_PhotoName,G_PhotoClass,G_PhotoContent,G_Date) values ('"&tdate&"','"&photoname&"','"&photoclass&"','"&photocontent&"',now())"
	else
		sql = "insert into G_Photo (G_PhotoDir,G_PhotoName,G_PhotoPassWord,G_PhotoClass,G_PhotoContent,G_Date) values ('"&tdate&"','"&photoname&"','"&md5(photopassword)&"','"&photoclass&"','"&photocontent&"',now())"
	end if
	conn.execute(sql)
	

	call close_conn
	response.write "<script>alert('相册创建完毕!');location.href='photo.asp';</script>"
%>
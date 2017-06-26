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
	
	'开始筛选数据
	dim rs,sql,photodir
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Photo where G_ID="&showid
	rs.open sql,conn,1,1
	
	'不存在此数据，返回
	if rs.eof then
		call close_rs
		call close_conn
		response.write "<script>alert('不存在此数据');history.back();</script>"
		response.end
	else
		'读出文件夹的名字
		photodir = rs("G_PhotoDir")
		'存在执行删除命令,删除数据库文件
		sql = "delete from G_Photo where G_ID="&showid
		conn.execute(sql)
		
		'删除磁盘里存在的文件夹
		dim fso
		set fso = server.createobject("scripting.filesystemobject")
		if fso.folderexists(server.mappath("upload\"&photodir)) then
			fso.deletefolder(server.mappath("upload\"&photodir))
		else
			response.write "<script>alert('相册不存在，无法删除');history.back();</script>"
			response.end
		end if
		set fso = nothing
		
	end if
	
	call close_rs
	call close_conn
	
	
	response.write "<script>alert('相册删除成功');location.href='photo.asp'</script>"
%>
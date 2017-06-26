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
	dim rs,sql

	'判断是否有这条数据
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Article where G_ID="&showid
	rs.open sql,conn,1,1

	if not rs.eof then
		'存在数据,先删主题
		sql = "delete from G_Article where G_ID="&showid
		conn.execute(sql)
		
		'再删紧追其后的回帖,sql是可以批处理的，所以，有多少条满足就能删多少条
		sql = "delete from G_Article where G_SID="&showid
		conn.execute(sql)
	else
		call close_rs
		call close_conn
		response.write "<script>alert('不存在此数据!');history.back();</script>"
		response.end
	end if
	
	call close_rs
	call close_conn
	
	response.write "<script>alert('永久删除成功!');location.href='admin_article.asp';</script>"

%>
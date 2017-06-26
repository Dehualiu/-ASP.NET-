<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%	
	dim username,showid,a
	
	username = request.querystring("username")
	showid = request.querystring("showid")
	a = request.querystring("a")
	
	'非法操作
	if username = "" then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	if showid = "" or not isnumeric(showid) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	if a = "" or not isnumeric(a) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
<%
	dim rs,sql,speaksql
	
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_User where G_UserName='"&username&"'"
	rs.open sql,conn,1,1
	
	if not rs.eof then
		
		if a = 0 then  '如果a是0，那么就禁言，如果a是1，那么就解禁
			speaksql = "update G_User set G_Speak=1 where G_UserName='"&username&"'"
			conn.execute(speaksql)
			call close_rs
			call close_conn
			response.write "<script>alert('禁言成功');location.href='article.asp?ShowId="&showid&"';</script>"
		elseif a = 1 then
			speaksql = "update G_User set G_Speak=0 where G_UserName='"&username&"'"
			conn.execute(speaksql)
			call close_rs
			call close_conn
			response.write "<script>alert('解禁成功');location.href='article.asp?ShowId="&showid&"';</script>"
		end if
		
		
		
	else
		response.write "<script>alert('不存在此数据');history.back();</script>"
		response.end
	end if
	
	
	
%>
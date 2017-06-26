<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	dim fromuser,touser
	fromuser=request.QueryString("fromuser")
	touser=request.QueryString("touser")

	if fromuser="" or touser="" then
		response.write "<script>alert('非法操作！');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
<%	
	dim rs,sql
	set rs=server.createobject("adodb.recordset")
	sql="select * from G_Friend where G_FromUser='"&fromuser&"' and G_ToUser='"&touser&"'"
	rs.open sql,conn,1,1
	
		if rs.eof then
		call close_rs
		call close_conn
		response.write "<script>alert('非法操作！');history.back();</script>"
		response.end
		
	else
	'判断成功后，删除
		sql="delete from G_Friend where G_FromUser='"&fromuser&"' and G_ToUser='"&touser&"'"
		conn.execute(sql)
	end if
	
	call close_rs
	call close_conn
	
	'response.redirect "member_friend.asp"
	response.Write "<script>alert('很遗憾，你拒绝对对方的验证');location.href='member_friend.asp';</script>"
	
	

%>

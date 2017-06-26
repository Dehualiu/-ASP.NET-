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
	
%>
<!--#include file="conn.asp"-->
<%
	dim showid,rs,sql,delsql
	showid = request.querystring("ShowId")
	
	'非法操作
	if showid = "" or not isnumeric(showid) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	'判断是否有这条数据
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_User where G_ID="&showid
	rs.open sql,conn,1,1
	
	
	if not rs.eof then
		delsql = "delete from G_User where G_ID="&showid
		conn.execute(delsql)
	else
		call close_rs
		call close_conn
		response.write "<script>alert('不存在此数据!');history.back();</script>"
		response.end
	end if
	
	
	call close_rs
	call close_conn
	
	response.write "<script>alert('删除成功!');location.href='admin_vip.asp';</script>"

%>
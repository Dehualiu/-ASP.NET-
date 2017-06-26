<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	dim showid,sid
	showid = request.querystring("ShowId")
	sid = request.querystring("sid")
	
	'非法操作
	if showid = "" or not isnumeric(showid) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	
	if session("Admin") = "" then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
%>

<!--#include file="conn.asp"-->

<%
	'只要把那个帖子的G_Del的0改为1就可以把帖子放入回收站了
	
	dim rs,sql
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Article where G_ID="&showid
	rs.open sql,conn,1,1
	
	'不存在此数据，返回
	if rs.eof then
		call close_rs
		call close_conn
		response.write "<script>alert('不存在此数据');history.back();</script>"
		response.end
	else
		'如果存在，放入回收站
		sql = "update G_Article set G_Del=1 where G_ID="&showid
		conn.execute(sql)
	end if
	
	call close_rs
	call close_conn
		
		
	if sid = showid then '说明删除的是主题
		response.write "<script>alert('此贴已经被放入回收站');location.href='index.asp'</script>"
	else
		response.write "<script>alert('此贴已经被放入回收站');location.href='article.asp?ShowId="&sid&"'</script>"
	end if
%>
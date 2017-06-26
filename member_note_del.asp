<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.Cookies("guest")("username")="" then
		response.write "<script>alert('非法操作！');history.back();</script>"
		response.end
	end if
	if request.form("send")="" then
		response.write"<script>alert('非法操作');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
<%
	dim ShowId,rs
	ShowId=request.form("ShowId")
	
	if ShowId="" then
		response.write"<script>alert('请选择你要删除的短信');history.back();</script>"
		response.end
	end if
	set rs=server.CreateObject("adodb.recordset")
	'G_ID=3属于自动编号，是数值型
	sql="select * from G_Note where G_ID in ("&ShowId&")"
	rs.open sql,conn,1,1
	
	if rs.eof then
		call close_rs
		call close_conn
		response.Write "<script>alert('找不到此数据，无法删除');history.back();</script>"
		response.end
	end if	
	'判断ShowID之后，执行删除命令
	'sql="delete from G_Note where G_ID="&ShowId    只能一条一条的删除数据
	'可以使用数组来删除，用in函数
	sql="delete from G_Note where G_ID in ("&ShowId&")"
	conn.execute(sql)
	call close_rs
	call close_conn
	response.Write "<script>alert('删除成功');location.href='member_note.asp';</script>"
%>
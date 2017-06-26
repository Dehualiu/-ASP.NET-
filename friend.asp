<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.Cookies("guest")("username")="" then
		response.write "<script>alert('请先登录再添加好友！');window.close();</script>"
		response.end
	end if
	
	dim fromuser,touser
	fromuser=request.Cookies("guest")("username")
	touser=request.QueryString("touser")
	
	'不能直接转到friend.asp页面，添加好友不能为空
	if touser="" then
		response.write"<script>alert('好友不得为空');history.back();</script>"
		response.end
	end if
	
	
	'不能加自己为好友
	if touser=fromuser then
		response.write"<script>alert('不能添加自己为好友');window.close();</script>"
		response.end
		end if
	
%>
<!--#include file="conn.asp"-->
<%
	'不能给数据库没有的会员添加好友
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from G_User where G_UserName='"&touser&"'"
	rs.open sql,conn,1,1
	if rs.eof then
		call close_rs
		call close_conn
		response.write"<script>alert('不能添加不存在的好友');history.back();</script>"
		response.end
	end if
	call close_rs
	
	
	'已经添加的好友，无法再次添加
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from G_Friend where (G_FromUser='"&fromuser&"' and G_ToUser='"&touser&"') or (G_FromUser='"&touser&"' and G_ToUser='"&fromuser&"')"
	rs.open sql,conn,1,1

	if not rs.eof then
		call close_rs
		call close_conn
		response.write"<script>alert('你已经添加了该好友，或者对方已添加了你\n\n无须再次添加');window.close();</script>"
		response.end
	end if
	call close_rs
	
	
	'添加好友
	sql="insert into G_Friend (G_FromUser,G_ToUser,G_Date) values ('"&fromuser&"','"&touser&"',now())"
	conn.execute(sql)
	
	call close_conn
	response.write"<script>alert('好友添加成功，请等待对方验证');window.close();</script>"
	
%>







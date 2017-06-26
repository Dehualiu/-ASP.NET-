<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.cookies("guest")("username")="" then
		response.write"<script>alert('非会员不能送花');window.close();</script>"
		response.end
		end if
		
	'接收送花者和收花者
	dim touser,fromuser
	touser=request.QueryString("touser")
	fromuser=request.cookies("guest")("username")
	
	
	'不能给空送花
	if touser="" then
		response.write"<script>alert('找不到收花者');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
<%
	
	'不能给数据库没有的会员送花
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from G_User where G_UserName='"&touser&"'"
	rs.open sql,conn,1,1
	if rs.eof then
		response.write"<script>alert('找不到收花者');history.back();</script>"
		response.end
	end if
	call close_rs
	
	
	

	'送花者和收花者不能为同一个人
	if touser=fromuser then
		response.write"<script>alert('不能给自己送花');window.close();</script>"
		response.end
		end if
	
	
	
	'将这两个人的信息写入数据库
	sql="insert into G_Flower(G_FromUser,G_ToUser,G_Date) values ('"&fromuser&"','"&touser&"',now())"
	conn.execute(sql)
	response.write"<script>alert('"&fromuser&"给"&touser&"成功送了一枝花');window.close();</script>"
%>
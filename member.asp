<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.Cookies("guest")("username")="" then
		response.write "<script>alert('非法操作！');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
<%
	dim rs,sql,username,sex,face,url,qq,email,underwrite
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from G_User where G_UserName='"&request.Cookies("guest")("username")&"'"
	rs.open sql,conn,1,1
	
	if not rs.eof then
		username=rs("G_UserName")
		sex=rs("G_Sex")
		face=rs("G_Face")
		url=rs("G_Url")
		qq=rs("G_QQ")
		email=rs("G_Email")
		underwrite=rs("G_UnderWrite")
	else
		response.write"<script>alert('非法操作！');history.back();</script>"
		response.end
	end if
	
	call close_rs
	call close_conn

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
</head>

<body>
<!--#include file="header.asp"-->
    <div id="sidebarmember">
        <h1>会 员 管 理</h1>
<!--#include file="member_sidebar.asp"-->
<!--#include file="ubb.asp"-->
    </div>
    <div id="contentmember">
        <h1>会 员 个 人 中 心</h1>
        <div class="member_member">
			<dl>
            	<dd>用 户 名：<%=username%></dd>
                <dd>性&nbsp;&nbsp;别：&nbsp;&nbsp;<%=sex%></dd>
                <dd>头&nbsp;&nbsp;像：<%=face%></dd>
                <dd> &nbsp;Q&nbsp;&nbsp;Q：<%=qq%></dd>
                <dd>&nbsp;E-Mail：<%=email%></dd>
                <dd>个人网站：<%=url%></dd>
                <dd style="height:auto;padding:5px 0;">个人签名：<%=ubb(underwrite)%></dd>
            </dl>
        </div>
    </div>
<!--#include file="footer.asp"-->

</body>

</html>
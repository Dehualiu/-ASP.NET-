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
	'接收发送过来的短信ID
	dim rs,sql,ShowId,fromuser,touser,tdate,message,title
	ShowId=request.QueryString("ShowId")
	'判断数据合理性
	if not isnumeric(ShowId) or ShowId="" then
		response.Write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	set rs=server.CreateObject("adodb.recordset")
	'G_ID=3属于自动编号，是数值型
	sql="select * from G_Note where G_ID="&ShowId
	rs.open sql,conn,1,1
	
	if rs.eof then
		response.Write "<script>alert('找不到此数据，请重新来过');history.back();</script>"
		response.end
	end if	
	fromuser=rs("G_FromUser")
	touser=rs("G_ToUser")
	tdate=rs("G_Date")
	message=rs("G_Message")
	
	if len(message)>15 then
		title=left(message,15)
	else
		title=message
	end if
	
	'如果读取成功，将未读的0改为已读的1
	sql = "update G_Note set G_Read=1 where G_ID="&ShowId
	conn.execute(sql)
	
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
        <h1>会员管理</h1>
<!--#include file="member_sidebar.asp"-->
    </div>
        <div id="contentmember">
        <h1>会员个人中心</h1>
        <div>
        	<h2><%=title%></h2>
            <p style="text-align:center;height:30px;line-height:30px;">收件人：<strong><%=touser%></strong> 发件人：<strong><%=fromuser%></strong> 发表时间：<%=tdate%></p>
            <p style="padding:20px 40px;"><%=message%></p>
        
        </div>
    </div>
</body>
<!--#include file="footer.asp"-->
</html>
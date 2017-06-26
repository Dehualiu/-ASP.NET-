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
	dim rs,sql,page,url
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from G_Note where G_FromUser ='"&request.Cookies("guest")("username")&"' order by G_Date desc"
	rs.open sql,conn,1,1
	
	
	'处理分页
	rs.pagesize=5
	'接受page的值
	page=request.querystring("page")
	'直接点击博友页面,没有传递page的值的情况
	if page="" then page=1
	'判断如果不是数字，则page=1
	if not isnumeric(page) then page=1
	'page的值为0或者负数时
	if clng(page)<1 then page=1
	'如果page大于最大的书页数，那么page为最后一页
	if clng(page)>rs.pagecount then page=rs.pagecount
	
	
	'把接收到的值赋值给页码,如果没有数据,rs.absolutepage不能重置
	if not rs.eof then
		rs.absolutepage=page
	end if
	
	
	
	'统计短信的条数
	notecount=rs.recordcount
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
        	<p style="text-align:center;height:30px;line-height:30px;"><a href="member_note.asp">收件箱</a> |<a href="member_note2.asp"> 发件箱</a></p>
             <p style="text-align:center;height:30px;line-height:30px;">你的发件箱一共有<%=notecount%>条短信</p>
        	<table>
            	<tr><th>收件人</th><th>发件内容</th><th>发件时间</th></tr>
                <%
					for i=1 to rs.pagesize
                    if rs.eof then exit for
						dim message
						if len(rs("G_Message"))>15 then
							message=left(rs("G_Message"),15)
							message=message&"..."
						else
							message=rs("G_Message")
						end if
				%>
                <tr><td><%=rs("G_ToUser")%></td><td><a href="member_note_d.asp?ShowId=<%=rs("G_ID")%>"><%=message%></a></td><td><%=rs("G_Date")%></td></tr>
                <%
					rs.movenext
					next			
				%>
            </table>
            <span id="page">
                    <ul>
                    <%
                            for i=1 to rs.pagecount
							'如果点击查询，按照查询来分页处理
							'否则按照普通的分页来处理
								url="page="&i
                    %>
                        <li><a href="member_note2.asp?<%=url%>"><%=i%></a></li>
					<%
                        next
                    %>
                    </ul>
           </span>
        </div>
    </div>
<!--#include file="footer.asp"-->

</body>

</html>
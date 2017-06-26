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
	'我添加的好友
	dim rs,sql,friendcount,page,url
	set rs=server.createobject("adodb.recordset")
	sql="select * from G_Friend where G_FromUser='"&request.Cookies("guest")("username")&"' order by G_Date desc"
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
	
		'统计好友总个数
	friendcount=rs.recordcount
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
<script type="text/javascript" src="js/checkall.js"></script>
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
        	<p><a href="member_friend.asp"><span class="note_top1">添加我的好友</span></a>
            <a href="member_friend2.asp"><span class="note_top2"> 我添加的好友</span></a></p>
        	<p class="note_min">你一共添加<%=friendcount%>个好友</p>
            <table>
            	<tr><th>好友名称</th><th>添加时间</th><th>状态</th></tr>
                <% 
                	for i=1 to rs.pagesize
                    if rs.eof then exit for
						dim tval,valstring
						tval=rs("G_Val")
							if tval=0 then
							valstring="对方未验证"
						else
							valstring="双方已是好友"
						end if
				%>
                <tr><td><%=rs("G_ToUser")%></td><td><%=rs("G_Date")%></td><td><%=valstring%></td></tr>
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
                        <li><a href="member_friend2.asp?<%=url%>"><%=i%></a></li>
					<%
                        next
                    %>
                    </ul>
                </span>
        </div>
    </div>
<%
	call close_rs
	call close_conn
%>
<!--#include file="footer.asp"-->

</body>

</html>
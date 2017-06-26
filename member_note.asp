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
	dim rs,sql,notecount,page,url
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from G_Note where G_ToUser ='"&request.Cookies("guest")("username")&"' order by G_Date desc"
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
<script type="text/javascript" src="js/checkall.js"></script>
<script type="text/javascript" src="js/noyesdel.js"></script>
</head>
<body>
<!--#include file="header.asp"-->
    <div id="sidebarmember">
        <h1>会 员 管 理</h1>
<!--#include file="member_sidebar.asp"-->
    </div>
    <div id="contentmember">
        <h1>会 员 个 人 中 心</h1>
        <div>
        	<p><a href="member_note.asp"><span class="note_top1">收件箱</span></a> <a href="member_note2.asp"> <span class="note_top2">发件箱</span></a></p>
            <p class="note_min">你的收件箱一共有<%=notecount%>条短信</p>
            <form method="post" action="member_note_del.asp">
        	<table>
            	<tr><th>发件人</th><th>发件内容</th><th>发件时间</th><th>状态</th><th>操作</th></tr>
                <%
					for i=1 to rs.pagesize
                    if rs.eof then exit for
						dim message,read
						if len(rs("G_Message"))>15 then
							message=left(rs("G_Message"),15)
							message=message&"..."
						else
							message=rs("G_Message")
						end if
						
						if rs("G_Read")=0 then
							read="<strong style='color:red'>未读</strong>"
						else
							read="<span style='color:blue'>已读</span>"
						end if
				%>
                <tr><td><%=rs("G_FromUser")%></td><td><a href="member_note_d.asp?ShowId=<%=rs("G_ID")%>"><%=message%></a></td><td><%=rs("G_Date")%></td><td><%=read%></td><td><input type="checkbox" name="ShowId" value="<%=rs("G_ID")%>" /></td></tr>
                <%
					rs.movenext
					next			
				%>
                <tr><td colspan="5" style="text-align:right;">
                <input type="checkbox" onclick="CheckAll(this.form);" name="chkall" />全选
                <input class="member_shan" type="submit" onclick="return del();" name="send" value="删除"></td></tr>
            </table>
            </form>
            <span id="page">
                    <ul>
                    <%
                            for i=1 to rs.pagecount
							'如果点击查询，按照查询来分页处理
							'否则按照普通的分页来处理
								url="page="&i
                    %>
                        <li><a href="member_note.asp?<%=url%>"><%=i%></a></li>
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
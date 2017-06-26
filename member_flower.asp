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
	sql="select * from G_Flower where G_ToUser ='"&request.Cookies("guest")("username")&"' order by G_Date desc"
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
	
	'统计花朵的数量
	flowercount=rs.recordcount
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
        <h1>会 员 个 人 中 心</h1>
        <div>
            <p class="note_min">你一共有(<strong>&nbsp;<%=flowercount%>&nbsp; x &nbsp;</strong><img src="image/x4.gif" alt="花">&nbsp;)枝花朵</p>
            <form method="post" action="member_note_del.asp">
        	<table>
            	<tr><th>送花人</th><th>送花枝数</th><th>送花时间</th></tr>
                <%
					for i=1 to rs.pagesize
                    if rs.eof then exit for
				%>
                <tr><td><%=rs("G_FromUser")%></td><td>(<strong>&nbsp;1&nbsp; x &nbsp;</strong><img src="image/x4.gif" alt="花">&nbsp;)</td><td><%=rs("G_Date")%></td></tr>
                <%
					rs.movenext
					next			
				%>
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
                        <li><a href="member_flower.asp?<%=url%>"><%=i%></a></li>
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
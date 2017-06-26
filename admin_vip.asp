<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%	
	'必须是会员
	if request.cookies("guest")("username")="" then
		response.write "<script>alert('不是会员不能进!');history.back();</script>"
		response.end
	end if
	
	'而且还是管理员
	if session("Admin") = "" then
		response.write "<script>alert('不是管理员不能进!');history.back();</script>"
		response.end
	end if
	
%>
<!--#include file="conn.asp"-->
<%
	dim rs,sql,a
	set rs = server.createobject("adodb.recordset")
	
	a = request.querystring("a")

	if a = 0 then	
		sql = "select * from G_User where G_Level=0 order by G_Date desc"
	elseif a = 1 then
		sql = "select * from G_User where G_Level=1 order by G_Date desc"
	else
		sql = "select * from G_User where G_Level=0 order by G_Date desc"
	end if
	
	rs.open sql,conn,1,1
	
	
	'分页处理
	rs.pagesize = 8
	allpage = rs.pagecount
	allcount = rs.recordcount
	page = request.querystring("page")
	if page = "" then page = 1
	if isnumeric(page) then
		'如果是0或者负数，那么page还是1 cint是整型，clng是长整形
		if clng(page) <1 then page = 1
		'如果page大于最大的分页数，那么就是最后一页
		if clng(page) > rs.pagecount then page = rs.pagecount
	else	
		page = 1
	end if
	if not rs.eof then
		rs.absolutepage = page
	end if
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
	<h1>后台管理</h1>	
<!--#include file="admin_sidebar.asp"-->
</div>

<div id="contentmember">
	<h1>后台首页 -- 会员管理</h1>	
	<div>
		<p><a class="note_top1" href="admin_vip.asp?a=0">普通会员</a>
        <a class="note_top2" href="admin_vip.asp?a=1">特殊会员</a></p>
		<table style="margin-top:70px;">
			<tr><th>会员名称</th><th>性别</th><th>邮件</th><th>注册时间</th><th>操作</th></tr>
			<%
				for i = 1 to rs.pagesize
					if rs.eof then exit for
			%>
			<tr><td><%=rs("G_UserName")%></td><td><%=rs("G_Sex")%></td><td><%=rs("G_Email")%></td><td><%=rs("G_Date")%></td><td><a href="admin_vip_mof.asp?ShowId=<%=rs("G_ID")%>">修改</a> <a href="admin_vip_del.asp?ShowId=<%=rs("G_ID")%>">删除</a></td></tr>
			<%
					rs.movenext
				next
			%>
		</table>
		<p class="fenye">
			共 <strong><%=allcount%></strong> 篇文章 | 
			<%=page%>/<%=allpage%>页 | 
			<%if page = 1 then%>
			首页 | 
			上一页 | 
			<%else%>
			<a href="admin_vip.asp">首页</a> | 
			<a href="admin_vip.asp?page=<%=page-1%>">上一页</a> | 
			<%end if%>
			<%
				'比较的时候，传过来的是字符串，所以，要转换成整形
				if clng(page) = allpage then
			%>
			下一页 | 
			尾页
			<%else%>
			<a href="admin_vip.asp?page=<%=page+1%>">下一页</a> | 
			<a href="admin_vip.asp?page=<%=allpage%>">尾页</a>
			<%end if%>
		</p>
	</div>
</div>

<!--#include file="footer.asp"-->	
</body>
</html>
<%
	call close_conn
%>
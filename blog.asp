<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<!--#include file="conn.asp"-->
<%
'打开表，选择全部数据
	dim rs,sql,page,kind,keyword,url
	set rs=server.CreateObject("adodb.recordset")
	
	if request.QueryString("send")="查询" then
		kind=request.QueryString("kind")
		keyword=request.QueryString("keyword")
		if kind="精确" then
			sql="select * from G_User where G_UserName='"&keyword&"' order by G_Date desc"
		elseif kind="模糊" then
			sql="select * from G_User where G_UserName like '%"&keyword&"%' order by G_Date desc"
		end if
		
	else
		sql="select * from G_User order by G_Date desc"
	end if
	
	rs.open sql,conn,1,1
	
	'处理分页
	rs.pagesize=web_blog
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
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
</head>

<body>
<!--#include file="header.asp"-->

<div id="blog">
	<h1>博 友 列 表</h1>
        <div>
        	<form method="get" action="blog.asp">
            	<input type="radio" name="kind" value="精确" checked="checked" /><span>精确</span>
                &nbsp;&nbsp;&nbsp;
                <input type="radio" name="kind" value="模糊" /><span>模糊</span>
                &nbsp;&nbsp;&nbsp;
                <span>关键字：</span>
                &nbsp;&nbsp;&nbsp;
                <input class="blog_text" type="text" name="keyword" />
                &nbsp;&nbsp;
                <input class="blog_cha" type="submit" value="查询" name="send"/>    
            </form>
			<%
				if rs.eof then
					response.write"<p style='text-align:center;'>没有任何博友</p>"
				end if
                for i=1 to rs.pagesize
                    if rs.eof then exit for
            %>
                <dl>
                    <dt><%=rs("G_UserName")%></dt>
                    <dd><img src="<%=rs("G_Face")%>" alt="<%=rs("G_UserName")%>" /></dd>
                    <dd><a href="###" onclick="javascript:window.open
                    ('flower.asp?touser=<%=rs("G_UserName")%>','flower','width=400,height=200,left=0,top=0')">给我送花</a>
                    |
                    <a href="###" onclick="javascript:window.open
                    ('note.asp?touser=<%=rs("G_UserName")%>','note','width=400,height=400,left=0,top=0')">写短信</a></dd>
                    <dd><a href="###" onclick="javascript:window.open
                    ('friend.asp?touser=<%=rs("G_UserName")%>','friend','width=400,height=400,left=0,top=0')">
                    &nbsp;&nbsp;&nbsp;加为好友</a> 
                    </dd>
                </dl>
            <%
                rs.movenext
                next
            %>
                <span id="page">
                    <ul>
                        <%
                            for i=1 to rs.pagecount
							'如果点击查询，按照查询来分页处理
							'否则按照普通的分页来处理
							if request.QueryString("send")="查询" then
								url="page=" &i& "&kind=" &request.QueryString("kind")&"&send=" &request.QueryString("send")&"&keyword=" &request.QueryString("keyword")
								'page=1&kind=模糊&send=查询&a
							else
								url="page="&i
							end if
                        %>
                        <li><a href="blog.asp?<%=url%>"><%=i%></a></li>
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
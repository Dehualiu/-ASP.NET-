<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	'读取xml文件，提取里面的内容
	dim oXML   '声明一个变量
	set oXML = server.CreateObject("Microsoft.XMLDOM")  '创建一个XMLDOM实例
	oXML.load(server.MapPath("vip.xml"))        '载入这个XML文件
	
	set oXMLRoot = oXML.documentElement   '创建一个文档元素
	'查找节点，取得里面的内容
	set username = oXMLRoot.SelectSingleNode("//username")    '提取姓名对象
	set face = oXMLRoot.SelectSingleNode("//face")    '提取头像对象
	set email = oXMLRoot.SelectSingleNode("//email")    '提取邮件对象
	set url = oXMLRoot.SelectSingleNode("//url")    '提取个人网站对象
	
	'通过这些对象取出里面的值
	vusername = username.text
	vface = face.text
	vemail = email.text
	vurl = url.text
	
	set username = nothing
	set face = nothing
	set email = nothing
	set url = nothing
	set oXMLRoot = nothing          '销毁
	set oXML = nothing
%>
<!--#include file="conn.asp"-->
<%

	'循环文章列表
	dim rs,sql
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from G_Article where G_SID=0 order by G_Date desc"
	rs.open sql,conn,1,1
		
	'分页处理
	'设置每页多少条,现在使用系统参数来决定每页多少条
	rs.pagesize = web_article
	
	'总页数
	allpage = rs.pagecount
	
	'总条数
	allcount = rs.recordcount
	
	'接收传过来的page页码
	page = request.querystring("page")
	
	'一开始，进入博友界面，没有传page值，那么page就是空置，所以可以设置为第一页1
	if page = "" then page = 1
	
	'判断如果不是数字，那么page = 1
	if isnumeric(page) then
		'如果是0或者负数，那么page还是1 cint是整型，clng是长整形
		if clng(page) <1 then page = 1
		'如果page大于最大的分页数，那么就是最后一页
		if clng(page) > rs.pagecount then page = rs.pagecount
	else	
		page = 1
	end if
	
	
	'当前页码
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
    <div id="sidebar">
        <h1>新进会员: <%=vusername%></h1>
        <div>
        	<dl>
            	<dt><img src="<%=vface%>" alt="新进会员" /></dt>
             
                <dd><img src="image/x4.gif">&nbsp;&nbsp;&nbsp;&nbsp;
                <a href="###" onclick="javascript:window.open('flower.asp?touser=<%=vusername%>','flower','width=500,height=250,left=0,top=0')">给我送花</a>
                </dd>
                
                <dd><img src="image/noread.gif">&nbsp;&nbsp;&nbsp;&nbsp;
                    <a href="###" onclick="javascript:window.open('note.asp?touser=<%=vusername%>','note','width=500,height=250,left=0,top=0')">写短信</a>
                </dd>
                    
                <dd><img src="image/member.gif">&nbsp;&nbsp;&nbsp;&nbsp;
                <a href="###" onclick="javascript:window.open('friend.asp?touser=<%=vusername%>','friend','width=500,height=250,left=0,top=0')">加为好友</a>
                </dd>
                <dd>我的邮件：<a href="mailto:<%=vemail%>"><%=vemail%></a></dd>
                <dd>个人网站：<a href="<%=vurl%>" target="_blank"><%=vurl%></a></dd>
            </dl>

        </div>
    </div>
    
    
    

    
    <div id="content">
        <h1>文章列表:留言板系统</h1>
        <div>
        	<p class="content_post"><a href="post.asp"></a></p>
        	<ul>
            <%
				for i = 1 to rs.pagesize
					if rs.eof then exit for
			%>
            	<li><span>阅读数(<strong><%=rs("G_ReadCount")%></strong>) 评论数(<strong><%=rs("G_CommentCount")%></strong>)</span><img src="kind/icon<%=rs("G_kind")%>.gif" alt="图标" /> <a href="article.asp?ShowId=<%=rs("G_ID")%>"><%=rs("G_Title")%></a></li>
            <%
					rs.movenext
				    next
			%>
            </ul>
         <p class="fenye">
			共 <strong><%=allcount%></strong> 篇文章 | 
			<%=page%>/<%=allpage%>页 | 
			<%if page = 1 then%>
			首页 | 
			上一页 | 
			<%else%>
			<a href="index.asp">首页</a> | 
			<a href="index.asp?page=<%=page-1%>">上一页</a> | 
			<%end if%>
			<%
				'比较的时候，传过来的是字符串，所以，要转换成整形
				if clng(page) = allpage then
			%>
			下一页 | 
			尾页
			<%else%>
			<a href="index.asp?page=<%=page+1%>">下一页</a> | 
			<a href="index.asp?page=<%=allpage%>">尾页</a>
			<%end if%>
		</p>
        <form method="get" action="index.asp" class="fanye">
			<select name="page">
				<%for i = 1 to allpage%>
				<option value="<%=i%>"><p>第<%=i%>页</p></option>
				<%next%>
			</select>
			<input type="submit" value="GO" />
		</form>
        </div>
    </div>
    
    
<!--#include file="images.asp"-->


<div id="sideimg">
	<h1>最近图片</h1>	
	<div style="text-align:center;padding-top:20px;">
		<img src="image/05.jpg" alt="<%=picname%>" style="width:248px;height:240px;box-shadow:0px 0px 10px #000;border-radius: 20px;" />		
	</div>
</div>    
    
    
    
<!--#include file="footer.asp"-->

</body>

</html>
<%
	call close_rs
	call close_conn
%>
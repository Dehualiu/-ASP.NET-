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
	'可以通过登录的cookies判断数据库里的谁登录的
	dim rs,sql,username,sex,face,url,qq,email,showid,level
	showid = request.querystring("ShowId")
	
	'非法操作
	if showid = "" or not isnumeric(showid) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_User where G_ID="&showid
	rs.open sql,conn,1,1
	
	if not rs.eof then
		'如果判断有数据，那么再判断是不是别的管理员
		level = rs("G_Level")
		username = rs("G_UserName")
		
		'下面这句判断的意思是别的管理员
		if level = 1 and username <> request.cookies("guest")("username") then
			call close_rs
			call close_conn
			response.write "<script>alert('您不可以修改别的管理员');history.back();</script>"
			response.end
		end if
		
		
		sex = rs("G_Sex")
		face = rs("G_Face")
		url = rs("G_Url")
		qq = rs("G_QQ")
		email = rs("G_Email")
		underwrite = rs("G_UnderWrite")
	else
		call close_rs
		call close_conn
		'没有数据的话，做特殊处理
		response.write "<script>alert('非法操作!');history.back();</script>"
		response.end
	end if
	
	
	call close_rs
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
<script type="text/javascript" src="js/member.js"></script>
</head>
<body>
<!--#include file="header.asp"-->
<div id="sidebarmember">
	<h1>会员管理</h1>	
<!--#include file="admin_sidebar.asp"-->
</div>

<div id="contentmember">
	<h1>会员个人中心</h1>	
	<div>
		<form method="post" name="reg" action="admin_vip_mof_do.asp">
		<input type="hidden" name="username" value="<%=username%>" />
		<dl>
			<dd>用 户 名：<%=username%></dd>
			<dd>密　　码：<input type="password" class="text" name="password" />(*留空则不修改)</dd>
			<dd>性　　别：<input type="radio" name="sex" value="男" <%if sex = "男" then response.write "checked='checked'"%> /> 男 <input type="radio" name="sex" <%if sex = "女" then response.write "checked='checked'"%> value="女" /> 女</dd>
			<dd>头　　像：<input onclick="javascript:window.open('face.asp','face','width=400,height=400,scrollbars=1')" type="text" name="face" readonly="readonly" value="<%=face%>" class="text" /><img src="face/m01.gif" id="faceimg" alt="头像" /></dd>
			<dd>　Q　　Q：<input type="text" name="qq" value="<%=qq%>" class="text" /></dd>
			<dd>　E-Mail：<input type="text" name="email" value="<%=email%>" class="text" /></dd>
			<dd>个人网站：<input type="text" name="url" value="<%=url%>" class="text" /></dd>
			<dd style="height:auto;padding:5px 0;">个人签名：
				<textarea style="width:300px;height:120px;" name="underwrite"><%=underwrite%></textarea>	
			</dd>
			<dd><input type="submit" value="修改资料" onclick="return check();" name="send" class="submit" /></dd>
		</dl>
		</form>
	</div>
</div>

<!--#include file="footer.asp"-->	
</body>
</html>
<%
	call close_conn
%>
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
	'如果点击了修改命令，那么执行修改，必须是获取数据之前修改
	dim rs,sql,webname,article,blog,photo,webstatic,skin,webclose,errorstring,subject,resubject,yzm,user
	
	if request.form("send")="修改参数" then
		'接收逐个数据
		webname = request.form("webname")
		article = request.form("article")
		blog = request.form("blog")
		photo = request.form("photo")
		webstatic = request.form("webstatic")
		skin = request.form("skin")
		webclose = request.form("webclose")
		errorstring = request.form("errorstring")
		subject = request.form("subject")
		resubject = request.form("resubject")
		yzm = request.form("yzm")
		user = request.form("user")
		
		' 然后对数据进行必要的判断。
		if webname = "" then
			response.write "<script>alert('网站的名称不能为空!');window.close();</script>"
			response.end
		end if
		
		if len(webclose)>100 then
			response.write "<script>alert('网站关闭的原因不得大于100!');window.close();</script>"
			response.end
		end if
		
		'修改系统参数
		sql = "update G_Web set G_WebName='"&webname&"',G_Article="&article&",G_Blog="&blog&",G_Photo="&photo&",G_Webstatic="&webstatic&",G_Skin="&skin&",G_Webclose='"&webclose&"',G_Errorstring='"&errorstring&"',G_Subject="&subject&",G_ReSubject="&resubject&",G_Yzm="&yzm&",G_User="&user&""
		conn.execute(sql)
		response.write "<script>alert('系统参数修改完成');location.href='admin_set.asp'</script>"

	end if



	'获取系统设置的初始化信息
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Web"
	rs.open sql,conn,1,1
	
	if not rs.eof then
		'如果有数据
		webname = rs("G_WebName")
		article = rs("G_Article")
		blog = rs("G_Blog")
		photo = rs("G_Photo")
		skin = rs("G_Skin")
		webstatic = rs("G_WebStatic")
		webclose = rs("G_WebClose")
		errorstring = rs("G_ErrorString")
		subject = rs("G_Subject")
		resubject = rs("G_ReSubject")
		yzm = rs("G_Yzm")
		user = rs("G_User")
	else
		'没有数据
		response.write "<script>alert('Error!系统表尚未初始化!');window.close();</script>"
		response.end
	end if
	
	call close_rs
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
	<h1>后台首页 -- 系统设置</h1>	
	<div>
	<form method="post" action="admin_set.asp">
	<dl>
		<dd>网站的名称：<input type="text" value="<%=webname%>" class="text" name="webname" /></dd>
		<dd>文章每页条数：
			<select name="article">
				<option value="10" <%if article = 10 then response.write "selected='selcted'"%>>每页10条</opction>	
				<option value="15" <%if article = 15 then response.write "selected='selcted'"%>>每页15条</opction>	
			</select>
		</dd>
		<dd>博客每页人数：
			<select name="blog">
				<option value="10" <%if blog = 10 then response.write "selected='selcted'"%>>每页10人</opction>	
				<option value="15" <%if blog = 15 then response.write "selected='selcted'"%>>每页15人</opction>	
			</select>
		</dd>
		<dd>相册每页张数：
			<select name="photo">
				<option value="10" <%if photo = 10 then response.write "selected='selcted'"%>>每页10张</opction>	
				<option value="15" <%if photo = 15 then response.write "selected='selcted'"%>>每页15张</opction>	
			</select>
		</dd>
		<dd>网站 的 皮肤：
			<select name="skin">
				<option value="1" <%if skin = 1 then response.write "selected='selcted'"%>>灰色黯淡</opction>	
				<option value="2" <%if skin = 2 then response.write "selected='selcted'"%>>粉色佳人</opction>	
				<option value="3" <%if skin = 3 then response.write "selected='selcted'"%>>墨色典雅</opction>	
			</select>
		</dd>
		<dd>网 站 状 态：
        <input type="radio" name="webstatic" value="0" <%if webstatic = 0 then response.write "checked='checked'"%> /> 
        关闭
        <input type="radio" name="webstatic" <%if webstatic = 1 then response.write "checked='checked'"%> value="1" /> 开启
        </dd>
		<dd>网站关闭原因：
        <input type="text" class="text" maxlength="100"  value="<%=webclose%>" name="webclose" /> 
        (*如果开启，无需填写)
        </dd>
		<dd>非法字符过滤：
        <input type="text" class="text"  value="<%=errorstring%>" name="errorstring" /> 
        (*请用|线隔开))
        </dd>
		<dd>发表主题限制：
        <input type="radio" name="subject" <%if subject = 30 then response.write "checked='checked'"%> value="30" /> 
        30秒 
        <input type="radio" name="subject" <%if subject = 60 then response.write "checked='checked'"%> value="60" /> 
        1分钟 
        <input type="radio" <%if subject = 180 then response.write "checked='checked'"%> name="subject" value="180" /> 
        3分钟
        </dd>
            <dd>回复主题限制：
            <input type="radio" name="resubject" <%if resubject = 15 then response.write "checked='checked'"%> value="15" /> 15秒 
            <input type="radio" name="resubject" <%if resubject = 30 then response.write "checked='checked'"%> value="30" /> 30秒 
            <input type="radio" name="resubject" <%if resubject = 50 then response.write "checked='checked'"%> value="50" /> 50秒
            </dd>
            <dd>是否启用验证：
            <input type="radio" name="yzm" <%if yzm = 0 then response.write "checked='checked'"%> value="0" /> 
            关闭  
            <input type="radio" name="yzm" <%if yzm = 1 then response.write "checked='checked'"%> value="1" /> 
            开启   (*发帖回帖验证)
            <dd>
            是否开放注册：
            <input type="radio" name="user" <%if user = 0 then response.write "checked='checked'"%> value="0" /> 
            关闭  
            <input type="radio" name="user" <%if user = 1 then response.write "checked='checked'"%> value="1" /> 
            开启
            <dd>
            <input type="submit" name="send" value="修改参数" class="submit" />
            </dd>
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
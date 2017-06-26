<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	
	'必须是按钮发送的
	if request.form("send") <> "发表文章"	then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	'会员才能进入
	if request.cookies("guest")("username") = ""	then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	
%>
<!--#include file="conn.asp"-->
<%	
	if isDate(request.cookies("time")) then
	'判断两次发帖的时间差
		if DateDiff("s",Cdate(request.cookies("time")),now())<web_subject then
			response.write "<script>alert('你发帖过于繁忙，请等会再发帖');history.back();</script>"
		response.end
		end if
	end if
	
	 
	'接收留言的标题和内容
	dim title,content,kind,username,brow,yzm
	brow = request.form("brow")
	username = request.cookies("guest")("username")
	kind = request.form("kind")
	title = filtrate(trim(request.form("title")))
	content = filtrate(trim(request.form("content")))
	yzm = request.form("yzm")
	
	
	'判断是否是禁言的用户，如果是，返回
	dim speakrs,speaksql
	set speakrs = server.createobject("adodb.recordset")
	speaksql = "select * from G_User where G_UserName='"&username&"'"
	speakrs.open speaksql,conn,1,1	
	if not speakrs.eof then
		'有此人，拿出禁言的标号,如果=1，说明此人被禁言了。
		if speakrs("G_Speak")  = 1 then
			speakrs.close
			set speakrs = nothing
			call close_conn
			response.write "<script>alert('你被禁言了，请发短信让管理员开通');history.back();</script>"
			response.end
		end if
		
	else
		response.write "<script>alert('发生错误');history.back();</script>"
		response.end
	end if
	
	speakrs.close
	set speakrs = nothing
	
	
	'除了javascript的验证，还要VBscript的验证
	if len(title) < 4 then
		response.write "<script>alert('标题不得少于4位');history.back();</script>"
		response.end
	end if
	
	if len(title) > 100 then
		response.write "<script>alert('标题不得大于100位');history.back();</script>"
		response.end
	end if
	
	if len(content) <10 then
		response.write "<script>alert('内容不得少于10位');history.back();</script>"
		response.end
	end if


	if web_yzm = 1 then
		'验证码验证
		if yzm="" or not isnumeric(yzm) then
			response.write"<script>alert('验证码错误!');history.back();</script>"
			response.end
		end if	
		if yzm <> Session("cnbruce.com_ValidateCode") then
			response.write"<script>alert('验证码错误!');history.back();</script>"
			response.end
		end if	
	end if

	'新增一条留言内容
	'  第一种新增并且，跳转到那个新增的文章页面上
	dim sql,rs
	sql = "insert into G_Article (G_Title,G_UserName,G_Kind,G_Brow,G_Content,G_Date) values ('"&title&"','"&username&"','"&kind&"','"&brow&"','"&content&"',now())"
	conn.execute(sql)	
	
	
	'文章发帖成功后，加3分
	application.lock
		sql="update G_User set G_Account=G_Account+3 where G_UserName='"&username&"'"
		conn.execute(sql)
	application.unlock
	
	
	

	'新增了一条，他的时间是最晚的时间+他的用户名（唯一的
	'就可以筛选到这个新增的文章的ID
	'此方法为用户并发状况不强
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Article where G_UserName='"&username&"' order by G_Date desc"
	rs.open sql,conn,1,1
	if not rs.eof then
		showid = rs("G_ID")
	else
		call close_rs
		call close_conn
		response.write "<script>alert('发生错误');history.back();</script>"
		response.end
	end if
	
	call close_rs
	call close_conn
	'创建一个发帖时间点
	response.cookies("time")=now()
	response.write "<script>alert('文章发表成功');location.href='Article.asp?ShowId="&showid&"	';</script>"
%>


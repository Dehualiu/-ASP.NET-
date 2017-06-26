<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%	

	if isDate(request.cookies("retime")) then
	'判断两次发帖的时间差
		if DateDiff("s",Cdate(request.cookies("retime")),now())<15 then
			response.write "<script>alert('你回帖过于繁忙，请等会再回帖');history.back();</script>"
		response.end
		end if
	end if
	
	
	'必须是按钮点进的
	if request.form("send") <> "回复主题"	then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	'会员才能进入
	if request.cookies("guest")("username") = ""	then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	dim yzm
	yzm = request.form("yzm")
	
	
%>
<!--#include file="conn.asp"-->
<%
	if isDate(request.cookies("retime")) then
	'判断两次发帖的时间差
		if DateDiff("s",Cdate(request.cookies("retime")),now())<web_resubject then
			response.write "<script>alert('你回帖过于繁忙，请等会再回帖');history.back();</script>"
		response.end
		end if
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
	


	dim title,brow,content,username,sid
	sid = request.form("sid")
	title = filtrate(trim(request.form("title")))
	brow = request.form("brow")
	content = filtrate(trim(request.form("content")))
	username = request.cookies("guest")("username")



	
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




	'将回帖写到数据库里去
	sql = "insert into G_Article (G_Title,G_UserName,G_Brow,G_Content,G_Date,G_SID) values ('"&title&"','"&username&"','"&brow&"','"&content&"',now(),'"&sid&"')"
	conn.execute(sql)
	
	'新增回帖成功后，累计评论数
	application.lock
		sql="update G_Article set G_CommentCount=G_CommentCount+1 where G_ID="&sid
		conn.execute(sql)
		
		
		'回帖成功后，加1分
		sql="update G_User set G_Account=G_Account+1 where G_UserName='"&username&"'"
		conn.execute(sql)

	application.unlock
	
	call close_conn
	
	'创建一个回帖时间点
	response.cookies("retime")=now()
	
	'回帖成功，返回刚才的页面
	response.write "<script>alert('回帖成功！');location.href='article.asp?ShowId="&sid&"'</script>"
%>












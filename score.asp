<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<!--#include file="conn.asp"-->
<%
	dim showid,sql,score,scoret,username
	username = request.querystring("username")
	'接收本页提交的信息
	if request.form("send") = "确定" then
		score = request.form("score")
		scoret = request.form("scoret")
		showid = request.form("ShowId")
		username = request.form("username")
		'没有ShowId
		if showid = "" or not isnumeric(showid) then
			response.write "<script>alert('非法操作');history.back();</script>"
			response.end
		end if
		if len(scoret) > 100 then
			response.write "<script>alert('评分理由不得大于100个字');history.back();</script>"
			response.end
		end if 
		
		'对文章进行加分减分的操作
		sql = "update G_Article set G_ScoreName='"&session("Admin")&"',G_Score="&score&",G_ScoreT='"&scoret&"' where G_ID="&showid
		conn.execute(sql)
		
		'对发表文章或回帖的人进行分数加减
		sql = "update G_User set G_Account=G_Account+"&score&" where G_UserName='"&username&"'"
		conn.execute(sql)
		
		response.write "<script>alert('评分成功');window.close();</script>"
		
	end if
	
	
	

	showid = request.querystring("ShowId")
	'没有ShowId
	if showid = "" or not isnumeric(showid) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	if session("Admin") = "" then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
</head>
<body style="width:auto;">
	
	<div id="face">
		<h1>评分操作</h1>
		<form method="post" action="score.asp" style="padding-left:20px;">
			<input type="hidden" value="<%=showid%>" name="ShowId" />
			<input type="hidden" value="<%=username%>" name="username" />
			选择分数：
			<input type="radio" name="score" value="-30" /> -30分
			<input type="radio" name="score" value="-15" /> -15分
			<input type="radio" name="score" value="-5" /> -5分
			<input type="radio" name="score" value="5" checked="checked" /> 5分
			<input type="radio" name="score" value="15" /> 15分
			<input type="radio" name="score" value="30" /> 30分<br />
			输入评分理由：<br />
			<textarea name="scoret" cols="40" rows="8"></textarea>
			<br /><input type="submit" value="确定" name="send" />
		</form>
	</div>
	
</body>
</html>
<%
	call close_conn
%>
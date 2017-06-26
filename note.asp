<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<!--#include file="conn.asp"-->
<%
	dim touser,message,sql
	touser=request.QueryString("touser")
	'判断是否是会员写短信
	if request.Cookies("guest")("username")="" then
		response.write "<script>alert('你还没登录，请登录后再写短信');window.close();</script>"
		response.end
	end if
	'判断是不是自己给自己写短信
	if request.Cookies("guest")("username")=touser then
		response.write "<script>alert('你不能给自己写短信');window.close();</script>"
		response.end
	end if
	if request.form("send")="发短信" then
		touser=request.form("touser")
		message=request.form("message")
		if touser="" then
			response.write "<script>alert('非法操作');history.back();</script>"
			response.end
		end if
		if message="" or len(message)<5 or len(message)>200 then
			response.write "<script>alert('短信不得为空，或者不得少于5个字符，大于200个字符');history.back();</script>"
			response.end
		end if
	'把数据写入到数据库去
		sql="insert into G_Note (G_FromUser,G_ToUser,G_Message,G_Date) values ('"&request.Cookies("guest")("username")&"','"&touser&"','"&message&"',now())"
		conn.execute(sql)
		call close_conn
	'提示发送成功后，关闭
		response.write "<script>alert('短信发表成功');window.close();</script>"
		response.end
	end if

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
<script type="text/javascript" src="js/note.js"></script>
</head>

<body style="width:auto;">
<div id="note">
	<h1>发短信</h1>
    <div>
        <form method="post" name="note" action="note.asp">
            <dl>
                <dd>用户名：<input type="text" name="touser" readonly="readonly" class="text" value="<%=touser%>"/></dd>
                <dd><textarea name="message"></textarea></dd>
                <dd><input type="submit" name="send" onclick="return check();" value="发短信" /></dd>
            </dl>
        </form>
    </div>
</div>

</body>
</html>
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.cookies("guest")("username")<>"" then
		response.write"<script>alert('你已处在登录状态,请退出再登录');history.back();</script>"
		response.end
		end if
%>
<!--#include file="conn.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
<script type="text/javascript" src="js/login.js"></script>
</head>

<body>
<!--#include file="header.asp"-->

    <div id="login">
        <h1>会 员 登 录</h1>
        <div>
        	<form name="login" method="post" action="login_do.asp">
            	<dl>
                	<dd><span>&nbsp;&nbsp;用 户 名：&nbsp;&nbsp;</span>
                    <input type="text" name="username" class="text"/></dd>
                    <dd><span>&nbsp;&nbsp;密&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码：&nbsp;&nbsp;</span>
                    <input type="password" name="password" class="text"/></dd>
                   <dd><span>&nbsp;&nbsp;验 证 码：&nbsp;&nbsp;</span>
                   <input type="text" maxlength="4" name="yzm" class="text yzm "/>
                   <img class="reg_yzm" src="validatecode.asp" ondblclick="javascript:this.src='validatecode.asp?tm='+Math.random()" 
                    alt="验证码"/></dd>
                   <dd><span>&nbsp;&nbsp;保留登录：&nbsp;&nbsp;</span>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                   <input type="radio" value="1" name="login" checked="checked" /><span>&nbsp;&nbsp;不保留&nbsp;&nbsp; </span>
                   &nbsp;&nbsp;
                   <input type="radio" value="2" name="login" /><span>&nbsp;&nbsp;一天&nbsp;&nbsp;</span> 
                   &nbsp;&nbsp;
                   <input type="radio" value="3" name="login" /><span>&nbsp;&nbsp;一月&nbsp;&nbsp;</span> 
                   &nbsp;&nbsp;
                   <input type="radio" value="4" name="login" /><span>&nbsp;&nbsp;一年&nbsp;&nbsp;</span></dd> 
                    <dd>
                    	<input class="submit" type="submit" value="登录" class="submit" name="send" onclick="return check();" />
                    	<input class="button" type="button" class="submit" value="忘密" onclick="javascript:location.href='find1.asp'" />
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
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.cookies("guest")("username")<>"" then
		response.write"<script>alert('你处在登录状态,请退出再注册');history.back();</script>"
		response.end
		end if
%>
<!--#include file="conn.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
<script type="text/javascript" src="js/reg.js"></script>
</head>

<body>
<!--#include file="header.asp"-->

    <div id="reg">
        <h1>会 员 注 册</h1>
        <form name="reg" method="post" action="reg_do.asp">
            <div>
            	<%if web_user = 1 then%>
                    <dl>
                        <dt></dt>
                        <dd><span>&nbsp;&nbsp;用	 &nbsp;户&nbsp;名：&nbsp;&nbsp;</span>
                        <input type="text" name="username" class="text"/></dd>
                        <dd><span>&nbsp;&nbsp;密&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码：&nbsp;&nbsp;</span>   
                        <input type="password" name="password" class="text" /></dd>
                        <dd><span>&nbsp;&nbsp;密码确认：&nbsp;&nbsp;</span>
                        <input type="password" name="notpassword" class="text" /></dd>
                        <dd><span>&nbsp;&nbsp;密码提示：&nbsp;&nbsp;</span>
                        <input type="text" name="passt" class="text"/></dd>
                        <dd><span>&nbsp;&nbsp;密码回答：&nbsp;&nbsp;</span>
					    <input type="text" name="passd" class="text"/></dd>
                        <dd><span>&nbsp;&nbsp;性&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别：&nbsp;&nbsp;</span>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="radio" name="sex" value="男" checked="checked" /><span>男</span>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="radio" name="sex" value="女" /><span>女</span></dd>
                        <dd><span>&nbsp;&nbsp;头&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;像：&nbsp;&nbsp;</span>
                        <input type="hidden" name="face" value="face/face01.jpg" />
                        <a href="###" onclick="javascript:window.open('face.asp','face','width=400,height=400,scrollbars=1')">
                        <img class="reg_face" src="face/face01.jpg" alt="头像" id="faceimg" class="face"/></a></dd>
                        <dd><span>&nbsp;&nbsp;电子邮件：&nbsp;&nbsp;</span>
                        <input type="text" name="email" class="text"/></dd>
                        <dd><span>&nbsp;&nbsp;个人网站：&nbsp;&nbsp;</span>
                        <input type="text" name="url" value="http://" class="text"/></dd>
                        <dd><span>&nbsp;&nbsp;Q&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Q：&nbsp;&nbsp;</span>
                        <input type="text" name="qq" class="text"/></dd>
                        <dd><span>&nbsp;&nbsp;验 &nbsp;证&nbsp;码：&nbsp;&nbsp;</span>
                        <input type="text" maxlength="4" name="yzm" class="text yzm "/>
                        <img class="reg_yzm" src="validatecode.asp" ondblclick="javascript:this.src='validatecode.asp?tm='+Math.random()" 
                         alt="验证码"/></dd>
                        <dd><input type="submit" value="zhuce" onclick="return check();" name="send" class="submit"/></dd>
                    </dl>
              <%elseif web_user = 0 then%>
			  <p style="text-align:center;color:#f00;font-weight:bold;height:50px;line-height:50px;">本系统暂时不接受任何注册!</p>
			  <%end if%>
            </div>
        </form>
    </div>
<!--#include file="footer.asp"-->

</body>

</html>
<%
	call close_conn
%>
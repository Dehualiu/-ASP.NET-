<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.Cookies("guest")("username")="" then
		response.write "<script>alert('非法操作！');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
<%
	dim rs,sql,username,sex,face,url,qq,email,underwrite
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from G_User where G_UserName='"&request.Cookies("guest")("username")&"'"
	rs.open sql,conn,1,1
	
	if not rs.eof then
		username=rs("G_UserName")
		sex=rs("G_Sex")
		face=rs("G_Face")
		url=rs("G_Url")
		qq=rs("G_QQ")
		email=rs("G_Email")
		underwrite=rs("G_UnderWrite")
	else
		response.write"<script>alert('非法操作！');history.back();</script>"
		response.end
	end if
	
	call close_rs
	call close_conn

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
        <h1>会 员 管 理</h1>
<!--#include file="member_sidebar.asp"-->
    </div>
    <div id="contentmember">
        <h1>会 员 个 人 中 心</h1>
        <div class="member_xiugai">
            <form method="post" name="reg" action="member_info_do.asp">
			<dl>
            	<dd>用 户 名：<%=username%></dd>
                <dd>密 &nbsp;&nbsp; 码：<input type="password" class="text" name="password"  />
                &nbsp;&nbsp;&nbsp;&nbsp;(*留空则不修改)</dd>
                <dd>性 &nbsp;&nbsp; 别：
                <input type="radio" name="sex" value="男" <%if sex="男" then response.write "checked='checked'"%>
				 />男
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="radio" name="sex" value="女" <%if sex="女" then response.write "checked='checked'"%>
				 />女</dd>
                <dd>头 &nbsp;&nbsp; 像：<input  type="text" readonly="readonly" name="face" value="<%=face%>" class="text"
                onclick="javascript:window.open('face.asp','face','width=400,height=400,scrollbars=1')" />
                <img src="face/face01.jpg" alt="头像" id="faceimg"/></dd>
                <dd> &nbsp;Q &nbsp;&nbsp; Q：<input type="text" name="qq" value="<%=qq%>" class="text"/></dd>
                <dd>&nbsp;E-Mail：<input type="text" name="email" value="<%=email%>" class="text"/></dd>
                <dd>个人网站：<input type="text" name="url" value="<%=url%>" class="text"/></dd>
                <dd style="height:auto;padding:5px 0;">个人签名：
                	<textarea class="member_xiu_area" name="underwrite"><%=underwrite%></textarea>       
                </dd>
                <dd><input type="submit" name="send" onclick="return check();" value="修改资料" class="submit"/></dd>
            </dl>
            </form>
        </div>
    </div>
<!--#include file="footer.asp"-->

</body>

</html>
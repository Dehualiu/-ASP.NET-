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
	<h1>后台首页 -- 服务器信息</h1>	
	<div>
        <dl>
            <dt style="font-size:16px;font-weight:bold;">..服务器配置..</dt>
            <dd>·相对路径信息：<%=Request.ServerVariables("PATH_INFO")%></dd>
            <dd>·服务器IP地址：<%=Request.ServerVariables("LOCAL_ADDR")%></dd>
            <dd>·显示执行SCRIPT的虚拟路径：<%=Request.ServerVariables("SCRIPT_NAME")%></dd>
            <dd>·返回服务器的主机名，DNS别名，或IP地址：<%=Request.ServerVariables("SERVER_NAME")%></dd>
            <dd>·返回服务器处理请求的端口：<%=Request.ServerVariables("SERVER_PORT")%></dd>
            <dd>·协议的名称和版本：<%=Request.ServerVariables("SERVER_PROTOCOL")%></dd>
            <dd>·服务器的名称和版本：<%=Request.ServerVariables("SERVER_SOFTWARE")%></dd>
            <dd>·脚本超时时间：<%=Server.ScriptTimeout%> 秒</dd>
            <dd>·服务器解译引擎：<%=ScriptEngine & "/"& ScriptEngineMajorVersion &"."&ScriptEngineMinorVersion&"."& ScriptEngineBuildVersion %></dd>
        </dl>
	</div>
</div>

<!--#include file="footer.asp"-->	
</body>
</html>
<%
	call close_conn
%>
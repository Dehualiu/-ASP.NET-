<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.form("send")="" then
	response.write"<script>alert('非法操作!');history.back();</script>"
	response.end
	end if
%>
<!--#include file="md5.asp"--> 
<%
'这张页面是处理表单提交的数据
    dim quot,t,fso,ts,rs,sql,yzm,username,password,notpassword,passt,passd,qq,email,url,sex,face
	yzm = trim(request.form("yzm"))
	password = trim(request.form("password"))
	username = trim(request.form("username"))
	notpassword = trim(request.form("notpassword"))
	passt = trim(request.form("passt"))
	passd = trim(request.form("passd"))
	qq = trim(request.form("qq"))
	email = trim(request.form("email"))
	url = trim(request.form("url"))
	sex = trim(request.form("sex"))
	face = trim(request.form("face"))
'用户名验证
	if username="" or len(username)<2 then
		response.write"<script>alert('用户名不得为空且至少为两位!');history.back();</script>"
		response.end
	end if
'密码验证
	if password="" or len(password)<6 then
		response.write"<script>alert('密码不得为空且至少为六位!');history.back();</script>"
		response.end
	end if
'密码和密码确认	
	if password <> notpassword then
		response.write"<script>alert('两次输入的密码不一致!');history.back();</script>"
		response.end
	end if
'密码提示
	if passt="" or len(passt)<3 then
		response.write"<script>alert('密码提示不得少于三位数!');history.back();</script>"
		response.end
	end if
'密码回答
	if passd="" or len(passd)<3 then
		response.write"<script>alert('密码回答不得少于三位数!');history.back();</script>"
		response.end
	end if
'密码提示和密码回答不得一致
	if passt=passd then
		response.write"<script>alert('密码提示和密码回答不得一致!');history.back();</script>"
		response.end
	end if
'电子邮件验证
'获取@位置
	epos = instr(email,"@")
'获取.的位置
	dpos = instr(epos,email,".")
'获取总长度
	emailLen = len(email)
	nns = emailLen - dpos
	if email="" then
		response.write"<script>alert('电子邮件不得为空!');history.back();</script>"
		response.end
	elseif epos<1 then 'epos小于1表示没有符号@
		response.write"<script>alert('电子邮件格式中缺少@符号!');history.back();</script>"
		response.end
	elseif dpos<1 then  '.符号必须在@符号之后搜索才能表明是域名的.
		response.write"<script>alert('电子邮件格式中缺少.符号!');history.back();</script>"
		response.end
	elseif epos<4 then 'epos小于1表示没有符号@
		response.write"<script>alert('电子邮件名不得小于3位!');history.back();</script>"
		response.end
	elseif nns<2 then 
		response.write"<script>alert('域名后缀必须大于或等于两位!');history.back();</script>"
		response.end
	end if

'个人网站验证
	if url="" or url="http://" then
		url="该用户还没有个人网站"
	end if
'qq验证
	if qq="" or len(qq)<5 or len(qq)>12 then
		response.write"<script>alert('QQ必须是5-12位之间!');history.back();</script>"
		response.end
	elseif not isnumeric(qq) then
		response.write"<script>alert('QQ必须是数字!');history.back();</script>"
		response.end
	end if
'验证码验证
	if yzm <> Session("cnbruce.com_ValidateCode") then
		response.write"<script>alert('验证码错误!');history.back();</script>"
		response.end
	end if	
%>
<!--#include file="conn.asp" -->
<%

	'如果系统参数不允许注册，下面一大段，也隐藏起来	
	if web_user = 1 then





'在写入数据之前，判断一下是否有重复的数据
	set rs=server.CreateObject("adodb.recordset")
	sql="select * from G_user where G_UserName='"&username&"'"
	rs.open sql,conn,1,1
'首先判断是否存在此数据
	if not rs.eof then     '说明有数据
'如果有重复，提前关掉表和数据库
		call close_rs
		call close_conn
		response.write"<script>alert('此用户名已经存在!');history.back();</script>"
		response.end
	end if
	
	call close_rs   '关闭和销毁表
'将密码和密码回答进行加密
	password = md5(password)
	passd = md5(passd)
	
'全部验证完毕后，写入数据库
	sql="insert into G_User(G_UserName,G_PassWord,G_PassT,G_PassD,G_Email,G_QQ,G_Url,G_Sex,G_Face,G_Date) values ('"&username&"','"&password&"','"&passt&"','"&passd&"','"&email&"','"&qq&"','"&url&"','"&sex&"','"&face&"',now())"
	conn.execute(sql) '执行SQL新增
	call close_conn '关闭和销毁数据库
'会员注册成功后，实现自动登陆
'登录的方式采用cookies来设计
	response.cookies("guest")("username")=username
'注册会员后，这个会员就是最新的会员
'将他的信息写入XML数据里去，然后首页调用这个XML，显示新进会员
'使用server对象的组建创建文本，创建一个XML文本，写入信息
	set fso=server.CreateObject("scripting.filesystemobject")
	set ts=fso.opentextfile(server.mappath("vip.xml"),2,true)
	
	quot = chr(34)   '表示文本里面的双引号
	t = chr(9)        '表示文本里面的TAB键盘
	
	ts.writeline("<?xml version="&quot&"1.0"&quot&" encoding="&quot&"gb2312"&quot&"?>")
	ts.writeline("<vip>")
	ts.writeline(t&"<username>" &username& "</username>")
	ts.writeline(t&"<face>" &face& "</face>")
	ts.writeline(t&"<email>" &email& "</email>")
	ts.writeline(t&"<url>" &url& "</url>")
	ts.writeline("</vip>")
	
	ts.close
	set ts = nothing
	set fso = nothing
	'新增成功后，执行跳转
	response.write"<script>alert('恭喜你，注册成功!');location.href='index.asp'</script>"
	
	
	else
	'不可以注册
	response.write "<script>alert('非法注册，不能成功！');window.close();'</script>"
end if
%>
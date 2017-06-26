<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	if request.form("send")="" then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	dim password,sex,face,qq,url,email,sql,underwrite
	password=request.form("password")
	sex=request.form("sex")
	face=request.form("face")
	qq=request.form("qq")
	url=request.form("url")
	email=request.form("email")
	underwrite=request.form("underwrite")
	
	'密码验证
	if password<>"" then
		if len(password)<6 then
			response.write"<script>alert('密码不得少于六位!');history.back();</script>"
			response.end
		end if
	end if
	dim epos,dpos,emailLen,nns
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
	
%>
<!--#include file="conn.asp"-->
<!--#include file="md5.asp"-->
<%
	
'修改数据
	if password="" then
		sql="update G_User set G_UnderWrite='"&underwrite&"',G_Sex='"&sex&"',G_QQ='"&qq&"',G_Email='"&email&"',G_Url='"&url&"',G_Face='"&face&"' where G_UserName='"&request.cookies("guest")("username")&"'"
	else
		sql="update G_User set G_UnderWrite='"&underwrite&"',G_Password='"&md5(password)&"',G_Sex='"&sex&"',G_QQ='"&qq&"',G_Email='"&email&"',G_Url='"&url&"',G_Face='"&face&"' where G_UserName='"&request.cookies("guest")("username")&"'"
	end if
	conn.execute(sql)
	
	call close_conn
	response.write "<script>alert('修改成功');location.href='member.asp';</script>>"
	
	

%>
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	'看看是否是点击了修改过来的
	if request.form("send") = "" then
		response.write "<script>alert('非法操作!');history.back();</script>"
		response.end
	end if
	
	'而且还是管理员
	if session("Admin") = "" then
		response.write "<script>alert('不是管理员不能进!');history.back();</script>"
		response.end
	end if
	
	dim password,sex,face,url,qq,email,sql,underwrite,username
	username = request.form("username")
	password = request.form("password")
	sex = request.form("sex")
	face = request.form("face")
	url = request.form("url")
	qq = request.form("qq")
	email = request.form("email")
	underwrite = request.form("underwrite")
	
	'对每一个字段进行VBSCRIPT判断，防止黑客禁用JS
	
	'当密码为空，是可以的，但是，如果填写了，就必须不能少于6位
	if password <> "" then
		if len(password) < 6 then
			response.write "<script>alert('密码不得少于6位');history.back();</script>"
			response.end
		end if
	end if
	
	
	dim epos,dpos,emailLen,nns
	'电子邮件
	'获取@的位置
	epos = instr(email,"@")
	'获取.符号的位置
	dpos = instr(epos,email,".")
	'先获取总长度
	emailLen = len(email)
	nns = emailLen - dpos
	if email = "" then
		response.write "<script>alert('电子邮件不得为空');history.back();</script>"
		response.end
	elseif epos<1 then   'epos小于1表示没有@符号 ,返回0表示没有
		response.write "<script>alert('电子邮件格式中缺少@符号');history.back();</script>"
		response.end
	elseif dpos<1 then   '.符号必须在@符号之后搜索才能标明是域名的.符号
		response.write "<script>alert('电子邮件格式中缺少.符号');history.back();</script>"
		response.end
	elseif epos<4 then
		response.write "<script>alert('电子邮件名必须大于3位');history.back();</script>"
		response.end
	elseif nns < 2 then
		response.write "<script>alert('域名后缀必须大于2位或等于2位');history.back();</script>"
		response.end
	end if	
	
	'个人网站
	if url = "" or url = "http://" then
		url = "该用户还没有个人网站"
	end if
	
	'qq
	if qq = "" or len(qq) < 5 or len(qq) > 10 then
		response.write "<script>alert('QQ必须是5-10位之间');history.back();</script>"
		response.end
	elseif not isnumeric(qq) then
		response.write "<script>alert('QQ必须是数字');history.back();</script>"
		response.end
	end if
	
%>
<!--#include file="conn.asp"-->
<!--#include file="md5.asp"-->
<%
	
	'如果密码没有填写，那么，就不修改密码，
	'如果密码填写了，那么就增加一条修改密码
	
	'执行修改命令,修改哪条记录？？？cookies

	if password = "" then
		sql = "update G_User set G_UnderWrite='"&underwrite&"', G_Sex='"&sex&"',G_QQ='"&qq&"',G_Email='"&email&"',G_Url='"&url&"',G_Face='"&face&"' where G_UserName='"&username&"'"
	else
		sql = "update G_User set G_UnderWrite='"&underwrite&"', G_Password='"&md5(password)&"',G_Sex='"&sex&"',G_QQ='"&qq&"',G_Email='"&email&"',G_Url='"&url&"',G_Face='"&face&"' where G_UserName='"&username&"'"
	end if
	
	conn.execute(sql)
	
	'销毁对象
	call close_conn
	
	'修改成功后，返回个人中心
	response.write "<script>alert('修改成功');location.href='admin_vip.asp';</script>"
%>
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	dim showid,sid
	showid = request.form("ShowId")
	sid = request.form("sid")
	
	'必须是按钮进来的
	if request.form("send") <> "修改文章" then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	'不是会员也不能进
	if request.cookies("guest")("username") = "" then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	'没有ShowId
	if showid = "" or not isnumeric(showid) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
	'没有sid
	if sid = "" or not isnumeric(sid) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
	
%>
<!--#include file="conn.asp"-->
<%
	'验证数据库里是否存在，如果存在就修改，如果不存在，就报错
	'开始筛选数据
	dim rs,sql,title,content,kind,brow
	
	title = filtrate(trim(request.form("title")))
	content = filtrate(trim(request.form("content")))
	kind = request.form("kind")
	brow = request.form("brow")
	
	
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Article where G_ID="&sid
	rs.open sql,conn,1,1
	'不存在此数据，返回
	if rs.eof then
		call close_rs
		call close_conn
		response.write "<script>alert('不存在此主题');history.back();</script>"
		response.end
	end if
	call close_rs
	
		
	
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Article where G_ID="&showid
	rs.open sql,conn,1,1
	
	'不存在此数据，返回
	if rs.eof then
		call close_rs
		call close_conn
		response.write "<script>alert('不存在此数据');history.back();</script>"
		response.end
	else
		'如果存在，执行修改
		sql = "update G_Article set G_Title='"&title&"',G_Content='"&content&"',G_Kind="&kind&",G_Brow='"&brow&"',G_UpdateName='"&request.Cookies("guest")("username")&"',G_UpdateDate=now() where G_ID="&showid
		conn.execute(sql)
		call close_rs
		call close_conn
		
		'修改成功后，跳转到那个指定的页面
		response.write "<script>alert('修改成功!');location.href='article.asp?ShowId="&sid&"'</script>"
	end if
	

%>

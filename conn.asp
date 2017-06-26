<%Response.Charset="utf-8"%>
<%
	dim conn,megrs,megsql,megreadcount,meg,web_webname,web_skin,web_article,web_user,web_yzm,web_subject,web_resubject,web_static,web_close,web_errorstring
	set conn = server.CreateObject("adodb.connection")
	conn.connectionstring = "Provider = Microsoft.Jet.OLEDB.4.0;Data Source = "&server.mapPath("db/guest.mdb")
	conn.open	
	
	sub close_conn
		conn.close
		set conn = nothing
	end sub
	
	sub close_rs
		rs.close
		set rs=nothing
	end sub
	
	if request.cookies("guest")("username")<>"" then
		'制作一个邮件读取器
		set megrs=server.CreateObject("adodb.recordset")
		megsql="select * from G_Note where G_Read=0 and G_ToUser='"&request.Cookies("guest")("username")&"'"
		megrs.open megsql,conn,1,1
		
		if not megrs.eof then
			megreadcount=megrs.recordcount
			meg="<strong onclick=javascript:location.href='member_note.asp' title='你有"&megreadcount&"条短信'>短信</strong>"
		else
			meg="<span onclick=javascript:location.href='member_note.asp' title='你没有新短信' class='noread'>没有短信</span>"
		end if
		
		megrs.close
		set megrs=nothing
	end if
	
	
	'网站参数调用器
	set systemrs = server.createobject("adodb.recordset")
	systemsql = "select * from G_Web"
	systemrs.open systemsql,conn,1,1
	
	if not systemrs.eof then
		'获取数据
		web_webname = systemrs("G_WebName")
		web_skin = systemrs("G_Skin")
		
		if request.cookies("skin") <> "" then
			web_skin = request.cookies("skin")
		end if
		
		web_article = systemrs("G_Article")
		web_blog = systemrs("G_Blog")
		web_user = systemrs("G_User")
		web_yzm = systemrs("G_Yzm")
		web_subject = systemrs("G_Subject")
		web_resubject = systemrs("G_ReSubject")
		web_close = systemrs("G_WebClose")
		web_static = systemrs("G_WebStatic")
		web_errorstring = systemrs("G_ErrorString")
		
		'web_errorstring 是一个字符串，我要将分解成每个词语，然后进行过滤
		'采用split函数将字符串分解
		'es不是普通变量了，已经是一个数组了array
		
		es = split(web_errorstring,"|")
		
	else
		'系统表没有初始化
		response.write "<script>alert('Error!系统表尚未初始化!');window.close();</script>"
		response.end
	end if
	

	systemrs.close
	set systemrs = nothing
	
	
	'语言过滤器,将字符串送进来，过滤一下，然后再送走
	function filtrate(varstr) 
		'将数据库里过滤的词拿出来一一过滤
		for i = lbound(es) to ubound(es)
			varstr = replace(varstr,es(i),"*")
		next
				
		'还有一些要转换的
		dim a,b,c
		a = chr(34)  'ASCII码34,双引号
		b = chr(39)  '单引号
		c = vbcrlf  '换行常量
		
		'varstr = replace(varstr,a,"“")
		'varstr = replace(varstr,b,"‘")
		varstr = replace(varstr,c,"<br />")     '将中文的换行，转换为英文的换行	

		
		filtrate = varstr
	end function 
	
		'判断系统状态
	if web_static = 0 then
		response.write web_close
		call close_conn
		response.end
	end if
	
	'判断用户是否被禁止访问
	dim visrs,vissql
	set visrs = server.createobject("adodb.recordset")
	vissql = "select * from G_User where G_UserName='"&request.cookies("guest")("username")&"'"
	visrs.open vissql,conn,1,1
	
	if not visrs.eof then
		if visrs("G_Visited") = 1 then
			visrs.close
			set visrs = nothing
			'response.write "你已经被禁止访问本站。"
			response.end
		end if
	end if
	
	visrs.close
	set visrs = nothing
	

%>
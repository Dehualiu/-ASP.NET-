<%
	'学习一个环境变量,取得上一页点击过来的网址request.servervariables("http_referer")
	
	dim skin
	skin = request.querystring("skin")
	
	'先判断何不合法
	if skin = "" or not isnumeric(skin) then
		skin = 2
	end if
	
	'判断不能大于3，小于1
	if skin > 3 or skin <1 then
		skin = 2
	end if
	
	'将得到的skin写入cookies,
	'因为客户端是自选的，而自选的又不能影响其他用户，
	'所以，将自选的风格存入客户端，这样，只能影向自己。
	
	'将整型的skin转成字符串写入COOKIES
	response.cookies("skin") = cstr(skin)
	
	'然后即刻返回刚才的网址
	
	if request.servervariables("http_referer")="" then
		response.redirect "index.asp"
	else
		response.redirect request.servervariables("http_referer")
	end if
%>
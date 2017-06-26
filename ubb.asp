<%
	'UBB解析器,将UBB代码解析成HTML代码
	
	function ubb(code) 
		
		dim re
		set re = new RegExp     '创建正则对象
		re.IgnoreCase = true    '不考虑大小写
		re.Global = true        '全部筛选
		
		'换行
		if instr(code,"[br]") > 0 then
			re.pattern = "(\[br\])"
			code = re.replace(code,"<br />")
		end if
		
		'加粗
		if instr(code,"[/b]") > 0 then
			re.pattern = "(\[b\])(.[^\[]*)(\[\/b\])"    '匹配模式
			code = re.replace(code,"<strong>$2</strong>")
		end if
		
		'倾斜
		if instr(code,"[/i]") > 0 then
			re.pattern = "(\[i\])(.[^\[]*)(\[\/i\])"    '匹配模式
			code = re.replace(code,"<em>$2</em>")
		end if
		
		'删除
		if instr(code,"[/s]") > 0 then
			re.pattern = "(\[s\])(.[^\[]*)(\[\/s\])"    '匹配模式
			code = re.replace(code,"<del>$2</del>")
		end if
		
		'下划线
		if instr(code,"[/u]") > 0 then
			re.pattern = "(\[u\])(.[^\[]*)(\[\/u\])"    '匹配模式
			code = re.replace(code,"<u>$2</u>")
		end if
		
		'字体大小
		if instr(code,"[/size]") > 0 then
			re.pattern = "(\[size:(.[^\[]*)\])(.[^\[]*)(\[\/size\])"
			code = re.replace(code,"<span style='font-size:$2px'>$3</span>")
		end if
		
		'颜色
		if instr(code,"[/color]") > 0 then
			re.pattern = "(\[color:(.[^\[]*)\])(.[^\[]*)(\[\/color\])"
			code = re.replace(code,"<span style='color:$2'>$3</span>")
		end if
		
		'图片
		if instr(code,"[img") > 0 then
			re.pattern = "(\[img code=(.[^\[]*)\])"
			code = re.replace(code,"<img src='$2' alt='贴图' />")
		end if
		
		'超链接
		if instr(code,"[/url]") > 0 then
			re.pattern = "(\[url code=(.[^\[]*)\])(.[^\[]*)(\[\/url\])"
			code = re.replace(code,"<a href='$2' target='_blank'>$3</a>")
		end if
		
		
		set re = nothing
		
		ubb = code
	end function
%>
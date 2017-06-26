<!--#include file="conn.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
<style type="text/css">
	dd {
		padding-top:15px;
		padding-right:15px;
		border-bottom:1px dashed #666;
	}
</style>
</head>
<body>
	
<p style="font-size:18px;text-align:center;color:#C33;font-weight:700;">ubb帮助文档</p>
<dl>
	<dd>[b]内容[/b] -- 这个可以使"内容"加粗</dd>
	<dd>[i]内容[/i] -- 这个可以使"内容"倾斜</dd>
	<dd>[u]内容[/u] -- 这个可以使"内容"下划线</dd>
	<dd>[s]内容[/s] -- 这个可以使"内容"删除线</dd>
	<dd>[size=10px]内容[/size] -- 这个可以使"内容"10号字体大小</dd>
	<dd>[img code=url] -- 这个可以插入图片</dd>
	<dd>[color=#f00]红色[/color] --  这个可以使"内容"字体为红颜色</dd>
    <dd>.....</dd>
</dl>

</body>
</html>
<%
	call close_conn
%>

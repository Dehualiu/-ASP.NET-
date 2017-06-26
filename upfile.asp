<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<!--#include file="upfile.inc"-->

<script type="text/javascript">
	function a(url) {
		window.opener.document.form1.picdir.value=url;
	}
</script>
<%
	dim picdir
	picdir = request.querystring("picdir")
	if request.querystring("menu") = "up" then
		
		dim fileup,formpath,file,filename
		
		picdir2 = request.querystring("picdir") 
		
		'当点击了上传之后，执行上传操作
		set fileup=new Upload_file  '实例化一个类 fileup就是一个对象 
		fileup.GetDate(-1)   '
		formpath="upload/" & picdir2 & "/" '上传的路径
		
		set file=fileup.file("file")  '创建一个file对象，通过上面一个对象的file方法传入一个"file"参数
		 '这个方法能够返回你上传文件的后缀
		
		'只允许上传指定的图片文件
		
		if file.fileext <> "jpg" and file.fileext <> "gif" and file.fileext <> "png" then
			response.write "<script>alert('图片类型必须是jpg,gif,png这三种');window.close();</script>"	
			response.end
		end if 
		
		
		'建立一个完整的路径  
		filename = formpath & year(now)&month(now)&day(now)&hour(now)&minute(now)&second(now) & "." & file.fileext 
		file.savetofile server.mappath(filename)

		set file = nothing
		set fileup = nothing
		
		
		response.write "<script>a('"&filename&"');</script>"
		response.write "<script>alert('图片上传成功');window.close();</script>"	
		
	else
%>
<form enctype="multipart/form-data" method="post" action=upfile.asp?menu=up&picdir=<%=picdir%>>
	<input type="file" name="file" size="30"> 
	<input type="submit" value="上 传 " />
</form>
<%
	end if
%>
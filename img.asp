<!--#include file="images.asp"-->
<%
	Dim img   
	set img = new cnGhostImage   
	img.Path = Server.MapPath("1.jpg")   
	response.write "宽度：" & img.W() & " px<br/>"  
	response.write "高度：" & img.H() & " px<br/>"  
	response.write "大小：" & img.S() & " bytes<br/>"  
	response.write "类型：" & img.T()   

%>

<img src="1.jpg" style="width:<%=img.W()*0.3%>px;height:<%=img.H()*0.3%>" />
  


<%
	set img = Nothing  
%>
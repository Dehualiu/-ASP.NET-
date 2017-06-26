<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	'清除cookies和session
	response.cookies("guest")("username") = ""
	session("Admin") = ""
	response.redirect "index.asp"
%>
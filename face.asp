<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<!--#include file="conn.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
<script type="text/javascript">
    function g(face){
        window.opener.document.reg.face.value=face
        window.opener.document.reg.faceimg.src=face
    }
</script>
</head>

<body style="width:auto">
    <div id="face">
        <h1>请选择你要选择的头像</h1>
        <%for i=1 to 9 %>
        <dl>
            <dd><img src="face/face0<%=i%>.jpg" alt="头像" onclick="g('face/face0<%=i%>.jpg')" /></dd>
        </dl>
        <%next%>
        <%for i=10 to 30 %>
        <dl>
            <dd><img src="face/face<%=i%>.jpg" alt="头像" onclick="g('face/face<%=i%>.jpg')" /></dd>
        </dl>
        <%next%>
    </div>



</body>
</html>
<%
	call close_conn
%>
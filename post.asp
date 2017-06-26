<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<!--#include file="conn.asp"-->
<%
	'会员才能进入
	if request.cookies("guest")("username") = ""	then
		response.write "<script>alert('您还没有登录，请登录后发帖');location.href='login.asp'</script>"
		response.end
	end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--#include file="title.asp"-->
<script type="text/javascript" src="js/ubb.js"></script>
<script type="text/javascript" src="js/post.js"></script>
</head>

<body>
<!--#include file="header.asp"-->
<div id="post" onmouseup="fonthid();">
	<h1>发表文章</h1>
	<div>
    	<form method="post" id="postbd" name="post" action="post_do.asp">
        	<dl>
            	<dd>文章标题：
                <select name="kind">
                	<option selected="selected" value="1">原创</option>
                    <option value="2">转帖</option>
                    <option value="3">图片</option>
                    <option value="4">下载</option>
                    <option value="5">文档</option>
                    <option value="6">音乐</option>

                	
                </select>
                <input type="text" name="title" class="text" />
                </dd>
                <dd>选择表情：
                <input type="radio" value="brow/p1.gif" name="brow" checked="checked" />
                <img src="brow/p1.gif" alt="表情一" />
                <input type="radio" value="brow/p2.gif" name="brow" />
                <img src="brow/p2.gif" alt="表情二" />
                <input type="radio" value="brow/p3.gif" name="brow" />
                <img src="brow/p3.gif" alt="表情三" />
                <input type="radio" value="brow/p4.gif" name="brow" />
                <img src="brow/p4.gif" alt="表情四" />
                <input type="radio" value="brow/p5.gif" name="brow" />
                <img src="brow/p5.gif" alt="表情五" />
                <input type="radio" value="brow/p6.gif" name="brow" />
                <img src="brow/p6.gif" alt="表情六" />
                <input type="radio" value="brow/p7.gif" name="brow" />
                <img src="brow/p7.gif" alt="表情七" />
                <input type="radio" value="brow/p8.gif" name="brow" />
                <img src="brow/p8.gif" alt="表情八" />
                <input type="radio" value="brow/p9.gif" name="brow" />
                <img src="brow/p9.gif" alt="表情九" />
                </dd>
                <dd style="padding-top:2px;padding-left:74px;">
                <input type="radio" value="brow/p10.gif" name="brow" /> 
                <img src="brow/p10.gif" alt="表情十" />
                <input type="radio" value="brow/p11.gif" name="brow" />
                <img src="brow/p11.gif" alt="表情十一" />
                <input type="radio" value="brow/p12.gif" name="brow" />
                <img src="brow/p12.gif" alt="表情十二" />
                <input type="radio" value="brow/p13.gif" name="brow" />
                <img src="brow/p13.gif" alt="表情十三" />
                <input type="radio" value="brow/p14.gif" name="brow" />
                <img src="brow/p14.gif" alt="表情十四" />
                <input type="radio" value="brow/p15.gif" name="brow" />
                <img src="brow/p15.gif" alt="表情十五" />
                <input type="radio" value="brow/p16.gif" name="brow" />
                <img src="brow/p16.gif" alt="表情十六" />
                <input type="radio" value="brow/p17.gif" name="brow" />
                <img src="brow/p17.gif" alt="表情十七" />
                <input type="radio" value="brow/p18.gif" name="brow" />
                <img src="brow/p18.gif" alt="表情十八" />
                </dd>
                <dd>插入Q 图：
					  <a href="###" onclick="javascript:window.open('qpic.asp?path=1&num=48','face','width=400,height=400,scrollbars=1')">Q图一</a>
					  <a href="###" onclick="javascript:window.open('qpic.asp?path=2&num=10','face','width=400,height=400,scrollbars=1')">Q图二</a>  
					  <a href="###" onclick="javascript:window.open('qpic.asp?path=3&num=39','face','width=400,height=400,scrollbars=1')">Q图三</a>
				</dd>
                <dd>
                <div id="ubb">
                	<img src="ubb/fontsize.gif" onclick="fontsize();" alt="字体大小" class="first" />
						<img src="ubb/bold.gif" alt="粗体" onclick="bold();" />
						<img src="ubb/italic.gif" alt="倾斜" onclick="it();" />
						<img src="ubb/underline.gif" alt="下划线" onclick="under();" />
						<img src="ubb/strikethrough.gif" alt="删除线" onclick="del();"  />
						<img src="ubb/space.gif" alt="分割线" />
						<img src="ubb/color.gif" alt="字体颜色" onclick="fontcolor();" />
						<img src="ubb/url.gif" alt="插入超链接" onclick="url();" />
						<img src="ubb/email.gif" alt="插入电子邮件"  onclick="email();" />
						<img src="ubb/space.gif" alt="分割线" />
						<img src="ubb/image.gif" alt="插入图片" onclick="img();" />
						<img src="ubb/swf.gif" alt="插入FLASH" onclick="flash();" />
						<img src="ubb/movie.gif" alt="插入影片" onclick="movie();" />
						<img src="ubb/space.gif" alt="分割线" />
						<img src="ubb/left.gif" alt="左对齐" onclick="left();" />
						<img src="ubb/center.gif" alt="居中" onclick="center();" />
						<img src="ubb/right.gif" alt="右对齐" onclick="right();" />
						<img src="ubb/br.gif" style="position:relative;top:4px;" alt="换行" onclick="br();" />
						<img src="ubb/space.gif" alt="分割线" />
						<img src="ubb/increase.gif" onclick="out();" alt="增加长度" />
						<img src="ubb/decrease.gif" onclick="ind();" alt="降低长度" />
						<img src="ubb/help.gif" onclick="javascrpt:window.open('ubbhelp.asp','ubbhelp','width=400,height=400')" alt="ubb帮助" />
                </div>
                <span id="fontDiv">
						<strong onclick="font(10)">10px</strong>
						<strong onclick="font(12)">12px</strong>
						<strong onclick="font(14)">14px</strong>
						<strong onclick="font(16)">16px</strong>
						<strong onclick="font(18)">18px</strong>
						<strong onclick="font(20)">20px</strong>
						<strong onclick="font(22)">22px</strong>
						<strong onclick="font(24)">24px</strong>
				</span>
                <span id="colorDiv">
							<strong title="黑色" style="background:#000" onclick="showcolor('#000')"></strong>
							<strong title="褐色" style="background:#930" onclick="showcolor('#930')"></strong>
							<strong title="橄榄树" style="background:#330" onclick="showcolor('#330')"></strong>
							<strong title="深绿" style="background:#030" onclick="showcolor('#030')"></strong>
							<strong title="深青" style="background:#036" onclick="showcolor('#036')"></strong>
							<strong title="深蓝" style="background:#000080" onclick="showcolor('#000080')"></strong>
							<strong title="靓蓝" style="background:#339" onclick="showcolor('#339')"></strong>
							<strong title="灰色-80%" style="background:#333" onclick="showcolor('#333')"></strong>
							<strong title="深红" style="background:#800000" onclick="showcolor('#800000')"></strong>
							<strong title="橙红" style="background:#f60" onclick="showcolor('#f60')"></strong>
							<strong title="深黄" style="background:#808000" onclick="showcolor('#000')"></strong>
							<strong title="深绿" style="background:#008000" onclick="showcolor('#808000')"></strong>
							<strong title="绿色" style="background:#008080" onclick="showcolor('#008080')"></strong>
							<strong title="蓝色" style="background:#00f" onclick="showcolor('#00f')"></strong>
							<strong title="蓝灰" style="background:#669" onclick="showcolor('#669')"></strong>
							<strong title="灰色-50%" style="background:#808080" onclick="showcolor('#808080')"></strong>
							<strong title="红色" style="background:#f00" onclick="showcolor('#f00')"></strong>
							<strong title="浅橙" style="background:#f90" onclick="showcolor('#f90')"></strong>
							<strong title="酸橙" style="background:#9c0" onclick="showcolor('#9c0')"></strong>
							<strong title="海绿" style="background:#396" onclick="showcolor('#396')"></strong>
							<strong title="水绿色" style="background:#3cc" onclick="showcolor('#3cc')"></strong>
							<strong title="浅蓝" style="background:#36f" onclick="showcolor('#36f')"></strong>
							<strong title="紫罗兰" style="background:#800080" onclick="showcolor('#800080')"></strong>
							<strong title="灰色-40%" style="background:#999" onclick="showcolor('#999')"></strong>
							<strong title="粉红" style="background:#f0f" onclick="showcolor('#f0f')"></strong>
							<strong title="金色" style="background:#fc0" onclick="showcolor('#fc0')"></strong>
							<strong title="黄色" style="background:#ff0" onclick="showcolor('#ff0')"></strong>
							<strong title="鲜绿" style="background:#0f0" onclick="showcolor('#0f0')"></strong>
							<strong title="青绿" style="background:#0ff" onclick="showcolor('#0ff')"></strong>
							<strong title="天蓝" style="background:#0cf" onclick="showcolor('#0cf')"></strong>
							<strong title="梅红" style="background:#936" onclick="showcolor('#936')"></strong>
							<strong title="灰度-20%" style="background:#c0c0c0" onclick="showcolor('#c0c0c0')"></strong>
							<strong title="玫瑰红" style="background:#f90" onclick="showcolor('#f90')"></strong>
							<strong title="茶色" style="background:#fc9" onclick="showcolor('#fc9')"></strong>
							<strong title="浅黄" style="background:#ff9" onclick="showcolor('#ff9')"></strong>
							<strong title="浅绿" style="background:#cfc" onclick="showcolor('#cfc')"></strong>
							<strong title="浅青绿" style="background:#cff" onclick="showcolor('#cff')"></strong>
							<strong title="浅蓝" style="background:#9cf" onclick="showcolor('#9cf')"></strong>
							<strong title="淡紫" style="background:#c9f" onclick="showcolor('#c9f')"></strong>
							<strong title="白色" style="background:#fff" onclick="showcolor('#fff')"></strong>
					</span>
                <textarea name="content" rows="8"></textarea>
                </dd>
                <%if web_yzm = 1 then%>
                <dd>验&nbsp;证&nbsp;码：<input type="text" name="yzm" maxlength="4" style="width:60px;" class="text yzm "/>
                    <img src="validatecode.asp" ondblclick="javascript:this.src='validatecode.asp?tm='+Math.random()" 
                     style="width:50px;height:23px;cursor:pointer;position:relative;top:8px;left:10px;border-radius:5px;" alt="验证码"/></dd> 
                <%end if%>
                <dd><input type="submit" name="send" onclick="return check();" value="发表文章" class="submit" /></dd>
            </dl>
	  </form>
    
    </div>
</div>


<!--#include file="footer.asp"-->

</body>

</html>
<%
	call close_conn
%>
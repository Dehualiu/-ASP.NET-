<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Response.Charset="utf-8"%>
<%
	dim showid
	showid = request.querystring("ShowId")
	
	'非法操作
	if showid = "" or not isnumeric(showid) then
		response.write "<script>alert('非法操作');history.back();</script>"
		response.end
	end if
%>
<!--#include file="conn.asp"-->
<%
	dim scorename,score,scoret,visited,speak,rs,readsql,sql,kind,title,content,tdate,brow,username,face,url,email,j,page,readcount,commentcount,updatename,updatedate,underwrite
	'在进入这张页面，筛选数据之前，就该进行累计阅读数，这才是最新的
	'开始筛选数据
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
		'开始累计
		application.lock
		readsql="update G_Article set G_ReadCount=G_ReadCount+1 where G_ID="&showid
		conn.execute(readsql)
		application.unlock
		sid = rs("G_ID")
		username = rs("G_UserName")
		title = rs("G_Title")
		content = rs("G_Content")
		brow = rs("G_Brow")
		tdate = rs("G_Date")
		readcount=rs("G_ReadCount")
		commentcount=rs("G_CommentCount")
		updatename=rs("G_UpdateName")
		updatedate=rs("G_UpdateDate")
		score = rs("G_Score")
		scoret = rs("G_ScoreT")
		scorename = rs("G_ScoreName")
		
		'获取精华帖
		dim nice
		nice = rs("G_Nice")
		
		'筛选发表文章的类型
		select case rs("G_Kind")
			case 1:
				kind = "原创"
			case 2:
				kind = "转帖"
			case 3:
				kind = "图片"
			case 4: 
				kind = "下载"
			case 5:
				kind = "音乐"
			case 6:
				kind = "文档"
			case else
				kind = "原创"
		end select		
	end if	
	call close_rs
	
	
	'这个通过username 去会员表里筛选信息
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_User where G_UserName='"&username&"'"
	rs.open sql,conn,1,1
	
	'提取数据
	if not rs.eof then
		speak = rs("G_Speak")
		visited = rs("G_Visited")
		face = rs("G_Face")
		email = rs("G_Email")
		url = rs("G_Url")
		account = rs("G_Account")
		underwrite = rs("G_UnderWrite")
		
		'这里用if underwrite = "" then 不合适
		'因为这里应该判断空null，而不是判断空字符串
 		if isnull(underwrite) then
			underwrite = "此人很懒，还没有个性签名"
		end if
		
	else
		face = "face/m01.gif"
		email = "<span style='color:#f00'>此用户以被删除</span>"
		url = "<span style='color:#f00'>此用户以被删除</span>"
		account = "此用户以被删除"
		underwrite = "此用户以被删除"
		
	end if
	call close_rs
	
	'下面是循环的回帖
	set rs = server.createobject("adodb.recordset")
	sql = "select * from G_Article where G_Del=0 and G_SID="&sid
	rs.open sql,conn,1,1
			
	
	'处理分页
			rs.pagesize=4
			'接受page的值
			page=request.querystring("page")
			'直接点击博友页面,没有传递page的值的情况
			if page="" then page=1
			'判断如果不是数字，则page=1
			if not isnumeric(page) then page=1
			'page的值为0或者负数时
			if clng(page)<1 then page=1
			'如果page大于最大的书页数，那么page为最后一页
			if clng(page)>rs.pagecount then page=rs.pagecount	
			'把接收到的值赋值给页码,如果没有数据,rs.absolutepage不能重置
			if not rs.eof then
				rs.absolutepage=page
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
<!--#include file="ubb.asp"-->
<!--#include file="header.asp"-->
<div id="article" onmouseup="fonthid();">
	<%if nice = 1 then%>
        <img src="image/nice.gif" class="nice" alt="精华" />
	<%end if%>
	<%if commentcount >13 then%>
        <img src="image/hot.gif" class="hot" alt="热门" />
	<%end if%>
    
    <h1>文 章 详 情</h1>
	<div id="acontent">
    
    	<!--以下是楼主-->
        <%if page=1 or page=0 then%>
    	<dl class="person">
        	<dt><%=username%>(楼主)</dt>
            <dd><img style="border-radius:50px;border:4px solid #fff;" src="<%=face%>" alt="<%=username%>" /></dd>
            <dd>给我送花|写短信</dd>
            <dd>加为好友</dd>
            <dd class="a"><%=email%></dd>
            <dd class="a"><%=url%></dd>
            <dd class="a">总积分：<strong><%=account%></strong>分</dd>
            <%if session("Admin")<>"" then%> 
                <dd>                    
                    <%if speak = 0 then%>
                    <a href="speak.asp?ShowId=<%=showid%>&username=<%=username%>&a=0">禁止发言</a>，
                    <%elseif speak = 1 then%>
                    <a href="speak.asp?ShowId=<%=showid%>&username=<%=username%>&a=1">解除禁言</a>，
                    <%end if%>
                    
                    <%if visited = 0 then%>
                    <a href="visited.asp?ShowId=<%=showid%>&username=<%=username%>&a=0">禁止访问</a>
                    <%else%>
                    <a href="visited.asp?ShowId=<%=showid%>&username=<%=username%>&a=1">解除访问</a>
                    <%end if%>
                    
                </dd> 
            <%end if%> 
        </dl>
        <div>
        	<p class="top"><em>#1</em><img src="image/member.gif" /> &nbsp;<%=username%> &nbsp; | &nbsp; <%=tdate%></p>
        	<%
				if username=request.Cookies("guest")("username") or session("Admin")<>"" then
			%>
            <em><a href="article_edit.asp?ShowId=<%=sid%>&sid=<%=sid%>">编辑</a></em>
            <%
				end if
			%>
            
            
            <%
				'加精只能是管理员加精，不能是其他任何人
				if session("Admin") <> "" then
			%>
			<em><a href="article_nice.asp?ShowId=<%=sid%>">加精</a></em>
			<em><a href="article_del.asp?sid=<%=sid%>&ShowId=<%=sid%>">删除</a></em>
			<%
				end if
			%>
            
            
            <h2>[<%=kind%>]<%=title%><img src="<%=brow%>" alt="表情" /></h2>
            <p class="content"><%=ubb(content)%></p>
            
            
            <%
				'如果是管理员登陆，显示评分二字
				'但如果已经评过了，就不需要显示评分二字
				'而显示评分的结果
				if session("Admin") <> "" and score = 0 then
			%>
			<p class="score"><a href="###" onclick="javascript:window.open('score.asp?ShowId=<%=showid%>&username=<%=username%>','score','width=600,height=300')">评分</a></p>
			<%else%>
				<%if score <> 0 then%>
				<p class="score2">
					分值：<%=score%>分 理由：<%=scoret%> 评分人：<%=scorename%>
				</p>
				<%end if%>
			<%end if%>
            
          
            <p class="update">
            <%if updatename <> "" and updatedate <> "" then%>
            [此文章由<strong><%=updatename%></strong>于<%=updatedate%>修改过]
            <%end if%>
            </p>
            <p class="underwrite"><%=ubb(underwrite)%></p>
            <p class="count">阅读数（<%=readcount%>） 评论数（<%=commentcount%>）</p>
        </div>
        <p class="line"></p>
        <%end if%>
        
       
		<!--以下是回复-->
        <%	
			j=2+(page-1)*rs.pagesize
			
			for i=1 to rs.pagesize    '如果有回帖，就循环
			if rs.eof then exit for
			'将循环出来的发帖人（用户名），放到用户表中进行查询
				dim rs2,sql2		
				set rs2=server.CreateObject("adodb.recordset")
				sql2="select * from G_User where G_UserName='"&rs("G_UserName")&"'"
				rs2.open sql2,conn,1,1		
				'拿出个人信息
				if not rs2.eof then
					respeak = rs2("G_Speak")
					revisited = rs2("G_Visited")
					reface=rs2("G_Face")
					reemail=rs2("G_Email")
					reurl=rs2("G_Url")
					reaccount=rs2("G_Account")
					reunderwrite=rs2("G_UnderWrite")
					
					if isnull(reunderwrite) then
						reunderwrite = "此人很懒，还没有个性签名"
					end if
				
				else
					'发生错误，不写了
					reface = "face/m01.gif"
					reemail = "<span style='color:#f00'>此用户以被删除</span>"
					reurl = "<span style='color:#f00'>此用户以被删除</span>"
					reaccount = "此用户以被删除"
					reunderwrite = "此用户以被删除"
				end if	
				rs2.close
				set rs2=nothing
		%>
        		
        <dl class="person">
        	<dt>
                <%	
					'标记出楼主,沙发
					if username=rs("G_UserName") and j=2 then
						a = rs("G_UserName")&"(楼主)"
					elseif username=rs("G_UserName") then
						a = rs("G_UserName")&"(楼主)"
					elseif j=2 then
						a = rs("G_UserName")&"(沙发)"
					else
						a = rs("G_UserName")
					end if
					response.write a
				%>
            </dt>
            <dd><img style="border-radius:50px;border:4px solid #fff;" src="<%=reface%>" alt="<%=rs("G_UserName")%>" /></dd>
            <dd>给我送花|写短信</dd>
            <dd>加为好友</dd>
            <dd class="a"><%=reemail%></dd>
            <dd class="a"><%=reurl%></dd>
            <dd class="a">总积分：<strong><%=reaccount%></strong>分</dd> 
            <%if session("Admin")<>"" then%>
                <dd>                   
                    <%if respeak = 0 then%>
                    <a href="speak.asp?ShowId=<%=showid%>&username=<%=rs("G_UserName")%>&a=0">禁止发言</a>，
                    <%elseif respeak = 1 then%>
                    <a href="speak.asp?ShowId=<%=showid%>&username=<%=rs("G_UserName")%>&a=1">解除禁言</a>，
                    <%end if%>
                    
                    <%if revisited = 0 then%>
                    <a href="visited.asp?ShowId=<%=showid%>&username=<%=rs("G_UserName")%>&a=0">禁止访问</a>
                    <%else%>
                    <a href="visited.asp?ShowId=<%=showid%>&username=<%=rs("G_UserName")%>&a=1">解除访问</a>
                    <%end if%>                   
                </dd>
            <%end if%>   
        </dl>
        <div>
        	<p class="top"><em>#<%=j%></em><img src="image/member.gif" /> &nbsp;<%=rs("G_UserName")%> &nbsp; | &nbsp; <%=rs("G_Date")%></p>
        	<h2>
            	<%if rs("G_UserName")=request.Cookies("guest")("username") or session("Admin")<>"" then%>
            	<em><a href="article_edit.asp?ShowId=<%=rs("G_ID")%>&sid=<%=sid%>">编辑</a></em>
                <%end if%>
                
                <%	'删除评论
					if session("Admin") <> "" then
				%>
				<em><a href="article_del.asp?sid=<%=sid%>&ShowId=<%=rs("G_ID")%>">删除</a></em>
				<%end if%>
                
				<%=rs("G_Title")%><img src="<%=rs("G_Brow")%>" alt="表情" />
            </h2>
            <p class="content"><%=ubb(rs("G_Content"))%></p>
    
            <%if session("Admin") <> "" and rs("G_Score") = 0 then%>
			<p class="score"><a href="###" onclick="javascript:window.open('score.asp?ShowId=<%=rs("G_ID")%>&username=<%=rs("G_UserName")%>','score','width=600,height=300')">评分</a>	</p>
			<%else%>
				<%if rs("G_Score") <> 0 then%>
				<p class="score2">
					分值：<%=rs("G_Score")%>分 理由：<%=rs("G_ScoreT")%> 评分人：<%=rs("G_ScoreName")%>
				</p>
				<%end if%>
			<%end if%>
            
            <p class="update">
			<%if rs("G_UpdateName") <> "" and rs("G_UpdateDate") <> "" then%>
            [此文章由<strong><%=rs("G_UpdateName")%></strong>于<%=rs("G_UpdateDate")%>修改过]
            <%end if%> 
            </p>
            <p class="underwrite"><%=ubb(reunderwrite)%></p>         
        </div>
        <p class="line"></p>
        <%
				j=j+1
				rs.movenext
			next
		%>
        <span id="page">
            <ul>
            <%
                for i=1 to rs.pagecount
                '如果点击查询，按照查询来分页处理
                '否则按照普通的分页来处理
                    url="page="&i
            %>
                <li><a href="article.asp?ShowId=<%=sid%>&<%=url%>"><%=i%></a></li>
            <%
                next
            %>
            </ul>
        </span>


        <!--以下是回复表单-->
         <%if request.Cookies("guest")("username")<>"" then%>   
        <form method="post" id="postbd" name="post" action="repost_do.asp">
        	<input type="hidden" name="sid" value="<%=sid%>" />
        	<dl>
            	<dd>文章标题：
                <input type="text" value="评论帖子：<%=title%>" readonly="readonly" name="title" class="text" />
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
                <div id="ubb" style="position:relative;left:-81px;">
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
                    style="cursor: pointer;" alt="验证码"/></dd> 
                <%end if%>
                <dd><input type="submit" name="send" onclick="return check();" value="回复主题" class="submit" /></dd>
            </dl>
	  </form>
      <%end if%>        
    </div>
</div>

<!--#include file="footer.asp"-->   
</body>
</html>
<%
	call close_conn
%>
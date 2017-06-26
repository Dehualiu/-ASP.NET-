<%Response.Charset="utf-8"%>
<div id="header">
        <ul>
            <li><a href="index.asp">首页</a></li>
            
            <% if request.cookies("guest")("username")="" then%>
            <li><a href="reg.asp">注册</a></li>
            <li><a href="login.asp">登录</a></li>
            <% else %>
            
             <li><a href="member.asp"><span><%=request.cookies("guest")("username")%></span>中心</a></li>
             <li>
             	<%=meg%>
             </li>
             <% end if %>
            <li><a href="blog.asp">博友</a></li>
            
            <li><a href="photo.asp">相册</a></li>
            
            <li class="menu">
            		风格
            	<dl id="menu">
                    <dd><a href="skin.asp?skin=2">粉色佳人</a></dd>
                    <dd><a href="skin.asp?skin=3">墨色典雅</a></dd>
                    <dd><a href="skin.asp?skin=1">灰度空间</a></dd>
                </dl>
            </li>
            
            <%if session("Admin")<>"" then%>
            <li><a href="admin.asp"><span>管理</span></a></li>
            <%end if%>
            
            <% if request.cookies("guest")("username")<>"" then%>
             <li><a href="logout.asp" class="out">退出</a></li>
            <% end if %>
        </ul>
</div>
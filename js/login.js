function check(){
	if(document.login.username.value == ""){
		alert("请输入你登录的用户名！");
		document.login.username.focus();
		return false;
		}
	if(document.login.username.value.length <2){
		alert("用户名不能少于两位！");
		document.login.username.focus();
		return false;
		}
	if(document.login.password.value==""){
		alert("请输入你的登录密码！");
		document.login.password.focus();
		return false;
		}
	if(document.login.password.value.length<6){
		alert("密码不得少于六位！");
		document.login.password.focus();
		return false;
		}
	return true;
}
	
	
	
	
	
	
	
	
	
	
	
	
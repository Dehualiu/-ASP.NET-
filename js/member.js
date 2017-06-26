function check(){
	var atpos=document.reg.email.value.indexOf("@",1);
	var pepos=document.reg.email.value.indexOf(".",atpos);
	//筛选出@在这个邮件的位置
	if(document.reg.password.value!=""){
		if(document.reg.password.value.length<6){
			alert("密码不得少于六位！");
			document.reg.password.focus();
			return false;
			}
		}
	if(document.reg.email.value==""){
		alert("邮件不得为空！");
		document.reg.email.focus();
		return false;
		}
	if(atpos==-1){//如果有@返回@的位置，如果没有则返回-1
		alert("输入的邮件缺少@");
		document.reg.email.focus();
		return false;	
		}
	if(document.reg.email.value.indexOf("@",atpos+1)!=-1){
		alert("邮件中不能同时输入两个@");
		document.reg.email.focus();
		return false;	
		}
	if(pepos==-1){
		alert("邮件中缺少.");
		document.reg.email.focus();
		return false;
		}
	if(pepos+3>document.reg.email.value.length){
		alert("邮件中.后没有至少两个字符！");
		document.reg.email.focus();
		return false;
		}
	if(document.reg.qq.value==""){
		alert("QQ不得为空！");
		document.reg.qq.focus();
		return false;
		}
	if(isNaN(document.reg.qq.value)){
		alert("QQ必须是数字！");
		document.reg.qq.focus();
		return false;
		}
	if(document.reg.qq.value.length<5||document.reg.qq.value.length>12){
		alert("QQ号码必须是5-12位！");
		document.reg.qq.focus();
		return false;	
		}
	if(document.reg.url.value==""||document.reg.url.value=="http://"){
		alert("地址不得为空！");
		document.reg.url.focus();
		return false;	
		}
	return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
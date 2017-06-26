function check(){
	if(document.note.touser.value==""){
		alert("用户名不得为空!");
		document.note.touser.focus();
		return false;
		}
	if(document.note.message.value=="" || document.note.message.value.length<5 || document.note.message.value.length>200){
		alert("短信内容不得为空，或者小于5个字符，大于200个字符!");
		document.note.message.focus();
		return false;
		}

	return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
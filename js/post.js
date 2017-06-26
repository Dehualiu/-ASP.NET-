function check() {
	if (document.post.title.value.length < 4) {		
		alert ("发表的标题不得小于4位");
		document.post.title.focus();		
		return false;
	}
	if (document.post.content.value.length < 10) {
		alert("内容不得少于10位");
		document.post.content.focus();
		return false;
	}
	return true;
}
$(function(){

	var url = $("#loading_url").val();

	if(url.indexOf("http://") != -1){
		$("#load_form").submit();
	}

});

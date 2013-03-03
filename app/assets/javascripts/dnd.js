$(function() {
		$("body").append("<div id=\"filter\"></div>")
		$("#filter").append("<div id=\"dropbox\">ここに画像をドロップしてURLを取得</div>")

		$("#filter").css({
	//		opacity: '0.6',
	//		background: '#000000',
			display: 'block',
			position: 'fixed',
			top: '0',
			left: '0',
			width: '100%',
			height: '100%',
			textAlign: 'center',
			zIndex: '1'
		});
		$("#dropbox").css({
			display: 'none',
			position: 'absolute',
		//	background: '#CFF',
			top: '50%',
			left: '50%',
			width: '500px',
			height: '75px',
			textAlign: 'center',
			marginLeft: '-250px',
			marginTop: '-50px',
			fontSize: 'large',
			fontWeight: 'bold',
			padding: '50px 0 0 0',
			border: 'solid 2px #000000',
			zIndex: '2',
			'-webkit-box-shadow': '0 10px 6px -6px #777',
			'-moz-box-shadow': '0 10px 6px -6px #777',
			'box-shadow': '0 10px 6px -6px #777',
			'border-radius': '10px',
			'-webkit-border-radius': '10px',
			'-moz-border-radius': '10px',

			'background-color': '#FFF4EA', 
			background: '-moz-linear-gradient(top,  #ffffff, #FFF4EA)', /* FF3.6+ */
			background: '-webkit-gradient(linear, center top, center bottom, from(#FFFFFF), to(#FFF4EA))' /* Chrome,Safari4+ */

		});

		$("html")
			.hover(
				function(){
					$("#filter").css('display', 'none');
				},
				function(){
					$("#filter").css('display', 'block');
				}
			);
		

		$("#filter")

			.bind("dragover", function(){
				$("#dropbox").css('display', 'block');
				return false;
			})
			.bind("dragend", function(){
				$("#dropbox").css('display', 'none');
				return false;
			});

		$("#dropbox")
			.bind("dragover", function(){
				return false;
			})
			.bind("drop", function(e){
				var node = e.originalEvent.dataTransfer.getData("text/html");

		    	if(node.substring(1, 4) != "img"){
		        	return false;
				}

				var find1 = node.indexOf("\"", node.search("src"));
				var find2 = node.indexOf("\"", find1+1);
			//	document.getElementById("loading_url").value = node.substring(find1+1, find2);
				var url = node.substring(find1+1, find2);
				$("#loading_url").val(url);
				$("#dropbox").css('display', 'none');

				e.preventDefault();	
				return false;
			});

});


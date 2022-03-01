<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %> 
<input type=button value='還沒有功能的按鈕' onclick=''>
<%
//-----------防止瀏覽器快取網頁------------
NoCatch(response);
//-----------宣告按鈕----------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//-----------宣告Grid----------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("100%");
%>
<input type=button value='跳出警告訊息' onclick='ADD()'>
<%
Grid.Show();
//-----------釋放--------------------------
Grid=null;
UI=null;
%>
<script>
	function ADD()
	{
		alert("123");
	};
</script>
<!------------Vue語法--------------------->
<!doctype html>
<head>
	<meta charset="UTF-8"> 
	<title>Title</title> 
	<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script> 
</head>
<body>
	<h2>測試中</h2>
	<div id='app'>
	{{message}}
	<input type="button" value='按鈕' v-model="message">
	</div>
	<script>
	var app = new Vue({
		el: "#app",
		data:{message:""}
	});
	</script>
</body>
</html>
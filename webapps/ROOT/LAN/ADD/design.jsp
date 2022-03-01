<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %> 
<%
response.setContentType("text/html;charset=big5");
NoCatch(response);
Html UI=new Html(pageContext,Data,Conn);
UI.Start();

Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("100%");

Grid.AddCol("<input id=nums type=hidden name=nums size=5><table id=mytable name=mytable width=580><tr><td width=100>標題:</td><td width=150>項目:</td><td width=200>題目:</td></tr></table>","colspan=2 align=center");  
Grid.AddRow("");


Grid.Show();
Grid=null;
UI=null;
%>

<input type=button name=go value="增加標題" onclick="add_new_data1()">
<script>
	function add_new_data1() 
	{
            //先取得目前的row數
            var num = document.getElementById("mytable").rows.length;
            //建立新的tr 因為是從0開始算 所以目前的row數剛好為目前要增加的第幾個tr
            var Tr = document.getElementById("mytable").insertRow(num);
            //建立新的td 而Tr.cells.length就是這個tr目前的td數
            Td = Tr.insertCell(Tr.cells.length);
            //而這個就是要填入td中的innerHTML
            Td.innerHTML = '<input name="QA_Title'+num+'" type="text" size="20">';
            //這裡也可以用不同的變數來辨別不同的td (我是用同一個比較省事XD)
            Td = Tr.insertCell(Tr.cells.length);
            Td.innerHTML = '<input name="QA_Type'+num+'" type="text" size="50">';
            Td = Tr.insertCell(Tr.cells.length);
            Td.innerHTML = '<input name="QA_Que'+num+'" type="text" size="70">';
            //這樣就好囉 記得td數目要一樣 不然會亂掉~
            document.getElementById("nums").value=num;
						
            alert(num);
	}
</script>
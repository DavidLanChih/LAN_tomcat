<%@ include file="/kernel.jsp" %><%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page contentType="text/html;charset=MS950" %>
<%
//-----------防止瀏覽器快取網頁----------------
NoCatch(response);
//----------------宣告按鈕---------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//--------------表格介面設定-------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setForm(true);
Grid.AddRow("");
Grid.AddGridTitle("<font size=3>廠商櫃號轉移：</font>","","colspan=2 rowspan=1 align=center"); 
//Grid.AddCol("&nbsp;&nbsp;&nbsp;&nbsp;<font size=2>舊櫃號：</font><input type='text' name='C1' id='C1' onclick='' maxlength=5 size=10 >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;->&nbsp;&nbsp;&nbsp;&nbsp;<font size=2>新櫃號：</font><input type='text' name='C2' id='C2' onclick='' maxlength=5 size=10>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='submit' name='mail' value='執行櫃號轉移' onclick='sendmail()'>","colspan=6 rowspan=1 align=left");
Grid.AddCol("&nbsp;&nbsp;<font size=3>櫃號轉移表單(已審核通過)</font>&nbsp;&nbsp;&nbsp;&nbsp;<font size=3><input type='submit' name='mail' style='width:90px;height:26px;font-size:16px;' value='執行轉移' onclick='sendmail()'></font>","colspan=6 rowspan=1 align=left");  
//------------------釋放-----------------------
Grid.Show();
Grid=null;
UI=null;
%>
<script>
//-------------將櫃號資料送出------------------
function sendmail()
{
	//var C1=document.getElementById("C1").value;
	//var C2=document.getElementById("C2").value;
	//window.open("Transfer.jsp?C1="+C1+"&C2="+C2,"櫃號變更","width=480,height=350");
	window.open("Transfer11.jsp?","櫃號變更","width=600,height=300");
}	
</script>
<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
leeten.Date JDate=new leeten.Date();
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String Field=req("Field",request);

String FR_RecId=req("FR_RecId",request);
String FI_RecId=req("FI_RecId",request);
String FD_RecId=req("FD_RecId",request);
String OrgId=req("OrgId",request);


NoCatch(response);
UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("200");
Grid.setForm(true); 
Grid.AddTab("大電腦帳密輸入",1);
Grid.AddRestTab("");
Grid.AddRow("");
Grid.AddCol("(請輸入帳號)<br><input type=text size='7' name='UserID' id='UserID'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("(請輸入密碼)<br><input type=Password size='7' name='Password' id='Password'   onKeyDown='if(event.keyCode==13) closeWindow();'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type=hidden size='7' name='checkt' id='checkt' >","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='closeWindow();' value='送出'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='clearData();' value='清除資料'>","colspan=2 align=center");


Grid.Show();
Grid=null;

%>
<iframe id='FrmTemp' src='' style='width:500;height:300' frameborder=0></iframe>
<script language="javascript">

function clearData()
{
	document.getElementById('UserID').value='';
	document.getElementById('Password').value='';
	window.close();
}

function closeWindow()
{
	var UsrID;
	var Pwd;
	
	UsrID=document.getElementById('UserID').value;
	Pwd=document.getElementById('Password').value;
	
		
	if(UsrID!=''&& Pwd!='')
	{
		document.getElementById('FrmTemp').src='/cy/getUserData.jsp?UserID='+UsrID+'&Password='+Pwd;
		//window.close();
		
	}
}
	var FR_RecId ='<%=FR_RecId%>';
	var FI_RecId ='<%=FI_RecId%>';
	var FD_RecId ='<%=FD_RecId%>';
	var OrgId ='<%=OrgId%>';

	function CheckOk()
	{
		alert("ok");
		
		opener.document.getElementById("checkt1").value=document.getElementById("checkt").value;
		opener.CheckOk2(FR_RecId,FI_RecId,FD_RecId,OrgId);
		window.close();
	
	}

	

</script>
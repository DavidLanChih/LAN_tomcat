<%@ include file="/kernel.jsp" %><%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page contentType="text/html;charset=MS950" %>
<%
//-----------�����s�����֨�����----------------
NoCatch(response);
//----------------�ŧi���s---------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//--------------��椶���]�w-------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setForm(true);
Grid.AddRow("");
Grid.AddGridTitle("<font size=3>�t���d���ಾ�G</font>","","colspan=2 rowspan=1 align=center"); 
//Grid.AddCol("&nbsp;&nbsp;&nbsp;&nbsp;<font size=2>���d���G</font><input type='text' name='C1' id='C1' onclick='' maxlength=5 size=10 >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;->&nbsp;&nbsp;&nbsp;&nbsp;<font size=2>�s�d���G</font><input type='text' name='C2' id='C2' onclick='' maxlength=5 size=10>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='submit' name='mail' value='�����d���ಾ' onclick='sendmail()'>","colspan=6 rowspan=1 align=left");
Grid.AddCol("&nbsp;&nbsp;<font size=3>�d���ಾ���(�w�f�ֳq�L)</font>&nbsp;&nbsp;&nbsp;&nbsp;<font size=3><input type='submit' name='mail' style='width:90px;height:26px;font-size:16px;' value='�����ಾ' onclick='sendmail()'></font>","colspan=6 rowspan=1 align=left");  
//------------------����-----------------------
Grid.Show();
Grid=null;
UI=null;
%>
<script>
//-------------�N�d����ưe�X------------------
function sendmail()
{
	//var C1=document.getElementById("C1").value;
	//var C2=document.getElementById("C2").value;
	//window.open("Transfer.jsp?C1="+C1+"&C2="+C2,"�d���ܧ�","width=480,height=350");
	window.open("Transfer11.jsp?","�d���ܧ�","width=600,height=300");
}	
</script>
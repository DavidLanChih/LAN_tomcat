<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
leeten.Date JDate=new leeten.Date();
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String Field=req("Field",request);

NoCatch(response);
UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("200");
Grid.setForm(true); 
Grid.AddTab("�t�ӽs����J",1);
Grid.AddRestTab("");
Grid.AddRow("");
Grid.AddCol("(�п�J�t�ӽs��)<br><input type=text size='5' name='no' id='no' >","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='closeWindow();' value='�e�X'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='clearData();' value='�M�����'>","colspan=2 align=center");
Grid.Show();
Grid=null;
%>
<iframe id='FrmTemp' src='' style='width:0;height:0' frameborder=0></iframe>
<script language="javascript">

function clearData()
{
	opener.document.getElementById('<%=Field%>').value='';
	window.close();
	}
function closeWindow()
{
	var no;
	no=document.getElementById('no').value;
	if(document.getElementById('no').value!='')
	{		
		document.getElementById('FrmTemp').src='/cy/CheckCountData3.jsp?UID='+no;		
	}
	else
	{		
		opener.document.getElementById('<%=Field%>').value=document.getElementById('no').value.trim();
		window.close();
	}
}
function CheckOk()
{	
	opener.document.getElementById('<%=Field%>').value=document.getElementById('no').value;
	window.close();	
}
</script>
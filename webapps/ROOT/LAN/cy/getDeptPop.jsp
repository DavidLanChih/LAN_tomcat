<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
leeten.Date JDate=new leeten.Date();
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String SqlStr="";
String UID=J_UD_Id.substring(0,5);
String UUID=J_UD_Id.substring(2);
String SelectUserStr="";
String Dept="",DName="";
String Field=req("Field",request);
String USID=req("USID",request);
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select manf073.m073_dept as dept,manf001.m001_dname as dname,manf073.m073_boss,manf002.m002_name,manf073.m073_boss as Value,manf073.m073_dept||manf001.m001_dname as ID   from manf073,manf002,manf001  where manf073.m073_code='1'  and manf073.m073_boss=manf002.m002_no  and  manf002.m002_dept=manf001.m001_dept  and  not m073_dept='' order by manf073.m073_dept";
NoCatch(response);
UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("200");
Grid.setForm(true); 
Grid.AddTab("�������",1);
Grid.AddRestTab("");
Grid.AddRow("");
SelectUserStr="<select size=1 name=user>";
ResultSet Rs=stmt.executeQuery(SqlStr);
SelectUserStr+="<option value=''>";
while(Rs.next())
{           
	SelectUserStr+="<option value='"+Rs.getString("ID")+"'>"+Rs.getString("dept")+":"+Rs.getString("dname");	
}

Rs.close();
stmt.close();
conn.close();

Grid.AddCol("�п�ܳ���","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol(SelectUserStr+="</select>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='closeWindow();' value='�e�X'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='clearData();' value='�M�����'>","colspan=2 align=center");
Rs.close();Rs=null;
Grid.Show();
Grid=null;
closeConn(Data,Conn);
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
	if(document.getElementById('user').options.value=='')
	{alert('�п�ܳ���!!');return false;}
	

	else
	{
			var x =document.getElementById("user");

			opener.document.getElementById('<%=Field%>').value=x.options[x.selectedIndex].text +":����";
			//opener.document.getElementById('<%=Field%>').value=document.getElementById('user').options.value.trim();
			window.close();
	
	}
}
function CheckOk()
{	
	opener.document.getElementById('<%=Field%>').value=x.options[x.selectedIndex].text +":����";
			
	//opener.document.getElementById('<%=Field%>').value=document.getElementById('user').options.value.trim();
	window.close();
	
}
</script>
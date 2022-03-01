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
String Dept="",Comp="";
String Field=req("Field",request);
String USID=req("USID",request);

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

SqlStr="select p001_venno,p001_name1,p001_blane,p001_venno||p001_name1 as ID from purf001 where p001_venno like 'F%' ";

//System.out.println("Informix "+SqlStr);
NoCatch(response);
UI.Start();

Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("200");
Grid.setForm(true); 
Grid.AddTab("廠商選擇",1);
Grid.AddRestTab("");
Grid.AddRow("");
SelectUserStr="<select size=1 name=user>";
ResultSet Rs=stmt.executeQuery(SqlStr);
SelectUserStr+="<option value=''>";


while(Rs.next())
{      
	
	SelectUserStr+="<option value='"+Rs.getString("ID")+"'>"+Rs.getString("p001_venno")+":"+Rs.getString("p001_name1");	

}
Grid.AddCol("請選擇廠商","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol(SelectUserStr+="</select>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("(如下拉選單中無所需廠商，<br>請輸入五碼廠商編號)<br><input type=text size='5' name=no onKeyDown='if(event.keyCode==13) closeWindow();'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='closeWindow();' value='送出'>","colspan=2 align=center");
Rs.close();Rs=null;
stmt.close();conn.close();
Grid.Show();
Grid=null;
closeConn(Data,Conn);
%>
<iframe id='FrmTemp' src='' style='width:0;height:0' frameborder=0></iframe>

<script language="javascript">
function closeWindow()
{
	var no;
	no=document.getElementById('no').value;
		
	if(document.getElementById('user').options.value=='' && document.getElementById('no').value=='')
	{alert('請選擇廠商!!');return false;}
	if(document.getElementById('user').options.value!='' && document.getElementById('no').value!='')
	{alert('兩個欄位勿同時輸入!!');return false;}
	if(document.getElementById('no').value!='')
	{
		document.getElementById('FrmTemp').src='/cy/checkCount_W1.jsp?venno='+no;
	}
	else
	{
			opener.document.getElementById('<%=Field%>').value=document.getElementById('user').options.value.trim();
			window.close();
	}
}
function CheckOk()
{	
	opener.document.getElementById('<%=Field%>').value=document.getElementById('no').value;
	window.close();
	
}

</script>
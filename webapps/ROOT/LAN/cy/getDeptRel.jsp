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
String USID="";
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select manf073.m073_dept,manf001.m001_dname,manf073.m073_boss,manf002.m002_name,manf073.m073_boss as Value from manf073,manf002,manf001 where manf073.m073_code ='2' and manf073.m073_boss=manf002.m002_no and manf002.m002_dept=manf001.m001_dept order by manf073.m073_dept";

//System.out.println("Informix "+SqlStr);
ResultSet rs=stmt.executeQuery(SqlStr);
rs.next();
rs.close();
NoCatch(response);
UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("200");
Grid.setForm(true); 
Grid.AddTab("部門專員選擇",1);
Grid.AddRestTab("");
Grid.AddRow("");
SelectUserStr="<select size=1 name=user>";
ResultSet Rs=stmt.executeQuery(SqlStr);
SelectUserStr+="<option value=''>";
while(Rs.next())
{           
	SelectUserStr+="<option value='"+Rs.getString("m073_dept")+"'>"+Rs.getString("m073_dept")+":"+Rs.getString("m001_dname")+":"+Rs.getString("m073_boss")+":"+Rs.getString("m002_name");	
}
Grid.AddCol("請選擇部門專員","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol(SelectUserStr+="</select>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='setOthers();' value='無相關專員，選擇其它'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='closeWindow();' value='送出資料'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='clearData();' value='清除資料'>","colspan=2 align=center");

Rs.close();Rs=null;
stmt.close();
conn.close();

Grid.Show();
Grid=null;
//closeConn(Data,Conn);
%>
<iframe id='FrmTemp' src='' style='width:0;height:0' frameborder=0></iframe>
<script language="javascript">


function clearData()
{
	opener.document.getElementById('<%=Field%>').value='';
	window.close();
}

function setOthers()
{
	opener.document.getElementById('<%=Field%>').value='其他';
	window.close();
}


function closeWindow()
{
	
			var x =document.getElementById("user");
			opener.document.getElementById('<%=Field%>').value=x.options[x.selectedIndex].text;
			window.close();
	
}

</script>
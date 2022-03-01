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
SqlStr="select m002_comp,m002_dept from manf002,manf000 where m002_dept='"+UID+"' or m002_no='"+UUID+"'";
//System.out.println("Informix "+SqlStr);
ResultSet rs=stmt.executeQuery(SqlStr);
rs.next();
Dept=rs.getString("m002_dept");
Comp=rs.getString("m002_comp");
rs.close();
stmt.close();
conn.close();

//SqlStr="select m002_name,m002_no,m002_no||m002_name as ID from manf002 where m002_dept='"+Dept+"' and (m002_ddate is null or m002_ddate >=today-60) union all select m002_name,m002_no,m002_no||m002_name as ID from manf074,manf002 where m074_work_dept='"+Dept+"' and m074_no=m002_no";
//System.out.println("Informix "+SqlStr);
NoCatch(response);
UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("200");
Grid.setForm(true); 
Grid.AddTab("櫃號選擇",1);
Grid.AddRestTab("");
Grid.AddRow("");
Grid.AddCol("(請輸入櫃號)<br><input type=text size='7' name=no   onKeyDown='if(event.keyCode==13) closeWindow();'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='closeWindow();' value='送出'>","colspan=2 align=center");
Grid.Show();
Grid=null;
%>
<iframe id='FrmTemp' src='' style='width:0;height:0' frameborder=0></iframe>
<script language="javascript">
function closeWindow()
{
	var no;
	no=document.getElementById('no').value;
	if(document.getElementById('no').value!='')
	{
		document.getElementById('FrmTemp').src='/cy/CheckCountName.jsp?UID='+no;
		//document.write('<iframe frameborder="0" name="myFrame" src="/cy/CheckCountId.jsp?UID='+no+'&Fid='+Fid+'"></iframe>');
	
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
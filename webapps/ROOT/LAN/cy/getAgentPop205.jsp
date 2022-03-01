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
String Comp="";
String m013_dd="";
String Field=req("Field",request);
String Dept=req("USID",request);
String yyy = req("start_yy",request);//申請年
String mmm = req("start_mm",request);//申請月
String ddd = req("start_dd",request);//申請日

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

//SqlStr="select m002_comp,m002_dept from manf002,manf000 where m002_dept='"+UID+"' or m002_no='"+UUID+"'";
//System.out.println("Informix "+SqlStr);
//ResultSet rs=stmt.executeQuery(SqlStr);
//rs.next();
//Dept=rs.getString("m002_dept");
//Comp=rs.getString("m002_comp");
//rs.close();

SqlStr="select m002_name,m002_no,m002_no||m002_name as ID from manf002 where m002_dept='"+Dept+"' and (m002_ddate is null or m002_ddate >=today-31) union all select m002_name,m002_no,m002_no||m002_name as ID from manf074,manf002 where m074_work_dept='"+Dept+"' and m074_no=m002_no";
//System.out.println("Informix "+SqlStr);
NoCatch(response);
UI.Start();

Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("200");
Grid.setForm(true); 
Grid.AddTab("陪檢人員選擇",1);
Grid.AddRestTab("");
Grid.AddRow("");
SelectUserStr="<select size=1 name=user>";
ResultSet Rs=stmt.executeQuery(SqlStr);
SelectUserStr+="<option value=''>";
while(Rs.next())
{           
	SelectUserStr+="<option value='"+Rs.getString("ID")+"'>"+Rs.getString("m002_no")+Rs.getString("m002_name");	
}
Grid.AddCol("請選擇陪檢人員","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol(SelectUserStr+="</select>","colspan=2 align=center");
Grid.AddRow("");

Grid.AddCol("<input type='submit' onClick='closeWindow();' value='送出'>","colspan=2 align=center");
Rs.close();Rs=null;
stmt.close();conn.close();
Grid.Show();
Grid=null;
closeConn(Data,Conn);
%>
<iframe id='FrmTemp' src='' style='width:0;height:0' frameborder=0></iframe>
<iframe id='FrmTemp1' src='' style='width:0;height:0' frameborder=0></iframe>

<script language="javascript">

function closeWindow()
{
		        
	
		opener.document.getElementById('<%=Field%>').value=  document.getElementById('user').options.value.trim() ;
		window.close();
	
}

</script>
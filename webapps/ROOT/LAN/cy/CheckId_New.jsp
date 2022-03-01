<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String m002No="",m002Name="",OP="",SqlStr="",SqlStr1="";
String UID=req("UID",request);
String yy=req("start_yy",request);
String mm=req("start_mm",request);
String dd=req("start_dd",request);


%>
	<script language="javascript">
		
		alert('123');
		alert(yy);
		alert(mm);
		alert(dd);
		
				
	</script>
<%
//UI.Start();

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select m002_no,m002_name from manf002 where m002_no='"+UID+"' and (m002_ddate is null or m002_ddate >=today-60)";

SqlStr1="select m013_dd"+dd+" from manf013 where m013_no='"+UID+"' and m013_yy='"+yy+"' and m013_mm='"+mm+"' and   m013_dd"+dd+"='/' ";
 


ResultSet rs=stmt.executeQuery(SqlStr);
ResultSet rs1=stmt.executeQuery(SqlStr1);

if(!rs.next())
{
%>
	<script language="javascript">
		alert('查無此工號!!')		
	</script>
<%	
}
else
{
	m002No=rs.getString("m002_no");
	m002Name=rs.getString("m002_name");
	
}
rs.close();
rs=null;

if(rs1.next())
{
	rs1.beforeFirst();
	while(rs1.next())
	{		
%>
	<script language="javascript">
		alert('請注意代理人當日排班為休假!請重新選擇代理人!');
		//parent.document.getElementById('<%=Field2%>').value+='<系統說明:請注意代理人'+<%=yy%>+'/'+<%=mm%>+'/'+<%=dd%>+'當日排班為休假!>';
    //parent.document.getElementById('<%=Field2%>').focus();
	</script> 

<%	    
	} 
	
} 
rs1.close();
rs1=null;
stmt.close();
conn.close();
	
%>
<script language="javascript">	
	parent.document.getElementById('no').value='<%=m002No%>'+'<%=m002Name%>';
	parent.CheckOk();
</script>
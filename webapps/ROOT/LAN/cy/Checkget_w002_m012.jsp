<%@ include file="/kernel.jsp" %>
<%@ include file="/cykernel.jsp" %>
<%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",Content="",Content2="",Content3="";

ArrayList ar = new ArrayList();
ArrayList armin = new ArrayList();
ArrayList arkind = new ArrayList();

String Field1=req("Field1",request);//remark1
Statement stmt = conn.createStatement();

SqlStr="select w002_date,w002_m012,w002_min_m012,w002_kind1 from manfw02 ";
Rs=stmt.executeQuery(SqlStr);
while(Rs.next())
{ 
   if(Rs.getString("w002_m012").trim().equals("1"))
	{
		ar.add(Rs.getString("w002_date"));
	
	   armin.add(Rs.getString("w002_min_m012"));
	   
	   arkind.add(Rs.getString("w002_kind1"));
	}
	
		
}

Rs.close();Rs=null;
conn.close();

out.println(ar);
%>

<script language="javascript">	
	
	parent.document.getElementById('FD_Data62').value='<%=ar%>';

	parent.document.getElementById('FD_Data67').value='<%=armin%>';
	parent.document.getElementById('FD_Data63').value='<%=arkind%>';

</script>
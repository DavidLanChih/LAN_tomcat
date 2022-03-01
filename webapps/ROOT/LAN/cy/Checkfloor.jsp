<%@ include file="/kernel.jsp" %>
<%@ include file="/cykernel.jsp" %>
<%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);


String SqlStr="",s026_ecr="",s026_floor="",s026_poll="";

String UID=req("UID",request).toUpperCase();

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);


//s026_ecr ¾÷¥x,s026_floor ´É§O,s026_poll ¼Ó 
SqlStr="select s026_ecr,s026_floor,s026_poll from salf026 "+
"where s026_lan='"+UID+"'";
out.println(SqlStr);
Rs=stmt.executeQuery(SqlStr);
  

if(Rs.next())
{
	s026_ecr=Rs.getString("s026_ecr").trim();	
	s026_floor=Rs.getString("s026_floor").trim();
	s026_poll=Rs.getString("s026_poll").trim();
}

Rs.close();
Rs=null;
stmt.close();
conn.close();


%>
<script language="javascript">	


	parent.document.getElementById('no').value='<%=s026_ecr%>'+":"+'<%=s026_floor%>'+":"+'<%=s026_poll%>';
	
	
	parent.CheckOk1();
</script>
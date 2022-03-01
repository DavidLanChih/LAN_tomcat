<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",Kind="",dd="",abc="";
String m002pno="",m023sname="",m002_name="",m002_no="";
String Field=req("Field",request);
String UID=req("UID",request);


Statement stmt2 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
//System.out.println("Informix "+SqlStr);
SqlStr="select * from manf047 where m047_matno='1' and m047_no='"+UID+"' ";


ResultSet rs2=stmt2.executeQuery(SqlStr);
if(!rs2.next())
{
%>
	<script language="javascript">
		parent.document.getElementById('<%=Field%>').value='N:尚未領用';
  </script>
<%	
}
else
{
%>
	<script language="javascript">
		parent.document.getElementById('<%=Field%>').value='Y:已領用';
  </script>
<%		
}
rs2.close();
rs2=null;
stmt2.close();
conn.close();
%>


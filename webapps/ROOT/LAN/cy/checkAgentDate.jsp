<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",Kind="";
String m013_no="",m013_yy="",m013_mm="",m013_dd="";

String Field=req("Field",request);
String yy=req("SDate_yy",request);
String mm=req("SDate_mm",request);
String dd=req("SDate_dd",request);
String AgentID=req("AgentID",request);

if(mm.length()==1){mm="0"+mm;}
if(dd.length()==1){dd="0"+dd;}


Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
//System.out.println("Informix "+SqlStr);
SqlStr="select m013_dd"+dd+" from manf013 where m013_no='"+AgentID+"' and m013_yy='"+yy+"' and m013_mm='"+mm+"' and   m013_dd"+dd+"='/' ";


ResultSet rs=stmt.executeQuery(SqlStr);
if(rs.next())
{
%>
	<script language="javascript">
		alert('代理人排班當日為休假，請重選代理人');
		parent.document.getElementById('<%=Field%>').value='';
  </script>
<%	
}
rs.close();
rs=null;
stmt.close();
conn.close();

%>


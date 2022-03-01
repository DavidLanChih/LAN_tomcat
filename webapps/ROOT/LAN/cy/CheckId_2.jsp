<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String m002No="",m002Name="",OP="",SqlStr="";
String UID=req("UID",request);
//UI.Start();

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select m002_no,m002_name from manf002 where m002_no='"+UID+"' and (m002_ddate is null or m002_ddate >=today-60)";

//System.out.println("Informix "+SqlStr);

ResultSet rs=stmt.executeQuery(SqlStr);
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
	m002Name=rs.getString("m002_name").trim();
	
	
}
rs.close();
rs=null;
stmt.close();
conn.close();
%>
<script language="javascript">	
	parent.document.getElementById('no').value='<%=m002No%>'+":"+'<%=m002Name%>'+":員工";
	parent.CheckOk();
</script>
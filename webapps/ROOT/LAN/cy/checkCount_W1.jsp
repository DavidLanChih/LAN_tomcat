<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String p001_venno="",p001_name1="",OP="",SqlStr="";
String venno=req("venno",request);
//UI.Start();

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
///SqlStr="select m002_no,m002_name from view_manf002 where m002_no='"+UID+"' and (m002_ddate is null or m002_ddate >=today-60)";

SqlStr="select  p001_venno,p001_name1 from purf001 where p001_venno='"+venno+"' ";

//System.out.println("Informix "+SqlStr);

ResultSet rs=stmt.executeQuery(SqlStr);
if(!rs.next())
{
%>
	<script language="javascript">
		alert('查無此廠商編號!!')		
	</script>
<%	
}
else
{
	p001_venno=rs.getString("p001_venno");
	p001_name1=rs.getString("p001_name1");
	
		
	
}
rs.close();
rs=null;
stmt.close();
conn.close();
%>
<script language="javascript">	
	parent.document.getElementById('no').value='<%=p001_venno%>'+'<%=p001_name1%>';
	parent.CheckOk();
	
</script>
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
SqlStr="select distinct  manf002.m002_name as m002_name,manf002.m002_no as m002_no,manf002.m002_pno as m002_pno,manf002.m002_sno1, manf023.m023_sname as m023_sname,manf023.m023_sno1  from manf002,manf023 where  manf002.m002_sno1=manf023.m023_sno1 and manf002.m002_no='"+UID+"'";

ResultSet rs2=stmt2.executeQuery(SqlStr);
if(!rs2.next())
{
%>
	<script language="javascript">
		alert('�d�L�������!!')		
	</script>
<%	
}
else
{
		m002_no=rs2.getString("m002_no");//�u��
		m002_name=rs2.getString("m002_name");//�m�W
		m002pno=rs2.getString("m002_pno");//¾��
		m023sname=rs2.getString("m023_sname");//¾�ȦW��
}

rs2.close();rs2=null;
stmt2.close();
conn.close();

%>

<script language="javascript">	
	parent.document.getElementById('<%=Field%>').value="¾��:"+'<%=m002pno%>'+":"+"¾�ȦW��:"+'<%=m023sname%>';
 </script>

<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String m002No="",m002Name="",OP="",SqlStr="";
String m035_no="",m035_name="",m035_idno="";
String UID=req("UID",request);
String UIDD = UID.toUpperCase();

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

SqlStr="select m035_no,m035_name,m035_idno from  manf035 where  manf035.m035_no='"+UIDD+"'";   

ResultSet rs=stmt.executeQuery(SqlStr);

if(!rs.next())
{
%>
	<script language="javascript">
		alert('�d�L���M�d�H���s��!!')		
	</script>
<%	
}
else
{
	m035_no=rs.getString("m035_no").trim();//�d��
	m035_name=rs.getString("m035_name").trim();//�m�W
	m035_idno=rs.getString("m035_idno");//�����Ҹ��X
	
	
}
rs.close();
rs=null;
stmt.close();
conn.close();
%>

<script language="javascript">	
	parent.document.getElementById('no').value='<%=m035_no%>'+':'+'<%=m035_name%>'+":�M�d:"+'<%=m035_idno%>';
	
  parent.CheckOk();
</script>

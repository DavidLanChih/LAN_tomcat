<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String m002No="",m002Name="",OP="",SqlStr="";
String m035No="",m035Name="",m035_SName="",sc1="";
String UID=req("UID",request);
String UIDD = UID.toUpperCase();

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

SqlStr="select m035_no,m035_name,m035_adate from  manf035 where  manf035.m035_no='"+UIDD+"'";   
	
ResultSet rs=stmt.executeQuery(SqlStr);

if(!rs.next())
{
%>
	<script language="javascript">
		alert('�d�L���M�d�H����d�s��')		
	</script>
<%	
}
else
{
	m035No=rs.getString("m035_no");//�d��
	m035Name=rs.getString("m035_name");//�m�W
	sc1=rs.getDate("m035_adate").toString().replaceAll("-","/") ;//��¾���

}
rs.close();
rs=null;
stmt.close();
conn.close();
%>

<script language="javascript">	
	parent.document.getElementById('no').value='<%=m035No%>'+';�m�W:'+'<%=m035Name%>'+';��¾��:'+'<%=sc1%>';
	parent.CheckOk();
</script>

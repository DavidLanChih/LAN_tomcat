<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String m002No="",m002Name="",OP="",SqlStr="",SqlStr2="";
String m035No="",m035Name="",m035Blane="";
String UID=req("UID",request);
String UIDD = UID.toUpperCase();

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

if (UIDD.length()==5)
{
	SqlStr="select p014_venno as venno,p014_sname as sname,p014_blane as blane from cy@chyusc1:purf014 where length(p014_venno)=5  and p014_venno = '"+UIDD+"'  union select p014_venno as venno,p014_sname as sname,p014_blane as blane from cy2@chyusc1:purf014 where length(p014_venno)=5  and p014_venno = '"+UIDD+"'  union  select p031_box as venno,p031_mark as sname,p031_blane as blane from   cy@chyusc1:purf031 where  length(p031_box)=5  and p031_box = '"+UIDD+"'  ";
	ResultSet rs=stmt.executeQuery(SqlStr);

	if(!rs.next())
	{
%>
	<script language="javascript">
		alert('查無此專櫃編號!!')		
	</script>
<%	
}
	else 
	{
			m035No=rs.getString("venno");
			m035Name=rs.getString("sname").trim();
			m035Blane=rs.getString("blane");
			
	}
	rs.close();
	rs=null;
	stmt.close();
	conn.close();
}
else
{
	%>
	<script language="javascript">
		alert('請輸入5碼櫃號!')		
	</script>
<%	
} 
%>

<script language="javascript">	
	parent.document.getElementById('no').value='<%=m035No%>'+':'+'<%=m035Name%>'+':'+'<%=m035Blane%>';
	
  parent.CheckOk();
</script>

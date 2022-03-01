<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",Kind="",dd="",abc="";
String m067_qty="";
String Field=req("Field",request);
String Field1=req("Field1",request);
String Field2=req("Field2",request);

String USID=req("USID",request);
String get_type=req("get_type",request);
String get_ym=req("get_ym",request);


Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select * from manf067 where  m067_no='"+USID+"' and m067_ym='"+get_ym+"'";


ResultSet rs=stmt.executeQuery(SqlStr);
if(!rs.next())
{
%>
	<script language="javascript">
		alert('查無此筆專櫃餐費資料!')		
  </script>
<%	
}
else
{
	m067_qty = rs.getString("m067_qty");
	
}
rs.close();
rs=null;
stmt.close();
conn.close();
%>

<script language="javascript">
	  parent.document.getElementById('<%=Field%>').value='<%=m067_qty%>';
		parent.document.getElementById('<%=Field1%>').value='0';
		parent.document.getElementById('<%=Field2%>').value='<%=m067_qty%>';
		
</script>
<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",SqlStr2="";
String Field = req("Field",request);
String Field1 = req("Field1",request);

String mw07yy = req("mw07yy",request);
String mw07mm = req("mw07mm",request);
String mw07dd = req("mw07dd",request);
String mw07no = req("mw07no",request);




Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

SqlStr="select * from  manfs07 where ms07_condition='N' and ms07_no='"+mw07no+"' and year(ms07_ymd1)='"+mw07yy+"' and month(ms07_ymd1)='"+mw07mm+"' and day(ms07_ymd1) = '"+mw07dd+"' ";   

	
ResultSet rs=stmt.executeQuery(SqlStr);



if(rs.next())
{
	%>
	<script language="javascript">
		
		alert('4.申請人員中的代理人當日有請假記錄!');		
	
	</script>
<%
		
 
}
rs.close();
rs=null;
stmt.close();
conn.close();
%>

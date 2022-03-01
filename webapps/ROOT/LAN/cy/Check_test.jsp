<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
leeten.Date JDate=new leeten.Date();
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
NoCatch(response);
request.setCharacterEncoding("big5");


int a = 1;
int b;
if(a == 1)
{
	b=a+1;	
	out.println(b);
}


Statement stmt = conn.createStatement();
String SqlStr="SELECT CONVERT(varchar(100), GETDATE(), 0) "; 
out.println(SqlStr);


stmt.close();

%>

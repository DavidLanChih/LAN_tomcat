<%@ include file="/kernel.jsp" %><%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page contentType="text/html;charset=MS950" %>
<%
//-----------此語法適用JAVA不能用JSP----------------

String A="";

Optional op = Optional.of(9455); 
if(op.isPresent())
{
	out.print("A有值");
}
%>
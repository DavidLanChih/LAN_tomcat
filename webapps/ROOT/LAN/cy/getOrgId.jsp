<%@page import="leeten.*" %><%@page contentType="text/xml; charset=big5"%><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %>
<%@ page pageEncoding="big5"%><%
ResultSet Rs=null;
String Content="",SqlStr="";
String UID=req("UID",request);
SqlStr="select top 1 * from Org where UD_ID='"+UID+"'";
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{        
    Content=Rs.getString("OrgId");
System.out.println("C->"+Content);
}
Rs.close();Rs=null;
NoCatch(response);
out.println(Content);%>
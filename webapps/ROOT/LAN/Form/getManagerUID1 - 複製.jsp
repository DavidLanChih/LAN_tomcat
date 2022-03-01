<%@page import="leeten.*" %><%@page contentType="text/xml; charset=big5"%><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %><%@ page pageEncoding="big5"%><%
ResultSet Rs=null;
String Content="",SqlStr="";
String J_OrgId=req("J_OrgId",request);

leeten.Org JOrg=new leeten.Org(Data,Conn);
Rs=JOrg.getMainDepartmentMangerInfoByUser(J_OrgId);
if(Rs.next())
{        
	Content=Rs.getString("UD_ID").substring(2)+" ";
}

Rs.close();Rs=null;
out.print(Content);%>
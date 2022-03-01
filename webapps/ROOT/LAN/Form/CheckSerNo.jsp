<%@page import="leeten.*" %><%@page contentType="text/xml; charset=big5"%><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %><%@ page pageEncoding="big5"%><%@ page import="java.util.Date" %><%
ResultSet Rs=null;
String SqlStr="";
String UID=req("UID",request);
SqlStr="select * from  flow_formdata  where FD_FormId='98' and  FD_Data4='"+UID+"' "; 
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
%>
	<script language="javascript">
		alert('此筆單號已存在，請輸入新的單號!')	
	</script>
<%	
}
Rs.close();Rs=null;
NoCatch(response);
%>
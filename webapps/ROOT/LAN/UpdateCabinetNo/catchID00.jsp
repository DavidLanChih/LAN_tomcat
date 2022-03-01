<%@page import="leeten.*" %>
<%@page contentType="text/xml; charset=big5" %>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat" %>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/APP3.0-TC.jsp" %>
<%@ page import="java.io.*"%>
<%
String SqlStr="",FF_Name="";
int count=0;
ResultSet MRs=null;
SqlStr="select * from flow_forminfo where FI_ID='JFlow_Form_279' order by FI_RecID DESC limit 1";   //抓取JFlow_Form_279最新的模組ID
MRs=Data.getSmt(Conn,SqlStr);
if(MRs.next())
{
	count++;
	FF_Name=MRs.getString("FI_RecId");
	out.print(FF_Name);	
}
out.print(count);
MRs.close();
%>
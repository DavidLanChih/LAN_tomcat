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
String SqlStr="",FI_RecId="",F1="";
int count=0;
ResultSet DRs=null;
SqlStr="select * from flow_forminfo where FI_ID='JFlow_Form_279' order by FI_RecID DESC limit 1";   //抓取JFlow_Form_279最新的模組ID
DRs=Data.getSmt(Conn,SqlStr);
if(DRs.next())
{
	count++;
	FI_RecId=DRs.getString("FI_RecId");
	out.print(FI_RecId+"<br>");	
}
out.print(count+"<br>");


SqlStr="select * from flow_formfieldinfo where FF_FormRecId='"+FI_RecId+"'";   //抓取最新的欄位名稱
DRs=Data.getSmt(Conn,SqlStr);
if(DRs.next())
{

	
	F1=DRs.getString("FF_F1_Name");
	
	out.print(F1+"<br>");	
}

DRs.close();

%>
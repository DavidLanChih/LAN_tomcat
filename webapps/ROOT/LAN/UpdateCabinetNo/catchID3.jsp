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
String SqlStr="",FI_RecId="",FI_FieldCount="",F1="";
int count=0, FieldCount=0;
ResultSet DRs=null;


//------------------抓取JFlow_Form_279最新的模組ID的總欄位數-----------------
SqlStr="select * from flow_forminfo where FI_ID='JFlow_Form_279' order by FI_RecID DESC limit 1";   
DRs=Data.getSmt(Conn,SqlStr);
if(DRs.next())
{
	FI_FieldCount=DRs.getString("FI_FieldCount");
}
DRs.close();
out.print(FI_FieldCount+"<br>");


//-------(抓取欄位總數-非供應商欄位數)/(一組櫃號的欄位數)=櫃號轉移組數-------
FieldCount=Integer.parseInt(FI_FieldCount);
out.print((FieldCount-12)/2+"<br>");                          //(16-12)/2=2組                                         
%>
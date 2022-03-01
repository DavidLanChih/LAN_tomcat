<%@ include file="/kernel.jsp" %>
<%@ include file="/cykernel.jsp" %>
<%@page import="java.sql.*,java.util.*" %>

<%@page import="leeten.*" %>
<%@page contentType="text/xml; charset=big5"%>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %>
<%@ page pageEncoding="big5"%><%
<%

ResultSet Rs=null;

String OP="",SqlStr="",Content="",Content1="";
String Field1=req("Field1",request);//remark1
String Field2=req("Field2",request);//remark1
Statement stmt = conn.createStatement();
SqlStr="select w002_date,w002_hour_m007 from manfw02 ";
Rs=stmt.executeQuery(SqlStr);
while(Rs.next())
{ 
	//請假特休最小時數開放
	if(!Rs.getString("w002_hour_m007").trim().equals("2.0"))
	{
		Content+=Rs.getString("w002_date").trim()+",";
		Content1+=Rs.getString("w002_hour_m007").trim()+",";
	}
}
if(!Content.equals("")) Content=Content.substring(0,Content.length()-1);
if(!Content1.equals("")) Content1=Content1.substring(0,Content1.length()-1);
Rs.close();Rs=null;
conn.close();
out.print(Content);%>




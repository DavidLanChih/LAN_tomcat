<%@ include file="/kernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String Dept=UI.req("WhereValue").trim();
String OP="",SqlStr="";
//UI.Start();
%>
<html>
<head><META HTTP-EQUIV='expires' CONTENT='-1'><META HTTP-EQUIV='pragma' CONTENT='no-cache'><meta http-equiv="Content-Type" content="text/html; charset=big5"><LINK REL="SHORTCUT ICON" HREF="/images/favicon.ico"><link rel="stylesheet" href="/Modules/JEIPKernel/lion.css" type="text/css"><link rel='STYLESHEET' type='text/css' href='/Template/default/style.css'><link rel='STYLESHEET' type='text/css' href='/Template/default/style1.css'>
<script language="javascript" src="/Modules/JEIPKernel/lion.js"></script><script language="javascript" src="/Modules/JEIPKernel/prototype.js"></script><title>JEIP 企業資訊入口平台</title></head><body bgcolor="#ffffff" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">

<%
try
{

Class.forName("sun.jdbc.odbc.JdbcOdbcDriver"); 
//Class.forName("com.informix.jdbc.IfxDriver");
Connection conn=DriverManager.getConnection("jdbc:odbc:InformixTest;UID=ftpguest;PWD=2253456");
//Connection conn=DriverManager.getConnection("jdbc:informix-sqli://1.0.0.5:1603/cy:informixserver=chyutest;DB_LOCALE=zh_tw.big5;CLIENT_LOCALE=zh_tw.big5;SERVER_LOCALE=zh_tw.big5;", "ftpguest", "2253456");
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=stmt.executeQuery("select manf003.m003_no from manf003,manf002 where manf002.m002_dept='C2020' and manf003.m003_umark='*' and manf002.m002_no= manf003.m003_no group by manf003.m003_no ");
System.out.println("JDBC driver name: " + conn.getMetaData().getDriverName());
    while (rs.next())
    {
	out.println(rs.getString("manf003.m003_no")+":"+"<br>");
     }
     rs.close();
}
catch (ClassNotFoundException ce)
{
       out.println("Class Not Found!!");
}
catch(Exception sqlEx)
{
out.println("Error msg: " + sqlEx.getMessage());

}
%>

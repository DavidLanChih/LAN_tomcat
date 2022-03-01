<%@ include file="/kernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
ResultSet Rs1=null;
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="";
String OP1="",SqlStr1="";
String UID=UI.req("WhereValue").trim();
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
SqlStr1="select m019_brk_kind from manf019 where m019_brk_kind matches '*C*' ";
ResultSet rs1=stmt.executeQuery(SqlStr1);
System.out.println("JDBC driver name: " + conn.getMetaData().getDriverName());
    while (rs1.next())
    {
	out.println(rs1.getString("m019_brk_kind"));
        String Result=rs1.getString("m019_brk_kind");
    }
    rs1.close();
    out.println("<br>");
SqlStr="select manf019.m019_brk_kind,manf019.m019_code,manf019.m019_name,manf019.m019_hh1,manf019.m019_mm1,manf019.m019_hh2,manf019.m019_mm2 from manf003,manf019 where manf003.m003_no='"+UID+"' and manf019.m019_brk_kind matches '*'||manf003.m003_brk_kind||'*' and manf019.m019_type is null group by manf019.m019_brk_kind,manf019.m019_code,manf019.m019_name,manf019.m019_hh1,manf019.m019_mm1,manf019.m019_hh2,manf019.m019_mm2   order by manf019.m019_code ";
ResultSet rs=stmt.executeQuery(SqlStr);
System.out.println("JDBC driver name: " + conn.getMetaData().getDriverName());
    while (rs.next())
    {	
	out.println(rs.getString("m019_brk_kind")+":"+rs.getString("m019_code")+":"+rs.getString("m019_name")+"<br>");
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

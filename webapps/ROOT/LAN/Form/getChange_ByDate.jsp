<%@ include file="/kernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="";
String Data1=UI.req("WhereValue").trim();
String Field=UI.req("Field");
String F_Type=UI.req("FF_Type");

String DataArr[]=Data1.split(":");
String UID=DataArr[0];

String Year=String.valueOf(Integer.parseInt(DataArr[1].split("/")[0])-1911);
String Month=DataArr[1].split("/")[1];
if(Month.length()==1) Month="0"+Month;

String Day=DataArr[1].split("/")[2];
if(Day.length()==1) Day="0"+Day;

out.println(UID+":"+Year+":"+Month+":"+Day);
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
SqlStr="select m013_dd"+Day+",m019_code,m019_name,m019_hh1,m019_mm1,m019_hh2,m019_mm2 from manf013,manf019 where   m013_yy   = '"+Year+"' and   m013_mm   ='"+Month+"' and   m013_no   = '"+UID+"'  and   m013_chk_date is not null and m019_code =m013_dd"+Day+" and m019_type is null";
out.println(SqlStr);
ResultSet rs=stmt.executeQuery(SqlStr);
%>
<script language="javascript">      
        parent.document.getElementById('<%=Field%>').options.length=0;       


<%
if(!rs.next())
{
%>
        var o = parent.document.createElement("OPTION");
        parent.document.getElementById('<%=Field%>').options.add(o);                   	
        o.value = "";
        o.text = "";             
<%
}
else
{
rs.beforeFirst();
while(rs.next())
{
%>    
        var o = parent.document.createElement("OPTION");
        parent.document.getElementById('<%=Field%>').options.add(o);                   	
        o.value = "<%=rs.getString("m013_dd"+Day)%>";
        o.text = "<%=rs.getString("m013_dd"+Day)+":"+rs.getString("m019_name").trim()+"("+rs.getString("m019_hh1")+":"+(rs.getString("m019_mm1").length()==1?"0":"")+rs.getString("m019_mm1")+"~"+rs.getString("m019_hh2")+":"+(rs.getString("m019_mm2").length()==1?"0":"")+rs.getString("m019_mm2")+")"%>";             
<% 
}    



rs.close();rs=null;

}
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
parent.getSelectData('<%=Field.substring(4)%>','<%=Field%>');

</script>
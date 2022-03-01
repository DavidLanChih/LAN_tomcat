<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
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
out.println(UID);
//UI.Start();
%>
<html>
<head><META HTTP-EQUIV='expires' CONTENT='-1'><META HTTP-EQUIV='pragma' CONTENT='no-cache'><meta http-equiv="Content-Type" content="text/html; charset=big5"><LINK REL="SHORTCUT ICON" HREF="/images/favicon.ico"><link rel="stylesheet" href="/Modules/JEIPKernel/lion.css" type="text/css"><link rel='STYLESHEET' type='text/css' href='/Template/default/style.css'><link rel='STYLESHEET' type='text/css' href='/Template/default/style1.css'>
<script language="javascript" src="/Modules/JEIPKernel/lion.js"></script><script language="javascript" src="/Modules/JEIPKernel/prototype.js"></script><title>JEIP 企業資訊入口平台</title></head><body bgcolor="#ffffff" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">

<%
try
{
	
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

SqlStr="select m002_no,m002_name from manf002 where (m002_dept = ( select m002_dept from manf002 where m002_no ='"+UID+"')) and (m002_ddate is null or m002_ddate >=today-60)";
out.println(SqlStr);
ResultSet rs=stmt.executeQuery(SqlStr);
%>
<script language="javascript">      
        parent.document.getElementById('<%=Field%>').options.length=0;
        var o = parent.document.createElement("OPTION");
        parent.document.getElementById('<%=Field%>').options.add(o);                   
        o.value = "";        
        o.text = "請選擇...";
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
				o.value = "<%=rs.getString("m002_no").trim()%>";
				o.text = "<%=rs.getString("m002_no")+" "+rs.getString("m002_name").trim()%>";             
		<% 
		}    





	}
}
catch(Exception sqlEx)
{
	out.println("Error msg: " + sqlEx.getMessage());
}
rs.close();rs=null;
stmt.close();
conn.close();
%>
parent.getSelectData('<%=Field.substring(4)%>','<%=Field%>');

</script>
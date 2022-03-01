<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="";
String UID=UI.req("WhereValue").trim();
String Field=UI.req("Field");
String F_Type=UI.req("FF_Type");
//UI.Start();
%>
<html>
<head><META HTTP-EQUIV='expires' CONTENT='-1'><META HTTP-EQUIV='pragma' CONTENT='no-cache'><meta http-equiv="Content-Type" content="text/html; charset=big5"><LINK REL="SHORTCUT ICON" HREF="/images/favicon.ico"><link rel="stylesheet" href="/Modules/JEIPKernel/lion.css" type="text/css"><link rel='STYLESHEET' type='text/css' href='/Template/default/style.css'><link rel='STYLESHEET' type='text/css' href='/Template/default/style1.css'>
<script language="javascript" src="/Modules/JEIPKernel/lion.js"></script><script language="javascript" src="/Modules/JEIPKernel/prototype.js"></script><title>JEIP 企業資訊入口平台</title></head><body bgcolor="#ffffff" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">

<%
try
{


Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select manf019.m019_brk_kind,manf019.m019_code,manf019.m019_name,manf019.m019_hh1,manf019.m019_mm1,manf019.m019_hh2,manf019.m019_mm2 from manf003,manf019 where manf003.m003_no='"+UID+"' and manf019.m019_brk_kind matches '*'||manf003.m003_brk_kind||'*'  and manf019.m019_type is null group by manf019.m019_brk_kind,manf019.m019_code,manf019.m019_name,manf019.m019_hh1,manf019.m019_mm1,manf019.m019_hh2,manf019.m019_mm2   order by manf019.m019_code ";
//System.out.println("Informix "+SqlStr);
ResultSet rs=stmt.executeQuery(SqlStr);
%>
<script language="javascript">      
        parent.document.getElementById('<%=Field%>').options.length=0;       
        var o = parent.document.createElement("OPTION");
        parent.document.getElementById('<%=Field%>').options.add(o);                   
        o.value = "";        
        o.text = "請選擇...";     
<%
	while(rs.next())
	{
	%>    
			var o = parent.document.createElement("OPTION");
			parent.document.getElementById('<%=Field%>').options.add(o);                   
			o.value = "<%=rs.getString("m019_code")%>";        
			o.text = "<%=rs.getString("m019_code")+":"+rs.getString("m019_name").trim()+"("+rs.getString("m019_hh1")+":"+(rs.getString("m019_mm1").length()==1?"0":"")+rs.getString("m019_mm1")+"~"+rs.getString("m019_hh2")+":"+(rs.getString("m019_mm2").length()==1?"0":"")+rs.getString("m019_mm2")+")"%>";
	<% 
	}    
}
catch(Exception sqlEx)
{
out.println("Error msg: " + sqlEx.getMessage());

}
rs.close();rs=null;
conn.close();
%>
parent.getSelectData('<%=Field.substring(4)%>','<%=Field%>');
</script>
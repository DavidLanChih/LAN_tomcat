<%@ include file="/cykernel.jsp" %><%@page import="leeten.*" %><%@page contentType="text/xml; charset=big5"%>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ page import="java.util.Date" %><%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %>
<%

ResultSet Rs=null;
String Content="",Content1="",SqlStr="",ss="";
String J_OrgId=req("J_OrgId",request);
String year="",month="",day="",Hours="";
String Field1=req("Field1",request);//remark1
String Field2=req("Field2",request);//remark1
int Hours1 =0;
leeten.Org JOrg=new leeten.Org(Data,Conn);
leeten.Date JDate=new leeten.Date();
String CurDate=JDate.format(new Date(),"yyyy/MM/dd/HH");
String CurDate1=JDate.format(new Date(),"yyyy/MM/dd");
Hours1=Integer.parseInt(CurDate.split("/")[3]);


Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
if(Hours1>=18)
{ss="m083_no_eve";}
else
{ss="m083_no_mor";}
SqlStr="select "+ss+" from manf083 where m083_date='"+CurDate1+"'";
Rs=stmt.executeQuery(SqlStr);
if(Rs.next())
{
	Content=Rs.getString(ss);
	
}
Rs.close();Rs=null;

SqlStr="select manf073.m073_dept,manf001.m001_dname,manf073.m073_boss,manf002.m002_name,manf073.m073_boss as Value from manf073,manf002,manf001 where manf073.m073_code in ('1') and manf073.m073_boss=manf002.m002_no and manf002.m002_dept=manf001.m001_dept and manf002.m002_no='"+Content+"'";
Rs=stmt.executeQuery(SqlStr);
if(Rs.next())
{ 
	Content1=Rs.getString("m073_boss")+","+Rs.getString("m073_dept")+Rs.getString("m001_dname")+":"+Rs.getString("m073_boss")+Rs.getString("m002_name").trim();
}
Rs.close();Rs=null;
conn.close();
out.print(Content);
%>
<script language="javascript">	
parent.document.getElementById('<%=Field1%>').value='<%=Content1%>';
parent.document.getElementById('<%=Field2%>').value='<%=Content%>';

 </script>
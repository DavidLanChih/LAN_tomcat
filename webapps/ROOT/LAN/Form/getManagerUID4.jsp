<%@ include file="/cykernel.jsp" %><%@page import="leeten.*" %><%@page contentType="text/xml; charset=big5"%><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%@ page import="java.util.Date" %><%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %><%

ResultSet Rs=null;
String Content="",SqlStr="",ss="";
String J_OrgId=req("J_OrgId",request);
String year="",month="",day="",Hours="";
int Hours1 =0;
leeten.Org JOrg=new leeten.Org(Data,Conn);
leeten.Date JDate=new leeten.Date();
String CurDate=JDate.format(new Date(),"yyyy/MM/dd/HH");
Hours1=Integer.parseInt(CurDate.split("/")[3]);


Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
if(Hours1>=18)
{ss="m083_no_eve";}
else
{ss="m083_no_mor";}
SqlStr="select "+ss+" from manf083";
Rs=stmt.executeQuery(SqlStr);
if(Rs.next())
{
	Content=Rs.getString(ss);
	//System.out.println("C->"+Content);
}
Rs.close();Rs=null;
conn.close();
NoCatch(response);

out.print(Content);%>

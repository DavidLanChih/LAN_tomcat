<%@page import="leeten.*" %><%@page contentType="text/xml; charset=big5"%><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %><%@ page pageEncoding="big5"%><%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
leeten.Date JDate=new leeten.Date();
String OP="",SqlStr="",FDId="";
//UI.Start();
%>
<html>
<head><META HTTP-EQUIV='expires' CONTENT='-1'><META HTTP-EQUIV='pragma' CONTENT='no-cache'><meta http-equiv="Content-Type" content="text/html; charset=big5"><LINK REL="SHORTCUT ICON" HREF="/images/favicon.ico"><link rel="stylesheet" href="/Modules/JEIPKernel/lion.css" type="text/css"><link rel='STYLESHEET' type='text/css' href='/Template/default/style.css'><link rel='STYLESHEET' type='text/css' href='/Template/default/style1.css'>
<script language="javascript" src="/Modules/JEIPKernel/lion.js"></script><script language="javascript" src="/Modules/JEIPKernel/prototype.js"></script><title>JEIP 企業資訊入口平台</title></head><body bgcolor="#ffffff" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<%
FDId=UI.req("FD_RecId");
SqlStr="select * from flow_formdata where FD_RecId="+FDId+" limit 1";
ResultSet DRs=Data.getSmt(Conn,SqlStr);
DRs.next();
try
{
Class.forName("com.informix.jdbc.IfxDriver");
Connection conn=DriverManager.getConnection("jdbc:informix-sqli://1.0.0.5:1603/cy:informixserver=chyutest;NEWLOACLE=zh_tw,en_us,zh_cn;NEWCODESET=Big5,GB2312-80,8859-1,819", "ftpguest", "2253456");
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
Statement stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
//mw07_ser_no:申請序號,如有多筆,則序號一致(六位數)
//mw07_no工號->申請人員代碼(四位數)
//mw07_code 假別->二碼
//mw07_ymd1 起始日yyyy/mm/dd  ,mw07_hh1時,mw07_mm1分
//mw07_ymd2 迄日yyyy/mm/dd  ,mw07_hh2時,mw07_mm2分
//mw07_kdate 建立日,mw07_remark申請原因
//,mw07_condition 狀態,申請

   
   for(int t=0;t<5;t++)
   {
          String Field1=String.valueOf((t*7)+1);	String Field2=String.valueOf((t*7)+2);
          String Field3=String.valueOf((t*7)+3);	String Field4=String.valueOf((t*7)+4);
          String Field5=String.valueOf((t*7)+5);	String Field6=String.valueOf((t*7)+6);
          String Field7=String.valueOf((t*7)+7);
          String ApplyUser=DRs.getString("FD_Data"+Field1);
         if(!ApplyUser.equals(""))
         {
	ApplyUser=DRs.getString("FD_Data"+Field1).split(",")[0].trim();
	String ChangType=DRs.getString("FD_Data"+Field2).split(",")[0].trim();
	String SDate=DRs.getString("FD_Data"+Field3);
	String Ben1=DRs.getString("FD_Data"+Field4).split(",")[0];

	String EDate=DRs.getString("FD_Data"+Field5);
	String Ben2=DRs.getString("FD_Data"+Field6).split(",")[0];

	String ApplyDate=JDate.ToDay();

	String Reson=DRs.getString("FD_Data"+Field7);
	String Survey1=DRs.getString("FD_Data36").split(",")[0].trim();
	String Survey2=DRs.getString("FD_Data37").split(",")[0].trim();
	String Survey3=DRs.getString("FD_Data38").split(",")[0].trim();
	String Survey4=DRs.getString("FD_Data39").split(",")[0].trim();
	String Survey5=DRs.getString("FD_Data40").split(",")[0].trim();

	SqlStr="select * from manfs11 order by ms11_billno desc";
	ResultSet rs=stmt1.executeQuery(SqlStr);
	rs.next();
	String BillNo=String.valueOf(rs.getInt("ms11_billno")+1);
	rs.close();

	SqlStr="insert into manfs11(ms11_ser_no,ms11_no,ms11_kind,ms11_ymd1,ms11_duty1,ms11_ymd2,ms11_duty2,";
	SqlStr+="ms11_kdate,ms11_remark,";
	SqlStr+="ms11_boss1,ms11_confirm1,ms11_boss2,ms11_confirm2,ms11_boss3,ms11_confirm3,ms11_keyin,ms11_billno) values (";
	SqlStr+=(t+1)+",'"+ApplyUser+"','"+ChangType+"','"+SDate+"','"+Ben1+"','"+EDate+"','"+Ben2+"','"+ApplyDate+"','"+Reson+"',";
	SqlStr+="'"+Survey1+"','Y','"+Survey2+"','Y','"+Survey3+"','Y','',"+BillNo+")";


	SqlStr   =   new   String(SqlStr.getBytes(),"ISO-8859-1");   	
	stmt.executeUpdate(SqlStr);
	//out.println(SqlStr);
	}
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
DRs.close();DRs=null;
%>

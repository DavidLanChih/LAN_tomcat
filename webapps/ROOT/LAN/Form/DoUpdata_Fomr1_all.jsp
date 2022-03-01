<%@page import="leeten.*" %><%@page contentType="text/xml; charset=big5"%><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %><%@ page pageEncoding="big5"%><%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
leeten.Date JDate=new leeten.Date();
String OP="",SqlStr="",FDId="";
int u=0;
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
          String Field1=String.valueOf((t*8)+1);	String Field2=String.valueOf((t*8)+2);
          String Field3=String.valueOf((t*8)+3);	String Field4=String.valueOf((t*8)+4);
          String Field5=String.valueOf((t*8)+5);	String Field6=String.valueOf((t*8)+6);
          String Field7=String.valueOf((t*8)+7);        String Field8=String.valueOf((t*8)+8);
          String ApplyUser=DRs.getString("FD_Data"+Field1);
         if(!ApplyUser.equals(""))
         {
               u++;
	ApplyUser=DRs.getString("FD_Data"+Field1).split(",")[0].trim();
	String HoldayType=DRs.getString("FD_Data"+Field2).split(",")[0].trim();

          	String SDate=DRs.getString("FD_Data"+Field3);
	String SDate_Arr[]=DRs.getString("FD_Data"+Field4).split(",")[0].split(":");
	String SDate_H=SDate_Arr[0];	
	String SDate_M=SDate_Arr[1];

          	String EDate=DRs.getString("FD_Data"+Field5);
	String EDate_Arr[]=DRs.getString("FD_Data"+Field6).split(",")[0].split(":");
	String EDate_H=EDate_Arr[0];	
	String EDate_M=EDate_Arr[1];
	String ApplyDate=JDate.ToDay();

	String Status=DRs.getString("FD_Data"+Field7).split(",")[0];

	String Reson=DRs.getString("FD_Data"+Field8);
	String Survey1=DRs.getString("FD_Data41").split(",")[0].trim();
	String Survey2=DRs.getString("FD_Data42").split(",")[0].trim();
	String Survey3=DRs.getString("FD_Data43").split(",")[0].trim();
	String Survey4=DRs.getString("FD_Data44").split(",")[0].trim();
	String Survey5=DRs.getString("FD_Data45").split(",")[0].trim();

	SqlStr="select * from manfw07 order by mw07_billno desc";
	ResultSet rs=stmt1.executeQuery(SqlStr);
	rs.next();
	String BillNo=String.valueOf(rs.getInt("mw07_billno")+1);
	rs.close();

	SqlStr="insert into manfw07(mw07_ser_no,mw07_no,mw07_code,mw07_ymd1,mw07_hh1,mw07_mm1,mw07_ymd2 ,mw07_hh2,mw07_mm2,";
	SqlStr+="mw07_kdate,mw07_remark,mw07_condition,";
	SqlStr+="mw07_boss1,mw07_confirm1,mw07_boss2,mw07_confirm2,mw07_boss3,mw07_confirm3,mw07_billno) values (";
	SqlStr+=(u)+",'"+ApplyUser+"','"+HoldayType+"','"+SDate+"',"+SDate_H+","+SDate_M+",'"+EDate+"',"+EDate_H+","+EDate_M+",'"+ApplyDate+"','"+Reson+"','"+Status+"',";
	SqlStr+="'"+Survey1+"','Y','"+Survey2+"','Y','"+Survey3+"','Y',"+BillNo+")";
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

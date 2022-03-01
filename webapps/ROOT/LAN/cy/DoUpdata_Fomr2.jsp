<%@page import="leeten.*" %><%@ include file="/cykernel.jsp" %><%@page contentType="text/xml; charset=big5"%><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %><%@ page pageEncoding="big5"%><%
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
ResultSet DRs=null;
try
{
SqlStr="select * from flow_formdata where FD_RecId="+FDId+" limit 1";
DRs=Data.getSmt(Conn,SqlStr);
DRs.next();

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
			ApplyUser=DRs.getString("FD_Data"+Field1).split(",")[0].trim();
			String CDate=DRs.getString("FD_Data"+Field2);
			String STime=DRs.getString("FD_Data"+Field3).split(",")[0].trim();
			String STimeArr[]=STime.split(":");
			String ETime=DRs.getString("FD_Data"+Field4).split(",")[0].trim();
			String ETimeArr[]=ETime.split(":");
			String AHour=DRs.getString("FD_Data"+Field5);
			String EatCount=DRs.getString("FD_Data"+Field6).split(",")[0].trim();
			String ChangNo=DRs.getString("FD_Data"+Field7).split(",")[0].trim();

			String AddTime="0.0",ChangTime="0.0";
			if(ChangNo.equals("1")) ChangTime=AHour;
			else AddTime=AHour;

			String ApplyDate=JDate.ToDay();

			String Reson=DRs.getString("FD_Data"+Field8);
			String Survey1=DRs.getString("FD_Data41").split(",")[0].trim();
			String Survey2=DRs.getString("FD_Data42").split(",")[0].trim();
			String Survey3=DRs.getString("FD_Data43").split(",")[0].trim();
			String Survey4=DRs.getString("FD_Data44").split(",")[0].trim();
			String Survey5=DRs.getString("FD_Data45").split(",")[0].trim();

			SqlStr="select * from manfs12 order by ms12_billno desc";
			ResultSet rs=stmt1.executeQuery(SqlStr);
			rs.next();
			String BillNo=String.valueOf(rs.getInt("ms12_billno")+1);
			rs.close();

			SqlStr="insert into manfs12(ms12_ser_no,ms12_no,ms12_ymd,ms12_hh1,ms12_mm1,ms12_hh2,ms12_mm2,";
			SqlStr+="ms12_kdate,ms12_tot,ms12_tot1,ms12_eat,ms12_kind,ms12_remark,ms12_condition,";
			SqlStr+="ms12_boss1,ms12_confirm1,ms12_boss2,ms12_confirm2,ms12_boss3,ms12_confirm3,ms12_keyin,ms12_billno) values (";
			SqlStr+=(t+1)+",'"+ApplyUser+"','"+CDate+"',"+STimeArr[0]+","+STimeArr[1]+","+ETimeArr[0]+","+ETimeArr[1]+",";
			SqlStr+="'"+ApplyDate+"',"+AddTime+","+ChangTime+","+EatCount+",'"+ChangNo+"','"+Reson+"',N,";
			SqlStr+="'"+Survey1+"','Y','"+Survey2+"','Y','"+Survey3+"','Y','',"+BillNo+")";

			SqlStr   =   new   String(SqlStr.getBytes(),"ISO-8859-1");   	
			stmt.executeUpdate(SqlStr);
			SqlStr="update flow_form_rulestage set BillNo='"+BillNo+"' where FR_DataId="+FDId;
			Data.ExecUpdateSql(Conn,SqlStr);
			out.println("OK<br>"+SqlStr);
		}
    }  
   
}
catch(Exception sqlEx)
{
    HttpCore HttpCore=new leeten.HttpCore(pageContext,Data,Conn);
    leeten.FileManager FileMgr=new leeten.FileManager();
    String To="",From="";       
    From="cy4737@mail2.chungyo.com.tw"; //寄件者
    To="cy4737@mail2.chungyo.com.tw##";  //收件者,多人用##區分
    String PortalTitle="表單錯誤回報";  //主旨
    String FormName="請假單2";

    HttpCore.SendMail(From,To,PortalTitle+"-"+FormName,"FormId->"+FDId+"<br><br>"+sqlEx.getMessage()); 
    out.println("Send Mail");
}
DRs=null; DRs.close();
conn.close();
%>

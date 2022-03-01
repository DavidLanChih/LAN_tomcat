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
SqlStr="select flow_formdata.*,flow_form_rulestage.FR_FinishTime from flow_formdata,flow_form_rulestage where flow_formdata.FD_RecId="+FDId+" and flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId limit 1";
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
//mw07_condition 狀態,申請

   
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
			if(!Survey4.equals(""))//080801修改。寫入informix DB時，將第四關主管往前移，捨棄第一關。
			{
				Survey1=Survey2;
				Survey2=Survey3;
				Survey3=Survey4;
				if(!Survey5.equals(""))//080801修改。寫入informix DB時，將第四、五關主管往前移，捨棄第一、二關。
				{
					Survey1=Survey2;
					Survey2=Survey3;
					Survey3=Survey5;
				}
			}

			SqlStr="select * from manfs11 order by ms11_billno desc";
			ResultSet rs=stmt1.executeQuery(SqlStr);
			rs.next();
			String BillNo=String.valueOf(rs.getInt("ms11_billno")+1);
			rs.close();

			SqlStr="insert into manfs11(ms11_ser_no,ms11_no,ms11_kind,ms11_ymd1,ms11_duty1,ms11_ymd2,ms11_duty2,";
			SqlStr+="ms11_kdate,ms11_remark,";
			SqlStr+="ms11_boss1,ms11_confirm1,ms11_boss2,ms11_confirm2,ms11_boss3,ms11_confirm3,ms11_keyin,ms11_billno,ms11_boss_billno,ms11_boss_date,ms11_boss_time) values (";
			SqlStr+=(t+1)+",'"+ApplyUser+"','"+ChangType+"','"+SDate+"','"+Ben1+"','"+EDate+"','"+Ben2+"','"+ApplyDate+"','"+Reson+"',";
			SqlStr+="'"+Survey1+"','Y','"+Survey2+"','Y','"+Survey3+"','Y','',"+BillNo+","+FDId+",'"+DRs.getDate("FR_FinishTime").toString().replaceAll("-","/")+"','"+DRs.getTime("FR_FinishTime")+"')";


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
    String FormName="請假單3";

    HttpCore.SendMail(From,To,PortalTitle+"-"+FormName,"FormId->"+FDId+"<br><br>"+sqlEx.getMessage()); 
    out.println("Send Mail");
}
DRs=null;DRs.close();
conn.close();
%>

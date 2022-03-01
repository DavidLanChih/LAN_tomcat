<%@page import="leeten.*" %><%@page import="java.sql.*" %><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%@ include file="Form_Config.jsp" %> 
<%
String SqlStr="",OP="";
String FR_RecId="",FI_RecId="",FD_RecId="";
int FormFieldCount=0;
ResultSet Rs=null,DataRs=null;
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
NoCatch(response);

OP=req("OP",request);
FI_RecId=Data.toSql(JForm_ID);
FR_RecId=Data.toSql(req("FR_RecId",request));

/*
SqlStr="select flow_form_rulestage.FR_DataId,flow_forminfo.FI_FieldCount from flow_form_rulestage,flow_forminfo where flow_form_rulestage.FR_RecId="+FR_RecId+" and flow_form_rulestage.FR_FormId=flow_forminfo.FI_RecId limit 1";
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
    FD_RecId=Rs.getString("FR_DataId");
    FormFieldCount=Rs.getInt("FI_FieldCount");
}
Rs.close();Rs=null;

SqlStr="select * from flow_formdata where FD_RecId="+FD_RecId+" and FI_RecId+"+FI_RecId+" limit 1";
DataRs=Data.getSmt(Conn,SqlStr);
DataRs.next();

 
 
DataRs.close();DataRs=null;   
*/
closeConn(Data,Conn);
%>
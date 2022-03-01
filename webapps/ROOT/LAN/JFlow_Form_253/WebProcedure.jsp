<%@page import="leeten.*" %><%@page import="java.sql.*" %><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%@ page contentType="text/html;charset=MS950" %><%@ include file="Form_Config.jsp" %><%
String SqlStr="",OP="";
String RetValue="",FI_RecId="",FD_RecId="";
String FD_DeptId="",FD_OrgId="";
ResultSet Rs=null;
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
NoCatch(response);
OP=req("OP",request);
FI_RecId=Data.toSql(JForm_ID);
FD_RecId=Data.toSql(req("FD_RecId",request));
if(isPost(request))
{    
    /*
    SqlStr="select * from flow_formdata where FD_RecId="+Data.toSql(FD_RecId)+" and FD_FormId="+FI_RecId+" limit 1";
    Rs=Data.getSmt(Conn,SqlStr);
    if(Rs.next())
    {
        FD_DeptId=Rs.getString("FD_DeptId");  //申請者部門
        FD_OrgId=Rs.getString("FD_OrgId");   //申請者
        RetValue=  //回傳資料
    }
    Rs.close();Rs=null;
    */
}    
closeConn(Data,Conn);
out.clear();response.reset();
response.setContentType("text/plain");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Charset",Portal_Encode);
out.println(RetValue);
%>
<%@ page pageEncoding="MS950"%><%@page import="leeten.*,java.sql.*,java.util.*" %><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Tool.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%
response.setCharacterEncoding(Portal_Encode);
request.setCharacterEncoding(Portal_Encode);
response.setContentType("text/html;charset=big5");
String J_ID="",J_OrgId="",J_Department="",J_UD_Id="";
String Separator=java.io.File.separator; 
String SysRootPath=application.getRealPath("/");
String SysTmpPath=application.getRealPath("/") + "temp"+Separator; 
String SysStorage=application.getInitParameter("Storage")+Separator;
String SysPicPath=SysStorage+"Pic"+Separator;
String SysCurrModuleId=getCurrModuleId(request);
String thisModuleId=SysCurrModuleId;
String SysFilePath=SysRootPath+"Modules"+Separator+"JICon"+Separator+"files"+Separator;
ResultSet SysRs=null;
String PortalModuleLink=request.getScheme()+"://"+request.getHeader("Host")+"/?ModuleId="+SysCurrModuleId;
String PortalLink=request.getScheme()+"://"+request.getHeader("Host");
leeten.Core SysCore=new leeten.Core(pageContext,Data,Conn);
J_ID=SysCore.getSession("J_Id"); 
J_OrgId=SysCore.getSession("J_OrgId");
J_Department=SysCore.getSession("J_Department");
J_UD_Id=SysCore.getSession("J_UD_Id");
if(J_OrgId.equals(""))
{
    response.sendRedirect("/logout.jsp");
    return;
} 
leeten.ACL SysACL=new leeten.ACL(pageContext,Data,Conn);   
leeten.Module SysModule=new leeten.Module(pageContext,Data,Conn);
if(!SysCurrModuleId.equals("") && !SysCurrModuleId.equals("ArmorForLion") && !SysCurrModuleId.equals("JEIPKernel") && !SysCurrModuleId.equals("JPortalMenuMap"))
{
    CheckACL(SysCurrModuleId,J_OrgId,SysModule,request,response);
}
%>
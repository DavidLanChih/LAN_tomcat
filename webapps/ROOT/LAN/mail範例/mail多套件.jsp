<%@page import="leeten.*" %>
<%@ include file="/cykernel.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@page contentType="text/xml; charset=big5"%>
<%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page pageEncoding="big5"%><%





NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
leeten.Date JDate=new leeten.Date();
String OP="",SqlStr="",SqlStr2="",FDId="",Sql_FD="";
String BillNo="",FD_Dept="",FD_DeptNo="",FD_DeptNo1="",MoneyAmount="";
int u=0;
int M065_qty=0;
int FCount=0,ICount=0;
//UI.Start();

%>
<html>
<head><META HTTP-EQUIV='expires' CONTENT='-1'><META HTTP-EQUIV='pragma' CONTENT='no-cache'><meta http-equiv="Content-Type" content="text/html; charset=big5"><LINK REL="SHORTCUT ICON" HREF="/images/favicon.ico"><link rel="stylesheet" href="/Modules/JEIPKernel/lion.css" type="text/css"><link rel='STYLESHEET' type='text/css' href='/Template/default/style.css'><link rel='STYLESHEET' type='text/css' href='/Template/default/style1.css'>
<script language="javascript" src="/Modules/JEIPKernel/lion.js"></script><script language="javascript" src="/Modules/JEIPKernel/prototype.js"></script><title>JEIP 企業資訊入口平台</title></head><body bgcolor="#ffffff" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<%

try
{
      int i = 1;
      i = i / 0;
      out.println("The answer is " + i);
 
 }
catch(Exception sqlEx)
{
		

Properties props=new Properties();
props.put("mail2.chungyo.com.tw","25");
Session s=Session.getInstance(props);
s.setDebug(true);

MimeMessage message=new MimeMessage(s);

//給消息對像設置發件人/收件人/主題/發信時間
InternetAddress from=new InternetAddress(From);//寄件者
message.setFrom(from);
InternetAddress to=new InternetAddress(To);//收件者,多人用##區分
message.setRecipient(Message.RecipientType.TO,to);
message.setSubject(PortalTitle);//主旨


//給消息對像設置內容
BodyPart mdp=new MimeBodyPart();//新建一個存放信件內容的BodyPart對像
mdp.setContent(FormName,"text/html;charset=big5");//給BodyPart對像設置內容和格式/編碼方式
Multipart mm=new MimeMultipart();//新建一個MimeMultipart對像用來存放BodyPart對象(事實上可以存放多個)
mm.addBodyPart(mdp);//將BodyPart加入到MimeMultipart對像中(可以加入多個BodyPart)
message.setContent(mm);//把mm作為消息對象的內容

message.saveChanges();
Transport transport=s.getTransport("smtp");
transport.connect("172.16.1.201","xxf","coffee");
transport.sendMessage(message,message.getAllRecipients());
transport.close();
		
		
		
    //HttpCore HttpCore=new leeten.HttpCore(pageContext,Data,Conn);
    //leeten.FileManager FileMgr=new leeten.FileManager();
    //String To="",From="";       
    //From="cy6213@mail2.chungyo.com.tw"; //寄件者
    //To="cy6213@mail2.chungyo.com.tw";  //收件者,多人用##區分
    //String PortalTitle="表單錯誤回報";  //主旨
    //String FormName="專櫃新進人員用品申請單-JFlow_Form_103";

    //HttpCore.SendMail(From,To,PortalTitle+"-"+FormName,"FormId->"+FDId+"<br><br>"+sqlEx.getMessage()); 
    out.println("send mail");
}
%>
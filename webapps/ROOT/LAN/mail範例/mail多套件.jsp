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
<script language="javascript" src="/Modules/JEIPKernel/lion.js"></script><script language="javascript" src="/Modules/JEIPKernel/prototype.js"></script><title>JEIP ���~��T�J�f���x</title></head><body bgcolor="#ffffff" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
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

//�������ﹳ�]�m�o��H/����H/�D�D/�o�H�ɶ�
InternetAddress from=new InternetAddress(From);//�H���
message.setFrom(from);
InternetAddress to=new InternetAddress(To);//�����,�h�H��##�Ϥ�
message.setRecipient(Message.RecipientType.TO,to);
message.setSubject(PortalTitle);//�D��


//�������ﹳ�]�m���e
BodyPart mdp=new MimeBodyPart();//�s�ؤ@�Ӧs��H�󤺮e��BodyPart�ﹳ
mdp.setContent(FormName,"text/html;charset=big5");//��BodyPart�ﹳ�]�m���e�M�榡/�s�X�覡
Multipart mm=new MimeMultipart();//�s�ؤ@��MimeMultipart�ﹳ�ΨӦs��BodyPart��H(�ƹ�W�i�H�s��h��)
mm.addBodyPart(mdp);//�NBodyPart�[�J��MimeMultipart�ﹳ��(�i�H�[�J�h��BodyPart)
message.setContent(mm);//��mm�@��������H�����e

message.saveChanges();
Transport transport=s.getTransport("smtp");
transport.connect("172.16.1.201","xxf","coffee");
transport.sendMessage(message,message.getAllRecipients());
transport.close();
		
		
		
    //HttpCore HttpCore=new leeten.HttpCore(pageContext,Data,Conn);
    //leeten.FileManager FileMgr=new leeten.FileManager();
    //String To="",From="";       
    //From="cy6213@mail2.chungyo.com.tw"; //�H���
    //To="cy6213@mail2.chungyo.com.tw";  //�����,�h�H��##�Ϥ�
    //String PortalTitle="�����~�^��";  //�D��
    //String FormName="�M�d�s�i�H���Ϋ~�ӽг�-JFlow_Form_103";

    //HttpCore.SendMail(From,To,PortalTitle+"-"+FormName,"FormId->"+FDId+"<br><br>"+sqlEx.getMessage()); 
    out.println("send mail");
}
%>
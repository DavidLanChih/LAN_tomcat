<%@ include file="/kernel.jsp" %>
<%@ page import="java.io.*,java.util.*,javax.mail.*,java.util.Timer,java.util.TimerTask"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page contentType="text/html;charset=MS950" %>
<%@ include file="/APP3.0-TC.jsp" %>
<%
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
//--------------�ǰe�Ӫ����-------------------
String C1=req("C1",request);           //���d��
String C2=req("C2",request);           //�s�d��
String old_ID=C1.toUpperCase();
String new_ID=C2.toUpperCase();
//-----------�����s�����֨�����----------------
NoCatch(response);
//-------------��s��ƪ��e------------------
String SqlStr="";
Statement stmt=connTC.createStatement();                                              
SqlStr="update CHANGE_GOODS set COUNTER_ID='"+new_ID+"'where COUNTER_ID='"+old_ID+"'";                   //��sCHANGE_GOODS���
SqlStr+="update GOODS_COUNTER set COUNTER_ID='"+new_ID+"'where COUNTER_ID='"+old_ID+"'";                 //��sGOODS_COUNTER���
SqlStr+="update GOODS set SUPPLIER_ID='"+new_ID+"'where SUPPLIER_ID='"+old_ID+"'";                       //��sGOODS���
SqlStr+="update GOODS_EC_PRICE set COUNTER_ID='"+new_ID+"'where COUNTER_ID='"+old_ID+"'";                //��sGOODS_EC_PRICE���
stmt.execute(SqlStr);
//------------------����-----------------------
out.print("���d��:"+old_ID+"&nbsp;&nbsp;�ন�s�d��:"+new_ID+"&nbsp;&nbsp;�ಾ���\�I<br>");
out.print("E-mail�ܰӰȸ�T�ҤH��(����:cy6213,cy6957 �ƥ�:cy6909)&nbsp;&nbsp;:");
stmt.close();
connTC.close();



//----------------�s�@txt�ɮ�------------------
//----------------<�ŧi�ɶ�>-------------------
String TransferDate=JDate.Now();
String[] TS = TransferDate.split("/");
String[] TSS =TS[2].split(" ");
String[] TSSS =TSS[1].split(":");
String T=TS[0]+TS[1]+TSS[0]+TSSS[0]+TSSS[1];
String path = request.getRealPath("/Modules/UpdateCabinetNo/TransferRecord");                            //�x�s��m
FileWriter fw = new FileWriter(path + "//TransferCabinetNo"+T+".txt");                                   //�إߤ���ɦW(�g�i���)
//--------------<�g�J��󤺮e>-----------------
fw.write("���d��:"+old_ID+"\0�ন�s�d��:"+new_ID+"\n");
fw.write("Statement stmt=connTC.createStatement();\n");
fw.write("SqlStr="+"update CHANGE_GOODS set COUNTER_ID='"+new_ID+"'where COUNTER_ID='"+old_ID+"';\n");
fw.write("SqlStr+="+"update GOODS_COUNTER set COUNTER_ID='"+new_ID+"'where COUNTER_ID='"+old_ID+"';\n");
fw.write("SqlStr+="+"update GOODS set SUPPLIER_ID='"+new_ID+"'where SUPPLIER_ID='"+old_ID+"';\n");
fw.write("SqlStr+="+"update GOODS_EC_PRICE set COUNTER_ID='"+new_ID+"'where COUNTER_ID='"+old_ID+"';\n");
fw.write("stmt.execute(SqlStr);");
fw.close();                                                                                              //�����ɮ�                                                                                             //�����ɮ�




//----------------mail�o�e���e-----------------	
String smtphost = "mail2.chungyo.com.tw";        						                                 //�ǰe�l����A��
String mailuser = "c20201";                      						                                 //�l����A���n�J�ϥΪ̦W��
String mailpassword = "5j/u.19cji";              					                                	 //�l����A���n�J�K�X
String from = "chungyoLion@mail2.chungyo.com.tw"; 					                                	 //�ǰe�H�l��a�}
String to = "cy7022@mail2.chungyo.com.tw";        						                                 //�����H�l��a�}(����)
String subject = "�d���ಾ�q��";                    					                                 //�l����D
String bodycontent = "�d���ಾ���\�I";   		                                                         //�l�󤺮e

//-------------<<mail�ǰe�{���]�w>>------------
Properties props = new Properties();                                                                     //�إ�Properties����
props.put("mail.smtp.host", smtphost);									 
props.put("mail.smtp.auth","true");
Session ssn = Session.getInstance(props, null);                                                          //�إ�Session����
MimeMessage message = new MimeMessage(ssn);                  		                                     //�إ�MimeMessage����
message.setFrom(new InternetAddress(from));                  		                                     //�]�w�H��H�H�c
message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));                                 //�]�w����H�H�c(����)
//------------------<�إߤ���>-----------------
BodyPart messageBodyPart0 = new MimeBodyPart();                                                          //�إ�BodyPart����
messageBodyPart0.setContent(bodycontent,"text/html; charset=UTF-8");                                     //�]�wmail�����e(�M��html�榡)�ñN�����x�s��messageBodyPart�A�γ]�w����榡
//------------------<�إߪ���>-----------------
BodyPart messageBodyPart1 = new MimeBodyPart();                                                          //�إߤ@��BodyPart����
String filesource = "D:/Portal/web/Modules/UpdateCabinetNo/TransferRecord/TransferCabinetNo"+T+".txt";   //������|
DataSource source = new FileDataSource(filesource);
messageBodyPart1.setDataHandler(new DataHandler(source));
String Filename="TransferCabinetNo"+T+"";                                                                //����W��
messageBodyPart1.setFileName(Filename);     
//----------------<����+����]�q>--------------
Multipart multipart = new MimeMultipart();                     		                                     //�إ�Multipart����
multipart.addBodyPart(messageBodyPart0);                                                                 //�N�H�󤺤��x�s��Multipart
multipart.addBodyPart(messageBodyPart1);                                                                 //�N�������x�s��Multipart
message.setContent(multipart);                                                                           //�]�w�H�e���e��Multipart
//------------------<�ǰe�`��>-----------------
Transport transport = ssn.getTransport("smtp");
transport.connect(smtphost, mailuser, mailpassword);
transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
transport.close();


out.print("�H�H���\�I");
%>
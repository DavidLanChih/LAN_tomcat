<%@page import="leeten.*" %>
<%@page contentType="text/xml; charset=big5"%>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat" %>
<%@ page pageEncoding="big5"%>
<%@ include file="/APP3.0-TC.jsp" %>
<%@ page import="java.io.*"%>

<%
//-----------�����s�����֨�����----------------
NoCatch(response);
//----------------�ŧi�ɶ�---------------------
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String NowDate=JDate.ToDay();                //�~���(����)
String SDate=JDate.DateAdd("D",NowDate,-30); //������-30��("D"���w�]�N��)
String EDate=JDate.DateAdd("D",NowDate,+1);  //������+1��("D"���w�]�N��)
String TransferDate=JDate.Now();             //�~���ɤ���(�ثe)
String[] TS = TransferDate.split("/");
String[] TSS =TS[2].split(" ");
String[] TSSS =TSS[1].split(":");
String T=TS[0]+TS[1]+TSS[0]+TSSS[0]+TSSS[1];
String[] TT =TransferDate.split(" ");
//----------------��Ʈw-----------------------
String SqlStr="",STime="",FDId="",SqlStrEC1="",SqlStrEC2="",SqlStrEC3="",SqlStrEC4="",SqlStrS="";
String BillNo="";
String Data1="",Data2="",Data3="";
String Field5="",Field6="";
int u=0,FCount=0,ICount=0;
String Record="";
SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('�d���ಾ����-JFlow_Form_279','�妸��J','�}�l...')";
Data.ExecUpdateSql(Conn,SqlStr);

try
{
//�qFR�MFD����w�f�ֹL(30�Ѥ�)�����  
STime="and flow_formdata.FD_Data4<'"+EDate+"'";  //�ͮĤ�
SqlStr="select flow_form_rulestage.BillNo1,flow_form_rulestage.BillNo2,flow_form_rulestage.FR_FinishTime,flow_formdata.* from flow_formdata,flow_form_rulestage where flow_form_rulestage.FR_FinishTime>'"+SDate+" 00:00' and flow_form_rulestage.FR_FinishTime<'"+NowDate+" 23:59' and flow_form_rulestage.FR_FormAP='JFlow_Form_279' and flow_form_rulestage.FR_FinishState=1 "+STime+"and flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId";
	
ResultSet DRs=null;
DRs=Data.getSmt(Conn,SqlStr);

Statement stmt = connTC.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);

while(DRs.next())
	{	
		
		FCount++;                                                                                            //����쪺����ƶq
		FDId=DRs.getString("FD_RecId");                                                                      //�C�i����N��
		
		//��for�j��]����d��
		u=0;
		for(int t=0;t<2;t++)              
		{
			Field5=String.valueOf((t*2)+5);	 
			Field6=String.valueOf((t*2)+6);
			//out.print(Field5);			
			//�T�{���g��H
			Data1=DRs.getString("FD_Data1");
			if(!Data1.equals(""))                                                 
			{
				
				//�T�{BillNo���S����s�L���аO
				u++;
				if(DRs.getString("BillNo"+u).equals(""))                          
				{
							
					Data2=DRs.getString("FD_Data"+Field5).split(":")[0].trim();                              //��������d��
					Data3=DRs.getString("FD_Data"+Field6).split(":")[0].trim();                              //�ಾ�������d��
					
					//�ֹ糧����Ʈw�d�������EC��Ʈw�ۦP�d��
					/*
					SqlStrEC="select USERS.COUNTER_ID as COUNTER_ID,COUNTER.SHORT_NAME as short_name from USERS, COUNTER where USERS.COUNTER_ID='"+Data2+"'and USERS.STATUS='1' and USERS.COUNTER_ID=COUNTER.COUNTER_ID group by USERS.COUNTER_ID,COUNTER.SHORT_NAME";
					ResultSet ECRs=stmt.executeQuery(SqlStrEC);	
					String COUNTER_ID="";
					COUNTER_ID=ECRs.getString("COUNTER_ID");
					out.print(COUNTER_ID);
					*/
					
					if(!Data2.equals("")) 
					{
						ICount++;                                                                             //�������s���C������
						
						/*CHANGE_GOODS��Ƨ�s*/
						SqlStrEC1="update CHANGE_GOODS set COUNTER_ID='"+Data3+"'where COUNTER_ID='"+Data2+"'";
						stmt.executeUpdate(SqlStrEC1);
						out.println("<br>�iCHANGE_GOODS��Ƨ�s�j ���d��: "+Data2+"�ഫ���s�d��: "+Data3+"<br>");
						
						/*GOODS_COUNTER��Ƨ�s*/
						SqlStrEC2="update GOODS_COUNTER set COUNTER_ID='"+Data3+"'where COUNTER_ID='"+Data2+"'";
						stmt.executeUpdate(SqlStrEC2);
						out.println("�iGOODS_COUNTER��Ƨ�s�j ���d��: "+Data2+"�ഫ���s�d��: "+Data3+"<br>");
						
						/*GOODS��Ƨ�s*/
						SqlStrEC3="update GOODS set SUPPLIER_ID='"+Data3+"'where SUPPLIER_ID='"+Data2+"'";
						stmt.executeUpdate(SqlStrEC3);
						out.println("�iGOODS��Ƨ�s�j ���d��: "+Data2+"�ഫ���s�d��: "+Data3+"<br>");
						
						/*GOODS_EC_PRICE��Ƨ�s*/
						SqlStrEC4="update GOODS_EC_PRICE set COUNTER_ID='"+Data3+"'where COUNTER_ID='"+Data2+"'"; 
						stmt.executeUpdate(SqlStrEC4);
						out.println("�iGOODS_EC_PRICE��Ƨ�s�j ���d��: "+Data2+"�ഫ���s�d��: "+Data3+"<br>");
					
						/*������Ƨ�s�аO*/
						SqlStr="update flow_form_rulestage set BillNo"+u+"='"+FDId+"' where FR_DataId="+FDId;
						Data.ExecUpdateSql(Conn,SqlStr);
						out.println("BillNo"+u+"='"+FDId+" ������Ʈw�аO���\!<br>");

						/*�C����Ƨ�s����*/
						Record+="�i��Ƨ�s�j ���d��: "+Data2+"�ഫ���s�d��: "+Data3+"���\�I\r\n";																		
					}
												
				}
				else    
				{
					/*�w����s�аO������h���X���T��*/
					BillNo=DRs.getString("BillNo1");
					out.print("����:"+BillNo+"����"+u+"�� �w��s�L (���A���Ƨ�s)<br>");
				}		
				
			}
		
		}
	
			
	}
	//----------------�s�@txt�ɮ�------------------
	String path = request.getRealPath("/Modules/UpdateCabinetNo/TransferRecord");                            //�x�s��m
	FileWriter fw = new FileWriter(path + "//TransferCabinetNo"+T+".txt");                                   //�إߤ���ɦW(�g�i���)
	//--------------<�g�J��󤺮e>-----------------
	fw.write(Record);
	fw.write("\r\n");
	fw.close();  
	DRs.close();
	SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('�d���ಾ����-JFlow_Form_279','�妸��J','����.�@�B�z "+FCount+" �i����,"+ICount+" �����.')";
	Data.ExecUpdateSql(Conn,SqlStr);
	connTC.close();
	Conn.close();

}
catch(Exception sqlEx)
{	
//----------------mail�o�e���e-----------------	
HttpCore HttpCore=new leeten.HttpCore(pageContext,Data,Conn);
leeten.FileManager FileMgr=new leeten.FileManager();
String report=sqlEx.getMessage();
String smtphost = "mail2.chungyo.com.tw";        						                                 //�ǰe�l����A��
String mailuser = "c20201";                      						                                 //�l����A���n�J�ϥΪ̦W��
String mailpassword = "5j/u.19cji";              					                                	 //�l����A���n�J�K�X
String from = "chungyoLion@mail2.chungyo.com.tw"; 					                                	 //�ǰe�H�l��a�}
String to1 = "cy7022@mail2.chungyo.com.tw";        						                                 //�����H�l��a�}(����)
//String to2 = "cy6957@mail2.chungyo.com.tw";
String cc1 = "cy7022@mail2.chungyo.com.tw";
//String CC2 = "cy7022@mail2.chungyo.com.tw";
String subject = "�d���ಾ�q��";                    					                                 //�l����D
String bodycontent = "�d���ಾ���ѡA��]:"+report;                                                       //�l�󤺮e

//-------------<<mail�ǰe�{���]�w>>------------

Properties props = new Properties();                                                                     //�إ�Properties����
props.put("mail.smtp.host", smtphost);									 
props.put("mail.smtp.auth","true");
Session ssn = Session.getInstance(props, null);                                                          //�إ�Session����
MimeMessage message = new MimeMessage(ssn);                  		                                     //�إ�MimeMessage����
message.setFrom(new InternetAddress(from));                  		                                     //�]�w�H��H�H�c
message.addRecipient(Message.RecipientType.TO, new InternetAddress(to1));                                //�]�w����H�H�c(����)
//message.addRecipient(Message.RecipientType.TO, new InternetAddress(to2));                                 //�]�w����H�H�c(����)
message.addRecipient(Message.RecipientType.CC, new InternetAddress(cc1));                                 //�]�w����H�H�c(�ƥ�)
//message.addRecipient(Message.RecipientType.CC, new InternetAddress(CC2));
message.setSubject(subject,"UTF-8");                                                                     //�]�wmail���D��
//------------------<�إߤ���>-----------------
BodyPart messageBodyPart0 = new MimeBodyPart();                                                          //�إ�BodyPart����
messageBodyPart0.setContent(bodycontent,"text/html; charset=UTF-8");                                     //�]�wmail�����e(�M��html�榡)�ñN�����x�s��messageBodyPart�A�γ]�w����榡
//------------------<�إߪ���>-----------------
BodyPart messageBodyPart1 = new MimeBodyPart();                                                          //�إߤ@��BodyPart����
String filesource = "D:/Portal/web/Modules/UpdateCabinetNo/TransferRecord/file.txt";   //������|
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
out.print(sqlEx.getMessage()+"<br>");
out.print("<br>E-mail�ܰӰȸ�T�ҤH��(����:cy6213,cy6957 �ƥ�:cy6909)�G�H�H���\�I");

connTC.close();
Conn.close();
}

out.print("------------------------------------------------------------------------------");
out.print("<br>�H�W�d��Ҥw�ಾ���\�I");


%>
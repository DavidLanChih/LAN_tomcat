<%@ include file="/kernel.jsp" %>
<%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page contentType="text/html;charset=MS950" %>
<%@ include file="/APP3.0-TC.jsp" %>

<%
//-----------�����s�����֨�����----------------
NoCatch(response);
//----------------<�ŧi�ɶ�>-------------------
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String TransferDate=JDate.Now();
ResultSet Rs=null;
String EDate=JDate.ToDay();
String[] TS = TransferDate.split("/");
String[] TSS =TS[2].split(" ");
String[] TSSS =TSS[1].split(":");
String T=TS[0]+TS[1]+TSS[0]+TSSS[0]+TSSS[1];
String[] TT =TransferDate.split(" ");
String SqlStrB="";
SqlStrB="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('�d���ಾ���-JFlow_Form_279','�妸��J','�}�l...')";
Data.ExecUpdateSql(Conn,SqlStrB);
//-----------���MS-SQL��Ʈw���e--------------
String SqlStrPASS="",FR_DataId="",SqlStr1="",SqlStr2="",Reply="",SqlStrE="",ERRORmessage="";
ResultSet Rs1=null;

SqlStrPASS="select FR_DataId from flow_form_rulestage where FR_FormAP='JFlow_Form_279' and FR_FinishState='1'";
Rs1=Data.getSmt(Conn,SqlStrPASS);

if(Rs1.next())
{
	for(int i=0;i<1000;i++)
	{ 
		FR_DataId=Rs1.getString("FR_DataId");
		//out.print("FR_DataId:"+FR_DataId+"<br>");                                        //�C����渹�X
		String SqlStrDATA="",FD_1_old="",FD_1_new="",FD_2_old="",FD_2_new="",old_ID_1="",new_ID_1="",old_ID_2="",new_ID_2="";
		ResultSet Rs2=null;
		SqlStrDATA="select FD_Data5,FD_Data6,FD_Data7,FD_Data8 from flow_formdata where FD_RecId='"+FR_DataId+"' and FD_Data4<'"+EDate+"'";
		Rs2=Data.getSmt(Conn,SqlStrDATA);
		
		//----------------�s�@txt�ɮ�------------------
		String path = request.getRealPath("/Modules/UpdateCabinetNo/TransferRecord");                                 	    //TXT�x�s��m
		FileWriter fw = new FileWriter(path + "//TransferCabinetNo"+T+".txt");                                        	    //�إߤ���ɦW(�g�i���)
		
		if(Rs2.next())
		{
			
			String[] FD_1_oldArr=Rs2.getString("FD_Data5").split(":");                     //1.���d��
			FD_1_old=FD_1_oldArr[0];
			
			String[] FD_1_newArr=Rs2.getString("FD_Data6").split(":");                     //1.�s�d��
			FD_1_new=FD_1_newArr[0];

			String[] FD_2_oldArr=Rs2.getString("FD_Data7").split(":");                     //2.���d��
			FD_2_old=FD_2_oldArr[0];
			
			String[] FD_2_newArr=Rs2.getString("FD_Data8").split(":");                     //2.�s�d��
			FD_2_new=FD_2_newArr[0];
			
			old_ID_1=FD_1_old.toUpperCase();
			new_ID_1=FD_1_new.toUpperCase();
			old_ID_2=FD_2_old.toUpperCase();
			new_ID_2=FD_2_new.toUpperCase();
			
			//--------------------------------------���b�]�w----------------------------------------------
			ERRORmessage="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('�d���ಾ���-JFlow_Form_279','�妸��J','���:"+FR_DataId+" �ಾ����!')";

			if(!FD_2_old.equals("") && FD_2_new.equals(""))
			{
				Reply+="���:"+FR_DataId+"<br>1.���d��:"+FD_1_old+" �� 2.�s�d��:"+FD_1_new+" �S����� => �ಾ���ѡI<br>";
				SqlStrB=ERRORmessage;
				Data.ExecUpdateSql(Conn,SqlStrB);
				if(FD_1_old.equals("") || FD_1_new.equals(""))
				{
					Reply+="���:"+FR_DataId+"<br>1.���d��:"+FD_1_old+" �� 1.�s�d��:"+FD_1_new+" �S����� => �ಾ���ѡI<br>";
					SqlStrB=ERRORmessage;
					Data.ExecUpdateSql(Conn,SqlStrB);
				}
			}	
			else if(FD_1_old.equals(FD_1_new))
			{
				Reply+="���:"+FR_DataId+"<br>1.���d��:"+FD_1_old+" �P 1.�s�d��:"+FD_1_new+" �ۦP => �ಾ���ѡI<br>";
				SqlStrB=ERRORmessage;
				Data.ExecUpdateSql(Conn,SqlStrB);
			}
			else if(FD_1_old.equals(FD_2_old))
			{
				Reply+="���:"+FR_DataId+"<br>1.���d��:"+FD_1_old+" �P 2.���d��:"+FD_1_new+" �ۦP => �ಾ���ѡI<br>";
				SqlStrB=ERRORmessage;
				Data.ExecUpdateSql(Conn,SqlStrB);
			}
			else if(FD_1_new.equals(FD_2_new))
			{
				Reply+="���:"+FR_DataId+"<br>1.�s�d��:"+FD_1_old+" �P 2.�s�d��:"+FD_1_new+" �ۦP => �ಾ���ѡI<br>";
				SqlStrB=ERRORmessage;
				Data.ExecUpdateSql(Conn,SqlStrB);
			}
			
		    //--------------------------------------��s��ƪ��e---------------------------------------------
			else if(!FD_1_old.equals("") && !FD_1_new.equals(""))             //�Ĥ@���d���ಾ
			{
				Statement stmt=connTC.createStatement();                                              
				SqlStr1="update CHANGE_GOODS set COUNTER_ID='"+new_ID_1+"'where COUNTER_ID='"+old_ID_1+"'";                   //��sCHANGE_GOODS���
				SqlStr1+="update GOODS_COUNTER set COUNTER_ID='"+new_ID_1+"'where COUNTER_ID='"+old_ID_1+"'";                 //��sGOODS_COUNTER���
				SqlStr1+="update GOODS set SUPPLIER_ID='"+new_ID_1+"'where SUPPLIER_ID='"+old_ID_1+"'";                       //��sGOODS���
				SqlStr1+="1""update GOODS_EC_PRICE set COUNTER_ID='"+new_ID_1+"'where COUNTER_ID='"+old_ID_1+"'"; 
out.println(SqlStr1);				//��sGOODS_EC_PRICE���
				//stmt.execute(SqlStr1);
				Reply+="���:"+FR_DataId+"<br>1.���d��:"+FD_1_old+" �ন 1.�s�d��:"+FD_1_new+" �ಾ���\�I<br>";
				stmt.close();
							
				if(!FD_2_old.equals("") && !FD_2_new.equals(""))              //�ĤG���d���ಾ
				{
					Statement stmt2=connTC.createStatement();                                              
					SqlStr2="update CHANGE_GOODS set COUNTER_ID='"+new_ID_2+"'where COUNTER_ID='"+old_ID_2+"'";                   //��sCHANGE_GOODS���
					SqlStr2+="update GOODS_COUNTER set COUNTER_ID='"+new_ID_2+"'where COUNTER_ID='"+old_ID_2+"'";                 //��sGOODS_COUNTER���
					SqlStr2+="update GOODS set SUPPLIER_ID='"+new_ID_2+"'where SUPPLIER_ID='"+old_ID_2+"'";                       //��sGOODS���
					SqlStr2+="update GOODS_EC_PRICE set COUNTER_ID='"+new_ID_2+"'where COUNTER_ID='"+old_ID_2+"'";                //��sGOODS_EC_PRICE���
					//stmt2.execute(SqlStr2);
					Reply+="2.���d��:"+FD_2_old+" �ন 2.�s�d��:"+FD_2_new+" �ಾ���\�I<br>";
					stmt2.close();
				}					
			}
			else
			{
				Reply+="���:"+FR_DataId+"<br>1.���d��:"+FD_1_old+" �ন 1.�s�d��:"+FD_1_new+" �ಾ���ѡI<br>";
				SqlStrB=ERRORmessage;
				Data.ExecUpdateSql(Conn,SqlStrB);
			}
			
		}	
		//--------------<�g�JTXT��󤺮e>-----------------
		fw.write(SqlStr1);
		fw.write(SqlStr2);
		fw.close();			//�����ɮ�	
		SqlStrB="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('�d���ಾ���-JFlow_Form_279','�妸��J','���:"+FR_DataId+" �ಾ���\!')";
			Data.ExecUpdateSql(Conn,SqlStrB);
		if(!Rs1.next()) break;	
		
	}
	
}
out.print(Reply);
connTC.close();
Conn.close();
/*
	
//----------------mail�o�e���e-----------------	
String smtphost = "mail2.chungyo.com.tw";        						                                 //�ǰe�l����A��
String mailuser = "c20201";                      						                                 //�l����A���n�J�ϥΪ̦W��
String mailpassword = "5j/u.19cji";              					                                	 //�l����A���n�J�K�X
String from = "chungyoLion@mail2.chungyo.com.tw"; 					                                	 //�ǰe�H�l��a�}
String to = "cy6213@mail2.chungyo.com.tw##,cy7022@mail2.chungyo.com.tw##";        						                                 //�����H�l��a�}(����)
String to2 = "cy6096@mail2.chungyo.com.tw";
String CC = "cy6957@mail2.chungyo.com.tw";
String subject = "�d���ಾ�q��";                    					                                 //�l����D
String bodycontent = Reply;   		                                                                     //�l�󤺮e

//-------------<<mail�ǰe�{���]�w>>------------
Properties props = new Properties();                                                                     //�إ�Properties����
props.put("mail.smtp.host", smtphost);									 
props.put("mail.smtp.auth","true");
Session ssn = Session.getInstance(props, null);                                                          //�إ�Session����
MimeMessage message = new MimeMessage(ssn);                  		                                     //�إ�MimeMessage����
message.setFrom(new InternetAddress(from));                  		                                     //�]�w�H��H�H�c
message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));                                //�]�w����H�H�c(����)
message.addRecipient(Message.RecipientType.TO, new InternetAddress(to2));                                 //�]�w����H�H�c(����)
message.addRecipient(Message.RecipientType.CC, new InternetAddress(CC));                                 //�]�w����H�H�c(�ƥ�)
message.setSubject(subject,"UTF-8");                                                                     //�]�wmail���D��
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
out.print("------------------------------------------------------------------------------");
out.print("<br>E-mail�ܰӰȸ�T�ҤH��(����:cy6213,cy6957 �ƥ�:cy6909)�G�H�H���\�I");
*/
%>
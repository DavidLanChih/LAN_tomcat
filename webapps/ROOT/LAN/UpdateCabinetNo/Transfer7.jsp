<%@page import="leeten.*" %>
<%@page contentType="text/xml; charset=big5" %>
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
String SDate=JDate.DateAdd("D",NowDate,-10);  //������-10��("D"���w�]�N��)
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
String Data1="",Data2="",Data3="",applyman[]=null,AM="";
String Field5="",Field6="";
int u=0,FCount=0,ICount=0;
String Record="",Record_1="";
String catch_e="",catch_ex="",catch_exc="";
String catch_de="",catch_dex="",catch_dexc="";
SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('�d���ಾ���-JFlow_Form_279','�妸��J','�}�l...')";
Data.ExecUpdateSql(Conn,SqlStr);

	//�qFR�MFD���(10�Ѥ�)�w�f�ֹL�����  
	STime="and flow_formdata.FD_Data4<'"+EDate+"'";  //�ͮĤ�
	SqlStr="select flow_form_rulestage.BillNo1,flow_form_rulestage.BillNo2,flow_form_rulestage.FR_FinishTime,flow_formdata.* from flow_formdata,flow_form_rulestage where flow_form_rulestage.FR_FinishTime>'"+SDate+" 00:00' and flow_form_rulestage.FR_FinishTime<'"+NowDate+" 23:59' and flow_form_rulestage.FR_FormAP='JFlow_Form_279' and flow_form_rulestage.FR_FinishState=1 "+STime+"and flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId";		
	ResultSet DRs=null;
	DRs=Data.getSmt(Conn,SqlStr);

	Statement stmt = connTC.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);							
	
try
{
	Conn.setAutoCommit(false);                                                     	//�����۰ʴ���
	Statement stmtDB= Conn.createStatement();
	while(DRs.next())
	{	

		
		/*�T�{BillNo1,BillNo2���S����s�L���аO*/
		if(DRs.getString("BillNo1").equals("")&&DRs.getString("BillNo2").equals(""))                          
		{
			
			/*�C�i���*/
			FCount++;                                                                                        //����쪺���ƶq
			FDId=DRs.getString("FD_RecId");                                                                  //�C�i���N��
			
			/*�T�{���g��H*/
			Data1=DRs.getString("FD_Data1");
			applyman=Data1.split(" ");
			AM=applyman[0]; 
			if(!Data1.equals(""))                                                 
			{
				
				try
				{
					connTC.setAutoCommit(false);                                                     	//�����۰ʴ���				
					
					/*��for�j��]����d��*/
					u=0;                                                                                         //�C�]���@�i����u�k0
					for(int t=0;t<2;t++)              
					{
						u++;
						Field5=String.valueOf((t*2)+5);	 
						Field6=String.valueOf((t*2)+6);
						Data2=DRs.getString("FD_Data"+Field5).split(":")[0].trim();                              //��������d��
						Data3=DRs.getString("FD_Data"+Field6).split(":")[0].trim();                              //�ಾ�������d��
											
						if(!Data2.equals("")) 
						{
							ICount++;                                                                            //�������s���C������
														
								
								
								/*CHANGE_GOODS��Ƨ�s*/
								SqlStrEC1="update CHANGE_GOODS set COUNTER_ID='"+Data3+"'where COUNTER_ID='"+Data2+"'";
								stmt.executeUpdate(SqlStrEC1);
								
								/*GOODS_COUNTER��Ƨ�s*/
								SqlStrEC2="update GOODS_COUNTER set COUNTER_ID='"+Data3+"'where COUNTER_ID='"+Data2+"'";
								stmt.executeUpdate(SqlStrEC2);
								
								/*GOODS��Ƨ�s*/
								SqlStrEC3="update GOODS set SUPPLIER_ID='"+Data3+"'where SUPPLIER_ID='"+Data2+"'";
								stmt.executeUpdate(SqlStrEC3);
								
								/*GOODS_EC_PRICE��Ƨ�s*/
								SqlStrEC4="update GOODS_EC_PRICE set COUNTER_ID='"+Data3+"'where COUNTER_ID='"+Data2+"'"; 
								stmt.executeUpdate(SqlStrEC4);
								
								/*������Ƨ�s�аO*/
								SqlStr="update flow_form_rulestage set BillNo"+u+"='"+FDId+"' where FR_DataId="+FDId;
								stmtDB.executeUpdate(SqlStr);
								
								out.println("<br>BillNo"+u+"='"+FDId+" ������Ʈw�аO���\!<br>");
								
								/*�C����Ƨ�s����*/
								Record+="�i���:"+FDId+" ��Ƨ�s�j ���d��: "+Data2+"�ഫ���s�d��: "+Data3+"���\�I\r\n";
								Record_1+="�i��Ƨ�s�j ���d��: "+Data2+"�ഫ���s�d��: "+Data3+"���\�I\r\n";
						}					
					}
					
					//--------------mail�o�e---------------

					String smtphost = "mail2.chungyo.com.tw"; // �ǰe�l����A��
					String mailuser = "c20201"; // �l����A���n�J�ϥΪ̦W��
					String mailpassword = "5j/u.19cji"; // �l����A���n�J�K�X
					String from = "chungyoLion@mail2.chungyo.com.tw"; // �ǰe�H�l��a�}
					String to = "cy"+AM+"@mail2.chungyo.com.tw"; // �����H�l��a�}
					String cc = "cy7022@mail2.chungyo.com.tw";
					String subject = "���ձH�e"; // �l����D
					String bodycontent = Record_1; // �l�󤺮e

					/*�H�U���ǰe�{���A�ϥΪ̵L�ݧ��*/

					Properties props = new Properties();
					props.put("mail.smtp.host", smtphost);
					props.put("mail.smtp.auth","true");
					Session ssn = Session.getInstance(props, null);
					MimeMessage message = new MimeMessage(ssn);

					InternetAddress fromAddress = new InternetAddress(from);
					message.setFrom(fromAddress);
					InternetAddress[] sendTo = InternetAddress.parse(to);
					message.setRecipients(MimeMessage.RecipientType.TO, sendTo);
					InternetAddress[] cc1 = InternetAddress.parse(cc);
					message.addRecipients(MimeMessage.RecipientType.CC, cc1);
					message.setSubject(subject,"UTF-8");
					
					//------------------<�ǰe�`��>-----------------	
					Transport transport = ssn.getTransport("smtp");
					transport.connect(smtphost, mailuser, mailpassword);
					transport.sendMessage(message, message.getAllRecipients());
					transport.close();
					
					connTC.commit();                                                                 //����
				}
				catch(Exception e)
				{							
					catch_e=e.getMessage();
					/*�C����Ƨ�s����*/
					Record+="�i���:"+FDId+"�j ��s���ѡI ��]:"+catch_e+"\r\n";
					
					if(connTC!=null)
					{								
																
						try
						{									
							connTC.rollback();                                                       //�M�^SQL���O																	
						}
						catch(Exception ex)
						{
							catch_ex=ex.getMessage();									
						}								
					}							
				}						
				finally 
				{
					if(connTC!=null)
					{
						try
						{									
							connTC.setAutoCommit(true);                                              //��_�۰ʴ���																										
						}
						catch(Exception exc)
						{									
							catch_exc=exc.getMessage();									
						}
					}							
				}
				//out.print(AM);     //�C�ӥӽФH
				//out.print(Record); //�C�i��檬�p
				//out.print("<br>");
				
				
				
				

			}
			
			
		}
				
	}
	Conn.commit();                                                                 //����
}
catch(Exception de)
{							
	catch_de=de.getMessage();
	/*�C����Ƨ�s����*/
	Record="��s���ѡI ��]:"+catch_de+"\r\n";
					
	if(Conn!=null)
	{								
																
		try
		{									
			Conn.rollback();                                                       //�M�^SQL���O																	
		}
		catch(Exception dex)
		{
			catch_dex=dex.getMessage();									
		}								
	}							
}						
finally 
{
	if(Conn!=null)
	{
		try
		{									
			Conn.setAutoCommit(true);                                              //��_�۰ʴ���																										
		}
		catch(Exception dexc)
		{									
			catch_dexc=dexc.getMessage();									
		}
	}							
}
//---------------�s�@txt�ɮ�---------------
				String path = request.getRealPath("/Modules/UpdateCabinetNo/TransferRecord");                            //�x�s��m
				FileWriter fw = new FileWriter(path + "//TransferCabinetNo"+T+".txt");                                   //�إߤ���ɦW
				fw.write(Record);                                                                                        //�ন�\���d��|�g�i���
				fw.close();
	
	//--------------�g�J��ƮwLOG--------------
	if(catch_de!=""||catch_dex!=""||catch_dexc!=""||catch_e!=""||catch_ex!=""||catch_exc!="")
	{
		SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('�d���ಾ���-JFlow_Form_279','�妸��J���~','Transfer.jsp ���~�T��: "+catch_de+""+catch_dex+"')";
		Data.ExecUpdateSql(Conn,SqlStr);
	}
	if(catch_de==""&&catch_dex==""&&catch_dexc==""&&catch_e==""&&catch_ex==""&&catch_exc=="")
	{
		SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('�d���ಾ���-JFlow_Form_279','�妸��J','����.�@�B�z "+FCount+" �i���,"+ICount+" �����.')";
		Data.ExecUpdateSql(Conn,SqlStr);
	}

	//--------------mail�o�e---------------

				String smtphost = "mail2.chungyo.com.tw"; // �ǰe�l����A��
				String mailuser = "c20201"; // �l����A���n�J�ϥΪ̦W��
				String mailpassword = "5j/u.19cji"; // �l����A���n�J�K�X
				String from = "chungyoLion@mail2.chungyo.com.tw"; // �ǰe�H�l��a�}
				//String to = "cy6957@mail2.chungyo.com.tw,cy6213@mail2.chungyo.com.tw"; // �����H�l��a�}
				String to = "cy7022@mail2.chungyo.com.tw"; // �����H�l��a�}
				String cc = "cy7022@mail2.chungyo.com.tw";
				String subject = "���ձH�e"; // �l����D
				String bodycontent = Record; // �l�󤺮e

				/*�H�U���ǰe�{���A�ϥΪ̵L�ݧ��*/

				Properties props = new Properties();
				props.put("mail.smtp.host", smtphost);
				props.put("mail.smtp.auth","true");
				Session ssn = Session.getInstance(props, null);
				MimeMessage message = new MimeMessage(ssn);

				InternetAddress fromAddress = new InternetAddress(from);
				message.setFrom(fromAddress);
				InternetAddress[] sendTo = InternetAddress.parse(to);
				message.setRecipients(MimeMessage.RecipientType.TO, sendTo);
				InternetAddress[] cc1 = InternetAddress.parse(cc);
				message.addRecipients(MimeMessage.RecipientType.CC, cc1);
				message.setSubject(subject,"UTF-8");
				
				//------------------<�إߤ���>-----------------
				BodyPart Part0 = new MimeBodyPart();                                                        			 //�إ�BodyPart����
				Part0.setContent(bodycontent,"text/html; charset=UTF-8");		
				//------------------<�إߪ���>-----------------
				BodyPart Part1 = new MimeBodyPart();                                                         			 //�إߤ@��BodyPart����
				String filesource = "D:/Portal/web/Modules/UpdateCabinetNo/TransferRecord/TransferCabinetNo"+T+".txt";   //������|
				DataSource source = new FileDataSource(filesource);
				Part1.setDataHandler(new DataHandler(source));
				String Filename="TransferCabinetNo"+T+"";                                                    			 //����W��
				Part1.setFileName(Filename);     
				//----------------<����+����]�q>--------------
				Multipart multipart = new MimeMultipart();                     		                                 	 //�إ�Multipart����
				multipart.addBodyPart(Part0);                                                                		   	 //�N�H�󤺤��x�s��Multipart
				multipart.addBodyPart(Part1);                                                                 		 	 //�N�������x�s��Multipart
				message.setContent(multipart);                                                                       	 //�]�w�H�e���e��Multipart
				//------------------<�ǰe�`��>-----------------	
				Transport transport = ssn.getTransport("smtp");
				transport.connect(smtphost, mailuser, mailpassword);
				transport.sendMessage(message, message.getAllRecipients());
				transport.close();		
			

			
			out.print("<br>E-mail�ܰӰȸ�T�ҤH��(����:�g��H �ƥ�:cy6213,cy6957,cy7022)�G�H�H���\�I");
	//--------------�u���������e---------------
	if(catch_de!="")
	{
		out.print("<br>�d���ಾ���ѡA��]:"+catch_de);
	}
	if(catch_dex!="")
	{
		out.print("<br>�d���ಾ���ѡA��]:"+catch_dex);
	}
	if(catch_dexc!="")
	{
		out.print("<br>�d���ಾ���ѡA��]:"+catch_dexc);
	}
	if(catch_e!="")
	{
		out.print("<br>�d���ಾ���ѡA��]:"+catch_e);
	}
	if(catch_ex!="")
	{
		out.print("<br>�d���ಾ���ѡA��]:"+catch_ex);
	}
	if(catch_exc!="")
	{
		out.print("<br>�d���ಾ���ѡA��]:"+catch_exc);
	}
	if(FDId!=""&&catch_e==""&&catch_ex==""&&catch_exc=="")
	{
		out.print("<br>�d���ಾ���\�I");
	}
		
	//------------------����-------------------
	DRs.close();
	connTC.close();
	Conn.close();
%>
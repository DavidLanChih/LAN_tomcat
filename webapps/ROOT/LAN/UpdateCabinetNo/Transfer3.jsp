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
String SDate=JDate.DateAdd("D",NowDate,-1); //������-1��("D"���w�]�N��)
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
SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('�d���ಾ���-JFlow_Form_279','�妸��J','�}�l...')";
Data.ExecUpdateSql(Conn,SqlStr);
try
{
	//�qFR�MFD���(1�Ѥ�)�w�f�ֹL�����  
	STime="and flow_formdata.FD_Data4<'"+EDate+"'";  //�ͮĤ�
	SqlStr="select flow_form_rulestage.BillNo1,flow_form_rulestage.BillNo2,flow_form_rulestage.FR_FinishTime,flow_formdata.* from flow_formdata,flow_form_rulestage where flow_form_rulestage.FR_FinishTime>'"+SDate+" 00:00' and flow_form_rulestage.FR_FinishTime<'"+NowDate+" 23:59' and flow_form_rulestage.FR_FormAP='JFlow_Form_279' and flow_form_rulestage.FR_FinishState=1 "+STime+"and flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId";		
	ResultSet DRs=null;
	DRs=Data.getSmt(Conn,SqlStr);

	Statement stmt = connTC.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);

	while(DRs.next())
	{	
		/*�T�{BillNo1���S����s�L���аO*/
		if(DRs.getString("BillNo1").equals(""))                          
		{
			/*�C�i���*/
			FCount++;                                                                                        //����쪺���ƶq
			FDId=DRs.getString("FD_RecId");                                                                  //�C�i���N��
			
			/*�T�{���g��H*/
			Data1=DRs.getString("FD_Data1");
			if(!Data1.equals(""))                                                 
			{
							
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
			}		
		}		
	}
	//----------------�s�@txt�ɮ�------------------
	String path = request.getRealPath("/Modules/UpdateCabinetNo/TransferRecord");                            //�x�s��m
	FileWriter fw = new FileWriter(path + "//TransferCabinetNo"+T+".txt");                                   //�إߤ���ɦW(�g�i���)
	//--------------<�g�J��󤺮e>-----------------
	fw.write(Record);
	fw.write("\r\n");
	fw.write("",0,3); //�s�y���~
	fw.close();  
	DRs.close();
	SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('�d���ಾ���-JFlow_Form_279','�妸��J','����.�@�B�z "+FCount+" �i���,"+ICount+" �����.')";
	Data.ExecUpdateSql(Conn,SqlStr);
	connTC.close();
	Conn.close();
	out.print("------------------------------------------------------------------------------");
	out.print("<br>�H�W�d���ಾ���\�I");
}
catch(Exception sqlEx)
{
String report=sqlEx.getMessage();
	/*mail�o�e*/
	
		String smtphost = "mail2.chungyo.com.tw"; // �ǰe�l����A��
		String mailuser = "c20201"; // �l����A���n�J�ϥΪ̦W��
		String mailpassword = "5j/u.19cji"; // �l����A���n�J�K�X
		String from = "chungyoLion@mail2.chungyo.com.tw"; // �ǰe�H�l��a�}
		String to = "cy6213@mail2.chungyo.com.tw"; // �����H�l��a�}
		String cc = "cy7022@mail2.chungyo.com.tw";
		String subject = "���ձH�e"; // �l����D
		String bodycontent = "123"; // �l�󤺮e

		// �H�U���ǰe�{���A�ϥΪ̵L�ݧ��

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
		message.setContent(bodycontent, "text/html; charset=utf-8");
		
		Transport transport = ssn.getTransport("smtp");
		transport.connect(smtphost, mailuser, mailpassword);
		transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
		transport.close();
		
	SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('�d���ಾ���-JFlow_Form_279','�妸��J','���~: Transfer.jsp  FR_DataId="+FDId+" ���~�T��:"+report+"')";
	Data.ExecUpdateSql(Conn,SqlStr);	
	out.print("Transfer.jsp  FR_DataId="+FDId+" ���~�T��:"+report+"<br>");
	out.print("<br>E-mail�ܰӰȸ�T�ҤH��(����:cy6213,cy6957 �ƥ�:cy6909)�G�H�H���\�I");

	connTC.close();
	Conn.close();
}
%>
<%@ page contentType="text/xml; charset=big5"%>
<%@ include file="/kernel.jsp" %>
<%@ page import="java.util.Properties,javax.mail.Message,javax.mail.Session,javax.mail.Transport,javax.mail.internet.InternetAddress,javax.mail.internet.MimeMessage" %>
<%
//-----------�����s�����֨�����--------
NoCatch(response);
//-----------����d��------------------
String D1=req("T1",request);									//���o�}�l���
String D2=req("T2",request);									//���o�������
//-----------�}�l����ɹs--------------
String FD_Data1Arr[]=null,d1="",d2="",d3="";
FD_Data1Arr=D1.split("/");
d1=FD_Data1Arr[0];
d2=String.format("%02d",  Integer.parseInt(FD_Data1Arr[1])); 
d3=String.format("%02d",  Integer.parseInt(FD_Data1Arr[2]));
//-----------��������ɹs--------------
String FD_Data2Arr[]=null,d4="",d5="",d6="";
FD_Data2Arr=D2.split("/");
d4=FD_Data2Arr[0];
d5=String.format("%02d",  Integer.parseInt(FD_Data2Arr[1])); 
d6=String.format("%02d",  Integer.parseInt(FD_Data2Arr[2]));
//-----------MS-SQL��Ʈw���I�s------
String SqlStr="";
ResultSet Rs=null;
SqlStr="select FR_RecId,FD_OrgId,FR_FormId,FR_DataId,FD_FormId,FD_Data1,FD_Data3,FD_Data4,FD_Data5,FD_Data15,FR_FinishState,FD_RecDate from flow_formdata,flow_form_rulestage where flow_formdata.FD_RecId="+
"flow_form_rulestage.FR_DataId and flow_formdata.FD_FormId IN ('207')"+
"and (CONVERT(varchar(10),CONVERT(datetime,FD_Data2,111),111)  BETWEEN  '"+d1+"/"+d2+"/"+d3+"' and '"+d4+"/"+d5+"/"+d6+"')";
Rs=Data.getSmt(Conn,SqlStr);
//-----------�ŧi��椺�e--------------
String result="",form="",table_start="",table_end="";
if(Rs.next())
{
	for(int i=0;i<1000;i++)
	{
		String Mark="";
		Mark=Rs.getString("FR_FinishState");
		if(Mark.equals("0"))
		{
		//-----------���ɤH--------------------
		String build[]=null;
		build=Rs.getString("FD_Data1").split(",");
		String buildman=build[1];
		//-----------�ӽнs��("FD_Data3")------
		//-----------�ӽ����O------------------
		String applytype[]=null;
		applytype=Rs.getString("FD_Data4").split(",");
		String AT=applytype[1];
		//-----------�D��("FD_Data5")----------
		//-----------�Ĥ����f�ֶ�gN��Y--------
		String judge[]=null;
		judge=Rs.getString("FD_Data15").split(",");
		String J=judge[0];
		//-----------�ӽЪ��A("�ӽФ�")--------
		//-----------�ӽЮɶ�------------------
		String applydate[]=null;
		applydate=Rs.getString("FD_RecDate").split(" ");
		String AD1=applydate[0];
		String AD2=applydate[1];
		String AD2_1=AD2.substring(0,8);                        //�u��(��:��:��)
		//-----------���e�`��------------------
		result+="<tr><td align=center>"+buildman+"</td>"+"<td align=center>"+Rs.getString("FD_Data3")+"</td>"+"<td align=center>"+AT+"</td><td align=center>"+Rs.getString("FD_Data5")+"</td><td align=center>"+J+"</td><td align=center>"+"�ӽФ�"+"</td><td align=center>"+AD1+"<br>"+AD2_1+"</td></tr>";	
		}
		if(!Rs.next()) break;
		
	}
}
else
{
	result+="<tr><td align=center colspan=7>�S�����</td></tr>";
}
table_start="<div align=center width='100%'>�|�p�b�Ƚվ��-�d��(�ӽФ�)</div><table style='border:2px #cccccc solid;' width='100%'>";
form="<tr><th width='14%'>���ɤH</th><th width='13.6%'>�ӽнs��</th><th width='13.3%'>�ӽ����O</th><th width='27.3%'>�D��</th><th width='8%'>�f�֧_</th><th width='11.3%'>�ӽЪ��A</th><th width='12.5%'>�ӽЮɶ�</th></tr>";
table_end="</table></body></html>";

//-----------mail�o�e���e--------------	
String smtphost = "mail2.chungyo.com.tw";        				//�ǰe�l����A��
String mailuser = "c20201";                      				//�l����A���n�J�ϥΪ̦W��
String mailpassword = "5j/u.19cji";              				//�l����A���n�J�K�X
String from = "chungyoLion@mail2.chungyo.com.tw"; 				//�ǰe�H�l��a�}
String to = "cy7022@mail2.chungyo.com.tw";        				//�����H�l��a�}
String subject = "���ձH�e";                    				//�l����D
String bodycontent = table_start+form+result+table_end;   		//�l�󤺮e
String CC1 = "cljh20220@gmail.com";
String CC2 = "cljh20220@gmail.com";
//-----------mail�ǰe�{��--------------
Properties props = new Properties();
props.put("mail.smtp.host", smtphost);
props.put("mail.smtp.auth","true");
Session ssn = Session.getInstance(props, null);

MimeMessage message = new MimeMessage(ssn);

InternetAddress fromAddress = new InternetAddress(from);
message.setFrom(fromAddress);
InternetAddress[] sendTo = InternetAddress.parse(to);
message.setRecipients(MimeMessage.RecipientType.TO, sendTo);
message.addRecipient(Message.RecipientType.TO, new InternetAddress(CC1));
message.addRecipient(Message.RecipientType.TO, new InternetAddress(CC2));
		
message.setSubject(subject,"UTF-8");
message.setContent(bodycontent, "text/html; charset=utf-8");
		
Transport transport = ssn.getTransport("smtp");
transport.connect(smtphost, mailuser, mailpassword);
transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
transport.close();		
//-----------�H�X���\�q��--------------
out.print(d1+"/"+d2+"/"+d3+"~"+d4+"/"+d5+"/"+d6+"&nbsp;(�|�p�b�Ƚվ��-�d��:�ӽФ�)&nbsp;�w���\�H�X!");
//-----------����----------------------		
Rs.close();
Conn.close();
%>

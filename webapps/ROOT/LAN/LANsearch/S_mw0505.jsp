<%@ page contentType="text/xml; charset=big5"%>
<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page import="java.util.Properties,javax.mail.Message,javax.mail.Session,javax.mail.Transport,javax.mail.internet.InternetAddress,javax.mail.internet.MimeMessage" %>
<%
String SqlStr="",result="",form="";
form="<caption>��¾�H�����</caption><tr><th width=60px>�u��</th><th width=60px>�m�W</th><th width=80px>��¾���</th></tr>";
//------------�����s�����֨�����---------------------
NoCatch(response);
//-------------����d��------------------------------
String D1=req("D1",request);
String D2=req("D2",request);
//-------------�����ܽd��1�ɹs---------------------
String FD_Data1Arr[]=null,d1="",d2="",d3="";
FD_Data1Arr=D1.split("/");
d1=FD_Data1Arr[0];
d2=String.format("%02d",  Integer.parseInt(FD_Data1Arr[1])); //�N�r���ഫ���Ʀr�A�M��A�ഫ���r��//�j��b�Ʀr�e��1��0   //1=�e��0�ҥh��;2=�S0��1��0�A���h����;3=��2��0;�̦�����
d3=String.format("%02d",  Integer.parseInt(FD_Data1Arr[2]));
//-------------�����ܽd��2�ɹs---------------------
String FD_Data2Arr[]=null,d4="",d5="",d6="";
FD_Data2Arr=D2.split("/");
d4=FD_Data2Arr[0];
d5=String.format("%02d",  Integer.parseInt(FD_Data2Arr[1])); 
d6=String.format("%02d",  Integer.parseInt(FD_Data2Arr[2]));
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select m002_no,m002_name,m002_ddate from manf002 where m002_ddate BETWEEN'"+d1+"-"+d2+"-"+d3+"' AND'"+d4+"-"+d5+"-"+d6+"' order by m002_ddate"; //�̷ӿ������d��
ResultSet Rs=stmt.executeQuery(SqlStr);
while(Rs.next())
    {
        result+="<tr><td align=center>"+Rs.getString("m002_no")+"</td>"+"<td align=center>"+Rs.getString("m002_name")+"</td>"+"<td align=center>"+Rs.getString("m002_ddate")+"</td></tr>";
    }

	/*mail�o�e*/
	
		String smtphost = "mail2.chungyo.com.tw"; // �ǰe�l����A��
		String mailuser = "c20201"; // �l����A���n�J�ϥΪ̦W��
		String mailpassword = "5j/u.19cji"; // �l����A���n�J�K�X
		String from = "chungyoLion@mail2.chungyo.com.tw"; // �ǰe�H�l��a�}
		String to = "cy7022@mail2.chungyo.com.tw"; // �����H�l��a�}
		String subject = "���ձH�e"; // �l����D
		String bodycontent = "<table style='border:2px #cccccc solid;' width=200px>"+form+result+"</table></body></html>"; // �l�󤺮e

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
		
		message.setSubject(subject,"UTF-8");
		message.setContent(bodycontent, "text/html; charset=utf-8");
		
		Transport transport = ssn.getTransport("smtp");
		transport.connect(smtphost, mailuser, mailpassword);
		transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
		transport.close();
		
Rs.close();
stmt.close();
conn.close();
out.print(D1+"~"+D2);
out.print("���w�H�X");
%>

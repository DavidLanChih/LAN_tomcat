<%@ page contentType="text/xml; charset=big5"%>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ page import="java.util.Properties,javax.mail.Message,javax.mail.Session,javax.mail.Transport,javax.mail.internet.InternetAddress,javax.mail.internet.MimeMessage" %>
<%@ include file="/cykernel.jsp" %>

<%
String SqlStr="";
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select m002_no,m002_name,m002_ddate from manf002 where m002_ddate>='20210301' order by m002_ddate"; //���>=20210301�A�̤u������
ResultSet Rs=stmt.executeQuery(SqlStr);

if(Rs.next())
{
	Rs.getString("m002_no");
	Rs.getString("m002_name");
	Rs.getString("m002_ddate");	
	
}
	
	/*mail�o�e*/
	
		String smtphost = "mail2.chungyo.com.tw"; // �ǰe�l����A��
		String mailuser = "c20201"; // �l����A���n�J�ϥΪ̦W��
		String mailpassword = "5j/u.19cji"; // �l����A���n�J�K�X
		String from = "chungyoLion@mail2.chungyo.com.tw"; // �ǰe�H�l��a�}
		String to = "cy7022@mail2.chungyo.com.tw"; // �����H�l��a�}
		String subject = "���ձH�e"; // �l����D
		String bodycontent = Rs.getString("m002_no")+Rs.getString("m002_name")+Rs.getString("m002_ddate"); // �l�󤺮e

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
out.print("�w�H�X");
%>

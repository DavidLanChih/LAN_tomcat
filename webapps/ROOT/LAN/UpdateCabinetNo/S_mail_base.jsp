<%@ page contentType="text/xml; charset=big5"%>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ page import="java.util.Properties,javax.mail.Message,javax.mail.Session,javax.mail.Transport,javax.mail.internet.InternetAddress,javax.mail.internet.MimeMessage" %>

<%

out.println("132");
	/*mail�o�e*/
	
		String smtphost = "mail2.chungyo.com.tw"; // �ǰe�l����A��
		String mailuser = "c20201"; // �l����A���n�J�ϥΪ̦W��
		String mailpassword = "5j/u.19cji"; // �l����A���n�J�K�X
		String from = "chungyoLion@mail2.chungyo.com.tw"; // �ǰe�H�l��a�}
		String to = "cljh20220@gmail.com,cljh20220@yahoo.com.tw"; // �����H�l��a�}
		String to2 = "cy7022@mail2.chungyo.com.tw";
		String subject = "���ձH�e"; // �l����D
		String body = "�L���z�|"; // �l�󤺮e

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
		InternetAddress[] sendCC = InternetAddress.parse(to2);
        message.setRecipients(MimeMessage.RecipientType.CC, sendCC);
		
		message.setSubject(subject,"UTF-8");
		message.setText(body,"UTF-8");

		Transport transport = ssn.getTransport("smtp");
		transport.connect(smtphost, mailuser, mailpassword);
		transport.sendMessage(message, message.getAllRecipients());
		transport.close();
%>

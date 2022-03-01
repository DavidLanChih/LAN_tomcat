<%@ page contentType="text/xml; charset=big5"%>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ page import="java.util.Properties,javax.mail.Message,javax.mail.Session,javax.mail.Transport,javax.mail.internet.InternetAddress,javax.mail.internet.MimeMessage" %>

<%

out.println("132");
	/*mail發送*/
	
		String smtphost = "mail2.chungyo.com.tw"; // 傳送郵件伺服器
		String mailuser = "c20201"; // 郵件伺服器登入使用者名稱
		String mailpassword = "5j/u.19cji"; // 郵件伺服器登入密碼
		String from = "chungyoLion@mail2.chungyo.com.tw"; // 傳送人郵件地址
		String to = "cljh20220@gmail.com,cljh20220@yahoo.com.tw"; // 接受人郵件地址
		String to2 = "cy7022@mail2.chungyo.com.tw";
		String subject = "測試寄送"; // 郵件標題
		String body = "無須理會"; // 郵件內容

		// 以下為傳送程式，使用者無需改動

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

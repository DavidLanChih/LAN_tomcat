<%@ page contentType="text/xml; charset=big5"%>
<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page import = "java.io.*,java.util.*,javax.mail.*"%>
<%@ page import = "javax.mail.internet.*,javax.activation.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%
String SqlStr="",result="",form="";
form="<caption>��¾�H�����</caption><tr><th width=60px>�u��</th><th width=60px>�m�W</th><th width=80px>��¾���</th></tr>";
//------------�����s�����֨�����---------------------
NoCatch(response);
//-------------����d��------------------------------
String D1=req("C1",request);
String D2=req("C2",request);
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
	
		String result1;
   
   // Recipient's email ID needs to be mentioned.
   String to = "cy7022@mail2.chungyo.com.tw";

   // Sender's email ID needs to be mentioned
   String from = "chungyoLion@mail2.chungyo.com.tw";

   // Assuming you are sending email from localhost
   String host = "mail2.chungyo.com.tw";
   String psd = "5j/u.19cji";
   String user = "c20201";

   // Get system properties object
   Properties properties = System.getProperties();

   // Setup mail server
   properties.setProperty("mail.smtp.host", host);

   // Get the default Session object.
   Session mailSession = Session.getDefaultInstance(properties);
	
	
   
   try {
	   properties.setProperty( "mail.transport.protocol", "smtp" );
	  // �ھ�session������o�l��ǿ骫��Transport
	  Transport transport = mailSession.getTransport(); 
	   
      // Create a default MimeMessage object.
      MimeMessage message = new MimeMessage(mailSession);

      // Set From: header field of the header.
      message.setFrom(new InternetAddress(from));

      // Set To: header field of the header.
      message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

      // Set Subject: header field
      message.setSubject("This is the Subject Line!");

      // Create the message part 
      BodyPart messageBodyPart = new MimeBodyPart();

      // Fill the message
      messageBodyPart.setText("This is message body");
      
      // Create a multipart message
      Multipart multipart = new MimeMultipart();

      // Set text message part
      multipart.addBodyPart(messageBodyPart);

      // Part two is attachment
      messageBodyPart = new MimeBodyPart();
      
	  transport.connect(host,user,psd);
	  
      String filename = "file.txt";
      DataSource source = new FileDataSource(filename);
      messageBodyPart.setDataHandler(new DataHandler(source));
      messageBodyPart.setFileName(filename);
      multipart.addBodyPart(messageBodyPart);

      // Send the complete message parts
      message.setContent(multipart );

      // Send message
      Transport.send(message);
      String title = "Send Email";
      result1 = "Sent message successfully....";
   } catch (MessagingException mex) {
      mex.printStackTrace();
      result1 = "Error: unable to send message....";
   }
		
Rs.close();
stmt.close();
conn.close();
out.print(d1+d2+d3+"~"+d4+d5+d6);
out.print("���w�H�X");
%>

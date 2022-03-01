<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
//-----------mail發送內容--------------	
String smtphost = "mail2.chungyo.com.tw";        						//傳送郵件伺服器
String mailuser = "c20201";                      						//郵件伺服器登入使用者名稱
String mailpassword = "5j/u.19cji";              						//郵件伺服器登入密碼
String from = "chungyoLion@mail2.chungyo.com.tw"; 						//傳送人郵件地址
String to = "cy7022@mail2.chungyo.com.tw";        						//接受人郵件地址
String subject = "測試寄送";                    						//郵件標題
String bodycontent = "HI~<br>HI~";   		                        		    //郵件內容
String CC1 = "cljh20220@gmail.com";
//-----------mail傳送程式--------------
Properties props = new Properties();
props.put("mail.smtp.host", smtphost);
props.put("mail.smtp.auth","true");
Session ssn = Session.getInstance(props, null);

MimeMessage message = new MimeMessage(ssn);                  		    //建立MimeMessage物件

message.setFrom(new InternetAddress(from));                  		    //建立mail的來源信箱物件
message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));//建立mail的接收者信箱物件
message.addRecipient(Message.RecipientType.TO, new InternetAddress(CC1));
message.setSubject(subject,"UTF-8");                                    //建立mail的標題物件
message.setContent(bodycontent, "text/html; charset=utf-8");            //建立mail的內容物件

//------宣告訊息包裹-----------
BodyPart messageBodyPart = new MimeBodyPart();
messageBodyPart.setText(bodycontent);                        		     //將信件內文儲存於messageBodyPart

Multipart multipart = new MimeMultipart();                     		     //宣告多重資料物件
multipart.addBodyPart(messageBodyPart);                    			     //將messageBodyPart儲存於多重資料物件

//------附件資料-----------
messageBodyPart = new MimeBodyPart();
String filesource = "D:/Portal/web/Modules/ServiceFormCheck9/File.txt";  //附件路徑
DataSource source = new FileDataSource(filesource);
messageBodyPart.setDataHandler(new DataHandler(source));
String Filename="attachment";                                            //附件名稱
messageBodyPart.setFileName(Filename);     
multipart.addBodyPart(messageBodyPart);                                  //將附件資料儲存於多重資料物件

message.setContent(multipart );

File file=new File(filesource);                                          //宣告檔案(路徑)
		
Transport transport = ssn.getTransport("smtp");
transport.connect(smtphost, mailuser, mailpassword);
transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
transport.close();		
//-----------寄出成功通知--------------
 if(!file.exists())                                                      //exists()需用於是否有其檔案
 {
	out.print("沒有附件"); 
 }
out.print("已成功寄出!");
//-----------釋放----------------------		
%>
<%@ include file="/kernel.jsp" %>
<%@ page import="java.io.*,java.util.*,javax.mail.*,java.util.Timer,java.util.TimerTask"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page contentType="text/html;charset=MS950" %>
<%@ include file="/APP3.0-TC.jsp" %>
<%
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
//--------------傳送來的資料-------------------
String C1=req("C1",request);           //舊櫃號
String C2=req("C2",request);           //新櫃號
String old_ID=C1.toUpperCase();
String new_ID=C2.toUpperCase();
//-----------防止瀏覽器快取網頁----------------
NoCatch(response);
//-------------更新資料表內容------------------
String SqlStr="";
Statement stmt=connTC.createStatement();                                              
SqlStr="update CHANGE_GOODS set COUNTER_ID='"+new_ID+"'where COUNTER_ID='"+old_ID+"'";                   //更新CHANGE_GOODS表單
SqlStr+="update GOODS_COUNTER set COUNTER_ID='"+new_ID+"'where COUNTER_ID='"+old_ID+"'";                 //更新GOODS_COUNTER表單
SqlStr+="update GOODS set SUPPLIER_ID='"+new_ID+"'where SUPPLIER_ID='"+old_ID+"'";                       //更新GOODS表單
SqlStr+="update GOODS_EC_PRICE set COUNTER_ID='"+new_ID+"'where COUNTER_ID='"+old_ID+"'";                //更新GOODS_EC_PRICE表單
stmt.execute(SqlStr);
//------------------釋放-----------------------
out.print("舊櫃號:"+old_ID+"&nbsp;&nbsp;轉成新櫃號:"+new_ID+"&nbsp;&nbsp;轉移成功！<br>");
out.print("E-mail至商務資訊課人員(正本:cy6213,cy6957 副本:cy6909)&nbsp;&nbsp;:");
stmt.close();
connTC.close();



//----------------製作txt檔案------------------
//----------------<宣告時間>-------------------
String TransferDate=JDate.Now();
String[] TS = TransferDate.split("/");
String[] TSS =TS[2].split(" ");
String[] TSSS =TSS[1].split(":");
String T=TS[0]+TS[1]+TSS[0]+TSSS[0]+TSSS[1];
String path = request.getRealPath("/Modules/UpdateCabinetNo/TransferRecord");                            //儲存位置
FileWriter fw = new FileWriter(path + "//TransferCabinetNo"+T+".txt");                                   //建立文件檔名(寫進文件)
//--------------<寫入文件內容>-----------------
fw.write("舊櫃號:"+old_ID+"\0轉成新櫃號:"+new_ID+"\n");
fw.write("Statement stmt=connTC.createStatement();\n");
fw.write("SqlStr="+"update CHANGE_GOODS set COUNTER_ID='"+new_ID+"'where COUNTER_ID='"+old_ID+"';\n");
fw.write("SqlStr+="+"update GOODS_COUNTER set COUNTER_ID='"+new_ID+"'where COUNTER_ID='"+old_ID+"';\n");
fw.write("SqlStr+="+"update GOODS set SUPPLIER_ID='"+new_ID+"'where SUPPLIER_ID='"+old_ID+"';\n");
fw.write("SqlStr+="+"update GOODS_EC_PRICE set COUNTER_ID='"+new_ID+"'where COUNTER_ID='"+old_ID+"';\n");
fw.write("stmt.execute(SqlStr);");
fw.close();                                                                                              //關閉檔案                                                                                             //關閉檔案




//----------------mail發送內容-----------------	
String smtphost = "mail2.chungyo.com.tw";        						                                 //傳送郵件伺服器
String mailuser = "c20201";                      						                                 //郵件伺服器登入使用者名稱
String mailpassword = "5j/u.19cji";              					                                	 //郵件伺服器登入密碼
String from = "chungyoLion@mail2.chungyo.com.tw"; 					                                	 //傳送人郵件地址
String to = "cy7022@mail2.chungyo.com.tw";        						                                 //接受人郵件地址(正本)
String subject = "櫃號轉移通知";                    					                                 //郵件標題
String bodycontent = "櫃號轉移成功！";   		                                                         //郵件內容

//-------------<<mail傳送程式設定>>------------
Properties props = new Properties();                                                                     //建立Properties物件
props.put("mail.smtp.host", smtphost);									 
props.put("mail.smtp.auth","true");
Session ssn = Session.getInstance(props, null);                                                          //建立Session物件
MimeMessage message = new MimeMessage(ssn);                  		                                     //建立MimeMessage物件
message.setFrom(new InternetAddress(from));                  		                                     //設定寄件人信箱
message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));                                 //設定收件人信箱(正本)
//------------------<建立內文>-----------------
BodyPart messageBodyPart0 = new MimeBodyPart();                                                          //建立BodyPart物件
messageBodyPart0.setContent(bodycontent,"text/html; charset=UTF-8");                                     //設定mail的內容(套用html格式)並將內文儲存於messageBodyPart，及設定內文格式
//------------------<建立附件>-----------------
BodyPart messageBodyPart1 = new MimeBodyPart();                                                          //建立一個BodyPart物件
String filesource = "D:/Portal/web/Modules/UpdateCabinetNo/TransferRecord/TransferCabinetNo"+T+".txt";   //附件路徑
DataSource source = new FileDataSource(filesource);
messageBodyPart1.setDataHandler(new DataHandler(source));
String Filename="TransferCabinetNo"+T+"";                                                                //附件名稱
messageBodyPart1.setFileName(Filename);     
//----------------<內文+附件包裹>--------------
Multipart multipart = new MimeMultipart();                     		                                     //建立Multipart物件
multipart.addBodyPart(messageBodyPart0);                                                                 //將信件內文儲存於Multipart
multipart.addBodyPart(messageBodyPart1);                                                                 //將附件資料儲存於Multipart
message.setContent(multipart);                                                                           //設定寄送內容為Multipart
//------------------<傳送總匯>-----------------
Transport transport = ssn.getTransport("smtp");
transport.connect(smtphost, mailuser, mailpassword);
transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
transport.close();


out.print("寄信成功！");
%>
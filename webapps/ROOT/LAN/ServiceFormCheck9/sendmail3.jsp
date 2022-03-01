<%@ page contentType="text/xml; charset=UTF-8"%>
<%@ include file="/kernel.jsp" %>
<%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%
//-----------防止瀏覽器快取網頁--------
NoCatch(response);
//-----------日期範圍------------------
String D1=req("T1",request);											 //取得開始日期
String D2=req("T2",request);											 //取得結束日期
//-----------開始日期補零--------------
String FD_Data1Arr[]=null,d1="",d2="",d3="";
FD_Data1Arr=D1.split("/");
d1=FD_Data1Arr[0];
d2=String.format("%02d",  Integer.parseInt(FD_Data1Arr[1])); 
d3=String.format("%02d",  Integer.parseInt(FD_Data1Arr[2]));
//-----------結束日期補零--------------
String FD_Data2Arr[]=null,d4="",d5="",d6="";
FD_Data2Arr=D2.split("/");
d4=FD_Data2Arr[0];
d5=String.format("%02d",  Integer.parseInt(FD_Data2Arr[1])); 
d6=String.format("%02d",  Integer.parseInt(FD_Data2Arr[2]));
//-----------MS-SQL資料庫欄位呼叫------
String SqlStr="";
ResultSet Rs=null;
SqlStr="select FR_RecId,FD_OrgId,FR_FormId,FR_DataId,FD_FormId,FD_Data1,FD_Data3,FD_Data4,FD_Data5,FD_Data15,FR_FinishState,FD_RecDate from flow_formdata,flow_form_rulestage where flow_formdata.FD_RecId="+
"flow_form_rulestage.FR_DataId and flow_formdata.FD_FormId IN ('207')"+
"and (CONVERT(varchar(10),CONVERT(datetime,FD_Data2,111),111)  BETWEEN  '"+d1+"/"+d2+"/"+d3+"' and '"+d4+"/"+d5+"/"+d6+"')";
Rs=Data.getSmt(Conn,SqlStr);
//-----------宣告表格內容--------------
String result="",form="",table_start="",table_end="";
if(Rs.next())
{
	for(int i=0;i<1000;i++)
	{
		String Mark="";
		Mark=Rs.getString("FR_FinishState");
		if(Mark.equals("0"))
		{
		//-----------建檔人--------------------
		String build[]=null;
		build=Rs.getString("FD_Data1").split(",");
		String buildman=build[1];
		//-----------申請編號("FD_Data3")------
		//-----------申請類別------------------
		String applytype[]=null;
		applytype=Rs.getString("FD_Data4").split(",");
		String AT=applytype[1];
		//-----------主旨("FD_Data5")----------
		//-----------第五關審核填寫N或Y--------
		String judge[]=null;
		judge=Rs.getString("FD_Data15").split(",");
		String J=judge[0];
		//-----------申請狀態("申請中")--------
		//-----------申請時間------------------
		String applydate[]=null;
		applydate=Rs.getString("FD_RecDate").split(" ");
		String AD1=applydate[0];
		String AD2=applydate[1];
		String AD2_1=AD2.substring(0,8);                         		 //只取(時:分:秒)
		//-----------內容總成------------------
		result+="<tr><td align=center>"+buildman+"</td>"+"<td align=center>"+Rs.getString("FD_Data3")+"</td>"+"<td align=center>"+AT+"</td><td align=center>"+Rs.getString("FD_Data5")+"</td><td align=center>"+J+"</td><td align=center>"+"申請中"+"</td><td align=center>"+AD1+"<br>"+AD2_1+"</td></tr>";	
		}
		if(!Rs.next()) break;
		
	}
}
else
{
	result+="<tr><td align=center colspan=7>沒有資料</td></tr>";
}
table_start="<div align=center width='100%'>會計帳務調整單-查詢(申請中)</div><table style='border:2px #cccccc solid;' width='100%'>";
form="<tr><th width='14%'>建檔人</th><th width='13.6%'>申請編號</th><th width='13.3%'>申請類別</th><th width='27.3%'>主旨</th><th width='8%'>審核否</th><th width='11.3%'>申請狀態</th><th width='12.5%'>申請時間</th></tr>";
table_end="</table></body></html>";

//-----------mail發送內容--------------	

String smtphost = "mail2.chungyo.com.tw";        						 //傳送郵件伺服器
String mailuser = "c20201";                      						 //郵件伺服器登入使用者名稱
String mailpassword = "5j/u.19cji";              						 //郵件伺服器登入密碼
String from = "chungyoLion@mail2.chungyo.com.tw"; 						 //傳送人郵件地址
String to = "cljh20220@yahoo.com.tw";        						     //接受人郵件地址(正本)
String subject = "測試寄送";                    						 //郵件標題
String bodycontent = table_start+form+result+table_end;   		         //郵件內容
String CC1 = "cy7022@mail2.chungyo.com.tw";						                 //接受人郵件地址(副本1)cljh20220@gmail.com
String CC2 = "cljh20220@gmail.com";						             //接受人郵件地址(副本2)cljh20220@yahoo.com.tw
String BCC = "cljh20220@gmail.com";						         //接受人郵件地址(密件)cy7022@mail2.chungyo.com.tw

//--<<mail傳送程式設定>>--
Properties props = new Properties();                                     //建立Properties物件
props.put("mail.smtp.host", smtphost);									 
props.put("mail.smtp.auth","true");
Session ssn = Session.getInstance(props, null);                          //建立Session物件
MimeMessage message = new MimeMessage(ssn);                  		     //建立MimeMessage物件
message.setFrom(new InternetAddress(from));                  		     //設定寄件人信箱
message.addRecipient(Message.RecipientType.TO, new InternetAddress(to)); //設定收件人信箱(正本)
message.addRecipient(Message.RecipientType.CC, new InternetAddress(CC1));//設定收件人信箱(副本1)
message.addRecipient(Message.RecipientType.CC, new InternetAddress(CC2));//設定收件人信箱(副本2)
message.addRecipient(Message.RecipientType.BCC, new InternetAddress(BCC));//設定收件人信箱(密件)
message.setSubject(subject,"UTF-8");                                     //設定mail的主旨
//-----<建立內文>---------
BodyPart messageBodyPart0 = new MimeBodyPart();                          //建立BodyPart物件
messageBodyPart0.setContent(bodycontent,"text/html; charset=UTF-8");     //設定mail的內容(套用html格式)並將內文儲存於messageBodyPart，及設定內文格式

//-----<建立附件>---------
BodyPart messageBodyPart1 = new MimeBodyPart();                          //建立一個BodyPart物件
String filesource = "D:/Portal/web/Modules/ServiceFormCheck9/index.jsp";   //附件路徑
DataSource source = new FileDataSource(filesource);
messageBodyPart1.setDataHandler(new DataHandler(source));
String Filename="attachment";                                            //附件名稱
messageBodyPart1.setFileName(Filename);     

//-----<內文+附件包裹>----
Multipart multipart = new MimeMultipart();                     		     //建立Multipart物件
multipart.addBodyPart(messageBodyPart0);                                 //將信件內文儲存於Multipart
multipart.addBodyPart(messageBodyPart1);                                 //將附件資料儲存於Multipart
message.setContent(multipart);                                           //設定寄送內容為Multipart
//-----<傳送總匯>---------
Transport transport = ssn.getTransport("smtp");
transport.connect(smtphost, mailuser, mailpassword);
transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
transport.close();
		
//-----------寄出成功通知--------------
out.print(d1+"/"+d2+"/"+d3+"~"+d4+"/"+d5+"/"+d6+"&nbsp;(會計帳務調整單-查詢:申請中)&nbsp;已成功寄出!");
//-----------釋放----------------------		
Rs.close();
Conn.close();
%>

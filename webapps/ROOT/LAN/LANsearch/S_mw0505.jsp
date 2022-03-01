<%@ page contentType="text/xml; charset=big5"%>
<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page import="java.util.Properties,javax.mail.Message,javax.mail.Session,javax.mail.Transport,javax.mail.internet.InternetAddress,javax.mail.internet.MimeMessage" %>
<%
String SqlStr="",result="",form="";
form="<caption>離職人員表單</caption><tr><th width=60px>工號</th><th width=60px>姓名</th><th width=80px>離職日期</th></tr>";
//------------防止瀏覽器快取網頁---------------------
NoCatch(response);
//-------------日期範圍------------------------------
String D1=req("D1",request);
String D2=req("D2",request);
//-------------日期選擇範圍1補零---------------------
String FD_Data1Arr[]=null,d1="",d2="",d3="";
FD_Data1Arr=D1.split("/");
d1=FD_Data1Arr[0];
d2=String.format("%02d",  Integer.parseInt(FD_Data1Arr[1])); //將字串轉換成數字，然後再轉換成字串//強制在數字前補1個0   //1=前面0皆去除;2=沒0補1個0，有則不補;3=補2個0;依此類推
d3=String.format("%02d",  Integer.parseInt(FD_Data1Arr[2]));
//-------------日期選擇範圍2補零---------------------
String FD_Data2Arr[]=null,d4="",d5="",d6="";
FD_Data2Arr=D2.split("/");
d4=FD_Data2Arr[0];
d5=String.format("%02d",  Integer.parseInt(FD_Data2Arr[1])); 
d6=String.format("%02d",  Integer.parseInt(FD_Data2Arr[2]));
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select m002_no,m002_name,m002_ddate from manf002 where m002_ddate BETWEEN'"+d1+"-"+d2+"-"+d3+"' AND'"+d4+"-"+d5+"-"+d6+"' order by m002_ddate"; //依照選取日期範圍
ResultSet Rs=stmt.executeQuery(SqlStr);
while(Rs.next())
    {
        result+="<tr><td align=center>"+Rs.getString("m002_no")+"</td>"+"<td align=center>"+Rs.getString("m002_name")+"</td>"+"<td align=center>"+Rs.getString("m002_ddate")+"</td></tr>";
    }

	/*mail發送*/
	
		String smtphost = "mail2.chungyo.com.tw"; // 傳送郵件伺服器
		String mailuser = "c20201"; // 郵件伺服器登入使用者名稱
		String mailpassword = "5j/u.19cji"; // 郵件伺服器登入密碼
		String from = "chungyoLion@mail2.chungyo.com.tw"; // 傳送人郵件地址
		String to = "cy7022@mail2.chungyo.com.tw"; // 接受人郵件地址
		String subject = "測試寄送"; // 郵件標題
		String bodycontent = "<table style='border:2px #cccccc solid;' width=200px>"+form+result+"</table></body></html>"; // 郵件內容

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
out.print("表單已寄出");
%>

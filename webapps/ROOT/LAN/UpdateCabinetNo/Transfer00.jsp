<%@ include file="/kernel.jsp" %>
<%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page contentType="text/html;charset=MS950" %>
<%@ include file="/APP3.0-TC.jsp" %>

<%
//-----------防止瀏覽器快取網頁----------------
NoCatch(response);
//----------------<宣告時間>-------------------
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String TransferDate=JDate.Now();
ResultSet Rs=null;
String EDate=JDate.ToDay();
String[] TS = TransferDate.split("/");
String[] TSS =TS[2].split(" ");
String[] TSSS =TSS[1].split(":");
String T=TS[0]+TS[1]+TSS[0]+TSSS[0]+TSSS[1];
String[] TT =TransferDate.split(" ");
String SqlStrB="";
SqlStrB="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','開始...')";
Data.ExecUpdateSql(Conn,SqlStrB);
//-----------抓取MS-SQL資料庫內容--------------
String SqlStrPASS="",FR_DataId="",SqlStr1="",SqlStr2="",Reply="",SqlStrE="",ERRORmessage="";
ResultSet Rs1=null;

SqlStrPASS="select FR_DataId from flow_form_rulestage where FR_FormAP='JFlow_Form_279' and FR_FinishState='1'";
Rs1=Data.getSmt(Conn,SqlStrPASS);

if(Rs1.next())
{
	for(int i=0;i<1000;i++)
	{ 
		FR_DataId=Rs1.getString("FR_DataId");
		//out.print("FR_DataId:"+FR_DataId+"<br>");                                        //每筆表單號碼
		String SqlStrDATA="",FD_1_old="",FD_1_new="",FD_2_old="",FD_2_new="",old_ID_1="",new_ID_1="",old_ID_2="",new_ID_2="";
		ResultSet Rs2=null;
		SqlStrDATA="select FD_Data5,FD_Data6,FD_Data7,FD_Data8 from flow_formdata where FD_RecId='"+FR_DataId+"' and FD_Data4<'"+EDate+"'";
		Rs2=Data.getSmt(Conn,SqlStrDATA);
		
		//----------------製作txt檔案------------------
		String path = request.getRealPath("/Modules/UpdateCabinetNo/TransferRecord");                                 	    //TXT儲存位置
		FileWriter fw = new FileWriter(path + "//TransferCabinetNo"+T+".txt");                                        	    //建立文件檔名(寫進文件)
		
		if(Rs2.next())
		{
			
			String[] FD_1_oldArr=Rs2.getString("FD_Data5").split(":");                     //1.舊櫃號
			FD_1_old=FD_1_oldArr[0];
			
			String[] FD_1_newArr=Rs2.getString("FD_Data6").split(":");                     //1.新櫃號
			FD_1_new=FD_1_newArr[0];

			String[] FD_2_oldArr=Rs2.getString("FD_Data7").split(":");                     //2.舊櫃號
			FD_2_old=FD_2_oldArr[0];
			
			String[] FD_2_newArr=Rs2.getString("FD_Data8").split(":");                     //2.新櫃號
			FD_2_new=FD_2_newArr[0];
			
			old_ID_1=FD_1_old.toUpperCase();
			new_ID_1=FD_1_new.toUpperCase();
			old_ID_2=FD_2_old.toUpperCase();
			new_ID_2=FD_2_new.toUpperCase();
			
			//--------------------------------------防呆設定----------------------------------------------
			ERRORmessage="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','表單:"+FR_DataId+" 轉移失敗!')";

			if(!FD_2_old.equals("") && FD_2_new.equals(""))
			{
				Reply+="表單:"+FR_DataId+"<br>1.舊櫃號:"+FD_1_old+" 但 2.新櫃號:"+FD_1_new+" 沒有資料 => 轉移失敗！<br>";
				SqlStrB=ERRORmessage;
				Data.ExecUpdateSql(Conn,SqlStrB);
				if(FD_1_old.equals("") || FD_1_new.equals(""))
				{
					Reply+="表單:"+FR_DataId+"<br>1.舊櫃號:"+FD_1_old+" 或 1.新櫃號:"+FD_1_new+" 沒有資料 => 轉移失敗！<br>";
					SqlStrB=ERRORmessage;
					Data.ExecUpdateSql(Conn,SqlStrB);
				}
			}	
			else if(FD_1_old.equals(FD_1_new))
			{
				Reply+="表單:"+FR_DataId+"<br>1.舊櫃號:"+FD_1_old+" 與 1.新櫃號:"+FD_1_new+" 相同 => 轉移失敗！<br>";
				SqlStrB=ERRORmessage;
				Data.ExecUpdateSql(Conn,SqlStrB);
			}
			else if(FD_1_old.equals(FD_2_old))
			{
				Reply+="表單:"+FR_DataId+"<br>1.舊櫃號:"+FD_1_old+" 與 2.舊櫃號:"+FD_1_new+" 相同 => 轉移失敗！<br>";
				SqlStrB=ERRORmessage;
				Data.ExecUpdateSql(Conn,SqlStrB);
			}
			else if(FD_1_new.equals(FD_2_new))
			{
				Reply+="表單:"+FR_DataId+"<br>1.新櫃號:"+FD_1_old+" 與 2.新櫃號:"+FD_1_new+" 相同 => 轉移失敗！<br>";
				SqlStrB=ERRORmessage;
				Data.ExecUpdateSql(Conn,SqlStrB);
			}
			
		    //--------------------------------------更新資料表內容---------------------------------------------
			else if(!FD_1_old.equals("") && !FD_1_new.equals(""))             //第一組櫃號轉移
			{
				Statement stmt=connTC.createStatement();                                              
				SqlStr1="update CHANGE_GOODS set COUNTER_ID='"+new_ID_1+"'where COUNTER_ID='"+old_ID_1+"'";                   //更新CHANGE_GOODS表單
				SqlStr1+="update GOODS_COUNTER set COUNTER_ID='"+new_ID_1+"'where COUNTER_ID='"+old_ID_1+"'";                 //更新GOODS_COUNTER表單
				SqlStr1+="update GOODS set SUPPLIER_ID='"+new_ID_1+"'where SUPPLIER_ID='"+old_ID_1+"'";                       //更新GOODS表單
				SqlStr1+="1""update GOODS_EC_PRICE set COUNTER_ID='"+new_ID_1+"'where COUNTER_ID='"+old_ID_1+"'"; 
out.println(SqlStr1);				//更新GOODS_EC_PRICE表單
				//stmt.execute(SqlStr1);
				Reply+="表單:"+FR_DataId+"<br>1.舊櫃號:"+FD_1_old+" 轉成 1.新櫃號:"+FD_1_new+" 轉移成功！<br>";
				stmt.close();
							
				if(!FD_2_old.equals("") && !FD_2_new.equals(""))              //第二組櫃號轉移
				{
					Statement stmt2=connTC.createStatement();                                              
					SqlStr2="update CHANGE_GOODS set COUNTER_ID='"+new_ID_2+"'where COUNTER_ID='"+old_ID_2+"'";                   //更新CHANGE_GOODS表單
					SqlStr2+="update GOODS_COUNTER set COUNTER_ID='"+new_ID_2+"'where COUNTER_ID='"+old_ID_2+"'";                 //更新GOODS_COUNTER表單
					SqlStr2+="update GOODS set SUPPLIER_ID='"+new_ID_2+"'where SUPPLIER_ID='"+old_ID_2+"'";                       //更新GOODS表單
					SqlStr2+="update GOODS_EC_PRICE set COUNTER_ID='"+new_ID_2+"'where COUNTER_ID='"+old_ID_2+"'";                //更新GOODS_EC_PRICE表單
					//stmt2.execute(SqlStr2);
					Reply+="2.舊櫃號:"+FD_2_old+" 轉成 2.新櫃號:"+FD_2_new+" 轉移成功！<br>";
					stmt2.close();
				}					
			}
			else
			{
				Reply+="表單:"+FR_DataId+"<br>1.舊櫃號:"+FD_1_old+" 轉成 1.新櫃號:"+FD_1_new+" 轉移失敗！<br>";
				SqlStrB=ERRORmessage;
				Data.ExecUpdateSql(Conn,SqlStrB);
			}
			
		}	
		//--------------<寫入TXT文件內容>-----------------
		fw.write(SqlStr1);
		fw.write(SqlStr2);
		fw.close();			//關閉檔案	
		SqlStrB="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','表單:"+FR_DataId+" 轉移成功!')";
			Data.ExecUpdateSql(Conn,SqlStrB);
		if(!Rs1.next()) break;	
		
	}
	
}
out.print(Reply);
connTC.close();
Conn.close();
/*
	
//----------------mail發送內容-----------------	
String smtphost = "mail2.chungyo.com.tw";        						                                 //傳送郵件伺服器
String mailuser = "c20201";                      						                                 //郵件伺服器登入使用者名稱
String mailpassword = "5j/u.19cji";              					                                	 //郵件伺服器登入密碼
String from = "chungyoLion@mail2.chungyo.com.tw"; 					                                	 //傳送人郵件地址
String to = "cy6213@mail2.chungyo.com.tw##,cy7022@mail2.chungyo.com.tw##";        						                                 //接受人郵件地址(正本)
String to2 = "cy6096@mail2.chungyo.com.tw";
String CC = "cy6957@mail2.chungyo.com.tw";
String subject = "櫃號轉移通知";                    					                                 //郵件標題
String bodycontent = Reply;   		                                                                     //郵件內容

//-------------<<mail傳送程式設定>>------------
Properties props = new Properties();                                                                     //建立Properties物件
props.put("mail.smtp.host", smtphost);									 
props.put("mail.smtp.auth","true");
Session ssn = Session.getInstance(props, null);                                                          //建立Session物件
MimeMessage message = new MimeMessage(ssn);                  		                                     //建立MimeMessage物件
message.setFrom(new InternetAddress(from));                  		                                     //設定寄件人信箱
message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));                                //設定收件人信箱(正本)
message.addRecipient(Message.RecipientType.TO, new InternetAddress(to2));                                 //設定收件人信箱(正本)
message.addRecipient(Message.RecipientType.CC, new InternetAddress(CC));                                 //設定收件人信箱(副本)
message.setSubject(subject,"UTF-8");                                                                     //設定mail的主旨
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
out.print("------------------------------------------------------------------------------");
out.print("<br>E-mail至商務資訊課人員(正本:cy6213,cy6957 副本:cy6909)：寄信成功！");
*/
%>
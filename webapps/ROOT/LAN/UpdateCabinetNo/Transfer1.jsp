<%@page import="leeten.*" %>
<%@page contentType="text/xml; charset=big5"%>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat" %>
<%@ page pageEncoding="big5"%>
<%@ include file="/APP3.0-TC.jsp" %>
<%@ page import="java.io.*"%>

<%
//-----------防止瀏覽器快取網頁----------------
NoCatch(response);
//----------------宣告時間---------------------
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String NowDate=JDate.ToDay();                //年月日(今日)
String SDate=JDate.DateAdd("D",NowDate,-30); //今日日期-30天("D"為預設代號)
String EDate=JDate.DateAdd("D",NowDate,+1);  //今日日期+1天("D"為預設代號)
String TransferDate=JDate.Now();             //年月日時分秒(目前)
String[] TS = TransferDate.split("/");
String[] TSS =TS[2].split(" ");
String[] TSSS =TSS[1].split(":");
String T=TS[0]+TS[1]+TSS[0]+TSSS[0]+TSSS[1];
String[] TT =TransferDate.split(" ");
//----------------資料庫-----------------------
String SqlStr="",STime="",FDId="",SqlStrEC1="",SqlStrEC2="",SqlStrEC3="",SqlStrEC4="",SqlStrS="";
String BillNo="";
String Data1="",Data2="",Data3="";
String Field5="",Field6="";
int u=0,FCount=0,ICount=0;
String Record="";
SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','開始...')";
Data.ExecUpdateSql(Conn,SqlStr);

try
{
//從FR和FD抓取已審核過(30天內)的資料  
STime="and flow_formdata.FD_Data4<'"+EDate+"'";  //生效日
SqlStr="select flow_form_rulestage.BillNo1,flow_form_rulestage.BillNo2,flow_form_rulestage.FR_FinishTime,flow_formdata.* from flow_formdata,flow_form_rulestage where flow_form_rulestage.FR_FinishTime>'"+SDate+" 00:00' and flow_form_rulestage.FR_FinishTime<'"+NowDate+" 23:59' and flow_form_rulestage.FR_FormAP='JFlow_Form_279' and flow_form_rulestage.FR_FinishState=1 "+STime+"and flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId";
	
ResultSet DRs=null;
DRs=Data.getSmt(Conn,SqlStr);

Statement stmt = connTC.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);

while(DRs.next())
	{	
		
		FCount++;                                                                                            //抓取到的表單數量
		FDId=DRs.getString("FD_RecId");                                                                      //每張表單代號
		
		//用for迴圈跑兩組櫃號
		u=0;
		for(int t=0;t<2;t++)              
		{
			Field5=String.valueOf((t*2)+5);	 
			Field6=String.valueOf((t*2)+6);
			//out.print(Field5);			
			//確認有經辦人
			Data1=DRs.getString("FD_Data1");
			if(!Data1.equals(""))                                                 
			{
				
				//確認BillNo內沒有更新過的標記
				u++;
				if(DRs.getString("BillNo"+u).equals(""))                          
				{
							
					Data2=DRs.getString("FD_Data"+Field5).split(":")[0].trim();                              //原供應商櫃號
					Data3=DRs.getString("FD_Data"+Field6).split(":")[0].trim();                              //轉移供應商櫃號
					
					//核對本機資料庫櫃號有抓到EC資料庫相同櫃號
					/*
					SqlStrEC="select USERS.COUNTER_ID as COUNTER_ID,COUNTER.SHORT_NAME as short_name from USERS, COUNTER where USERS.COUNTER_ID='"+Data2+"'and USERS.STATUS='1' and USERS.COUNTER_ID=COUNTER.COUNTER_ID group by USERS.COUNTER_ID,COUNTER.SHORT_NAME";
					ResultSet ECRs=stmt.executeQuery(SqlStrEC);	
					String COUNTER_ID="";
					COUNTER_ID=ECRs.getString("COUNTER_ID");
					out.print(COUNTER_ID);
					*/
					
					if(!Data2.equals("")) 
					{
						ICount++;                                                                             //有執行更新的每筆紀錄
						
						/*CHANGE_GOODS資料更新*/
						SqlStrEC1="update CHANGE_GOODS set COUNTER_ID='"+Data3+"'where COUNTER_ID='"+Data2+"'";
						stmt.executeUpdate(SqlStrEC1);
						out.println("<br>【CHANGE_GOODS資料更新】 舊櫃號: "+Data2+"轉換成新櫃號: "+Data3+"<br>");
						
						/*GOODS_COUNTER資料更新*/
						SqlStrEC2="update GOODS_COUNTER set COUNTER_ID='"+Data3+"'where COUNTER_ID='"+Data2+"'";
						stmt.executeUpdate(SqlStrEC2);
						out.println("【GOODS_COUNTER資料更新】 舊櫃號: "+Data2+"轉換成新櫃號: "+Data3+"<br>");
						
						/*GOODS資料更新*/
						SqlStrEC3="update GOODS set SUPPLIER_ID='"+Data3+"'where SUPPLIER_ID='"+Data2+"'";
						stmt.executeUpdate(SqlStrEC3);
						out.println("【GOODS資料更新】 舊櫃號: "+Data2+"轉換成新櫃號: "+Data3+"<br>");
						
						/*GOODS_EC_PRICE資料更新*/
						SqlStrEC4="update GOODS_EC_PRICE set COUNTER_ID='"+Data3+"'where COUNTER_ID='"+Data2+"'"; 
						stmt.executeUpdate(SqlStrEC4);
						out.println("【GOODS_EC_PRICE資料更新】 舊櫃號: "+Data2+"轉換成新櫃號: "+Data3+"<br>");
					
						/*本機資料更新標記*/
						SqlStr="update flow_form_rulestage set BillNo"+u+"='"+FDId+"' where FR_DataId="+FDId;
						Data.ExecUpdateSql(Conn,SqlStr);
						out.println("BillNo"+u+"='"+FDId+" 本機資料庫標記成功!<br>");

						/*每筆資料更新紀錄*/
						Record+="【資料更新】 舊櫃號: "+Data2+"轉換成新櫃號: "+Data3+"成功！\r\n";																		
					}
												
				}
				else    
				{
					/*已有更新標記的表單則跳出此訊息*/
					BillNo=DRs.getString("BillNo1");
					out.print("表單:"+BillNo+"的第"+u+"筆 已更新過 (不再重複更新)<br>");
				}		
				
			}
		
		}
	
			
	}
	//----------------製作txt檔案------------------
	String path = request.getRealPath("/Modules/UpdateCabinetNo/TransferRecord");                            //儲存位置
	FileWriter fw = new FileWriter(path + "//TransferCabinetNo"+T+".txt");                                   //建立文件檔名(寫進文件)
	//--------------<寫入文件內容>-----------------
	fw.write(Record);
	fw.write("\r\n");
	fw.close();  
	DRs.close();
	SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','完成.共處理 "+FCount+" 張表單,"+ICount+" 筆資料.')";
	Data.ExecUpdateSql(Conn,SqlStr);
	connTC.close();
	Conn.close();

}
catch(Exception sqlEx)
{	
//----------------mail發送內容-----------------	
HttpCore HttpCore=new leeten.HttpCore(pageContext,Data,Conn);
leeten.FileManager FileMgr=new leeten.FileManager();
String report=sqlEx.getMessage();
String smtphost = "mail2.chungyo.com.tw";        						                                 //傳送郵件伺服器
String mailuser = "c20201";                      						                                 //郵件伺服器登入使用者名稱
String mailpassword = "5j/u.19cji";              					                                	 //郵件伺服器登入密碼
String from = "chungyoLion@mail2.chungyo.com.tw"; 					                                	 //傳送人郵件地址
String to1 = "cy7022@mail2.chungyo.com.tw";        						                                 //接受人郵件地址(正本)
//String to2 = "cy6957@mail2.chungyo.com.tw";
String cc1 = "cy7022@mail2.chungyo.com.tw";
//String CC2 = "cy7022@mail2.chungyo.com.tw";
String subject = "櫃號轉移通知";                    					                                 //郵件標題
String bodycontent = "櫃號轉移失敗，原因:"+report;                                                       //郵件內容

//-------------<<mail傳送程式設定>>------------

Properties props = new Properties();                                                                     //建立Properties物件
props.put("mail.smtp.host", smtphost);									 
props.put("mail.smtp.auth","true");
Session ssn = Session.getInstance(props, null);                                                          //建立Session物件
MimeMessage message = new MimeMessage(ssn);                  		                                     //建立MimeMessage物件
message.setFrom(new InternetAddress(from));                  		                                     //設定寄件人信箱
message.addRecipient(Message.RecipientType.TO, new InternetAddress(to1));                                //設定收件人信箱(正本)
//message.addRecipient(Message.RecipientType.TO, new InternetAddress(to2));                                 //設定收件人信箱(正本)
message.addRecipient(Message.RecipientType.CC, new InternetAddress(cc1));                                 //設定收件人信箱(副本)
//message.addRecipient(Message.RecipientType.CC, new InternetAddress(CC2));
message.setSubject(subject,"UTF-8");                                                                     //設定mail的主旨
//------------------<建立內文>-----------------
BodyPart messageBodyPart0 = new MimeBodyPart();                                                          //建立BodyPart物件
messageBodyPart0.setContent(bodycontent,"text/html; charset=UTF-8");                                     //設定mail的內容(套用html格式)並將內文儲存於messageBodyPart，及設定內文格式
//------------------<建立附件>-----------------
BodyPart messageBodyPart1 = new MimeBodyPart();                                                          //建立一個BodyPart物件
String filesource = "D:/Portal/web/Modules/UpdateCabinetNo/TransferRecord/file.txt";   //附件路徑
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
out.print(sqlEx.getMessage()+"<br>");
out.print("<br>E-mail至商務資訊課人員(正本:cy6213,cy6957 副本:cy6909)：寄信成功！");

connTC.close();
Conn.close();
}

out.print("------------------------------------------------------------------------------");
out.print("<br>以上櫃位皆已轉移成功！");


%>
<%@page import="leeten.*" %>
<%@page contentType="text/xml; charset=big5" %>
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
String SDate=JDate.DateAdd("D",NowDate,-10);  //今日日期-10天("D"為預設代號)
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
String Data1="",Data2="",Data3="",applyman[]=null,AM="";
String Field5="",Field6="";
int u=0,FCount=0,ICount=0;
String Record="",Record_1="";
String catch_e="",catch_ex="",catch_exc="";
String catch_de="",catch_dex="",catch_dexc="";
SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','開始...')";
Data.ExecUpdateSql(Conn,SqlStr);

	//從FR和FD抓取(10天內)已審核過的資料  
	STime="and flow_formdata.FD_Data4<'"+EDate+"'";  //生效日
	SqlStr="select flow_form_rulestage.BillNo1,flow_form_rulestage.BillNo2,flow_form_rulestage.FR_FinishTime,flow_formdata.* from flow_formdata,flow_form_rulestage where flow_form_rulestage.FR_FinishTime>'"+SDate+" 00:00' and flow_form_rulestage.FR_FinishTime<'"+NowDate+" 23:59' and flow_form_rulestage.FR_FormAP='JFlow_Form_279' and flow_form_rulestage.FR_FinishState=1 "+STime+"and flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId";		
	ResultSet DRs=null;
	DRs=Data.getSmt(Conn,SqlStr);

	Statement stmt = connTC.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);							
	
try
{
	Conn.setAutoCommit(false);                                                     	//取消自動提交
	Statement stmtDB= Conn.createStatement();
	while(DRs.next())
	{	

		
		/*確認BillNo1,BillNo2內沒有更新過的標記*/
		if(DRs.getString("BillNo1").equals("")&&DRs.getString("BillNo2").equals(""))                          
		{
			
			/*每張表單*/
			FCount++;                                                                                        //抓取到的表單數量
			FDId=DRs.getString("FD_RecId");                                                                  //每張表單代號
			
			/*確認有經辦人*/
			Data1=DRs.getString("FD_Data1");
			applyman=Data1.split(" ");
			AM=applyman[0]; 
			if(!Data1.equals(""))                                                 
			{
				
				try
				{
					connTC.setAutoCommit(false);                                                     	//取消自動提交				
					
					/*用for迴圈跑兩組櫃號*/
					u=0;                                                                                         //每跑完一張表單後u歸0
					for(int t=0;t<2;t++)              
					{
						u++;
						Field5=String.valueOf((t*2)+5);	 
						Field6=String.valueOf((t*2)+6);
						Data2=DRs.getString("FD_Data"+Field5).split(":")[0].trim();                              //原供應商櫃號
						Data3=DRs.getString("FD_Data"+Field6).split(":")[0].trim();                              //轉移供應商櫃號
											
						if(!Data2.equals("")) 
						{
							ICount++;                                                                            //有執行更新的每筆紀錄
														
								
								
								/*CHANGE_GOODS資料更新*/
								SqlStrEC1="update CHANGE_GOODS set COUNTER_ID='"+Data3+"'where COUNTER_ID='"+Data2+"'";
								stmt.executeUpdate(SqlStrEC1);
								
								/*GOODS_COUNTER資料更新*/
								SqlStrEC2="update GOODS_COUNTER set COUNTER_ID='"+Data3+"'where COUNTER_ID='"+Data2+"'";
								stmt.executeUpdate(SqlStrEC2);
								
								/*GOODS資料更新*/
								SqlStrEC3="update GOODS set SUPPLIER_ID='"+Data3+"'where SUPPLIER_ID='"+Data2+"'";
								stmt.executeUpdate(SqlStrEC3);
								
								/*GOODS_EC_PRICE資料更新*/
								SqlStrEC4="update GOODS_EC_PRICE set COUNTER_ID='"+Data3+"'where COUNTER_ID='"+Data2+"'"; 
								stmt.executeUpdate(SqlStrEC4);
								
								/*本機資料更新標記*/
								SqlStr="update flow_form_rulestage set BillNo"+u+"='"+FDId+"' where FR_DataId="+FDId;
								stmtDB.executeUpdate(SqlStr);
								
								out.println("<br>BillNo"+u+"='"+FDId+" 本機資料庫標記成功!<br>");
								
								/*每筆資料更新紀錄*/
								Record+="【表單:"+FDId+" 資料更新】 舊櫃號: "+Data2+"轉換成新櫃號: "+Data3+"成功！\r\n";
								Record_1+="【資料更新】 舊櫃號: "+Data2+"轉換成新櫃號: "+Data3+"成功！\r\n";
						}					
					}
					
					//--------------mail發送---------------

					String smtphost = "mail2.chungyo.com.tw"; // 傳送郵件伺服器
					String mailuser = "c20201"; // 郵件伺服器登入使用者名稱
					String mailpassword = "5j/u.19cji"; // 郵件伺服器登入密碼
					String from = "chungyoLion@mail2.chungyo.com.tw"; // 傳送人郵件地址
					String to = "cy"+AM+"@mail2.chungyo.com.tw"; // 接受人郵件地址
					String cc = "cy7022@mail2.chungyo.com.tw";
					String subject = "測試寄送"; // 郵件標題
					String bodycontent = Record_1; // 郵件內容

					/*以下為傳送程式，使用者無需改動*/

					Properties props = new Properties();
					props.put("mail.smtp.host", smtphost);
					props.put("mail.smtp.auth","true");
					Session ssn = Session.getInstance(props, null);
					MimeMessage message = new MimeMessage(ssn);

					InternetAddress fromAddress = new InternetAddress(from);
					message.setFrom(fromAddress);
					InternetAddress[] sendTo = InternetAddress.parse(to);
					message.setRecipients(MimeMessage.RecipientType.TO, sendTo);
					InternetAddress[] cc1 = InternetAddress.parse(cc);
					message.addRecipients(MimeMessage.RecipientType.CC, cc1);
					message.setSubject(subject,"UTF-8");
					
					//------------------<傳送總匯>-----------------	
					Transport transport = ssn.getTransport("smtp");
					transport.connect(smtphost, mailuser, mailpassword);
					transport.sendMessage(message, message.getAllRecipients());
					transport.close();
					
					connTC.commit();                                                                 //提交
				}
				catch(Exception e)
				{							
					catch_e=e.getMessage();
					/*每筆資料更新紀錄*/
					Record+="【表單:"+FDId+"】 更新失敗！ 原因:"+catch_e+"\r\n";
					
					if(connTC!=null)
					{								
																
						try
						{									
							connTC.rollback();                                                       //撤回SQL指令																	
						}
						catch(Exception ex)
						{
							catch_ex=ex.getMessage();									
						}								
					}							
				}						
				finally 
				{
					if(connTC!=null)
					{
						try
						{									
							connTC.setAutoCommit(true);                                              //恢復自動提交																										
						}
						catch(Exception exc)
						{									
							catch_exc=exc.getMessage();									
						}
					}							
				}
				//out.print(AM);     //每個申請人
				//out.print(Record); //每張表單狀況
				//out.print("<br>");
				
				
				
				

			}
			
			
		}
				
	}
	Conn.commit();                                                                 //提交
}
catch(Exception de)
{							
	catch_de=de.getMessage();
	/*每筆資料更新紀錄*/
	Record="更新失敗！ 原因:"+catch_de+"\r\n";
					
	if(Conn!=null)
	{								
																
		try
		{									
			Conn.rollback();                                                       //撤回SQL指令																	
		}
		catch(Exception dex)
		{
			catch_dex=dex.getMessage();									
		}								
	}							
}						
finally 
{
	if(Conn!=null)
	{
		try
		{									
			Conn.setAutoCommit(true);                                              //恢復自動提交																										
		}
		catch(Exception dexc)
		{									
			catch_dexc=dexc.getMessage();									
		}
	}							
}
//---------------製作txt檔案---------------
				String path = request.getRealPath("/Modules/UpdateCabinetNo/TransferRecord");                            //儲存位置
				FileWriter fw = new FileWriter(path + "//TransferCabinetNo"+T+".txt");                                   //建立文件檔名
				fw.write(Record);                                                                                        //轉成功的櫃位會寫進文件
				fw.close();
	
	//--------------寫入資料庫LOG--------------
	if(catch_de!=""||catch_dex!=""||catch_dexc!=""||catch_e!=""||catch_ex!=""||catch_exc!="")
	{
		SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入錯誤','Transfer.jsp 錯誤訊息: "+catch_de+""+catch_dex+"')";
		Data.ExecUpdateSql(Conn,SqlStr);
	}
	if(catch_de==""&&catch_dex==""&&catch_dexc==""&&catch_e==""&&catch_ex==""&&catch_exc=="")
	{
		SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','完成.共處理 "+FCount+" 張表單,"+ICount+" 筆資料.')";
		Data.ExecUpdateSql(Conn,SqlStr);
	}

	//--------------mail發送---------------

				String smtphost = "mail2.chungyo.com.tw"; // 傳送郵件伺服器
				String mailuser = "c20201"; // 郵件伺服器登入使用者名稱
				String mailpassword = "5j/u.19cji"; // 郵件伺服器登入密碼
				String from = "chungyoLion@mail2.chungyo.com.tw"; // 傳送人郵件地址
				//String to = "cy6957@mail2.chungyo.com.tw,cy6213@mail2.chungyo.com.tw"; // 接受人郵件地址
				String to = "cy7022@mail2.chungyo.com.tw"; // 接受人郵件地址
				String cc = "cy7022@mail2.chungyo.com.tw";
				String subject = "測試寄送"; // 郵件標題
				String bodycontent = Record; // 郵件內容

				/*以下為傳送程式，使用者無需改動*/

				Properties props = new Properties();
				props.put("mail.smtp.host", smtphost);
				props.put("mail.smtp.auth","true");
				Session ssn = Session.getInstance(props, null);
				MimeMessage message = new MimeMessage(ssn);

				InternetAddress fromAddress = new InternetAddress(from);
				message.setFrom(fromAddress);
				InternetAddress[] sendTo = InternetAddress.parse(to);
				message.setRecipients(MimeMessage.RecipientType.TO, sendTo);
				InternetAddress[] cc1 = InternetAddress.parse(cc);
				message.addRecipients(MimeMessage.RecipientType.CC, cc1);
				message.setSubject(subject,"UTF-8");
				
				//------------------<建立內文>-----------------
				BodyPart Part0 = new MimeBodyPart();                                                        			 //建立BodyPart物件
				Part0.setContent(bodycontent,"text/html; charset=UTF-8");		
				//------------------<建立附件>-----------------
				BodyPart Part1 = new MimeBodyPart();                                                         			 //建立一個BodyPart物件
				String filesource = "D:/Portal/web/Modules/UpdateCabinetNo/TransferRecord/TransferCabinetNo"+T+".txt";   //附件路徑
				DataSource source = new FileDataSource(filesource);
				Part1.setDataHandler(new DataHandler(source));
				String Filename="TransferCabinetNo"+T+"";                                                    			 //附件名稱
				Part1.setFileName(Filename);     
				//----------------<內文+附件包裹>--------------
				Multipart multipart = new MimeMultipart();                     		                                 	 //建立Multipart物件
				multipart.addBodyPart(Part0);                                                                		   	 //將信件內文儲存於Multipart
				multipart.addBodyPart(Part1);                                                                 		 	 //將附件資料儲存於Multipart
				message.setContent(multipart);                                                                       	 //設定寄送內容為Multipart
				//------------------<傳送總匯>-----------------	
				Transport transport = ssn.getTransport("smtp");
				transport.connect(smtphost, mailuser, mailpassword);
				transport.sendMessage(message, message.getAllRecipients());
				transport.close();		
			

			
			out.print("<br>E-mail至商務資訊課人員(正本:經辦人 副本:cy6213,cy6957,cy7022)：寄信成功！");
	//--------------彈跳視窗內容---------------
	if(catch_de!="")
	{
		out.print("<br>櫃號轉移失敗，原因:"+catch_de);
	}
	if(catch_dex!="")
	{
		out.print("<br>櫃號轉移失敗，原因:"+catch_dex);
	}
	if(catch_dexc!="")
	{
		out.print("<br>櫃號轉移失敗，原因:"+catch_dexc);
	}
	if(catch_e!="")
	{
		out.print("<br>櫃號轉移失敗，原因:"+catch_e);
	}
	if(catch_ex!="")
	{
		out.print("<br>櫃號轉移失敗，原因:"+catch_ex);
	}
	if(catch_exc!="")
	{
		out.print("<br>櫃號轉移失敗，原因:"+catch_exc);
	}
	if(FDId!=""&&catch_e==""&&catch_ex==""&&catch_exc=="")
	{
		out.print("<br>櫃號轉移成功！");
	}
		
	//------------------釋放-------------------
	DRs.close();
	connTC.close();
	Conn.close();
%>
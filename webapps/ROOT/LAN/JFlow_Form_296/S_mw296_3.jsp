<%@page import="leeten.*" %>
<%@ include file="/cykernel.jsp" %>
<%@ include file="/cy2kernel.jsp" %>
<%@page contentType="text/xml; charset=big5" %>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat" %>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/APP3.0-TC.jsp" %>
<%@ page import="java.io.*"%>
<%
//--------------防止瀏覽器快取網頁-----------------
NoCatch(response);
//-------------------宣告時間----------------------
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String NowDate=JDate.ToDay();                                                                                    //年月日(今日)
String SDate=JDate.DateAdd("D",NowDate,-1);                                                                      //今日日期-1天("D"為預設代號)
String EDate=JDate.DateAdd("D",NowDate,+1);                                                                      //今日日期+1天("D"為預設代號)
String TransferDate=JDate.Now();                                                                                 //年月日時分秒(目前)
String[] TS = TransferDate.split("/");
String[] TSS =TS[2].split(" ");
String[] TSSS =TSS[1].split(":");
String T=TS[0]+TS[1]+TSS[0]+TSSS[0]+TSSS[1];
String[] TT =TransferDate.split(" ");
//-------------------資料庫------------------------
String SqlStr="",STime="",FDId="",Sql_FD="",SqlStrCY1="",SqlStrS="",SqlStrF="";
String BillNo="";
String FD_Data1="",FD_Data3="",FD_Data4="",FD_Data5="",applyman[]=null,AM="",AD="",FI_FieldCount="";
String Field3="",Field4="",Field5="";
int u=0,FCount=0,ICount=0,UpdateSuccess=0,FieldCount=0,TransferGroup=0,AMN=0;
String Record="",Record_All="";
String catch_e="",catch_ex="",catch_d="";

FDId=req("FD_RecId",request);
if(!FDId.equals("")) Sql_FD=" and flow_form_rulestage.FR_DataId="+FDId;

try
{				
	SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('EC撤櫃表單-JFlow_Form_296','批次轉入','開始...')";
	Data.ExecUpdateSql(Conn,SqlStr);
	%><script>alert("批次轉入開始！");</script><%
	
	//------------------櫃號組數--------------------
	SqlStrF="select * from flow_forminfo where FI_ID='JFlow_Form_296' order by FI_RecID DESC limit 1";
	ResultSet Ds=null;
	Ds=Data.getSmt(Conn,SqlStrF);
	if(Ds.next())
	{
		FI_FieldCount=Ds.getString("FI_FieldCount");
	}
	Ds.close();
	FieldCount=Integer.parseInt(FI_FieldCount);
	//公式:(抓取表單欄位總數-非供應商欄位數)/(一組櫃號的欄位數)=表單櫃號總組數
	TransferGroup=(FieldCount-8)/3;                          
	%><script>alert("取得櫃號組數，共<%=TransferGroup%>組！");</script><%

	//----------抓取(前1天內)已審核過的表單----------
	STime="and flow_formdata.FD_Data4<'"+EDate+"'";                                                              //櫃號轉移生效日
	SqlStr="select flow_form_rulestage.BillNo1,flow_form_rulestage.BillNo2,flow_form_rulestage.BillNo3,flow_form_rulestage.FR_FinishTime,flow_formdata.* from flow_formdata,flow_form_rulestage where flow_form_rulestage.FR_FinishTime>'"+SDate+" 00:00' and flow_form_rulestage.FR_FinishTime<'"+NowDate+" 23:59' "+Sql_FD+" and flow_form_rulestage.FR_FormAP='JFlow_Form_296' and flow_form_rulestage.FR_FinishState=1 "+STime+"and flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId";		
	out.println(SqlStr+"<br>");
	Statement stmtD=Conn.createStatement();
	ResultSet DRs=stmtD.executeQuery(SqlStr);
	Statement stmtCY = connTC.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
	while(DRs.next())
	{	
		//------抓取沒有更新過標記的表單--------
		if(DRs.getString("BillNo1").equals(""))                          
		{				
			try
			{
				connTC.setAutoCommit(false);
				
				//------------表單--------------
				FCount++;                                                                                        //抓取到的表單數量
				UpdateSuccess=0;																				 //每跑完一張表單後UpdateSuccess歸0
				FDId=DRs.getString("FD_RecId");                                                                  //每張表單代號				
				//-----------經辦人-------------
				FD_Data1=DRs.getString("FD_Data1");
				applyman=FD_Data1.split(",");
				AD=applyman[0].trim();
				AMN=AD.length();
				if(AMN==4)
				{
					AM="cy"+AD;
				}
				else
				{
					AM=AD;
				}				
				if(!FD_Data1.equals(""))                                                 
				{
					Record="";                                                                                   //每跑完一張表單後Record資料清除
					u=0;                                                                                         //每跑完一張表單後u歸0
					//--------用for迴圈跑多組櫃號--------
					for(int t=0;t<TransferGroup;t++)                                                             //t的參數=第幾組(0=第一組,1=第二組，類推)->參數由TransferGroup動態取值             
					{
						u++;
						Field3=String.valueOf((t*3)+3);	                                                         //供應商欄位
						Field4=String.valueOf((t*3)+4);	                                                         //關閉日期欄位
						Field5=String.valueOf((t*3)+5);                                                          //異動說明欄位
						FD_Data3=DRs.getString("FD_Data"+Field3).split(":")[0].trim();                           //供應商櫃號
						FD_Data4=DRs.getString("FD_Data"+Field4);                                                //關閉日期
						FD_Data5=DRs.getString("FD_Data"+Field5);                                                //異動說明
						
												
						if(!FD_Data3.equals("")) 
						{
							
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");                           //關閉日期小於或等於今日才執行更新
							Date endDate=sdf.parse(JDate.ToDay()); 
							Date beginDate = sdf.parse(FD_Data4);
							long days =beginDate.getTime() - endDate.getTime();
							days=days/(1000*24*60*60);
							
							if(days<=0)
							{
								
								ICount++;                                                                        //所有表單有執行更新的總組數
																						
								//EC:USERS資料更新								
								SqlStrCY1="UPDATE USERS SET STATUS ='0' where SUBSTRING(LOGIN_ID,1,5) = '"+FD_Data3+"'";
								stmtCY.executeUpdate(SqlStrCY1);
								out.println("USERS資料更新<br>"+SqlStrCY1+"<br><br>");
								
								String SqlStrDL="select L_RecDate from flow_log where L_FormName='EC撤櫃表單-JFlow_Form_296' order by L_RecId DESC limit 1";
								ResultSet DLs=null;
								DLs=Data.getSmt(Conn,SqlStrDL);
								
								//ERP資料更新
								
								String p027_dateArr[]=null;
								p027_dateArr=DRs.getString("FD_RecDate").split(" ");
								String p027_date=p027_dateArr[0].replace("-","/");        //申請日
								out.print(p027_date+"<br>");
								String p027_boxno=FD_Data3;                               //櫃號
								out.print(p027_boxno+"<br>");
								String p027_out=FD_Data4;                                 //撤櫃日
								out.print(p027_out+"<br>");
								String p027_active="0";                                   //櫃號狀態 (1:啟用, 0:停用)
								out.print(p027_active+"<br>");
								String p027_note=FD_Data5;                                //備註
								out.print(p027_note+"<br>");
								String p027_kdateArr[]=null;
								if(DLs.next())
								{
									p027_kdateArr=DLs.getString("L_RecDate").split(" ");
								}
								String p027_kdate=p027_kdateArr[0].replace("-","/");      //結轉日期
								out.print(p027_kdate+"<br>");
								String p027_kuser=applyman[1].trim();                     //申請人
								out.print(p027_kuser+"<br>");
								
								String SqlStrcy="",SqlStrcy2="";
								if(FD_Data3.substring(0,1).equals("Y"))                   //櫃號開頭字母為Y，公司別=3A，非Y則公司別=1A               
								{
									String p027_comp="3A";                                   
									out.print(p027_comp+"<br>");
									Statement stmtcy2 = conn2.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
									SqlStrcy2+="insert into purf027(p027_comp,p027_date,p027_boxno,p027_out,p027_active,p027_note,p027_kdate,p027_kuser) ";
									SqlStrcy2+="values ('"+p027_comp+"','"+p027_date+"','"+p027_boxno+"','"+p027_out+"','"+p027_active+"','"+p027_note+"','"+p027_kdate+"','"+p027_kuser+"')";
									stmtcy2.executeUpdate(SqlStrcy2);
								}
								else
								{
									String p027_comp="1A";                                   
									out.print(p027_comp+"<br>");
									Statement stmtcy = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);	
									SqlStrcy+="insert into purf027(p027_comp,p027_date,p027_boxno,p027_out,p027_active,p027_note,p027_kdate,p027_kuser) ";
									SqlStrcy+="values ('"+p027_comp+"','"+p027_date+"','"+p027_boxno+"','"+p027_out+"','"+p027_active+"','"+p027_note+"','"+p027_kdate+"','"+p027_kuser+"')";
									stmtcy.executeUpdate(SqlStrcy);
								}
								
								
								
						
								Record+="櫃號: "+FD_Data3+" 撤櫃成功！\r\n";
								Record_All+="表單:"+FDId+" 櫃號: "+FD_Data3+" 撤櫃成功！\r\n";
								%><script>alert("表單:<%=FDId%>第<%=u%>筆執行EC撤櫃成功！");</script><%
								UpdateSuccess++;                                                                 //單一張表單成功更新的組數
							}
						}																	
					}
					try
					{
						Conn.setAutoCommit(false);
						
						//本機資料更新標記
						Statement stmtDB=Conn.createStatement();
						for(int s=1; s<UpdateSuccess+1; s++)
						{
							SqlStrS+="update flow_form_rulestage set BillNo"+s+"='"+FDId+"' where FR_DataId="+FDId;
						}
						stmtDB.executeUpdate(SqlStrS);
						out.println("OK<br>"+SqlStr+"<br>");
						%><script>alert("表單:<%=FDId%>標記完畢！");</script><%	
						
						//----------------mail發送------------------	
						String smtphost = "mail2.chungyo.com.tw";                							 	 // 傳送郵件伺服器
						String mailuser = "c20201";                              							 	 // 郵件伺服器登入使用者名稱
						String mailpassword = "5j/u.19cji";                      								 // 郵件伺服器登入密碼
						String from = "chungyoLion@mail2.chungyo.com.tw";        								 // 傳送人郵件地址
						String to = AM+"@mail2.chungyo.com.tw";             							 	     // 接受人郵件地址(正本)
						String CC = "cy7022@mail2.chungyo.com.tw";   // 接受人郵件地址(副本)
						String subject = "撤櫃成功通知";                     							 	     // 郵件標題
						String body = Record; 							 							 		 	 // 郵件內容

						Properties props = new Properties();
						props.put("mail.smtp.host", smtphost);
						props.put("mail.smtp.auth","true");
						Session ssn = Session.getInstance(props, null);
						MimeMessage message = new MimeMessage(ssn);
						InternetAddress fromAddress = new InternetAddress(from);
						message.setFrom(fromAddress);
						InternetAddress[] sendTo = InternetAddress.parse(to);
						message.setRecipients(MimeMessage.RecipientType.TO, sendTo);
						InternetAddress[] sendCC = InternetAddress.parse(CC);
						message.setRecipients(MimeMessage.RecipientType.CC, sendCC);						
						message.setSubject(subject,"UTF-8");
						message.setText(body,"UTF-8");

						Transport transport = ssn.getTransport("smtp");
						transport.connect(smtphost, mailuser, mailpassword);
						transport.sendMessage(message, message.getAllRecipients());
						transport.close();
						%><script>alert("發送Email給承辦人，通知撤櫃成功！");</script><%
						
						Conn.commit();
					}
					catch(Exception d)
					{							
						catch_d=d.getMessage();																
						Conn.rollback();                                                       					 //撤回SQL指令(connTC)		
						%><script>alert("表單:<%=FDId%>標記或mail承辦人失敗，返回至資料庫標記前狀態！");</script><%					
					}						
					finally 
					{									
						Conn.setAutoCommit(true);                                              					 //恢復自動提交(connTC)																																	
						if(catch_d!="")
						{
							connTC.rollback();
							%><script>alert("表單:<%=FDId%> 返回至EC撤櫃前狀態！");</script><%
						}
					}
				}
				connTC.commit();                                                       						     //執行SQL指令(connTC)					
			}
			catch(Exception e)
			{							
				catch_e=e.getMessage();																
				connTC.rollback();                                                       						 //撤回SQL指令(connTC)		
				%><script>alert("表單:<%=FDId%>撤櫃失敗，返回至撤櫃前狀態！");</script><%					
			}						
			finally 
			{									
				connTC.setAutoCommit(true);                                              						 //恢復自動提交(connTC)																																	
			}
		}				
	}	
	DRs.close();                           
}		
catch(Exception ex)
{							
	catch_ex=ex.getMessage();																
	%><script>alert("撤櫃失敗！錯誤原因:<%=catch_ex %>");</script><%			
}						



//-----------成功或失敗都會製作txt檔案-------------
String path = request.getRealPath("/Modules/JFlow_Form_296/TransferRecord");                            		 //儲存位置
FileWriter fw = new FileWriter(path + "//TransferCabinetNo"+T+".txt");                                   		 //建立文件檔名
if(catch_e!=""||catch_ex!=""||catch_d!="")
{
	fw.write("S_mw296.jsp 表單:"+FDId+" 錯誤訊息:"+catch_e+catch_ex+catch_d+"\r\n");
}
else
{
	fw.write(Record_All);		
}
fw.close();

//--------------最後寫入資料庫LOG------------------
if(catch_e!=""||catch_ex!=""||catch_d!="")
{
	SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('EC撤櫃表單-JFlow_Form_296','批次轉入','錯誤: S_mw296.jsp  FR_DataId="+FDId+" 錯誤訊息:"+catch_e+catch_ex+catch_d+"')";
	Data.ExecUpdateSql(Conn,SqlStr);
	%><script>alert("已將錯誤訊息寫入於資料庫!");</script><%
		
	//-------(有錯誤訊息)mail發送至商務資訊課------
	String smtphost = "mail2.chungyo.com.tw";                                                             		 // 傳送郵件伺服器
	String mailuser = "c20201";                                                                           		 // 郵件伺服器登入使用者名稱
	String mailpassword = "5j/u.19cji";                                                                   		 // 郵件伺服器登入密碼
	String from = "chungyoLion@mail2.chungyo.com.tw";                                                     		 // 傳送人郵件地址
	String to = "cy7022@mail2.chungyo.com.tw";                                		                             // 接受人郵件地址(多人正本)
	String cc = "cy7022@mail2.chungyo.com.tw";                                                            		 // 接受人郵件地址(副本)
	String subject = "撤櫃失敗通知";                                                                  		     // 郵件標題
	String bodycontent = "撤櫃失敗！<br>請查看附件內容！";                                            		     // 郵件內容

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
					
	//-------------<建立內文>--------------
	BodyPart Part0 = new MimeBodyPart();                                                        			 	 //建立BodyPart物件
	Part0.setContent(bodycontent,"text/html; charset=UTF-8");		
	//-------------<建立附件>--------------
	BodyPart Part1 = new MimeBodyPart();                                                         			 	 //建立一個BodyPart物件
	String filesource = "D:/Portal/web/Modules/JFlow_Form_296/TransferRecord/TransferCabinetNo"+T+".txt";   	 //附件路徑
	DataSource source = new FileDataSource(filesource);
	Part1.setDataHandler(new DataHandler(source));
	String Filename="TransferCabinetNo"+T+"";                                                    			 	 //附件名稱
	Part1.setFileName(Filename);     
	//-----------<內文+附件包裹>-----------
	Multipart multipart = new MimeMultipart();                     		                                 	 	 //建立Multipart物件
	multipart.addBodyPart(Part0);                                                                		   	 	 //將信件內文儲存於Multipart
	multipart.addBodyPart(Part1);                                                                 		 	 	 //將附件資料儲存於Multipart
	message.setContent(multipart);                                                                       	 	 //設定寄送內容為Multipart
	//-------------<傳送總匯>--------------	
	Transport transport = ssn.getTransport("smtp");
	transport.connect(smtphost, mailuser, mailpassword);
	transport.sendMessage(message, message.getAllRecipients());
	transport.close();	
	%><script>alert("已將錯誤訊息Email至商務資訊課負責人員!");</script><%
}
else
{
	SqlStr="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('EC撤櫃表單-JFlow_Form_296','批次轉入','完成.共處理 "+FCount+" 張表單,"+ICount+" 筆資料.')";
	Data.ExecUpdateSql(Conn,SqlStr);
	%><script>alert("批次更新完畢，寫入資料庫成功!");</script><%
}

//----------------------釋放-----------------------
connTC.close();
Conn.close();
%>
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
//ResultSet rs= execute

	//從FR和FD抓取(10天內)已審核過的資料  
	STime="and flow_formdata.FD_Data4<'"+EDate+"'";  //生效日
	SqlStr="select flow_form_rulestage.BillNo1,flow_form_rulestage.BillNo2,flow_form_rulestage.FR_FinishTime,flow_formdata.* from flow_formdata,flow_form_rulestage where flow_form_rulestage.FR_FinishTime>'"+SDate+" 00:00' and flow_form_rulestage.FR_FinishTime<'"+NowDate+" 23:59' and flow_form_rulestage.FR_FormAP='JFlow_Form_279' and flow_form_rulestage.FR_FinishState=1 "+STime+"and flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId";		
	ResultSet DRs=null;
	DRs=Data.getSmt(Conn,SqlStr);

	Statement stmt = connTC.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);					
	
try
{
	Conn.setAutoCommit(false);                                                     	//取消自動提交

	
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
								try
								{
											
									connTC.setAutoCommit(false);                                                     	 //取消自動提交
								
									ICount++;                                                                            //有執行更新的每筆紀錄																															
									
									/*CHANGE_GOODS資料更新*/
									SqlStrEC1="update CHANGE_GOODS set COUNTER_ID='11069'where COUNTER_ID='11081'";
									stmt.executeUpdate(SqlStrEC1);
									
									/*GOODS_COUNTER資料更新*/
									SqlStrEC2="update GOODS_COUNTER set COUNTER_ID='11069'where COUNTER_ID='11081'";
									stmt.executeUpdate(SqlStrEC2);
								
									/*GOODS資料更新*/
									SqlStrEC3="update GOODS set SUPPLIER_ID='11069'where SUPPLIER_ID='11081'";
									stmt.executeUpdate(SqlStrEC3);
									
									/*GOODS_EC_PRICE資料更新*/
									SqlStrEC4="update GOODS_EC_PRICE set COUNTER_ID='11069'where COUNTER_ID='11081'"; 
									stmt.executeUpdate(SqlStrEC4);
									
									
									
									/*每筆資料更新紀錄*/
									Record+="【表單:"+FDId+" 資料更新】 舊櫃號: "+Data2+"轉換成新櫃號: "+Data3+"成功！\r\n";
									Record_1+="【資料更新】 舊櫃號: "+Data2+"轉換成新櫃號: "+Data3+"成功！\r\n";
									
									connTC.commit();                                                                 //提交
									}
									catch(SQLException e)
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
											catch(SQLException ex)
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
											catch(SQLException exc)
											{									
												catch_exc=exc.getMessage();									
											}
										}							
									}
							}
							
						/*本機資料更新標記*/
						SqlStr="update flow_form_rulestage set BillNo3='"+FDId+"' where FR_DataId="+FDId;
						Data.ExecUpdateSql(Conn,SqlStr);

						SqlStr="update f set BillNo"+u+"='"+FDId+"' where FR_DataId="+FDId;
						Data.ExecUpdateSql(Conn,SqlStr);						
								
						out.println("<br>BillNo"+u+"='"+FDId+" 本機資料庫標記成功!<br>");							
					}
					

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

						


	
		
	//------------------釋放-------------------
	DRs.close();
	connTC.close();
	Conn.close();
%>
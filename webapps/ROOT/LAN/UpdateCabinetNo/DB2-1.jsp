<%@page import="leeten.*" %>
<%@page contentType="text/xml; charset=big5" %>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat" %>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/APP3.0-TC.jsp" %>
<%@ page import="java.io.*"%>
<%
String SqlStr1="",SqlStr2="";
//--------第一個更新失敗，第二個仍然會執行--------
SqlStr1="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','開始...')";
Data.ExecUpdateSql(Conn,SqlStr1);
SqlStr2="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','結束...')";
Data.ExecUpdateSql(Conn,SqlStr2);


//--------------------DB變形----------------------
//Statement stmt= Conn.createStatement();
//stmt.executeUpdate("insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','第二次結束...')");


//---------------transaction瘦身------------------
//-------設定stmt4故障->嘗試將DB(rollback)--------
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String NowDate=JDate.ToDay();                //年月日(今日)
String SDate=JDate.DateAdd("D",NowDate,-30);  //今日日期-30天("D"為預設代號)
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
int u=0,FCount=0,ICount=0,c=0;
String Record="",Record_1="";
String catch_e="",catch_ex="",catch_exc="";
String catch_de="",catch_dex="",catch_dexc="";
STime="and flow_formdata.FD_Data4<'"+EDate+"'";  //生效日
SqlStr="select flow_form_rulestage.BillNo1,flow_form_rulestage.BillNo2,flow_form_rulestage.FR_FinishTime,flow_formdata.* from flow_formdata,flow_form_rulestage where flow_form_rulestage.FR_FinishTime>'"+SDate+" 00:00' and flow_form_rulestage.FR_FinishTime<'"+NowDate+" 23:59' and flow_form_rulestage.FR_FormAP='JFlow_Form_279' and flow_form_rulestage.FR_FinishState=1 "+STime+"and flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId";		
Statement stmtD=Conn.createStatement();
ResultSet DRs=stmtD.executeQuery(SqlStr);
Statement stmt = connTC.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
Statement stmt3= Conn.createStatement();
Statement stmt4= Conn.createStatement();
while(DRs.next())
{c++;
	try
	{
		Conn.setAutoCommit(false);
		//-----確認表單沒有更新過的標記-----
		if(DRs.getString("BillNo1").equals("")&&DRs.getString("BillNo2").equals(""))                          
		{
			
			//------------表單--------------
			FCount++;                                                                                        //抓取到的表單數量
			FDId=DRs.getString("FD_RecId");                                                                  //每張表單代號
			
			//-----------經辦人-------------
			Data1=DRs.getString("FD_Data1");
			applyman=Data1.split(" ");
			AM=applyman[0]; 
			if(!Data1.equals(""))                                                 
			{
				try
				{
					connTC.setAutoCommit(false);
					u=0;                                                                                         //每跑完一張表單後u歸0
					for(int t=0;t<2;t++)              
					{
						u++;
						Field5=String.valueOf((t*2)+5);	                                                         //原供應商FD_Data欄位
						Field6=String.valueOf((t*2)+6);	                                                         //轉移供應商FD_Data欄位
						Data2=DRs.getString("FD_Data"+Field5).split(":")[0].trim();                              //原供應商櫃號
						Data3=DRs.getString("FD_Data"+Field6).split(":")[0].trim();                              //轉移供應商櫃號
												
						if(!Data2.equals("")) 
						{
							ICount++;                                                                            //有執行更新的每筆紀錄
																					
							//CHANGE_GOODS資料更新
							SqlStrEC1="update CHANGE_GOODS set COUNTER_ID='11069'where COUNTER_ID='11081'";
							stmt.executeUpdate(SqlStrEC1);
									
							//GOODS_COUNTER資料更新
							SqlStrEC2="update GOODS_COUNTER set COUNTER_ID='11069'where COUNTER_ID='11081'";
							stmt.executeUpdate(SqlStrEC2);
									
							//GOODS資料更新
							SqlStrEC3="update GOODS set SUPPLIER_ID='11069'where SUPPLIER_ID='11081'";
							stmt.executeUpdate(SqlStrEC3);
									
							//GOODS_EC_PRICE資料更新
							SqlStrEC4="update GOODS_EC_PRICE set COUNTER_ID='11069'where COUNTER_ID='11081'"; 
							stmt.executeUpdate(SqlStrEC4);		
							
							%><script>alert("第<%=c%>張表單的第<%=u%>筆EC資料更新成功！");</script><%
						}
						
					}
					connTC.commit();
				}
				catch(SQLException e)
				{							
					catch_e=e.getMessage();																
					connTC.rollback();                                                       //撤回SQL指令		
					%><script>alert("第<%=c%>張表單的EC資料返回至更新前狀態！");</script><%
				}						
				finally 
				{									
					connTC.setAutoCommit(true);                                              //恢復自動提交	
					%><script>alert("第<%=c%>張表單的EC資料最後提交！");</script><%
				}
				stmt3.executeUpdate("insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','第三次結束...')");
				stmt4.executeUpdate("insert into F (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','第四次結束...')");			
				%><script>alert("第<%=c%>張表單的DB資料插入成功！");</script><%													
			}			
		}
	
		Conn.commit();                                                         //若無故障則提交
	}
	catch(SQLException e)
	{							
		catch_e=e.getMessage();																
		Conn.rollback();                                                       //撤回SQL指令	
		%><script>alert("第<%=c%>張表單的DB資料返回至插入前狀態！");</script><%
		out.print(catch_e);
	}						
	finally 
	{									
		Conn.setAutoCommit(true);                                              //恢復自動提交	
		%><script>alert("第<%=c%>張表單的DB資料最後提交！");</script><%
	}
}
DRs.close();
%>
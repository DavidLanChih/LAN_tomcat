<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950"%>
<%
//-----------頁面顯示比數宣告--------------
int Page=1,PageSize=15,TTLPage=1,TTLRec=0;
//-----------取得表單資料------------------
String D1=req("T1",request);                          //取得開始日期
String D2=req("T2",request);                          //取得結束日期
String Status=req("Status",request);                  //取得查詢狀態
//-----------換頁按鈕----------------------
if(req("P",request)=="") Page=1; else Page=Integer.parseInt(req("P",request));
//-----------防止瀏覽器快取網頁------------
NoCatch(response);
//-----------日期選擇範圍1補零-------------
String FD_Data1Arr[]=null,d1="",d2="",d3="";
FD_Data1Arr=D1.split("/");
d1=FD_Data1Arr[0];
d2=String.format("%02d",  Integer.parseInt(FD_Data1Arr[1])); 
d3=String.format("%02d",  Integer.parseInt(FD_Data1Arr[2]));
//-----------日期選擇範圍2補零-------------
String FD_Data2Arr[]=null,d4="",d5="",d6="";
FD_Data2Arr=D2.split("/");
d4=FD_Data2Arr[0];
d5=String.format("%02d",  Integer.parseInt(FD_Data2Arr[1])); 
d6=String.format("%02d",  Integer.parseInt(FD_Data2Arr[2]));
//-----------宣告按鈕----------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//-----------宣告Grid----------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
//-----------MS-SQL資料庫欄位呼叫----------
String SqlStr="";
ResultSet Rs=null;
SqlStr="select FR_RecId,FD_OrgId,FR_FormId,FR_DataId,FD_FormId,FD_Data1,FD_Data3,FD_Data4,FD_Data5,FD_Data15,FR_FinishState,FD_RecDate from flow_formdata,flow_form_rulestage where flow_formdata.FD_RecId="+
"flow_form_rulestage.FR_DataId and flow_formdata.FD_FormId = '207'"+
"and (CONVERT(varchar(10),CONVERT(datetime,FD_Data2,111),111)  BETWEEN  '"+d1+"/"+d2+"/"+d3+"' and '"+d4+"/"+d5+"/"+d6+"')"; 
//-----------取得申請單狀態----------------
if(Status!="")
{
	SqlStr+="and (FR_FinishState = '"+Status+"')";
}
Rs=Data.getSmt(Conn,SqlStr);
//-----------選擇表單----------------------
Grid.AddTab("表單查詢","index.jsp",0);
Grid.AddTab("<img src='/Modules/JFlow_FormWizard/Form_Tracert.gif'>&nbsp;搜尋結果",1);
Grid.AddRestTab(""); 
Grid.AddRow("");
//-----------標頭--------------------------
Grid.AddRestTab(""); 
Grid.AddGridTitle("<font color ='0000FF'>此列為最上方列(可設定下面欄位有幾格)"+""+"</font>","","colspan=8");
Grid.AddRow(""); 
Grid.AddGridTitle("項次","","");
Grid.AddGridTitle("建檔人","","");
Grid.AddGridTitle("申請編號","","");
Grid.AddGridTitle("申請類別","","");
Grid.AddGridTitle("主旨","","");
Grid.AddGridTitle("審核否","","");
Grid.AddGridTitle("申請狀態","","");
Grid.AddGridTitle("申請時間","","");
//-----------頁面顯示筆數Size--------------
Grid.setDataInfo(Rs,Page,PageSize);
//-----------判斷取得對應資料--------------
	if(Rs.next())
	{			
		Grid.moveToPage();
		//---------------顯示資料迴圈-------------------
		for(int i=0;i<PageSize;i++)
		{
			if(Rs.isAfterLast()) break;
			Grid.AddRow("");
			//-----------項次---------------------------
			Grid.AddCol(Grid.getGridSN(i),"align=center nowrap");
			//-----------建檔人-------------------------
			String build[]=null;
			build=Rs.getString("FD_Data1").split(",");
			String buildman=build[1];
			Grid.AddCol(buildman,"align=center nowrap");
			//-----------申請編號-----------------------
			Grid.AddCol(Rs.getString("FD_Data3"),"align=center nowrap");
			//-----------申請類別-----------------------
			String applytype[]=null;
			applytype=Rs.getString("FD_Data4").split(",");
			String AT=applytype[1];
			Grid.AddCol(AT,"align=center nowrap");  
			//-----------主旨---------------------------
			Grid.AddCol(Rs.getString("FD_Data5"),"align=center nowrap"); 
			//-----------第五關審核填寫N或Y-------------
			String Judge[]=null;
			Judge=Rs.getString("FD_Data15").split(",");
			String J=Judge[0];
			Grid.AddCol(J,"align=center nowrap"); 
			//-----------申請狀態-----------------------
			String Mark="";
			Mark=Rs.getString("FR_FinishState");
			if(Mark.equals("")||Mark==null){Grid.AddCol("","align=center nowrap");}
			else if(Mark.equals("0")){Grid.AddCol("申請中","align=center nowrap");}
			else if(Mark.equals("1")){Grid.AddCol("已審核","align=center nowrap");}
			else if(Mark.equals("2")){Grid.AddCol("退單","align=center nowrap");}
			else if(Mark.equals("3")){Grid.AddCol("抽單","align=center nowrap");}
			//-----------申請時間-----------------------
			String applydate[]=null;
			applydate=Rs.getString("FD_RecDate").split(" ");
			String AD1=applydate[0];
			String AD2=applydate[1];
			String AD2_1=AD2.substring(0,8);          //只取(時:分:秒)
			Grid.AddCol(AD1+"<br>"+AD2_1,"align=center nowrap");
			//-----------表單選項(下載,內容,關卡)-------
			Grid.AddRow("");
			Grid.AddCol("&nbsp;&nbsp;<img src='/Modules/JFlow_FormWizard/form.png' border=0>&nbsp;<a href='javascript:ProcEditEvent("+Rs.getString("FR_RecId")+","+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+","+Rs.getString("FD_OrgId")+")'>申請內容</a>&nbsp;&nbsp;&nbsp;<img src='/images/view.gif' border=0>&nbsp;<a href='javascript:perViewStage("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'>進度檢視</a>","align=right nowrap  colspan=8");
			//------------------------------------------
			if(!Rs.next()) break;
		}				
	}
	else
	{
		Grid.AddRow("");
		Grid.AddRow("");
		Grid.AddCol("沒有資料","align=center colspan=8");
	}
Grid.Show();	
//-----------釋放--------------------------
Rs.close();
Conn.close();
Grid=null;
UI=null;
%>
<script>
//-----------檔案內容----------------------
function perViewForm(FR_FormId,FR_DataId)
{
	var OK=popDialog('perViewForm','/Modules/ServiceFormCheck9/Form_Apply_ContentWang1.jsp?OP=View&FI_RecId='+FR_FormId+'&FD_RecId='+FR_DataId,screen.availWidth*0.8,587);   
}  
function ProcEditEvent(FR_RecId,FR_FormId,FR_DataId,FD_OrgId)
{
	var OK=popDialog('EditEvent','/Modules/ServiceFormCheck9/Report_Check_Content.jsp?OP=hasCheck&FR_RecId='+FR_RecId+'&FI_RecId='+FR_FormId+'&FD_RecId='+FR_DataId+'&OrgId='+FD_OrgId,screen.availWidth*0.8,800);
} 
//-----------進度檢視----------------------
function perViewStage(FR_FormId,FR_DataId)
{
	var OK=popDialog('perViewStage','/Modules/ServiceFormCheck9/Form_Apply_FinishWang1.jsp?OP=View&FId='+FR_FormId+'&FDId='+FR_DataId,screen.availWidth*0.8,400);       
}
</script>

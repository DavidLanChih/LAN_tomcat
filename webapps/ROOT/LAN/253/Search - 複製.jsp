<%@ include file="/kernel.jsp" %><%@page import="leeten.*" %>
<%@page import="java.net.*,java.lang.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat,java.sql.*,java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=MS950" %>
<%
//----------------宣告-----------------------------------
String OP="",Site="index.jsp",UpdateLink="";
String SqlStr="",SqlStr2="",UserNo="",UserName="",ADYear="",yadd="",Seniority="",Mark="";
String FD_Data1Arr[]=null;
String FD_Data1="",FD_Data3="",FD_Data2="",FD_Data5="",FD_Data4="",FD_Data8="",FD_RecDate="";
ResultSet Rs=null;
//----------頁面顯示比數宣告-------------------------
int Page=1,PageSize=15,TTLPage=1,TTLRec=0;
String ReApply="",DeleteFunction="",CancelStr="";
//------------接收值宣告------------------------------

//-------------日期範圍-----------------------
String Year1=req("Year1",request);
String Month1=req("Month1",request);
//---------------申請單狀態-------------------
String Status=req("Status",request);
//--------------換頁按鈕---------------------
if(req("P",request)=="") Page=1; else Page=Integer.parseInt(req("P",request));
//------------防止瀏覽器快取網頁-----------------
NoCatch(response);
//-----------------------------------------------
//-------------日期選擇範圍1補零-----------------------------
String FD_Data2Arr[]=null;
String FD_Data3Arr[]=null;
String FD_Data4Arr[]=null;
String d1="",d2="",d3="";
FD_Data2Arr=Year1.split("/");
d1=FD_Data2Arr[0];
FD_Data3Arr=Year1.split("/");
d2=FD_Data3Arr[1];
if(d2.length()==1)
	d2="0"+FD_Data3Arr[1];
else if((d2.length()>1))
	d2=FD_Data3Arr[1];
FD_Data4Arr=Year1.split("/");
d3=FD_Data4Arr[2];
//-------------日期選擇範圍2補零------------------------
String FD_Data5Arr[]=null;
String FD_Data6Arr[]=null;
String FD_Data7Arr[]=null;
String d4="",d5="",d6="";
FD_Data5Arr=Month1.split("/");
d4=FD_Data5Arr[0];
FD_Data6Arr=Month1.split("/");
d5=FD_Data6Arr[1];
if(d5.length()==1)
	d5="0"+FD_Data6Arr[1];
else if((d5.length()>1))
	d5=FD_Data6Arr[1];
FD_Data7Arr=Month1.split("/");
d6=FD_Data7Arr[2];
//------------------------------------------
Date Now = new Date();
NoCatch(response);
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//--------------宣告Grid------------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
//------------------MS-SQL資料庫欄位呼叫--------------------------
SqlStr="select FR_FormId,FR_DataId,FD_FormId,FD_Data1,FD_Data2,FD_Data3,FD_Data4,FD_Data5,FD_Data8,FD_Data9,FR_FinishState from flow_formdata,flow_form_rulestage where flow_formdata.FD_RecId="+
"flow_form_rulestage.FR_DataId and  flow_formdata.FD_FormId IN ('232','235','237')"+
"and (convert(varchar,FD_Data1,111)  BETWEEN  '"+d1+"/"+d2+"/"+d3+"' and '"+d4+"/"+d5+"/"+d6+"')";




//------------------申請單狀態------------------------------------
if(Status!=""){
SqlStr+="and (FR_FinishState = '"+Status+"')";
}


//-----------------------------------------------------------------
//out.println(SqlStr);
//out.flush();
Rs=Data.getSmt(Conn,SqlStr);

//-----------------選擇表單-------------------------------
Grid.AddTab("表單查詢","index.jsp",0);
Grid.AddTab("<img src='/Modules/JFlow_FormWizard/Form_Tracert.gif'>&nbsp;查詢結果",1);
Grid.AddRestTab(""); 
Grid.AddRow("");
//----------------標頭----------------------------
Grid.AddRestTab(""); 
Grid.AddGridTitle("<font color ='0000FF'>"+""+"</font>","","colspan=8");
Grid.AddRow(""); 
Grid.AddGridTitle("項次","","");
Grid.AddGridTitle("承辦人","","");;
Grid.AddGridTitle("承辦日期","","");
Grid.AddGridTitle("表單類別","","");
Grid.AddGridTitle("機台號","","");
Grid.AddGridTitle("申請狀態","","");
//------------------頁面顯示筆數Size-------------------------------
Grid.setDataInfo(Rs,Page,PageSize);
//-------------------判斷有無資料---------------------------
if(Rs.next())
{		
	Grid.moveToPage();
	//---------------顯示資料迴圈----------------------------
	for(int i=0;i<PageSize;i++)
	{
		if(Rs.isAfterLast()) break;
		ReApply="";DeleteFunction="";CancelStr="";
        Grid.AddRow("");
        Grid.AddCol(Grid.getGridSN(i),"align=center nowrap");  
		//---------------承辦人------------------
		FD_Data5Arr=Rs.getString("FD_Data5").split(",");
		FD_Data5=FD_Data5Arr[1];
		Grid.AddCol(FD_Data5,"align=center nowrap");
		//--------------承辦日期-----------------
		Grid.AddCol(Rs.getString("FD_Data1"),"align=center nowrap");
		//--------------表單類別-----------------
		FD_Data3=Rs.getString("FD_FormId");
		if(FD_Data3.equals("232"))
		{
			Grid.AddCol("付款調整","align=center nowrap");
		}else if(FD_Data3.equals("235"))
			{
				Grid.AddCol("信用卡帳務","align=center nowrap");
			}else if(FD_Data3.equals("237")){
				Grid.AddCol("發票(清機條)","align=center nowrap");
			}
		
		//---------------機台號--------------------	
		Grid.AddCol(Rs.getString("FD_Data2"),"align=center nowrap");
		//--------------相關單位-----------------
		/*FD_Data1Arr=Rs.getString("FD_Data8").split(",");
		FD_Data8=FD_Data1Arr[1];
		Grid.AddCol(FD_Data8,"align=center nowrap");	*/
		//--------------申請狀態-------------------
		Mark=Rs.getString("FR_FinishState");
		if(Mark==null)Grid.AddCol("","align=center nowrap");			
			else if(Mark.equals(""))Grid.AddCol("","align=center nowrap");
			else if(Mark.equals("0"))Grid.AddCol("申請中","align=center nowrap");
			else if(Mark.equals("1"))Grid.AddCol("通過","align=center nowrap");
			else if(Mark.equals("2"))Grid.AddCol("退單","align=center nowrap");
			else if(Mark.equals("3"))Grid.AddCol("抽單","align=center nowrap");		
		//-------------表單選項(下載,內容,關卡)------------------
		Grid.AddRow("");
		Grid.AddCol("&nbsp;&nbsp;<img src='/Modules/JFlow_FormWizard/form.png' border=0>&nbsp;<a href='javascript:perViewForm("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'>申請內容</a>&nbsp;&nbsp;&nbsp;<img src='/images/view.gif' border=0>&nbsp;<a href='javascript:perViewStage("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'>進度檢視</a>","align=right nowrap  colspan=8");
		//-------------------------------------------
		if(!Rs.next()) break;		
	}
}   
else{
	Grid.AddRow("");
	Grid.AddRow("");
	Grid.AddCol("沒有資料","align=center colspan=8");
}
//-------------------釋放-------------------------
Rs.close();Rs=null;
Grid.Show();
Grid=null;
UI=null;
closeConn(Data,Conn);
%>
<iframe id='FrmTemp' src='' style='width:0;height:0' frameborder=0></iframe>
<script>
//--------------------------下載檔案--------------------------------------------------
function perPrintForm(FR_FormId,FR_DataId)
{
   window.open("/Modules/ServiceFormCheck8/Form_Apply_Content_Print1.jsp?FI_RecId="+FR_FormId+"&FD_RecId="+FR_DataId, "晨會日誌",'width=900,height=1200,toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
}
//--------------------------檔案內容--------------------------------------------------
function perViewForm(FR_FormId,FR_DataId)
{
   var OK=popDialog('perViewForm','/Modules/ServiceFormCheck8/Form_Apply_ContentWang1.jsp?OP=View&FI_RecId='+FR_FormId+'&FD_RecId='+FR_DataId,screen.availWidth*0.8,587);   
}   
//--------------------------進度檢視--------------------------------------------------
function perViewStage(FR_FormId,FR_DataId)
{
    var OK=popDialog('perViewStage','/Modules/ServiceFormCheck8/Form_Apply_FinishWang1.jsp?OP=View&FId='+FR_FormId+'&FDId='+FR_DataId,screen.availWidth*0.8,400);       
}

</script>

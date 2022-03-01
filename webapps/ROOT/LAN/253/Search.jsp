<%@ include file="/kernel.jsp" %><%@page import="leeten.*" %>
<%@page import="java.net.*,java.lang.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat,java.sql.*,java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=MS950" %>
<%
//----------------宣告-----------------------------------
String OP="",Site="index.jsp",UpdateLink="";
String SqlStr="",SqlStr2="",UserNo="",UserName="",ADYear="",yadd="",Seniority="",Mark="";
String FD_Data1Arr[]=null;
String FD_Data2Arr[]=null;
String FD_Data3Arr[]=null;
String FD_Data4Arr[]=null;
String FD_Data5Arr[]=null;
String FD_Data6Arr[]=null;
String FD_Data1="",FD_Data2="",FD_Data3="",FD_Data4="",FD_Data5="",FD_Data6="",FD_Data7="",FD_Data8="",FD_Data9="",FD_Data10="",FD_Data11="",FD_Data12="",FD_Data13="",FD_Data14="",FD_Data15="",FD_Data16="",FD_Data17="",FD_Data18="",FD_RecDate="";
ResultSet Rs=null;
//----------頁面顯示比數宣告-------------------------
int Page=1,PageSize=15,TTLPage=1,TTLRec=0;   //從第一頁開始，一頁最大可有15筆
String ReApply="",DeleteFunction="",CancelStr="";
//------------接收值宣告------------------------------

//-------------日期範圍-----------------------
String Year1=req("Year1",request);
String Year2=req("Month1",request);
//---------------申請單狀態-------------------
String Status=req("Status",request);
//--------------換頁按鈕---------------------
if(req("P",request)=="") Page=1; else Page=Integer.parseInt(req("P",request));
//------------防止瀏覽器快取網頁-----------------
NoCatch(response);
//-----------------------------------------------
//-------------日期選擇範圍1補零-----------------------------

String d1="",d2="",d3="";
FD_Data1Arr=Year1.split("/");
d1=FD_Data1Arr[0];
d2=String.format("%02d",  Integer.parseInt(FD_Data1Arr[1]));
d3=String.format("%02d",  Integer.parseInt(FD_Data1Arr[2]));
//out.print(d1);
//-------------日期選擇範圍2補零------------------------

String d4="",d5="",d6="";
FD_Data2Arr=Year2.split("/");
d4=FD_Data2Arr[0];
d5=String.format("%02d",  Integer.parseInt(FD_Data2Arr[1]));
d6=String.format("%02d",  Integer.parseInt(FD_Data2Arr[2]));

//------------------------------------------
Date Now = new Date();
NoCatch(response);
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//--------------宣告Grid------------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
//------------------MS-SQL資料庫欄位呼叫--------------------------
SqlStr="select FD_RecId,FR_RecId,FD_OrgId,FR_FormId,FR_DataId,FD_FormId,FD_Data1,FD_Data2,FD_Data3,FD_Data4,FD_Data5,FD_Data6,FD_Data7,FD_Data8,FD_Data9,FD_Data10,FD_Data11,FD_Data12,FD_Data13,FD_Data14,FD_Data15,FD_Data16,FD_Data17,FD_Data18,FD_RecDate,FR_FinishState from flow_formdata,flow_form_rulestage where flow_formdata.FD_RecId="+"flow_form_rulestage.FR_DataId and flow_formdata.FD_FormId IN ('253','255','257','274')"+"and (CONVERT(varchar(10),CONVERT(datetime,FD_Data3,111),111)  BETWEEN  '"+d1+"/"+d2+"/"+d3+"' and '"+d4+"/"+d5+"/"+d6+"')";
//convert(鎖定某個欄位)between進行比對選取範圍
//out.println();


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
Grid.AddGridTitle("編號","","");
Grid.AddGridTitle("經辦人","","");;
Grid.AddGridTitle("分機","","");
Grid.AddGridTitle("專櫃名稱","","");
Grid.AddGridTitle("棟","","");
Grid.AddGridTitle("樓","","");
Grid.AddGridTitle("類別","","");
Grid.AddGridTitle("申請狀態","","");
Grid.AddGridTitle("申請時間","","");
//------------------頁面顯示筆數Size-------------------------------
Grid.setDataInfo(Rs,Page,PageSize);
//-------------------判斷有無資料---------------------------
if(Rs.next())
{		
	Grid.moveToPage();
	//---------------顯示資料迴圈----------------------------
	for(int i=0;i<PageSize;i++)                                                              //計算取得筆數
	{
		if(Rs.isAfterLast()) break;
		ReApply="";DeleteFunction="";CancelStr="";
        Grid.AddRow("");
        Grid.AddCol(Rs.getString("FD_RecId"),"align=center nowrap");                                        
		//---------------經辦人------------------
		FD_Data2Arr=Rs.getString("FD_Data1").split(",");
		FD_Data1=FD_Data2Arr[1];
		Grid.AddCol(FD_Data1,"align=center nowrap");                                                 
		//--------------分機-----------------
		Grid.AddCol(Rs.getString("FD_Data2"),"align=center nowrap"); 
        //--------------專櫃名稱-----------------
		Grid.AddCol(Rs.getString("FD_Data4"),"align=center nowrap"); 		
        //--------------棟-----------------
		FD_Data3Arr=Rs.getString("FD_Data6").split(",");
		FD_Data6=FD_Data3Arr[1];
		Grid.AddCol(FD_Data6,"align=center nowrap");
        //--------------樓-----------------
		FD_Data4Arr=Rs.getString("FD_Data7").split(",");
		FD_Data7=FD_Data4Arr[1];
		Grid.AddCol(FD_Data7,"align=center nowrap");
        //--------------維修類別-----------------
		FD_Data5Arr=Rs.getString("FD_Data9").split(",");
		FD_Data9=FD_Data5Arr[1];
		Grid.AddCol(FD_Data9,"align=center nowrap");
        //--------------申請狀態-----------------
		Mark=Rs.getString("FR_FinishState");
		if(Mark==null)Grid.AddCol("","align=center nowrap");			                             
			else if(Mark.equals(""))Grid.AddCol("","align=center nowrap");
			else if(Mark.equals("0"))Grid.AddCol("申請中","align=center nowrap");
			else if(Mark.equals("1"))Grid.AddCol("通過","align=center nowrap");
			else if(Mark.equals("2"))Grid.AddCol("退單","align=center nowrap");
			else if(Mark.equals("3"))Grid.AddCol("抽單","align=center nowrap");		
		
        //--------------申請時間-----------------
		FD_Data6Arr=Rs.getString("FD_RecDate").split(" ");
		FD_Data10=FD_Data6Arr[0];
		FD_Data11=FD_Data6Arr[1];
		Grid.AddCol(FD_Data10+"<br>"+FD_Data11,"align=center nowrap");
		//--------------申請狀態-------------------
		//-------------表單選項(下載,內容,關卡)------------------		
		Grid.AddRow("");
		//Grid.AddCol("&nbsp;&nbsp;<img src='/Modules/JFlow_FormWizard/form.png' border=0>&nbsp;<a href='javascript:perViewForm("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'>申請內容</a>&nbsp;&nbsp;&nbsp;<img src='/images/view.gif' border=0>&nbsp;<a href='javascript:perViewStage("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'>進度檢視</a>","align=right nowrap  colspan=8");
		Grid.AddCol("&nbsp;&nbsp;<img src='/Modules/JFlow_FormWizard/form.png' border=0>&nbsp;<a href='javascript:ProcEditEvent("+Rs.getString("FR_RecId")+","+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+","+Rs.getString("FD_OrgId")+")'>申請內容</a>&nbsp;&nbsp;&nbsp;<img src='/images/view.gif' border=0>&nbsp;<a href='javascript:perViewStage("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'>進度檢視</a>","align=right nowrap  colspan=9");                         //第八欄所呈現資料
		//-------------------------------------------
		if(!Rs.next()) break;		                                  //在FOR迴圈內show出每筆，直到結束
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
   window.open("/Modules/253/Form_Apply_Content_Print1.jsp?FI_RecId="+FR_FormId+"&FD_RecId="+FR_DataId, "晨會日誌",'width=900,height=1200,toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
}
//--------------------------檔案內容--------------------------------------------------
function perViewForm(FR_FormId,FR_DataId)
{
   var OK=popDialog('perViewForm','/Modules/253/Form_Apply_ContentWang1.jsp?OP=View&FI_RecId='+FR_FormId+'&FD_RecId='+FR_DataId,screen.availWidth*0.8,587);   
}  

function ProcEditEvent(FR_RecId,FR_FormId,FR_DataId,FD_OrgId)
{
   var OK=popDialog('EditEvent','/Modules/253/Report_Check_Content.jsp?OP=hasCheck&FR_RecId='+FR_RecId+'&FI_RecId='+FR_FormId+'&FD_RecId='+FR_DataId+'&OrgId='+FD_OrgId,screen.availWidth*0.8,800);

} 
//--------------------------進度檢視--------------------------------------------------
function perViewStage(FR_FormId,FR_DataId)
{
    var OK=popDialog('perViewStage','/Modules/253/Form_Apply_FinishWang1.jsp?OP=View&FId='+FR_FormId+'&FDId='+FR_DataId,screen.availWidth*0.8,400);       
}

</script>

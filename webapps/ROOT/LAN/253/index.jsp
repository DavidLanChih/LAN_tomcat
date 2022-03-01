<%@ include file="/kernel.jsp" %><%@page import="leeten.*" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=MS950" %>
<%!
int g_SolarMonth[]={31,28,31,30,31,30,31,31,30,31,30,31};

public int SolarDays(int xYear,int xMonth)
{
   int Days = g_SolarMonth[xMonth];
   if(xMonth == 2)
   {
      if ((xYear % 4 == 0) && (xYear % 100 != 0) || (xYear % 400 == 0)) {Days = 29;}      //計算2月是否為閏月的方式
   }
   return Days;
}
%>
<%
//----------------宣告----------------------
leeten.Date JDate=new leeten.Date();
String SqlStr="";
String CurrDate="",StartDate="",EndDate="";
int i=0;
Date Now = new Date();

CurrDate=req("D",request);
if(CurrDate.equals("")) CurrDate=JDate.ToDay();
String DateArr[]=CurrDate.split("/");
String PYear=DateArr[0];
String PMonth=DateArr[1];
String PDay=DateArr[2];
String days[]=new String[42];  
int Days=0;

for(i=0;i<42;i++)  
{  
    days[i]="";   
}  

Days=SolarDays(Integer.parseInt(PYear),Integer.parseInt(PMonth)-1);
StartDate=PYear+"/"+PMonth+"/1";
EndDate=PYear+"/"+PMonth+"/"+Days;

//--------防止瀏覽器快取網頁-----------------
NoCatch(response);
//------------宣告按鈕----------------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//------------MS SQL設定-----------------------------
String SelectUserStr="";
ResultSet Rs=null;
SqlStr="select UD_ID,OrgName from Org where UD_ID NOT like 'cy%' and UD_ID<>'' and UD_ID = substring( UD_ID, 1, 5 ) and UD_ID NOT like 'p%' and UD_ID NOT like 'x%'";
//out.println(SqlStr);
Rs=Data.getSmt(Conn,SqlStr);
//-------------宣告Grid-------------------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.AddRow("");
//----------------日期範圍(起始日及結束日)------------------------------
Grid.AddGridTitle("承辦日期：","",""); 
Grid.AddCol("<input type=text name=Year1 id=Year1 value='"+StartDate+"' onclick=\"calendar(this);\" readonly maxlength=10 size=10> ~ <input type=text name=Month1 id=Month1 value='"+EndDate+"' onclick=\"calendar(this);\" readonly maxlength=10 size=10>","colspan=7 rowspan=1 align=left");  
Grid.AddRow("");
//------------------申請單狀態(下拉式選單)----------------------------
Grid.AddGridTitle("狀態：","","");
Grid.AddCol("<select size=1 name='Status' id='Status'><option value=>請選擇</option><option value=0>申請中</option><option value=1>通過</option><option value=2>退單</option><option value=3>抽單</option></select>","colspan=7 rowspan=1 align=left");
Grid.AddRow("");
//-----------------(確定)按鈕-----------------------
Grid.AddCol(UI.addButtonForSubmit()+"<input type=hidden name='Button' value='new'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;","colspan=2 rowspan=8 align=center");
Grid.setForm(true); 
Grid.setFormAction("Search.jsp");
//-----------------(匯出Excel)按鈕-----------------------
Grid.AddCol("<input type='button' name='op' onclick='printExcel(253)' value='陽春版匯出Excel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;","colspan=2 rowspan=8 align=center");
Grid.AddCol("<input type='button' name='op' onclick='printExcel_1(253)' value='多樣模版匯出Excel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;","colspan=2 rowspan=8 align=center");
Grid.AddCol("<input type='button' name='op' onclick='printExcel_2(253)' value='完整設定版匯出Excel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;","colspan=2 rowspan=8 align=center");
Grid.setForm(true); 
Grid.AddRow("");
//------------------釋放-----------------------------
Rs.close();Rs=null;
Grid.Show();
Grid=null;
UI=null;
closeConn(Data,Conn);
%>

<script>

function printExcel(num)                                                 //產生EXCEL
{
	var Year1=document.getElementById("Year1").value;                    //起始日期
	var Month1=document.getElementById("Month1").value;                  //結束日期
	var Fcategory="";

    if(num=="253")                                                       //將變數轉換成模組代碼名稱，存在Fcategory
	{
		 Fcategory="JFlow_Form_253";
	}
			
	window.open("Report_Print.jsp?SDate="+Year1+"&EDate="+Month1+"&Fcategory="+Fcategory, "",'width=900,height=1200,toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
}

function printExcel_1(num)                                               //產生EXCEL
{
	var Year1=document.getElementById("Year1").value;                    //起始日期
	var Month1=document.getElementById("Month1").value;                  //結束日期
	var Fcategory="";

    if(num=="253")                                                       //將變數轉換成模組代碼名稱，存在Fcategory
	{
		 Fcategory="JFlow_Form_253";
	}
			
	window.open("Report_Print_1.jsp?SDate="+Year1+"&EDate="+Month1+"&Fcategory="+Fcategory, "",'width=900,height=1200,toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
}

function printExcel_2(num)                                               //產生EXCEL
{
	var Year1=document.getElementById("Year1").value;                    //起始日期
	var Month1=document.getElementById("Month1").value;                  //結束日期
	var S=document.getElementById("Status");
	var Status=S.options[S.selectedIndex].value;
	var Fcategory="";

    if(num=="253")                                                       //將變數轉換成模組代碼名稱，存在Fcategory
	{
		 Fcategory="JFlow_Form_253";
	}
			
	window.open("Report_Print_2.jsp?SDate="+Year1+"&EDate="+Month1+"&Fcategory="+Fcategory+"&Status="+Status, "",'width=900,height=1200,toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
}
</script>

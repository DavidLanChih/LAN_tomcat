<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %>
<%!
int g_SolarMonth[]={31,28,31,30,31,30,31,31,30,31,30,31};
public int SolarDays(int xYear,int xMonth)                                               //套件預設格式(當月最後一天的日期)
{
   int Days = g_SolarMonth[xMonth];
   if(xMonth == 2)
   {
      if ((xYear % 4 == 0) && (xYear % 100 != 0) || (xYear % 400 == 0)) {Days = 29;}     //計算2月是否為閏月的方式
   }
   return Days;
}
%>
<%
//-----宣告日期------------------------------
leeten.Date JDate=new leeten.Date();
String CurrDate="";
CurrDate=JDate.ToDay();
String DateArr[]=CurrDate.split("/"),PYear=DateArr[0],PMonth=DateArr[1],PDay=DateArr[2];
//-----(變更月份日期:前一個月的"月")---------
int Days=0;
int iPMonth=Integer.parseInt(PMonth);                                                    //將字串(當月)PMonth轉成整數(當月)iPMonth
int iBMonth=iPMonth-1;                                                                   //將月份-1
String sBMonth=Integer.toString(iBMonth);                                                //將整數(前個月)iBMonth轉成字串(前個月)sBMonth
//-----(變更月份日期:前一個月的"日")---------
Days=SolarDays(Integer.parseInt(PYear),Integer.parseInt(PMonth)-1);                      //"日"使用套件格式
int iPYear= Integer.parseInt(PYear);                                                     //將字串(當年)PYear轉成整數(當年)iPYear
if (Days==31)
	{
		Days=30;
	}
else if (Days==30)
	{
		Days=31;
	}
else if (Days==28||Days==29)
	{
		Days=31;
	}
else if ((Days==31&&iPMonth==3&&iPYear%4==0&&iPYear%100!=0)||(Days==31&&iPMonth==3&&iPYear%400==0))
	{
		Days=29;
	}
else if (Days==31&&iPMonth==3)
	{
		Days=28;
	}
//-----選取月份日期(前一個月的"年/月/日")----
String StartDate="",EndDate="";
StartDate=PYear+"/"+sBMonth+"/1";
EndDate=PYear+"/"+sBMonth+"/"+Days;
//-----防止瀏覽器快取網頁--------------------
NoCatch(response);
//-----宣告按鈕------------------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//-----宣告Grid------------------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.AddRow("");
//-----日期範圍(起始日及結束日)--------------
Grid.AddGridTitle("<font size=2>查詢期間：</font>","","colspan=6 rowspan=1 align=center"); 
Grid.AddCol("<input type='text' name='C1' id='C1' value='"+StartDate+"' onclick=\"calendar(this);\" readonly maxlength=10 size=20 > ~ <input type='text' name='C2' id='C2' value='"+EndDate+"' onclick=\"calendar(this);\" readonly maxlength=10 size=20>&nbsp;&nbsp;&nbsp;&nbsp;"+UI.addButtonForSubmit("查詢結果")+"<input type='hidden' name='Button' value='new'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='button' name='mail' value='發送E-mail' onclick='sendmail()'>","colspan=2 rowspan=1 align=left");  
Grid.AddRow("");
//-----(查詢結果)按鈕+(發送E-mail)按鈕------------------------
Grid.setForm(true); 
Grid.setFormAction("Search.jsp");
//-----釋放----------------------------------
Grid.Show();
Grid=null;
UI=null;
%>
<script>

//var Start=new Array;
//var End=new Array;
var C1=document.getElementById("C1").value;
var C2=document.getElementById("C2").value;

//Start=C1.split("/");
//End=C2.split("/");

function sendmail()
{
	//window.open("S_mw0505.jsp?d1="+Start[0]+"&d2="+Start[1]+"&d3="+Start[2]+"&d4="+End[0]+"&d5="+End[1]+"&d6="+End[2]+"","離職人員表單","width=1200,height=1000,scrollbar=1");
	window.open("S_mw0505.jsp?D1="+C1+"&D2="+C2+"","離職人員表單","width=1200,height=1000,scrollbar=1");
	alert(C1+"\n"+C2);
	
}
	
</script>
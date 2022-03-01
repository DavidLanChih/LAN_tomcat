<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %>
<%!
int g_SolarMonth[]={31,28,31,30,31,30,31,31,30,31,30,31};
public int SolarDays(int xYear,int xMonth)
{
   int Days = g_SolarMonth[xMonth];
   if(xMonth == 2)
   {
      if ((xYear % 4 == 0) && (xYear % 100 != 0) || (xYear % 400 == 0)) {Days = 29;}
   }
   return Days;
}
%>
<%
//------------宣告-------------------------
leeten.Date JDate=new leeten.Date();
String CurrDate="",StartDate="",EndDate="";
int i=0;
CurrDate=JDate.ToDay();
String DateArr[]=CurrDate.split("/");
String PYear=DateArr[0];
String PMonth=DateArr[1];
String PDay=DateArr[2];
String days[]=new String[42];  
int Days=0;
Days=SolarDays(Integer.parseInt(PYear),Integer.parseInt(PMonth)-1);
StartDate=PYear+"/"+PMonth+"/1";
EndDate=PYear+"/"+PMonth+"/"+Days;
//------------防止瀏覽器快取網頁-----------
NoCatch(response);
//------------宣告按鈕---------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//------------宣告Grid---------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.AddRow("");
//------------日期範圍---------------------
Grid.AddGridTitle("承辦日期：","",""); 
Grid.AddCol("&nbsp;<input type=text name=T1 id=T1 value='"+StartDate+"' onclick=\"calendar(this);\" readonly maxlength=10 size=10> ~ <input type=text name=T2 id=T2 value='"+EndDate+"' onclick=\"calendar(this);\" readonly maxlength=10 size=10>","colspan=7 rowspan=1 align=left");  
Grid.AddRow("");
//------------狀態選單---------------------
Grid.AddGridTitle("狀態：","","");
Grid.AddCol("&nbsp;<select size=1 style='width:95px;' name='Status' id='Status'><option value=''>請選擇</option><option value=0>未審核</option><option value=1>已審核</option></select>&nbsp;&nbsp;"+UI.addButtonForSubmit()+"<input type=hidden name='Button' value='new'>","colspan=4 rowspan=1 align=left");
Grid.AddGridTitle("狀態：申請中","","");
Grid.AddCol("<input type='button' name='op' onclick='sendmail()' value='&nbsp;直接發送至設定名單之E-mail&nbsp;'>","colspan=2 align=center");
Grid.setForm(true); 
Grid.setFormAction("Search.jsp");
//------------釋放-------------------------
Grid.Show();
Grid=null;
UI=null;
closeConn(Data,Conn);
%>
<script>
//------------發送E-mail-------------------
function sendmail()
{
	var T1=document.getElementById("T1").value;
	var T2=document.getElementById("T2").value;
	var Status=document.getElementById("Status").value;
	window.open("sendmail3.jsp?T1="+T1+"&T2="+T2+"&Status="+Status, "會計帳務表單申請中",'width=900,height=1200,toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
}
</script>

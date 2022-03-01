<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
leeten.Date JDate=new leeten.Date();
leeten.Util JUtil=new leeten.Util();
String OP="",SqlStr="",SearchTargetStr="",CurrDate="";
String SDate=JDate.MonthOfStartDay();
String EDate=JDate.MonthOfEndDay();
String FI_RecId=req("FI_RecId",request);
String I_Value=req("I_Value",request);
String I_Valuename="";
CurrDate=req("D",request);
if(CurrDate.equals("")) CurrDate=JDate.ToDay();
String DateArr[]=CurrDate.split("/");
String PYear=DateArr[0];
String PMonth=DateArr[1];
String PDay=DateArr[2];
String days[]=new String[42]; 
OP=req("OP",request);
SqlStr="SELECT I_RecId, I_FRecId, I_Name, I_Value, I_Sort, I_isHidden FROM flow_fieldtypeitem where i_frecid='117' and i_ishidden='0' and I_Value='"+I_Value+"'";
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
	I_Valuename=Rs.getString("I_Name");
}
Rs.close();Rs=null;
UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("100%");
Grid.AddTab("<a href='Report_Calendar.jsp?FI_RecId="+FI_RecId+"&I_Value="+I_Value+"&D="+JDate.DateAdd("M",PYear+"/"+PMonth+"/1",-1)+"' title='上個月'><img src=images/c_pre.gif border=0></a>&nbsp;<b>"+CurrDate+"</b>&nbsp;<a href='Report_Calendar.jsp?FI_RecId="+FI_RecId+"&I_Value="+I_Value+"&D="+JDate.DateAdd("M",PYear+"/"+PMonth+"/1",1)+"' title='下個月'><img src=images/c_next.gif border=0></a>",0);
//Grid.AddTab("<a href style='cursor:hand' onclick='ProcPrint("+FI_RecId+","+I_Value+","+PYear+","+PMonth+",1)' title='匯出Excel'><img src=/images/print.gif border=0>&nbsp;匯出Excel</a>",0);
Grid.AddTab("<a href='index_Result.jsp?FI_RecId="+FI_RecId+"&I_Value="+I_Value+"' style='cursor:hand' title='活動預約查詢'><img src=/images/print.gif border=0>&nbsp;"+I_Valuename+"活動預約查詢</a>",1);
Grid.AddRestTab("");
Grid.AddRow("");
Grid.AddCol("活動預約查詢時間:","");  
Grid.AddCol(UI.SelectDate("SDate",SDate)+"~"+UI.SelectDate("EDate",EDate),"");  
Grid.AddRow("");
Grid.AddCol("<input type='button' name='op' onclick='printExcel("+FI_RecId+","+I_Value+")' value='匯出Excel'>"," colspan=2 align=center");
Grid.Show();
Grid=null;
UI=null;
closeConn(Data,Conn);
%>
<script>
function printExcel(FI_RecId,I_Value)
{
	var Date1 = document.getElementsByName('SDate');
	var  SDate = Date1[0].value;
	var Date2 = document.getElementsByName('EDate');
	var  EDate = Date2[0].value;
	
	
	window.open("Report_Print.jsp?FI_RecId="+FI_RecId+"&I_Value="+I_Value+"&SDate="+SDate+"&EDate="+EDate, "資源預約申請單",'width=900,height=1200,toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
}
</script>
<%@ page contentType="text/html;charset=MS950" %><%@ include file="/kernel.jsp" %><%@ page  import="java.util.*,java.text.SimpleDateFormat" %><%@ page import="java.util.Date" %>

<%@ page import="java.text.SimpleDateFormat,java.text.ParseException"%>
<%@page import="java.text.SimpleDateFormat"%>
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
%><%
NoCatch(response); 
ResultSet Rs=null;
Html UI=new Html(request,pageContext,Data,Conn); 
leeten.Util Util=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String Site="Report_Calendar.jsp",CurrDate="",StartDate="",EndDate="",ExeDate="";
String OP="",SqlStr_Form="",SqlStr="",BgColor="",OrgId="";
String FI_RecId=req("FI_RecId",request);
StringBuffer DayContent=new StringBuffer();
StringBuffer Content=new StringBuffer();
int Page=1,PageSize=10,TTLPage=1,TTLRec=0;
int i=0;
CurrDate=req("D",request);
if(CurrDate.equals("")) CurrDate=JDate.ToDay();
String DateArr[]=CurrDate.split("/");
String PYear=DateArr[0];
String PMonth=DateArr[1];
String PDay=DateArr[2];
String days[]=new String[42];  
int Days=0;
//string Mo[]=null;
//String Mo1="";
String MD[]=null;
String MD_1="";

String Data5day="";

	 
OP=req("OP",request);

for(i=0;i<42;i++)  
{  
    days[i]="";   
}  

Days=SolarDays(Integer.parseInt(PYear),Integer.parseInt(PMonth)-1);
StartDate=PYear+"/"+PMonth+"/1";
EndDate=PYear+"/"+PMonth+"/"+Days;

Calendar thisMonth=Calendar.getInstance();  
thisMonth.set(Calendar.YEAR, Integer.parseInt(PYear));  
thisMonth.set(Calendar.MONTH, Integer.parseInt(PMonth)-1);
thisMonth.set(Calendar.DAY_OF_MONTH,1);
int firstIndex=thisMonth.get(Calendar.DAY_OF_WEEK)-1;  
int maxIndex=thisMonth.getActualMaximum(Calendar.DAY_OF_MONTH);  
for(i=0;i<maxIndex;i++)  
{  
    days[firstIndex+i]=String.valueOf(i+1);  
}  

GregorianCalendar Date2 = new GregorianCalendar();
String CurrYear=String.valueOf(Date2.get(Date2.YEAR)); 
String CurrMonth=String.valueOf(Date2.get(Date2.MONTH)+1);
String CurrDay=String.valueOf(Date2.get(Date2.DAY_OF_MONTH));

if(!FI_RecId.equals("")) 
{
	SqlStr_Form=" and (flow_form_rulestage.FR_FormId="+Data.toSql(FI_RecId)+" or flow_form_rulestage.FR_FormId IN ('253','255','257','274'))";
}
else                                                                                                       //如果有表單送出，
{SqlStr_Form=" and (flow_form_rulestage.FR_FormId='255' )";}         //SQL語法(表單模組ID為255)，儲存至字串SqlStr_Form

UI.Start();
Grid Grid=new Grid(request,out); 
Grid.Init(); 
Grid.setGridWidth("100%");
Grid.setGridHeight("100%");

Grid.AddTab("<a href='Report_Calendar.jsp?FI_RecId="+FI_RecId+"&D="+JDate.DateAdd("M",PYear+"/"+PMonth+"/1",-1)+"' title='上個月'><img src=images/c_pre.gif border=0></a>&nbsp;<b>"+CurrDate+"</b>&nbsp;<a href='Report_Calendar.jsp?FI_RecId="+FI_RecId+"&D="+JDate.DateAdd("M",PYear+"/"+PMonth+"/1",1)+"' title='下個月'><img src=images/c_next.gif border=0></a>",1);
Grid.AddTab("<a href style='cursor:hand' onclick='ProcPrint()' title='列印'><img src=/images/print.gif border=0>&nbsp;列印</a>",0);
Grid.AddRestTab("");
Grid.AddRow("");
Grid.AddRow("");
Content.append("<table width='100%' height='1' cellpadding='1' cellspacing='1' bgcolor='#DDDDDD'>");
Content.append("<tr>");
Content.append("<td align='center' width='14%'><font  color='red' style='font-size:18px'><b>星期日</b></font></td>");
Content.append("<td align='center' width='14%'><font  color='black' style='font-size:18px'><b>星期一</b></font></td>");
Content.append("<td align='center' width='14%'><font  color='black' style='font-size:18px'><b>星期二</b></font></td>");
Content.append("<td align='center' width='14%'><font  color='black' style='font-size:18px'><b>星期三</b></font></td>");
Content.append("<td align='center' width='14%'><font  color='black' style='font-size:18px'><b>星期四</b></font></td>");
Content.append("<td align='center' width='14%'><font  color='black' style='font-size:18px'><b>星期五</b></font></td>");
Content.append("<td align='center' width='14%'><font  color='red' style='font-size:18px'><b>星期六</b></font></td>");
Content.append("</tr>");
Content.append("</table>");
Content.append("<table width='100%' height='95%' cellpadding='1' cellspacing='1' bgcolor='black'>");


String StartTime="";
String DateToUse = CurrDate;
String DayYear = JDate.Year(DateToUse);
String DayMonth = JDate.Month(DateToUse);
String DayNumber= JDate.Day(DateToUse);
String DayWithOutYear = DayMonth + "/" + DayNumber;
String DayName = JDate.WeekOfDay(DateToUse);
String PrivateStr="",ExeOrgId=OrgId;  

   
			  
			  
if(!J_OrgId.equals(OrgId) && !OrgId.equals("")) 
{
  PrivateStr=" and J_Job.J_Private=0 ";
  ExeOrgId=OrgId;
}

for(int j=0;j<6;j++) 
{ 
    Content.append("<tr height='15%'>");
    for(i=j*7;i<(j+1)*7;i++) 
    {  
        BgColor="silver";
        DayContent.setLength(0); 
        if(!days[i].equals("")) 
        {
            int strd = Integer.parseInt(days[i]);
            int strm = Integer.parseInt(PMonth);
            String strday = String.format("%02d", strd);
      		String strMM = String.format("%02d", strm);
      		String strMonth =PYear+"/"+strm+"/"+days[i];
            String strdate=PYear+"/"+strMM+"/"+strday;
			
			
            //StartDate=PYear+"/"+PMonth+"/1";
            //EndDate=PYear+"/"+PMonth+"/"+Days;
            if(PYear.equals(CurrYear) && PMonth.equals(CurrMonth) && days[i].equals(CurrDay)) BgColor="#638FFD"; else BgColor="white";
            DayContent.append("<td width='14%' valign='top' bgcolor='"+BgColor+"' align='left'>");
            DayContent.append("<table width='100%' cellpadding='0' cellspacing='0' height='75'>");
            DayContent.append("    <tr height='15%'>");
            DayContent.append("        <td align='left' bgcolor='#DDDDDD'>");
            DayContent.append("        <a title='檢視當天申請人員'><img src=/images/more.gif border=0>&nbsp;");
            DayContent.append(days[i]); 
            //DayContent.append(strdate); 
            DayContent.append("        </a></td>");
            DayContent.append("    </tr>");
            DayContent.append("    <tr height='85%'><td height='85%' valign=top>");                 
           
			SqlStr="select flow_form_rulestage.FR_RecId,flow_form_rulestage.FR_FormId,flow_form_rulestage.FR_FinishState,flow_form_rulestage.FR_OrgId,flow_form_rulestage.FR_DataId,"+
			       "flow_forminfo.FI_Name,flow_formdata.FD_Data3,flow_formdata.FD_Data4,flow_formdata.FD_Data9,Org.OrgName	"+ //行事曆擷取資料庫的內容
			       "from flow_form_rulestage,flow_formdata,flow_forminfo,Org"+
				   " where (flow_form_rulestage.FR_FinishState=0 or flow_form_rulestage.FR_FinishState=1)"+SqlStr_Form+" "+ //篩選條件:1.申請中或通過的 2.表單模組ID為230或231
				   "and CONVERT(varchar(10), CONVERT(datetime, flow_formdata.FD_Data3, 111), 111) <='"+strdate+"' "+        //篩選條件:小於等於選擇日期
			       "and CONVERT(varchar(10), CONVERT(datetime, flow_formdata.FD_Data3, 111), 111) >='"+strdate+"' "+        //篩選條件:大於等於選擇日期
				   " and flow_form_rulestage.FR_OrgId=Org.OrgId "+                                                          //篩選條件:表單填寫者員工等於員工帳號
				   "and flow_form_rulestage.FR_DataId=flow_formdata.FD_RecId and flow_form_rulestage.FR_FormId=flow_forminfo.FI_RecId";
			                                                           	  
            Rs=Data.getSmt(Conn,SqlStr);
			
            while(Rs.next())
            {	
				MD=Rs.getString("FD_Data4").split(" ");
				MD_1=MD[0];
				String MT[]=null;
				String MT1="";
				MT=Rs.getString("FD_Data9").split(",");
				MT1=MT[0];
            if(Rs.getString("FR_FinishState").equals("1")){             //因為FR_FinishState==1會有很多物件，所以要使用equals
			DayContent.append("<div ><img src=/images/edit.gif border=0><a style='color:Green;' href='javascript:ProcEditEvent("+Rs.getString("FR_RecId")+","+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+","+Rs.getString("FR_OrgId")+")'>"+MD_1+"  "+MT1+"</a></div>");
			}
			else{
			DayContent.append("<div><img src=/images/edit.gif border=0><a href='javascript:ProcEditEvent("+Rs.getString("FR_RecId")+","+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+","+Rs.getString("FR_OrgId")+")'>"+MD_1+"  "+MT1+"</a></div>");
			}
			}
            Rs.close();Rs=null;

            DayContent.append("    </td></tr>");
            DayContent.append("</table>");           
            DayContent.append("</td>");
        }
        else
        {
            DayContent.append("<td width='14%' valign='top' bgcolor='"+BgColor+"' align='center'>");
            DayContent.append("<font face='Verdana' size='2' color='black'>");
            DayContent.append("</font></td>");
        }
        Content.append(DayContent.toString());
    }
    Content.append("</tr>");
    if(i-firstIndex>=maxIndex) break;
}
Content.append("</table>");
Grid.AddCol(Content.toString(),"height='100%'");
Grid.Show();
Grid=null;
UI=null;
closeConn(Data,Conn);
%>
<script>
function ProcEditEvent(FR_RecId,FI_RecId,FD_RecId,OrgId)
{
   //var OK=popDialog('EditEvent','/Modules/JResourceMgr1/Form_Check_Content.jsp?OP=Edit&OrgId=<%=OrgId%>&FI_RecId='+FI_RecId,520,427);
   var OK=popDialog('EditEvent','/Modules/JResourceMgr5/Report_Check_Content.jsp?OP=hasCheck&FR_RecId='+FR_RecId+'&FI_RecId='+FI_RecId+'&FD_RecId='+FD_RecId+'&OrgId='+OrgId,screen.availWidth*0.8,800);

}


function ProcPrint()
{
    SysOpenWin("Report_Print.jsp?FI_RecId=<%=FI_RecId%>&D=<%=CurrDate%>",650,500);
}
</script>

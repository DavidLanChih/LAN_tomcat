<%@ page contentType="text/html;charset=MS950" %><%@ include file="/kernel.jsp" %><%@ page  import="java.util.*" %><%!
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
{SqlStr_Form=" and flow_form_rulestage.FR_FormId="+Data.toSql(FI_RecId)+" ";}
else
{SqlStr_Form=" and (flow_form_rulestage.FR_FormId='230')";}

UI.setOnLoad("onload='self.print();'");
UI.Start();
Grid Grid=new Grid(request,out); 
Grid.Init(); 
Grid.setGridWidth("100%");
Grid.setGridHeight("100%");
Grid.AddTab("<a href='Report_Calendar.jsp?FI_RecId="+FI_RecId+"&D="+JDate.DateAdd("M",PYear+"/"+PMonth+"/1",-1)+"' title='上個月'><img src=images/c_pre.gif border=0></a>&nbsp;<b>"+CurrDate+"</b>&nbsp;<a href='Report_Calendar.jsp?OrgId="+OrgId+"&D="+JDate.DateAdd("M",PYear+"/"+PMonth+"/1",1)+"' title='下個月'><img src=images/c_next.gif border=0></a>",1);
Grid.AddRestTab("");
Grid.AddRow("");
Grid.AddRow("");
Content.append("<table width='100%' height='1' cellpadding='1' cellspacing='1' bgcolor='#DDDDDD'>");
Content.append("<tr>");
Content.append("<td align='center' width='14%'><font  color='black' style='font-size:13px'><b>星期日</b></font></td>");
Content.append("<td align='center' width='14%'><font  color='black' style='font-size:13px'><b>星期一</b></font></td>");
Content.append("<td align='center' width='14%'><font  color='black' style='font-size:13px'><b>星期二</b></font></td>");
Content.append("<td align='center' width='14%'><font  color='black' style='font-size:13px'><b>星期三</b></font></td>");
Content.append("<td align='center' width='14%'><font  color='black' style='font-size:13px'><b>星期四</b></font></td>");
Content.append("<td align='center' width='14%'><font  color='black' style='font-size:13px'><b>星期五</b></font></td>");
Content.append("<td align='center' width='14%'><font  color='black' style='font-size:13px'><b>星期六</b></font></td>");
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
            ExeDate=PYear+"/"+PMonth+"/"+days[i];
            if(PYear.equals(CurrYear) && PMonth.equals(CurrMonth) && days[i].equals(CurrDay)) BgColor="#638FFD"; else BgColor="white";
            DayContent.append("<td width='14%' valign='top' bgcolor='"+BgColor+"' align='left'>");
            DayContent.append("<table width='100%' cellpadding='0' cellspacing='0' height='75'>");
            DayContent.append("    <tr height='15%'>");
            DayContent.append("        <td align='left' bgcolor='#DDDDDD'>");
            DayContent.append("        <a href='/Modules/JFlow_FormFolder/Form_hasCheckList.jsp?OP=EveryOne&D="+ExeDate+"' title='檢視當天申請人員'><img src=/images/more.gif border=0>&nbsp;");
            DayContent.append(days[i]); 
            DayContent.append("        </a></td>");
            DayContent.append("    </tr>");
            DayContent.append("    <tr height='85%'><td height='85%' valign=top>");                 
            SqlStr="select flow_forminfo.FI_Name,flow_formdata.FD_Data4,flow_formdata.FD_Data5,flow_form_rulestage.FR_FinishState,count(flow_forminfo.FI_Name) as TTL "+
					"from flow_form_rulestage,flow_formdata,flow_forminfo"+
					" where (flow_form_rulestage.FR_FinishState=0 or flow_form_rulestage.FR_FinishState=1)"+SqlStr_Form+" "+
					"and flow_form_rulestage.FR_FormId=flow_forminfo.FI_RecId and flow_form_rulestage.FR_FormId=flow_formdata.FD_FormId"+
					" and CONVERT(varchar(10), CONVERT(datetime, flow_formdata.FD_Data5, 111), 111) <='"+ExeDate+"' "+
			       "and CONVERT(varchar(10), CONVERT(datetime, flow_formdata.FD_Data5, 111), 111) >='"+ExeDate+"' "+
				   " and flow_form_rulestage.FR_FormId=flow_forminfo.FI_RecId  "+
				   "group by flow_forminfo.FI_Name ,flow_formdata.FD_Data4,flow_formdata.FD_Data5,flow_form_rulestage.FR_FinishState order by flow_forminfo.FI_Name"; 
            
			
			Rs=Data.getSmt(Conn,SqlStr);
            while(Rs.next())
            {
              
				
				if(Rs.getString("FR_FinishState").equals("0"))
				{
					  DayContent.append("<div style='color:#FF0000;'>"+Rs.getString("FD_Data4")+"("+Rs.getString("FD_Data5")+")</div>");
				}
               else
			   {
				    DayContent.append("<div style='color:#008800;'>"+Rs.getString("FD_Data4")+"("+Rs.getString("FD_Data5")+")</div>");
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
function ProcPrint()
{
    SysOpenWin("Report_Print.jsp?OrgId=<%=OrgId%>&D=<%=CurrDate%>",650,500);
}
</script>

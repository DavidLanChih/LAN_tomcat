<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %><%@ page import="java.util.Date"%>

<%@ page contentType="text/html;charset=MS950" %>
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",Content="";
String ss="";
String p04_qty="",strDate="",strDate1="";
String FID="";
String Field1=req("Field1",request);//remark1
String UDate1=req("UDate",request);
String UID1=req("UID",request);
String strMonth;
int y=1 ,thisYear=1911,thisMonth=0,thisDate=0;
thisYear = Integer.valueOf(UDate1.split("/")[0]);
thisMonth = Integer.valueOf(UDate1.split("/")[1]);
thisDate =Integer.valueOf(UDate1.split("/")[2]);

if(thisDate>32)
{
	if(thisMonth==12)
	{
		thisYear=thisYear+1;
		strMonth = String.format("%02d",1);
		strDate=thisYear+"/"+String.format("%02d",thisMonth);
		strDate1=thisYear+strMonth;
	}
	else 
	{
		strMonth = String.format("%02d",thisMonth+y);
		strDate=thisYear+"/"+String.format("%02d",thisMonth);
		strDate1=thisYear+strMonth;
	}
	
}
else
{
	strMonth = String.format("%02d",thisMonth);
	strDate=thisYear+"/"+strMonth;
	strDate1=thisYear+strMonth;
	
}

SqlStr="select top 1 FD_Data4 from flow_formdata INNER JOIN flow_form_rulestage ON flow_formdata.FD_RecId = flow_form_rulestage.FR_DataId where FD_Data3 like N'"+UID1+"%' and FD_Data4 like '"+UID1+strDate1+"%' ORDER BY FD_Data4 DESC";  
//SqlStr="select top 1 FD_Data4 from flow_formdata where FD_Data3 like N'"+UID1+"%' and FD_Data2 like N'2014/09%' ORDER BY FD_Data4 DESC";  

Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{ss= String.format("%03d",Integer.valueOf(Rs.getString("FD_Data4").substring(9))+y); }
else
{ss= String.format("%03d",y); }
p04_qty=UID1+thisYear+strMonth+ss;
Rs.close();Rs=null;

out.print(SqlStr);
%>

<script language="javascript">	
parent.document.getElementById('<%=Field1%>').value='<%=p04_qty%>';

 </script>

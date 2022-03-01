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
String p04_qty="",strDate="",strDay="";
String FID="";
String Field1=req("Field1",request);//remark1
String UDate1=req("UDate",request);
String strMonth;
int y=1 ,thisYear=1911,thisMonth=0,thisDate=0;
thisYear = Integer.valueOf(UDate1.split("/")[0]);
thisMonth = Integer.valueOf(UDate1.split("/")[1]);
thisDate =Integer.valueOf(UDate1.split("/")[2]);

strMonth = String.format("%02d",thisMonth);
strDate = String.format("%02d",thisDate);
strDay=thisYear+"/"+strMonth+"/"+strDate;
SqlStr="select top 1 FD_Data3 from flow_formdata INNER JOIN flow_form_rulestage ON flow_formdata.FD_RecId = flow_form_rulestage.FR_DataId where FD_FormId='207' and FD_Data2 like N'"+strDay+"%' ORDER BY FD_Data3 DESC";  


Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{ss= String.format("%02d",Integer.valueOf(Rs.getString("FD_Data3").substring(9))+y); }
else
{ss= String.format("%02d",y); }
p04_qty=thisYear+strMonth+strDate+ss;
Rs.close();Rs=null;

//out.print(p04_qty);
%>

<script language="javascript">	
parent.document.getElementById('<%=Field1%>').value='<%=p04_qty%>';

 </script>

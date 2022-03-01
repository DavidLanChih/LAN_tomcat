<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
ResultSet Rs=null;
leeten.Date JDate=new leeten.Date();
String SqlStr="";
String OrgId=req("OrgId",request);//由設備傳入

String RecId=req("RecId",request);
String isAllChecked=req("isAllChecked",request);
String SD=req("SD",request);
String ED=req("ED",request);
String ST=req("ST",request);
String ET=req("ET",request);
String RecIdStr="";
boolean hasChoosed=false,isEnable=false;

if(!RecId.equals("")) RecIdStr=" and J_RecId<>"+Data.toSql(RecId)+" ";

SqlStr="Select isEnable from Org where OrgId="+OrgId+" limit 1";
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
	if(Rs.getString("isEnable").equals("1")) isEnable=true;
}

if(isEnable)
{
	if(isAllChecked.equals("1"))//整天
	{
		SqlStr ="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and J_StartDate<='"+Data.toSql(SD)+"' and J_EndDate>='"+Data.toSql(SD)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and J_StartDate<='"+Data.toSql(ED)+"' and J_EndDate>='"+Data.toSql(ED)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and J_StartDate>='"+Data.toSql(SD)+"' and J_EndDate<='"+Data.toSql(ED)+"') limit 1";
	}else if(SD.equals(ED))//指定的日期為同一天
	{
		//狀況1: 預約日期為 1月2日介於 1/1 ~ 1/5為例 ,則1/2已被預訂
		//狀況2: 預約日期為 1月1日(或1月5日) 13:00~14:00 ,以 1/1 ~ 1/5為例 ,則判斷 1/1(或1/5)之 13:00~14:00是否被預訂
		SqlStr ="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate<'"+Data.toSql(SD)+"' and J_EndDate>'"+Data.toSql(SD)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and (J_StartDate='"+Data.toSql(SD)+"' or  J_EndDate='"+Data.toSql(SD)+"') and J_StartTime<='"+Data.toSql(ST)+"' and J_EndTime>'"+Data.toSql(ST)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and (J_StartDate='"+Data.toSql(SD)+"' or  J_EndDate='"+Data.toSql(SD)+"') and J_StartTime<'"+Data.toSql(ET)+"' and J_EndTime>='"+Data.toSql(ET)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and (J_StartDate='"+Data.toSql(SD)+"' or  J_EndDate='"+Data.toSql(SD)+"') and J_StartTime>'"+Data.toSql(ST)+"' and J_EndTime<'"+Data.toSql(ET)+"') limit 1";
	}else if(!SD.equals(ED))//指定的日期不為同一天
	{
		//狀況1: 預約日期為 開始日:1月2日介於 1/1 ~ 1/5為例 ,則1/2已被預訂
		//狀況2: 預約日期為 結束日:1月2日介於 1/1 ~ 1/5為例 ,則1/2已被預訂
		//狀況3: 預約日期為 1月1日~1月3日, 以 1/1 ~ 1/5為例 (預約起日為資料起日),則已被預約 (若資料非異日,則須判斷預約起日之時間,以狀況4為例)
		//狀況4: 預約日期為 1月1日~1月3日, 以 1/1 ~ 1/1為例 (預約起日為資料起日=迄日),則須判斷預約起日之時間 "開始時間" 是否落於資料的 "起迄時間"
		//狀況5: 預約日期為 1月5日~1月7日, 以 1/1 ~ 1/5為例 (預約起日為資料迄日),則須判斷預約起日之時間 "開始時間" 是否小於資料的 "迄日的結束時間"
		//狀況6: 預約日期為 1月1日~1月3日, 以 1/3 ~ 1/5為例 (預約迄日為資料起日),則須判斷預約迄日之時間 "結束時間" 是否大於資料的 "起日的開始時間"
		//狀況7: 預約日期為 1月1日~1月3日, 以 1/3 ~ 1/3為例 (預約迄日為資料起日=迄日),則須判斷預約迄日之時間 "結束時間" 是否落於資料的 "起迄時間"
		//狀況8: 預約日期為 1月3日~1月5日, 以 1/1 ~ 1/5為例 (預約迄日為資料迄日),則已被預約 (若資料非異日,則須判斷預約迄日之時間,以狀況7為例)
		//狀況9: 預約日期為 1月1日~1月5日, 以 1/2 ~ 1/3為例 (預約起迄日包含資料起迄日),則已被預約
	
		
		SqlStr ="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate<'"+Data.toSql(SD)+"' and J_EndDate>'"+Data.toSql(SD)+"')   union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate<'"+Data.toSql(ED)+"' and J_EndDate>'"+Data.toSql(ED)+"')   union";
	
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate='"+Data.toSql(SD)+"' and J_StartDate<>J_EndDate)           union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate='"+Data.toSql(SD)+"' and J_StartDate=J_EndDate      and J_StartTime<'"+Data.toSql(ST)+"' and J_EndTime>'"+Data.toSql(ST)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_EndDate='"+Data.toSql(SD)+"'   and J_EndTime>'"+Data.toSql(ST)+"')   union";
	
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate='"+Data.toSql(ED)+"' and J_StartTime<'"+Data.toSql(ET)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate='"+Data.toSql(ED)+"' and J_StartDate=J_EndDate      and J_StartTime<'"+Data.toSql(ET)+"' and J_EndTime>'"+Data.toSql(ET)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_EndDate='"+Data.toSql(ED)+"'   and J_StartDate<>J_EndDate)           union";
	
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate>'"+Data.toSql(SD)+"' and J_StartDate<'"+Data.toSql(ED)+"' and J_EndDate>'"+Data.toSql(SD)+"' and J_EndDate<'"+Data.toSql(ED)+"')   limit 1";
	}
	Rs=Data.getSmt(Conn,SqlStr);
	if(Rs.next())
	{
		hasChoosed=true;
	}
	Rs.close();Rs=null;
	
	
	if(hasChoosed) out.println("<script>alert('您預約的時間已被預約,請再確定一下!');</script>");
	else out.println("<script>parent.document.Frm.submit();</script>");
}
else
{
	out.println("<script>alert('此設備目前無法預約!');</script>");
}



%>


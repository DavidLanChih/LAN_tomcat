<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;

Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",SqlStr1="";
String Get_YY="",Get_MM="",Get_DD="",Get_ID="",Get_Day="";


Get_YY=req("get_YY",request);
Get_MM=req("get_MM",request);
Get_DD=req("get_DD",request);
Get_ID=req("get_ID",request);


if(Get_MM.length()==1) Get_MM="0"+Get_MM;
if(Get_DD.length()==1) Get_DD="0"+Get_DD;

Get_Day=Get_YY+"/"+Get_MM+"/"+Get_DD;



Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
Statement stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

SqlStr="select m013_dd"+Get_DD+" from manf013 where  m013_yy='"+Get_YY+"' and m013_mm='"+Get_MM+"' and m013_no= '"+Get_ID+"'  and   m013_chk_date is not null and m013_dd"+Get_DD+"='/' ";
SqlStr1="select * from manfs07 where  ms07_ymd1='"+Get_Day+"' and ms07_no='"+Get_ID+"' ";

ResultSet rs=stmt.executeQuery(SqlStr);
ResultSet rs1=stmt1.executeQuery(SqlStr1);


while(rs.next())
{
%>
<script language="javascript">	
	alert('提醒您：若連續請假三日以上，請仔細確認核送主管關卡');
	
</script>
<%
}


while(rs1.next())
{
%>
<script language="javascript">	
	alert('提醒您：若連續請假三日以上，請仔細確認核送主管關卡哦');
	
</script>
<%
}

rs.close();rs1.close();
rs=null;rs1=null;
stmt.close();
conn.close();


%>

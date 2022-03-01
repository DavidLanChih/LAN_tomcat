<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
ResultSet Rs=null;

String SqlStr="",hasData="0";
String UD_ID=req("UD_ID",request);
String OrgId=req("OrgId",request);

//載出設備類別
if(OrgId.equals(""))
{
    SqlStr="select UD_ID from Org where class=7 and UD_ID='"+Data.toSql(UD_ID)+"' limit 1";
}
else
{
	SqlStr="select UD_ID from Org where class=7 and OrgId<>"+Data.toSql(OrgId)+" and UD_ID='"+Data.toSql(UD_ID)+"' limit 1";
}

Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
    hasData="1";
}	
Rs.close();Rs=null;

closeConn(Data,Conn);
%>
<script>
if(<%=hasData%>=='1')
{
   alert('設備代碼已重覆，請重新設定!');
}
else
{
	parent.Frm.JBtn.disabled=true;
    parent.Frm.submit();
}
</script>

<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
ResultSet Rs=null;

String SqlStr="",hasData="0";
String UD_ID=req("UD_ID",request);
String OrgId=req("OrgId",request);

//���X�]�����O
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
   alert('�]�ƥN�X�w���СA�Э��s�]�w!');
}
else
{
	parent.Frm.JBtn.disabled=true;
    parent.Frm.submit();
}
</script>

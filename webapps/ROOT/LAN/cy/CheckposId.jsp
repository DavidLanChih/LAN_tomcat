<%@ include file="/kernel.jsp" %><%@ include file="/cycy2kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null,Rs2=null;
Html UI=new Html(pageContext,Data,Conn);


String Content="",SqlStr="",SqlStr2="",floor="",floorno="",speno="",Content2="",Content3="",Content4="",Content5="";

String UID=req("UID",request).toUpperCase();

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
Statement stmt2 = conn2.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

   SqlStr="select  s026_mno,s026_ecr,s026_lan,p014_sname as Namep,p031_mark as Namep2 from  cy@chyusc1: salf026 left join purf014 on s026_lan = p014_speno left join purf031 on s026_lan = p031_box where s026_mno ='"+UID+"' and s026_ecr not matches 'Z*'";
	
	SqlStr2="select  s026_mno,s026_ecr,s026_lan,p014_sname as Namep from  cy2@chyusc1: salf026 left join purf014 on s026_lan = p014_speno  where s026_mno ='"+UID+"' and s026_ecr not matches 'Z*'";
	
	
  Rs=stmt.executeQuery(SqlStr);
  Rs2=stmt2.executeQuery(SqlStr2);

if(Rs.next())
{
   Content3=Rs.getString("s026_mno").trim();	
   Content=Rs.getString("s026_ecr").trim();
   if(Rs.getString("s026_lan")!=null)
   {
	   Content2=Rs.getString("s026_lan").trim();
   }
   else
   {
	   Content2="";
   }
   
   if(Rs.getString("Namep")!=null)
   {
	   Content4=Rs.getString("Namep").trim();
   }
   else
   {
	   Content4="";
   }
   if(Rs.getString("Namep2")!=null)
   {
	   Content5=Rs.getString("Namep2").trim();
   }
   else
   {
	   Content5="";
   }
}
else if(Rs2.next())
{
   Content3=Rs2.getString("s026_mno").trim();	
   Content=Rs2.getString("s026_ecr").trim();
   if(Rs2.getString("s026_lan")!=null)
   {
	   Content2=Rs2.getString("s026_lan").trim();
   }
   else
   {
	   Content2="";
   }
   
   if(Rs2.getString("Namep")!=null)
   {
	   Content4=Rs2.getString("Namep").trim();
   }
   else
   {
	   Content4="";
   }
   
}
else
{
	%>
	<script language="javascript">
		alert('查無此機台編號')		
	</script>
   <%
}
Rs.close();
Rs=null;
stmt.close();
conn.close();

Rs2.close();
Rs2=null;
stmt2.close();
conn2.close();

%>
<script language="javascript">	

	parent.document.getElementById('no').value='<%=Content3%>'+":"+'<%=Content2%>'+" "+'<%=Content4%>'+'<%=Content5%>';
	parent.CheckOk();
</script>
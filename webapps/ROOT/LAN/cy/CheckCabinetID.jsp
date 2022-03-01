<%@ include file="/kernel.jsp" %>
<%@ include file="/cykernel.jsp" %>
<%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);


String SqlStr="",speno="",sname="",blane="",divno="",s026_ecr="",s026_floor="",s026_poll="";

String UID=req("UID",request).toUpperCase();
out.println(UID+"<br>");
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);


SqlStr="select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno "+
	"from cy@chyusc1:purf014 where p014_speno='"+UID+"' and length(p014_speno)=5 and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 "+
	"union select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno "+
	"from cy2@chyusc1:purf014 where p014_speno='"+UID+"' and length(p014_speno)=5 and p014_speno like 'Y%' "+
	"union select p031_box as speno,p031_mark as sname,p031_blane as blane,p031_div as divno "+
	"from cy@chyusc1:purf031 where p031_box='"+UID+"' and length(p031_box)=5 and (p031_out is null or p031_out >=today -30)" ;	
out.println(SqlStr+"<br>");
Rs=stmt.executeQuery(SqlStr);
  

if(Rs.next())
{
	speno=Rs.getString("speno").trim();	
	sname=Rs.getString("sname").trim();
	blane=Rs.getString("blane").trim();
	
}
else
{
	%>
	<script language="javascript">
		alert('查無此專櫃');
	</script>
   <%
}


//s026_ecr 機台,s026_floor 棟別,s026_poll 樓 
SqlStr="select s026_ecr,s026_floor,s026_poll from salf026 "+
"where s026_lan='"+UID+"'";
out.println(SqlStr+"<br>");
Rs=stmt.executeQuery(SqlStr);

if(Rs.next())
{
	s026_ecr=Rs.getString("s026_ecr").trim();	
	s026_floor=Rs.getString("s026_floor").trim();
	s026_poll=Rs.getString("s026_poll").trim();
}

Rs.close();
Rs=null;
stmt.close();
conn.close();


%>
<script language="javascript">	

	parent.document.getElementById('no').value='<%=speno%>'+":"+'<%=sname%>'+":"+'<%=blane%>'+":"+'<%=s026_ecr%>'+":"+'<%=s026_floor%>'+":"+'<%=s026_poll%>';
	//alert('DD'+document.getElementById('no').value);
	
	parent.CheckOk();
</script>
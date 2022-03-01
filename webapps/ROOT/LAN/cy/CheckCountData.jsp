<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String m002No="",m002Name="",OP="",SqlStr="",SqlStr2="";
String m035No="",m035Name="",m035Blane="";
String UID=req("UID",request);
String UIDD = UID.toUpperCase();

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
//Statement stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

if (UIDD.length()==6 || UIDD.length()==7)//專櫃個人
{
	
	SqlStr="select m035_no,m035_name,m035_venno from  manf035 where  manf035.m035_no='"+UIDD+"'";   
	ResultSet rs=stmt.executeQuery(SqlStr);

	if(!rs.next())
	{
%>
	<script language="javascript">
		alert('查無此專櫃編號!!')		
	</script>
<%	
	}
	else
	{
		m035No=rs.getString("m035_no");//人員櫃號
		m035Name=rs.getString("m035_name");//姓名
		m035Blane=rs.getString("m035_venno");

		
	}
	rs.close();
	rs=null;
	stmt.close();
	conn.close();
	
}
else
{
	%>
	<script language="javascript">
		alert('請輸入完整櫃號!')		
	</script>
<%	
} 



/*
if (UIDD.length()==5)//專櫃
{
	
	//SqlStr="select p014_venno as venno,p014_sname as sname,p014_blane as blane from purf014 where length(p014_venno) = 5 and p014_venno = '"+UIDD+"'  union select p031_box as venno,p031_mark as sname,p031_blane as blane from purf031 where length(p031_box)=5 and p031_box='"+UIDD+"' ";
	SqlStr="select p014_venno as venno,p014_sname as sname,p014_blane as blane from cy@chyusc1:purf014 where length(p014_venno)=5  and p014_venno = '"+UIDD+"'  union select p014_venno as venno,p014_sname as sname,p014_blane as blane from cy2@chyusc1:purf014 where length(p014_venno)=5  and p014_venno = '"+UIDD+"'  union  select p031_box as venno,p031_mark as sname,p031_blane as blane from   cy@chyusc1:purf031 where  length(p031_box)=5  and p031_box = '"+UIDD+"'  ";

	ResultSet rs1=stmt1.executeQuery(SqlStr);
	if(!rs1.next())
	{
%>
	<script language="javascript">
		alert('查無此專櫃編號!!')		
	</script>
<%	
	}
	else
	{
		m035No=rs1.getString("venno");//櫃號
		m035Name=rs1.getString("sname").substring(0,5);
		m035Blane=rs1.getString("blane");
		
	}
	rs1.close();
	rs1=null;
	stmt1.close();
	conn.close();
}
*/
%>

<script language="javascript">	
	
	parent.document.getElementById('no').value='<%=m035No%>'+':'+'<%=m035Name%>'+':'+'專櫃人員';
  parent.CheckOk();

</script>

<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String m002No="",m002Name="",OP="",SqlStr="",SqlStr2="";
String m035No="",m035Name="",m035Blane="",m035_sName="";
String UID=req("UID",request);
String UIDD = UID.toUpperCase();
String UIDD1 = UIDD.substring(0,5);

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
Statement stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

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
		m035Name=rs.getString("m035_name").trim();//姓名
	}
	rs.close();
	rs=null;
	
	
}
else
{
	%>
	<script language="javascript">
		alert('請輸入完整櫃號!')		
	</script>
<%	
	} 

if (UIDD1.length()==5)//專櫃
{
	
	//SqlStr="select p014_sname as sname from cy@chyusc1:purf014 where length(p014_venno)=5  and p014_venno = '"+UIDD1+"'  union select p014_sname as sname from cy2@chyusc1:purf014 where length(p014_venno)=5  and p014_venno = '"+UIDD1+"'  union  select p031_mark as sname from   cy@chyusc1:purf031 where  length(p031_box)=5  and p031_box = '"+UIDD1+"'  ";
  SqlStr="select p014_sname as sname from cy@chyusc1:purf014 where length(p014_speno)=5  and p014_speno = '"+UIDD1+"'  union all select p014_sname as sname from cy2@chyusc1:purf014 where length(p014_speno)=5  and p014_speno = '"+UIDD1+"'  union all select p031_mark as sname from   cy@chyusc1:purf031 where  length(p031_box)=5  and p031_box = '"+UIDD1+"'  ";  
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
		m035_sName=rs1.getString("sname");
	}
	rs1.close();
	rs1=null;
	
}
conn.close();
%>

<script language="javascript">	
	
	parent.document.getElementById('no').value='<%=m035No%>'+':'+'<%=m035Name%>'+':'+'<%=m035_sName%>';
  parent.CheckOk();

</script>

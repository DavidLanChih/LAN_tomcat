<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String m002No="",m002Name="",OP="",SqlStr="",SqlStr2="";
String m035No="",m035Name="",m035Blane="",m035_sName="",p014_slaeno="";
String UID=req("UID",request);
String UIDD = UID.toUpperCase();

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);


	
	SqlStr="select cid,short_name,vat_no from pic_s_vendor_m where  cid='"+UIDD+"'";   
	ResultSet rs=stmt.executeQuery(SqlStr);

	if(!rs.next())
	{
%>
	<script language="javascript">
		alert('查無此廠商編號!!')		
	</script>
<%	
	}
	else
	{
		m035No=rs.getString("cid");//櫃號
		m035Name=rs.getString("short_name").trim();//櫃名
		p014_slaeno=rs.getString("vat_no").trim();//統編
	}
	rs.close();
	rs=null;
	
	

conn.close();
%>

<script language="javascript">	
	
	parent.document.getElementById('no').value='<%=m035No%>'+':'+'<%=m035Name%>'+':'+'<%=p014_slaeno%>';
  parent.CheckOk();

</script>

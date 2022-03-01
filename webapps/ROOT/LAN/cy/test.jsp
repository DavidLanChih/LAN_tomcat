<%@ include file="/kernel.jsp" %>
<%@ include file="/cykernel.jsp" %>
<%@page import="java.util.*" %>
<%@ page import="java.util.Date"%>
<%@ page contentType="text/html;charset=MS950" %>
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",Content="";
String ss="";
String p039_qty="",strNo="";
String FID="";
String Field1=req("Field1",request);//remark1




Class.forName("sun.jdbc.odbc.JdbcOdbcDriver"); 
Connection conn1=DriverManager.getConnection("jdbc:informix-sqli://172.16.10.11:1618/cy:informixserver=chyusc1;NEWLOACLE=zh_tw,en_us,zh_cn;NEWCODESET=Big5,GB2312-80,8859-1,819", "ftpguest", "2253456");
Statement stmt = conn1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);


SqlStr="select w002_date,w002_m011 from manfw02";

Rs=stmt.executeQuery(SqlStr);
while(Rs.next())
{ 
	if(Rs.getString("w002_m011").trim().equals("N"))
	{
		Content+=Rs.getString("w002_date").trim()+", ";
	}
}
if(!Content.equals("")) Content=Content.substring(0,Content.length()-2);
Rs.close();Rs=null;
conn1.close();
p039_qty=Content;

out.println(p039_qty);

%>

<script language="javascript">	
parent.document.getElementById('<%=Field1%>').value='<%=p039_qty%>';

 </script>

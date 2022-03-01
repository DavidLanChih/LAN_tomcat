<%@ include file="/kernel.jsp" %>
<%@ include file="/cykernel.jsp" %>
<%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",Content="";
String Field1=req("Field1",request);//remark1
Statement stmt = conn.createStatement();
SqlStr="select w002_date,w002_m007,w002_hour_m007 from manfw02 ";
Rs=stmt.executeQuery(SqlStr);
while(Rs.next())
{ 
	//時間內請假允許無代理人
	if(Rs.getString("w002_m007").trim().equals("1"))
	{
		Content+=Rs.getString("w002_date").trim()+",";
	}
}
if(!Content.equals("")) Content=Content.substring(0,Content.length()-1);
Rs.close();Rs=null;
conn.close();

out.println(Content);


%>

<script language="javascript">	
	parent.document.getElementById('<%=Field1%>').value='<%=Content%>';

</script>


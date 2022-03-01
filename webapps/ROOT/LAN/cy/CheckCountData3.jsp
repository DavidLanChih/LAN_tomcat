<%@ include file="/kernel.jsp" %><%@page import="java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %>
<%@ include file="/APP3.0-TC.jsp" %> 
<%
NoCatch(response);
//------------防止瀏覽器亂碼---------------
Html UI=new Html(pageContext,Data,Conn);
String No="",Name="",OP="",SqlStr="";
String UID=req("UID",request);
String UIDD = UID.toUpperCase();
//--------------資料庫抓取-----------------
Statement stmt=connTC.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
SqlStr="SELECT USERS.COUNTER_ID as COUNTER_ID,COUNTER.SHORT_NAME as short_name from USERS, COUNTER where USERS.COUNTER_ID='"+UIDD+"'and USERS.STATUS='1' and USERS.COUNTER_ID=COUNTER.COUNTER_ID group by USERS.COUNTER_ID,COUNTER.SHORT_NAME";
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
		No=rs.getString("COUNTER_ID");//櫃號
		Name=rs.getString("short_name");//櫃名
	}
	rs.close();
    connTC.close();
%>

<script language="javascript">	
parent.document.getElementById('no').value='<%=No%>'+':'+'<%=Name%>';
parent.CheckOk();
</script>

<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",SqlStr02="";
String Field = req("Field",request);
String Field1 = req("Field1",request);
String Field2 = req("Field2",request);

String yy = req("start_yy",request);//�ӽЦ~
String mm = req("start_mm",request);//�ӽФ�
String dd = req("start_dd",request);//�ӽФ�
String AgentID = req("AgentID",request);//�N�z�H�u��

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

	//SqlStr="select * from  manfs07 where ms07_condition='N' and ms07_no='"+mw07no+"' and year(ms07_ymd1)='"+mw07yy+"' and month(ms07_ymd1)='"+mw07mm+"' and day(ms07_ymd1) = '"+mw07dd+"' ";   
  SqlStr="select m013_dd"+dd+" from manf013 where m013_no='"+AgentID+"' and m013_yy='"+yy+"' and m013_mm='"+mm+"' and   m013_dd"+dd+"='/' ";
 
ResultSet rs=stmt.executeQuery(SqlStr);

if(!rs.next())
{
	rs.close();
	rs=null;
	
}
else
{
	rs.beforeFirst();
	while(rs.next())
	{		
%>
	<script language="javascript">
		alert('�Ъ`�N�N�z�H���ƯZ����!�Щ��í��s��ܥN�z�H!');
		parent.document.getElementById('<%=Field2%>').value+='<�t�λ���:�Ъ`�N�N�z�H'+<%=yy%>+'/'+<%=mm%>+'/'+<%=dd%>+'���ƯZ����!>';
    parent.document.getElementById('<%=Field2%>').focus();
   
  
<%	    
    } 
	
}
rs.close();
rs=null;
stmt.close();
conn.close();
%>
</script> 

  
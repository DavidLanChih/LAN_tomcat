<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",Kind="",dd="",abc="";

String Field=req("Field",request);
String UID=req("UID",request);
String CTYPE=req("CTYPE",request);//專櫃1、自營2
String UID1=UID.substring(0,5);//取五碼櫃號



Statement stmt2 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
//System.out.println("Informix "+SqlStr);


if (CTYPE.equals("1"))
{
	SqlStr ="select * from cy@chyusc1:purf014  where p014_speno='"+UID1+"' union select * from cy@chyusc1:purf014  where p014_speno='"+UID1+"'";
	ResultSet rs2=stmt2.executeQuery(SqlStr);
	if(!rs2.next())
	{
%>
	<script language="javascript">
		alert('專櫃類別和櫃號不符!');
		parent.document.getElementById('<%=Field%>').value='';
  </script>
<%	
	}
	rs2.close();
	rs2=null;
}

	
if (CTYPE.equals("2"))
{
	SqlStr ="select * from purf031  where p031_box='"+UID1+"' ";
	ResultSet rs2=stmt2.executeQuery(SqlStr);
	if(!rs2.next())
	{
%>
	<script language="javascript">
		alert('專櫃類別和櫃號不符!');
		parent.document.getElementById('<%=Field%>').value='';
  </script>
<%	
	}
	rs2.close();
	rs2=null;

}
	
if (CTYPE.equals("3"))
{
	SqlStr ="select * from cy@chyusc1:purf014  where p014_speno='"+UID1+"' and p014_boxtype='2' union select * from cy@chyusc1:purf014  where p014_speno='"+UID1+"' and p014_boxtype='2'";
	ResultSet rs2=stmt2.executeQuery(SqlStr);
	if(!rs2.next())
	{
%>
	<script language="javascript">
		alert('此專櫃類別非臨時櫃!');
		parent.document.getElementById('<%=Field%>').value='';
  </script>
<%	
	}
	rs2.close();
	rs2=null;
	
}

stmt2.close();
conn.close();



%>




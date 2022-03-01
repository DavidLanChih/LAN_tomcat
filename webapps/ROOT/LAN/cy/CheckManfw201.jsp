<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %><%@ page import="java.util.Date"%>
<%@ page contentType="text/html;charset=MS950" %>
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",Content="";
String ss="";
String p039_qty="",p046_qty="",p039_val="",p046_val="",strNo="";
String FID="";
String Field1=req("Field1",request);//remark1
String Field2=req("Field2",request);//remark2
String Field3=req("Field3",request);//remark3
String Field4=req("Field4",request);//remark4
String UID1=req("UID",request);


Class.forName("sun.jdbc.odbc.JdbcOdbcDriver"); 
Connection conn1=DriverManager.getConnection("jdbc:informix-sqli://172.16.10.11:1618/cy:informixserver=chyusc1;NEWLOACLE=zh_tw,en_us,zh_cn;NEWCODESET=Big5,GB2312-80,8859-1,819", "ftpguest", "2253456");
Statement stmt = conn1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);


SqlStr="select m073_boss from manf073 where m073_code ='1' and m073_dept='"+UID1+"'";
Rs=stmt.executeQuery(SqlStr);
if(Rs.next())
{ 
	Content=Rs.getString("m073_boss").trim()+" ";
}
Rs.close();Rs=null;
p039_qty=Content;


SqlStr="select manf073.m073_dept,manf001.m001_dname,manf073.m073_boss,manf002.m002_name,manf073.m073_boss as Value from manf073,manf002,manf001 where manf073.m073_code in ('1') and manf073.m073_boss=manf002.m002_no and manf002.m002_dept=manf001.m001_dept and manf002.m002_no='"+p039_qty+"'";
Rs=stmt.executeQuery(SqlStr);
if(Rs.next())
{ 
	p039_val=Rs.getString("m073_boss")+","+Rs.getString("m073_dept")+Rs.getString("m001_dname")+":"+Rs.getString("m073_boss")+Rs.getString("m002_name").trim();
}
Rs.close();Rs=null;








SqlStr="select m073_big_boss from manf073 where m073_code ='1' and m073_dept='"+UID1+"'";
Rs=stmt.executeQuery(SqlStr);
if(Rs.next())
{ 
	
	if(Rs.getString("m073_big_boss")!=null)
	{
		ss=Rs.getString("m073_big_boss").trim();
		if(ss.equals("0160")||ss.equals("4315"))
		{
			Content="";
		}
		else
		{
			Content=Rs.getString("m073_big_boss").trim()+" ";
		}
	}
}
Rs.close();Rs=null;
p046_qty=Content;


SqlStr="select manf073.m073_dept,manf001.m001_dname,manf073.m073_boss,manf002.m002_name,manf073.m073_boss as Value from manf073,manf002,manf001 where manf073.m073_code in ('1') and manf073.m073_boss=manf002.m002_no and manf002.m002_dept=manf001.m001_dept and manf002.m002_no='"+p046_qty+"'";
Rs=stmt.executeQuery(SqlStr);
if(Rs.next())
{ 
	p046_val=Rs.getString("m073_boss")+","+Rs.getString("m073_dept")+Rs.getString("m001_dname")+":"+Rs.getString("m073_boss")+Rs.getString("m002_name").trim();
}
Rs.close();Rs=null;




//out.print(SqlStr+"<br>");
//out.print(p039_qty);
//out.print(p046_qty);
//out.print(p039_val);
//out.print(p046_val);
%>

<script language="javascript">	
parent.document.getElementById('<%=Field1%>').value='<%=p039_qty%>';
parent.document.getElementById('<%=Field2%>').value='<%=p046_qty%>';
parent.document.getElementById('<%=Field3%>').value='<%=p039_val%>';
parent.document.getElementById('<%=Field4%>').value='<%=p046_val%>';
 </script>

<%@page import="leeten.*" %><%@page contentType="text/xml; charset=big5"%><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %><%@ page pageEncoding="big5"%><%
ResultSet Rs=null,Rs1=null,Rs2=null,Rs3=null;
String Content="",SqlStr="",SqlStr1="",SqlStr2="",SqlStr3="";
String J_OrgId=req("J_OrgId",request);
String UID2="";
leeten.Org JOrg=new leeten.Org(Data,Conn);
Rs=JOrg.getMainDepartmentMangerInfoByUser(J_OrgId);
if(Rs.next())
{        
	Content=Rs.getString("UD_ID").substring(2)+" ";
}

Class.forName("sun.jdbc.odbc.JdbcOdbcDriver"); 
Connection conn1=DriverManager.getConnection("jdbc:informix-sqli://172.16.10.11:1618/cy:informixserver=chyusc1;NEWLOACLE=zh_tw,en_us,zh_cn;NEWCODESET=Big5,GB2312-80,8859-1,819", "ftpguest", "2253456");
Statement stmt = conn1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
String ss="";
SqlStr="select MenuGroup,UD_ID from Org where OrgId="+J_OrgId+" ";


Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
	int itemid = Rs.getString("UD_ID").indexOf("y");
	if(itemid==1)
	{
	  UID2 =Rs.getString("UD_ID").substring(2);
	  SqlStr1="select m073_big_boss as boss from manf073 where m073_code ='1' and m073_boss='"+UID2+"'";
	}
	else
	{
	  UID2 =Rs.getString("UD_ID").substring(0,5);
	  SqlStr1="select m073_boss as boss from manf073 where m073_code ='1' and m073_dept='"+UID2+"'";
	}
	 
	Rs1=stmt.executeQuery(SqlStr1);
	if(Rs1.next())
	{ 

		ss=Rs1.getString("boss").trim();
		SqlStr2="select m073_big_boss as boss from manf073 where m073_code ='1' and m073_boss='"+ss+"'";
		Rs2=stmt.executeQuery(SqlStr2);
		if(Rs2.next())
		{ 
	
			ss=Rs2.getString("boss").trim();
			if(ss.equals("0160")||ss.equals("4770"))
			{
				  Content="";
			}
			else
			{
				SqlStr3="select m073_big_boss as boss from manf073 where m073_code ='1' and m073_boss='"+ss+"'";
				Rs3=stmt.executeQuery(SqlStr3);
				if(Rs3.next())
				{ 
					Content=Rs3.getString("boss");
				}
			}
		}
	}
}
Rs.close();Rs=null;
Rs1.close();Rs1=null;
out.print(Content);%>
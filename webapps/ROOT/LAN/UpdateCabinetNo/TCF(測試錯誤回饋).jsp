<%@page import="leeten.*" %>
<%@page contentType="text/xml; charset=big5" pageEncoding="UTF-8"%>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat" %>
<%@ include file="/APP3.0-TC.jsp" %>
<%@ page import="java.io.*"%>
<%
String A="", B="", C="",SqlStrEC1="",SqlStrEC2="";



try
{
		
	connTC.setAutoCommit(false);                                                                            //取消自動提交
	Statement stmt = connTC.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
	
	/*CHANGE_GOODS資料更新*/
	SqlStrEC1="update CHANGE_GOODS set COUNTER_ID='11069'where COUNTER_ID='11081'";                         //櫃號11069換至11081
	stmt.executeUpdate(SqlStrEC1);
				
	/*GOODS_COUNTER資料更新*/
	SqlStrEC2="update G set COUNTER_ID='11069'where COUNTER_ID='11081'";                        //櫃號11069換至11081
	stmt.executeUpdate(SqlStrEC2);
		
	
	connTC.commit();                                                                                        //提交					
	%><script>alert("try成功執行完畢");</script><%
	

}
catch(SQLException e)
{
	A=e.getMessage();
	out.print(A);
	if(connTC!=null)
	{
		%><script>alert("try內有程式故障，目前跳到catch第一層");</script><%
		try
		{
			connTC.rollback();                                                                              //撤回SQL指令
			%><script>alert("執行catch第二層rollback，回復資料原始狀況");</script><%
		}
		catch(SQLException ex)
		{
			B=ex.getMessage();
			out.print(B);
		}
	}
	
}
finally 
{
    if(connTC!=null)
	{
		try
		{
			connTC.setAutoCommit(true);                                                                      //恢復自動提交
			connTC.close();
			%><script>alert("無論try是否有故障，最後都會到Finally完成資料庫關閉");</script><%
		}
		catch(SQLException exc)
		{
			C=exc.getMessage();
			out.print(C);
		}
	}
	
}
%>
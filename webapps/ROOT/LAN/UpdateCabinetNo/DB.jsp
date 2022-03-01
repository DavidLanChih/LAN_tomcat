<%@page import="leeten.*" %>
<%@page contentType="text/xml; charset=big5" %>
<%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %>
<%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat" %>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/APP3.0-TC.jsp" %>
<%@ page import="java.io.*"%>
<%
String SqlStr1="",SqlStr2="";
String catch_e="";
//--------第一個更新失敗，第二個仍然會執行--------
SqlStr1="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','開始...')";
Data.ExecUpdateSql(Conn,SqlStr1);
SqlStr2="insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','結束...')";
Data.ExecUpdateSql(Conn,SqlStr2);


//--------------------DB變形----------------------
Statement stmt= Conn.createStatement();
stmt.executeUpdate("insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','第二次結束...')");


//---------------transaction瘦身------------------
//-------設定stmt4故障->嘗試將DB(rollback)--------
try
{
	Conn.setAutoCommit(false);
	Statement stmt3= Conn.createStatement();
	stmt3.executeUpdate("insert into Flow_Log (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','第三次結束...')");
	Statement stmt4= Conn.createStatement();
	stmt4.executeUpdate("insert into F (L_FormName,L_ActiveType,L_FormMemo) values ('櫃號轉移表單-JFlow_Form_279','批次轉入','第四次結束...')");
	Conn.commit();                                                         //若無故障則提交
}
catch(SQLException e)
{							
	catch_e=e.getMessage();																
	Conn.rollback();                                                       //撤回SQL指令																																
}						
finally 
{									
	Conn.setAutoCommit(true);                                              //恢復自動提交																																	
}

%>
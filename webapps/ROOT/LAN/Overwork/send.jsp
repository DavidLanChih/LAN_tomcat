<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %> 

<%
Html UI=new Html(pageContext,Data,Conn);
leeten.Date JDate=new leeten.Date();
String InsertDate=JDate.Now().replaceAll("/","-");
String TD=JDate.ToDay();
String D="2021/08/02 10:10:10.000";
//--------------接收表單內容---------------------
String q1=req("q1",request);
String q2=req("q2",request);
String q3=req("q3",request);
String q4=req("q4",request);
String q5=req("q5",request);
String q6=req("q6",request);
//--------------計算總分-------------------------
int iq1=Integer.parseInt(q1);
int iq2=Integer.parseInt(q2);
int iq3=Integer.parseInt(q3);
int iq4=Integer.parseInt(q4);
int iq5=Integer.parseInt(q5);
int iq6=Integer.parseInt(q6);
int Q=iq1+iq2+iq3+iq4+iq5+iq6;
out.print("表單送出成功，總分為:"+Q);
out.print("<br>"+InsertDate);
out.print("<br>"+TD);
//-------------------MS-SQL----------------------
String SqlStr="";
SqlStr="insert into Overwork2 (O_q1, O_q2, O_q3, O_q4, O_q5, O_q6, O_Q, O_date) values ("+iq1+","+iq2+","+iq3+","+iq4+","+iq5+","+iq6+","+Q+","+TD+")";
Data.ExecUpdateSql(Conn,SqlStr);
//-------------------釋放------------------------
Conn.close(); 
%>
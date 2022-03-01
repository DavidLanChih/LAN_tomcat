<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@ include file="/Modules/JFlow_FormWizard/Util_FormField.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=BIG5" %> 
<%

leeten.Org JOrg=new leeten.Org(Data,Conn);
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String OP="",Site="index.jsp",UpdateLink="";
String SqlStr="";
NoCatch(response);
request.setCharacterEncoding("BIG5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String VoteNo=req("VoteUser",request);
VoteNo = new String(VoteNo.getBytes("ISO-8859-1"), "BIG5");
String Vote1=req("Vote1",request);
String Vote2=req("Vote2",request);
String EDate=JDate.ToDay();
SqlStr="select * from vote_final_result where emp_no='"+VoteNo+"'";

Rs=Data.getSmt(Conn,SqlStr);

if(Rs.next())
	{
%>
	<script language="javascript">
		alert('【注意】此工號已有投票記錄!!!');
	</script>
<%
  }
else{
		SqlStr="insert into vote_final_result(emp_no,vote_sel1,vote_sel2,vote_date) values ('"+VoteNo+"','"+Vote1+"','"+Vote2+"','"+EDate+"')";
		Data.ExecUpdateSql(Conn,SqlStr);
										

%>
	<script language="javascript">
		alert('投票成功!');
	</script>
<%
	}
  

Rs.close();Rs=null;
UI=null;
closeConn(Data,Conn);
%>
<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@ include file="/Modules/JFlow_FormWizard/Util_FormField.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
leeten.Org JOrg=new leeten.Org(Data,Conn);
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String OP="",Site="index.jsp",UpdateLink="";
String SqlStr="";

NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
Html UI=new Html(pageContext,Data,Conn);
String Field=req("Field",request);
String UTID=req("UTID",request);
String UDate=req("UDate",request);
	


SqlStr="SELECT  flow_formdata.*	FROM flow_formdata INNER JOIN flow_form_rulestage ON flow_formdata.FD_RecId = flow_form_rulestage.FR_DataId  WHERE     (flow_formdata.FD_FormId = '71') AND (flow_form_rulestage.FR_FinishState = '1') AND   ((flow_formdata.FD_Data3='"+UDate+"' AND flow_formdata.FD_Data8='"+UTID+"') OR  (flow_formdata.FD_Data13='"+UDate+"' AND flow_formdata.FD_Data18='"+UTID+"') OR  (flow_formdata.FD_Data23='"+UDate+"' AND flow_formdata.FD_Data28='"+UTID+"') OR  (flow_formdata.FD_Data33='"+UDate+"' AND flow_formdata.FD_Data38='"+UTID+"') OR  (flow_formdata.FD_Data43='"+UDate+"' AND flow_formdata.FD_Data48='"+UTID+"'))";

out.println(SqlStr);

Rs=Data.getSmt(Conn,SqlStr);

if(Rs.next())
	{
%>
	<script language="javascript">
		alert('【注意】申請人當日已經為代理人,故無法請假!!!')
		parent.document.getElementById('<%=Field%>').value='';		
	</script>
<%
  }

Rs.close();
Rs=null;
UI=null;
closeConn(Data,Conn);
%>
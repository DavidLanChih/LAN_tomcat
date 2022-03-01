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
String Serno=req("Serno",request);
	
//SqlStr="select * from flow_formdata,flow_form_rulestage where flow_form_rulestage.FR_FormAP='JFlow_Form_63' and flow_form_rulestage.FR_FinishState!=2 and flow_form_rulestage.FR_FinishState!=3 and flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId  and FD_Data4='"+Serno+"' ";

SqlStr="select * from flow_formdata,flow_form_rulestage where flow_form_rulestage.FR_FormAP='JFlow_Form_63' and flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId  and flow_formdata.FD_Data4='"+Serno+"' ";

Rs=Data.getSmt(Conn,SqlStr);

if(Rs.next())
{
%>
	<script language="javascript">
		alert('【錯誤】申請資料重複, 無法寫入!!!');
		parent.document.getElementById('<%=Field%>').value='';		
		
	</script>
<%
}

Rs.close();Rs=null;
UI=null;
closeConn(Data,Conn);
%>
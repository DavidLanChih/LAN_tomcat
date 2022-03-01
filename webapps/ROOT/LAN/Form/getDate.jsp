<%@page import="leeten.*" %><%@page contentType="text/xml; charset=big5"%><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %><%@ page pageEncoding="big5"%><%


NoCatch(response);

ResultSet Rs=null;
String Content="",SqlStr="";

String date=req("date",request);

String time=req("time",request);

SqlStr="select count(flow_formdata.FD_Data7) as TTL ,flow_formdata.FD_Data7 from flow_form_rulestage,flow_formdata,flow_forminfo,Org where (flow_form_rulestage.FR_FormId=230 or flow_form_rulestage.FR_FormId='231') and CONVERT(varchar(10), CONVERT(datetime, flow_formdata.FD_Data5, 111), 111) ='"+date+"' and flow_formdata.FD_Data7 ='"+time+"' and flow_form_rulestage.FR_OrgId=Org.OrgId and flow_form_rulestage.FR_DataId=flow_formdata.FD_RecId and flow_form_rulestage.FR_FormId=flow_forminfo.FI_RecId group by flow_formdata.FD_Data7";		
			
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{        
    Content=Rs.getString("TTL");

}
else
{
	Content="0";
}
out.println(Content);
Rs.close();Rs=null;


%>

<script language="javascript">

	 var strContent = <%=Content%>;
	 parent.document.getElementById('FD_Data24').innerText=strContent;
	
</script>





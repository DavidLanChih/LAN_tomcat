<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
response.setContentType("text/html;charset=big5");
String RecId=req("RecId",request);
String Page=req("Page",request);
String To=req("SendTo",request);
String ModuleFrom=req("ModuleFrom",request);
String JobId=req("JobId",request);
String ViewType=req("ViewType",request);
if(Page.equals("")) Page="measure.jsp";
else if(RecId.equals("")) Page+="&ModuleFrom="+ModuleFrom+"&SendTo="+To+"&JobId="+JobId+"&ViewType="+ViewType;
else if(!RecId.equals("")) Page+="&ViewType="+ViewType+"&RecId="+RecId;
%>
<frameset name="FrmMainBody" rows="*" frameborder="0" border="0">	
	 <frame name="basefrm" src="<%=Page%>" marginwidth="0" marginheight="0"  scrolling="auto" frameborder=1 border=1>
</frameset>	
<noframes>
	<body>
		<p>This page uses frames, but your browser doesn't support them.</p>
	</body>
</noframes>

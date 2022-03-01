<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
String Page=req("Page",request);
String FI_RecId=req("FI_RecId",request);
if(Page.equals("")) Page="Form_Apply.jsp";
else Page+="&FI_RecId="+FI_RecId;
%>
<frameset name="FrmMainBody" rows="*" frameborder="0" border="0">	
	<frameset name="FrmMainBody" cols="120,*" frameborder="1" border="1">		
            <frame name="FrmTree" src="FormTree.jsp"  scrolling="auto" target="basefrm" marginwidth="0" marginheight="0">
            <frame name="basefrm" src="<%=Page%>" marginwidth="0" marginheight="0"  scrolling="auto" frameborder=1 border=1>		
	</frameset>	
</frameset>
<noframes>
<body>
<p>This page uses frames, but your browser doesn't support them.</p>
</body>
</noframes>

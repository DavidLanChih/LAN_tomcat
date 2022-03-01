<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
response.setContentType("text/html;charset=big5");
String Page="";
Page="design.jsp";
%>
<frameset name="FrmMainBody" rows="*" frameborder="0" border="0">	
	<frame name="basefrm" src="<%=Page%>" marginwidth="0" marginheight="0"  scrolling="auto" frameborder=1 border=1>		
</frameset>	
<noframes>
	<body>
		<p>This page uses frames, but your browser doesn't support them.</p>
	</body>
</noframes>
<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 

<frameset name="FrmMainBody" rows="*" frameborder="0" border="0">
    <frameset name="FrmMainBody" cols="160,*" frameborder="1" border="1">
        <frame name="FrmTree" src="Tree.jsp" scrolling="auto" target="basefrm" marginwidth="0" marginheight="0">
        <frame name="basefrm" src="Report_Calendar.jsp?FI_RecId=255" marginwidth="0" marginheight="0" scrolling="auto" frameborder=1 border=1>
    </frameset> 
</frameset>
<noframes>
    <body>
        <p>This page uses frames, but your browser doesn't support them.</p>
    </body>
</noframes>





   
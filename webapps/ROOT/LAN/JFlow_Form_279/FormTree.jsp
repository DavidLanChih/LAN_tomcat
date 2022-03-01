<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %>
<%@ include file="Form_Config.jsp" %> 
<%
NoCatch(response);
Html UI=new Html(pageContext,Data,Conn);
ResultSet Rs=null,TmpRs=null;
String SqlStr="",FRecId="",TTL="";
SqlStr="select count(*) as TTL from flow_form_rulestage where FR_FormId="+JForm_ID+" and FR_OrgId="+J_OrgId+" and FR_FinishState=0";
TmpRs=Data.getSmt(Conn,SqlStr);
TmpRs.next();
TTL=TmpRs.getString("TTL");
TmpRs.close();TmpRs=null;

StringBuffer Content=new StringBuffer();
Content.append("<table width='90%' cellpadding='0' cellspacing='0' height='100' border=0 bgcolor=white>");
Content.append("    <tr height='4'>");
Content.append("        <td width=2><img src='/images/paper/B_T_Left.gif'></td><td width='99%' background='/images/paper/B_T_Middle.gif'></td><td width=8><img src='/images/paper/B_T_Right.gif'></td>");                                
Content.append("    </tr>");
Content.append("    <tr height='100%'>");
Content.append("        <td width=2 background='/images/paper/B_M_Left.gif'></td>");
Content.append("        <td width='100%' valign=top align=center>");                                        

Content.append("<table width='100%' cellpadding='0' cellspacing='0' height='100%' border=0>");
Content.append("    <tr >");
Content.append("        <td align='left' width=25 valign=top><img src='/Modules/JFlow_FormWizard/Form_apply.png'></td><td valign=top>申請此表單,並進行流程審核.<br><br></td>");
Content.append("    </tr>");                          
Content.append("    <tr >");
Content.append("        <td align='left' width=25 valign=top><img src='/Modules/JFlow_FormWizard/Form_Tracert.gif'></td><td valign=top>您可以隨時瞭解目前審核進度.<br><br></td>");
Content.append("    </tr>");                          
Content.append("    <tr >");
Content.append("        <td align='left' width=25 valign=top><!--<img src='/Modules/JFlow_FormWizard/form.png'></td><td valign=top>每次申請的資料,皆會存在此目錄,您可以在備份資料內執行重新申請功能.<br><br>--></td>");
Content.append("    </tr>");                          
Content.append("</table>"); 

Content.append("    </td>");
Content.append("    <td width=8 background='/images/paper/B_M_Right.gif'></td>");        
Content.append("    </tr>");
Content.append("    <tr height='4'>");
Content.append("        <td width=2><img src='/images/paper/B_B_Left.gif'></td><td width='99%' background='/images/paper/B_B_Middle.gif'></td><td width=8><img src='/images/paper/B_B_Right.gif'></td>");                                
Content.append("    </tr>");
Content.append("</table>");

UI.Start();
%>

<!-- Infrastructure code for the tree -->
<script language="javascript" src="/Modules/ua.js"></script>
<script language="javascript" src="/Modules/ftiens4.js"></script>

<!-- Execution of the code that actually builds the specific tree -->
<script language="javascript">

USETEXTLINKS = 1  

newTarget="basefrm"
ICONPATH = '/images/STree/'
foldersTree = gFld("&nbsp;表單服務", "")
foldersTree.iconSrc = "module.gif"
foldersTree.iconSrcClosed= "module.gif"            
aux1 = insFld(foldersTree, gFld("&nbsp;表單申請","Form_Apply.jsp"))
aux1.iconSrc = "/Modules/JFlow_FormWizard/Form_apply.png"
aux1.iconSrcClosed= "/Modules/JFlow_FormWizard/Form_apply.png"     
aux2 = insFld(foldersTree, gFld("&nbsp;表單追蹤(<%=(TTL.equals("0")?"0":"<font color=#ff0000>"+TTL+"</font>")%>)","Form_Tracert.jsp"))
aux2.iconSrc =  "/Modules/JFlow_FormWizard/Form_Tracert.gif"
aux2.iconSrcClosed="/Modules/JFlow_FormWizard/Form_Tracert.gif"
/*aux3 = insFld(foldersTree, gFld("&nbsp;表單申請備份","Form_Backup.jsp"))
aux3.iconSrc = "/Modules/JFlow_FormWizard/form.png"
aux3.iconSrcClosed= "/Modules/JFlow_FormWizard/form.png"     */
       
</script>
<style>
a         {text-decoration:none}
a:visited {color:#000000;}
a:link    {color:#000000;}
a:hover   {color:#0066dd;}
a:active  {color:#000000;}
</style>
</head>
<body bgcolor="#fffff">
<div style="position:absolute; top:-100; left:0; "><table border=0><tr><td><font size=-2><a style="font-size:7pt;text-decoration:none;color:silver" href="http://www.treemenu.net/" target=_blank>JavaScript Tree Menu</a></font></td></tr></table></div>
<script language="javascript">initializeDocument()</script>
<div align=center><%=Content.toString()%></div>
<noscript>
A tree for site navigation will open here if you enable JavaScript in your browser.
</noscript>
</body>
</html>

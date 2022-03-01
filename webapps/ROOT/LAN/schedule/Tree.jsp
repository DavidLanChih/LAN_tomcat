<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);


String SqlStr="",FI_RecId="";
boolean hasPublish=false,isAdmin=false;

Html UI=new Html(pageContext,Data,Conn);
leeten.Date JDate=new leeten.Date();
UI.Start();
ResultSet Rs=null,Rs1=null;

//檢核自己是否為系統管理者
isAdmin=SysACL.isSystemAdmin(J_OrgId);

//檢核自己是否為發佈者
SqlStr="select * from J_Resource_Publisher where R_OrgId="+J_OrgId+" limit 1";
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next()) hasPublish=true;
Rs.close();

%>

<!--Infrastructrue code for the tree -->
<script src="/Modules/ua.js"></script>
<script src="/Modules/ftiens4.js"></script>
<!--Execution of the code that actually builds the specific tree -->

<script>
    USETEXTLINKS =1
    newTarget="basefrm"
    ICONPATH='/images/STree/'
    foldersTree = gFld("&nbsp;此為收銀機裝測行事曆", "")
    foldersTree.iconSrc ='module.gif'
    foldersTree.iconSrcClosed = 'module.gif'	 

   
	
<%
SqlStr="Select * from Module,flow_forminfo where (Module.M_Id='JFlow_Form_230' ) and Module.M_Owner=-1 and Module.M_Type=12 and Module.M_Id=flow_forminfo.FI_ID ";
Rs=Data.getSmt(Conn,SqlStr);
int i=1;
while(Rs.next())
{
if(Rs.getString("fi_version").equals("1.0"))
{
%>

   
    aux3_<%=i%> = insFld(foldersTree, gFld("&nbsp;<%=Rs.getString("M_Name")%>","Report_Calendar.jsp?FI_RecId=<%=Rs.getString("M_Id").split("_",3)[2]%>"))
    aux3_<%=i%>.iconSrc = 'images/type.gif'
    aux3_<%=i%>.iconSrcClosed = 'images/type.gif'
	
<%
}
i++;
}
Rs.close();Rs=null;
%>


</script>

<style>
	a	{text-decoration:none}
	a:visited   {color:#000000;}
	a:link       {color:#000000;}
	a:hover    {color:#0066dd;}
	a:active    {color:#000000;}
</style>

</head>

<body bgcolor="#fffff">
      <div style="position:absolute;top:-100;left:0; ">
          <table border=0>
             <tr><td><font size=-2>
                    <a style="font-size:7pt;text-decoration:none;color:silver" href="http://www.treemenu.net/" target=_blank>JavaScript TreeMenu</a>
             </font></td></tr>
         </table>
     </div>
     

<script>initializeDocument();</script>

<noscript>
	A tree for site navigation will open here if you enable JavaScript in your browser.
</noscript>

</body>
</html>
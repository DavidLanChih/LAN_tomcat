<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%@ include file="Form_Config.jsp" %> 
<%
leeten.Org JOrg=new leeten.Org(Data,Conn);
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String SqlStr="",OP="",Site="Form_Backup.jsp";
String FI_ID="",FI_Version="",FI_RecId="",FR_RecId="",FinishTime="",DrawFunctionStr="";
int RI_DrawForm=0;
int Page=1,PageSize=15,TTLPage=1,TTLRec=0;
int FR_FinishState=0;
StringBuffer MStr=new StringBuffer();
String SearchWord=req("SearchWord",request);
if(SearchWord.equals("請輸入關鍵字...")) SearchWord="";
ResultSet Rs=null,TmpRs=null;

OP=req("OP",request);
if(req("P",request)=="") Page=1; else Page=Integer.parseInt(req("P",request));

SqlStr="select * from flow_forminfo where FI_RecId="+JForm_ID+" limit 1";
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
    FI_ID=Rs.getString("FI_ID");
    FI_Version=Rs.getString("FI_Version");
}
Rs.close();Rs=null;

NoCatch(response);
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("100%");
Grid.setSearch(1);
Grid.AddTab("<img src='/Modules/JFlow_FormWizard/form.png'>&nbsp;表單申請備份",1);
Grid.AddRestTab(""); 
Grid.AddRow("");
Grid.AddGridTitle("項次","","width=25 nowrap");
Grid.AddGridTitle("表單名稱","","");
Grid.AddGridTitle("申請者","","");
Grid.AddGridTitle("申請時間","","");
SqlStr="select flow_form_rulestage.FR_RecId,flow_form_rulestage.FR_FormId,flow_form_rulestage.FR_RuleId,flow_form_rulestage.FR_DataId,flow_form_rulestage.FR_FinishState,flow_form_rulestage.FR_FinishState,flow_form_rulestage.FR_SetFinishOrg,flow_form_rulestage.FR_FinishTime,flow_form_rulestage.FR_Reason,flow_forminfo.FI_Version,flow_forminfo.FI_Name,Org.OrgName,flow_formdata.* from flow_form_rulestage,flow_formdata,flow_forminfo,Org where flow_form_rulestage.FR_FormAP='"+FI_ID+"' and flow_form_rulestage.FR_OrgId="+J_OrgId+" and flow_form_rulestage.FR_OrgId=Org.OrgId and flow_form_rulestage.FR_FormId=flow_forminfo.FI_RecId and flow_form_rulestage.FR_DataId=flow_formdata.FD_RecId order by flow_formdata.FD_RecDate desc";
if(!SearchWord.equals(""))
{
    SqlStr="select flow_form_rulestage.FR_RecId,flow_form_rulestage.FR_FormId,flow_form_rulestage.FR_RuleId,flow_form_rulestage.FR_DataId,flow_form_rulestage.FR_FinishState,flow_form_rulestage.FR_FinishState,flow_form_rulestage.FR_SetFinishOrg,flow_form_rulestage.FR_FinishTime,flow_form_rulestage.FR_Reason,flow_forminfo.FI_Version,flow_forminfo.FI_Name,Org.OrgName,flow_formdata.* from flow_form_rulestage,flow_formdata,flow_forminfo,Org where flow_form_rulestage.FR_FormAP='"+FI_ID+"' and flow_form_rulestage.FR_OrgId="+J_OrgId+" and flow_form_rulestage.FR_OrgId=Org.OrgId and flow_form_rulestage.FR_FormId=flow_forminfo.FI_RecId and flow_form_rulestage.FR_DataId=flow_formdata.FD_RecId and (";
    for(int j=1;j<=60;j++)
        SqlStr+=" flow_formdata.FD_Data"+j+" like '%"+Data.toSql(SearchWord)+"%' or";
    SqlStr=SqlStr.substring(0,SqlStr.length()-2);
    SqlStr+=") order by flow_form_rulestage.FR_RecId desc";
}
Rs=Data.getSmt(Conn,SqlStr);
Grid.setDataInfo(Rs,Page,PageSize);
if(Rs.next())
{
    Grid.moveToPage();
    for(int i=0;i<PageSize;i++)
    {    
        if(Rs.isAfterLast()) break;          
        Grid.AddRow("");
        Grid.AddCol(Grid.getGridSN(i),"align=center nowrap");
        Grid.AddCol(Rs.getString("FI_Name")+"(Ver&nbsp;"+Rs.getString("FI_Version")+")","align=center nowrap");
        Grid.AddCol(Rs.getString("OrgName"),"align=center nowrap");      
        Grid.AddCol(Rs.getDate("FD_RecDate").toString().replaceAll("-","/")+"<br>"+Rs.getTime("FD_RecDate"),"align=center");       
        Grid.AddRow("");
        Grid.AddCol("<a href='javascript:ViewApplyForm("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'><img src='/Modules/JFlow_FormWizard/form.png' border=0>申請內容</a>","nowrap align=right colspan=4"); 
        if(!Rs.next()) break;
    }
}
Rs.close();Rs=null;
Grid.Show();
Grid=null;
UI=null;
closeConn(Data,Conn);
%>
<iframe id='FrmTemp' src='' style='width:0;height:0' frameborder=0></iframe>
<script>
function setValue(FId,value)
{
    document.getElementById('FrmTemp').src='setHidden.jsp?FId='+FId+'&value='+value;
}

function ViewApplyForm(FI_RecId,FD_RecId)
{
    document.location.href='Form_Apply_Content.jsp?OP=ReApply&FI_RecId='+FI_RecId+'&FD_RecId='+FD_RecId;
}


<%
if(OP.equals("ReloadTree")) out.println("parent.FrmTree.document.location.reload();");
%>
</script>

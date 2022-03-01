<%@ include file="/kernel.jsp" %><%@ include file="/Modules/JFlow_FormWizard/Util_FormField.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%@ include file="Form_Config.jsp" %>
<%
leeten.Org JOrg=new leeten.Org(Data,Conn);
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
java.util.ArrayList TitleArr=new java.util.ArrayList();
java.util.ArrayList FieldArr=new java.util.ArrayList();
String SqlStr="",SqlStr_Date="",OP="",StartDate="",EndDate="",FormName="",ReApply="",DeleteFunction="",CancelStr="",FieldCountArr[]=null;;
String FI_RecId="",FR_RecId="",FinishTime="",DrawFunctionStr="",ScriptStr="";
int RI_DrawForm=0;
int Page=1,PageSize=15,TTLPage=1,TTLRec=0;
int FR_FinishState=0;
StringBuffer MStr=new StringBuffer();
String SearchWord=req("KeyWord",request);
StartDate=req("StartDate",request);
EndDate=req("EndDate",request);
ResultSet Rs=null,TmpRs=null;

OP=req("OP",request);
if(req("P",request)=="") Page=1; else Page=Integer.parseInt(req("P",request));

if(OP.equals("Draw"))
{
    FR_RecId=req("FR_RecId",request);
    SqlStr="select flow_ruleinfo.RI_DrawForm from flow_form_rulestage,flow_ruleinfo  where flow_form_rulestage.FR_RecId="+Data.toSql(FR_RecId)+" and flow_form_rulestage.FR_FinishState=0 and flow_form_rulestage.FR_RuleId=flow_ruleinfo.RI_RecId limit 1";
    Rs=Data.getSmt(Conn,SqlStr);
    if(Rs.next())
    {
        RI_DrawForm=Rs.getInt("RI_DrawForm");
        Rs.close();Rs=null;
        if(RI_DrawForm==1)
        {
            SqlStr="update flow_form_rulestage set FR_FinishState=3,FR_SetFinishOrg="+J_OrgId+",FR_FinishTime='"+JDate.Now()+"' where FR_RecId="+Data.toSql(FR_RecId)+" and FR_OrgId="+J_OrgId+" and (FR_FinishState<>1 or FR_FinishState<>2)";
            Data.ExecUpdateSql(Conn,SqlStr);
        }
        OP="ReloadTree";
    }
    else
    {
        OP="ReloadTree";
        ScriptStr="alert('此表單無法抽單,因為已審核完畢!')";
    }
}

ProceFormField(JForm_ID,Data,Conn);
FormName=FI_ID;
TitleArr=pTitleArr;
FieldArr=pFieldArr;
NoCatch(response);
Html UI=new Html(pageContext,Data,Conn);

UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("100%");
Grid.AddTab("表單追蹤","Form_Tracert.jsp",0);
Grid.AddTab("表單搜尋","Form_Search.jsp",0);
Grid.AddTab("<img src='/Modules/JFlow_FormWizard/Form_Tracert.gif'>&nbsp;搜尋結果",1);
Grid.AddRestTab(""); 
Grid.AddRow("");
Grid.AddGridTitle("項次","","width=25 nowrap");
//Grid.AddGridTitle("表單名稱","","");
//Grid.AddGridTitle("申請者","","");
for(int j=0;j<TitleArr.size();j++)
{
    Grid.AddGridTitle(TitleArr.get(j).toString(),"","");
}
Grid.AddGridTitle("申請狀態","","");
Grid.AddGridTitle("申請時間","","");

if(!StartDate.equals("") && !EndDate.equals("")) SqlStr_Date=" and (flow_formdata.FD_RecDate >='"+Data.toSql(StartDate)+" 00:00' and flow_formdata.FD_RecDate <='"+Data.toSql(EndDate)+" 23:59') ";
SqlStr="select flow_form_rulestage.FR_RecId,flow_form_rulestage.FR_FormId,flow_form_rulestage.FR_RuleId,flow_form_rulestage.FR_DataId,flow_form_rulestage.FR_hasCancel,flow_form_rulestage.FR_FinishState,flow_form_rulestage.FR_FinishState,flow_form_rulestage.FR_SetFinishOrg,flow_form_rulestage.FR_FinishTime,flow_form_rulestage.FR_Reason,flow_forminfo.FI_Version,flow_forminfo.FI_Name,flow_forminfo.FI_isReApply,Org.OrgName,flow_ruleinfo.RI_DrawForm,flow_formdata.* from flow_form_rulestage,flow_formdata,flow_forminfo,flow_ruleinfo,Org where flow_form_rulestage.FR_FormAP='"+FormName+"' and flow_form_rulestage.FR_OrgId="+J_OrgId+" and flow_form_rulestage.FR_OrgId=Org.OrgId and flow_form_rulestage.FR_FormId=flow_forminfo.FI_RecId and flow_form_rulestage.FR_RuleId=flow_ruleinfo.RI_RecId and flow_form_rulestage.FR_DataId=flow_formdata.FD_RecId "+SqlStr_Date+" order by flow_form_rulestage.FR_RecId desc";
if(!SearchWord.equals(""))
{
    SqlStr="select flow_form_rulestage.FR_RecId,flow_form_rulestage.FR_FormId,flow_form_rulestage.FR_RuleId,flow_form_rulestage.FR_DataId,flow_form_rulestage.FR_hasCancel,flow_form_rulestage.FR_FinishState,flow_form_rulestage.FR_FinishState,flow_form_rulestage.FR_SetFinishOrg,flow_form_rulestage.FR_FinishTime,flow_form_rulestage.FR_Reason,flow_forminfo.FI_Version,flow_forminfo.FI_Name,flow_forminfo.FI_isReApply,Org.OrgName,flow_ruleinfo.RI_DrawForm,flow_formdata.* from flow_form_rulestage,flow_formdata,flow_forminfo,flow_ruleinfo,Org where flow_form_rulestage.FR_FormAP='"+FormName+"' and flow_form_rulestage.FR_OrgId="+J_OrgId+" and flow_form_rulestage.FR_OrgId=Org.OrgId and flow_form_rulestage.FR_FormId=flow_forminfo.FI_RecId and flow_form_rulestage.FR_RuleId=flow_ruleinfo.RI_RecId and flow_form_rulestage.FR_DataId=flow_formdata.FD_RecId "+SqlStr_Date+" and (";    
    for(int j=1;j<=60;j++)
        SqlStr+=" flow_formdata.FD_Data"+j+" like '%"+Data.toSql(SearchWord)+"%' or";
    SqlStr=SqlStr.substring(0,SqlStr.length()-2);
    SqlStr+=") order by flow_form_rulestage.FR_RecId desc";
	

	
} 
//out.println(SqlStr);
Rs=Data.getSmt(Conn,SqlStr);
Rs.last();
TTLRec=Rs.getRow();
Rs.beforeFirst(); 
Grid.setTTLCount(TTLRec);Grid.setPage(Page);Grid.setPageSize(PageSize);
Grid.setDataInfo(Rs,Page,PageSize);
if(Rs.next())
{

	 Grid.moveToPage();
    for(int i=0;i<PageSize;i++)
    {    
		if(Rs.isAfterLast()) break;
        ReApply="";DeleteFunction="";CancelStr="";
        Grid.AddRow("");
        Grid.AddCol(Grid.getGridSN(i),"align=center nowrap");        
        for(int j=0;j<FieldArr.size();j++)
        {
            if(FieldArr.get(j).toString().indexOf(":")>-1)
            {
                FieldCountArr=FieldArr.get(j).toString().split(":");
                Grid.AddCol(Rs.getString("FD_Data"+FieldCountArr[0])+"~"+Rs.getString("FD_Data"+FieldCountArr[1]),"align=center");
            } 
            else if(FieldArr.get(j).toString().indexOf("@@")>-1)
            {
                FieldCountArr=FieldArr.get(j).toString().split("@@");
				String tmpStr[]=Rs.getString("FD_Data"+FieldCountArr[0]).split(",");
				if(tmpStr.length==2)
					Grid.AddCol(Rs.getString("FD_Data"+FieldCountArr[0]).split(",")[1],"align=center");
				else
					Grid.AddCol("","align=center");
            }
            else if(FieldArr.get(j).toString().indexOf("##")>-1)
            {
                FieldCountArr=FieldArr.get(j).toString().split("##");
                Grid.AddCol(Rs.getString("FD_Data"+FieldCountArr[0]),"align=center");
            }
            else
                Grid.AddCol(Rs.getString("FD_Data"+FieldArr.get(j).toString()),"align=center");
        }
        //Grid.AddCol(Rs.getString("OrgName"),"align=center nowrap");
        FR_FinishState=Rs.getInt("FR_FinishState");
        RI_DrawForm=Rs.getInt("RI_DrawForm");
        if(Rs.getInt("FR_hasCancel")==1) CancelStr="<br><font color=#ff0000>已取消</font>";
        switch(FR_FinishState)
        {
            case 0:
                Grid.AddCol("<img src='/Modules/JFlow_FormWizard/doing.gif' >&nbsp;申請中","align=center nowrap");   	
                break;
            case 1:
                FinishTime=Rs.getDate("FR_FinishTime").toString().replaceAll("-","/")+"<br>"+Rs.getTime("FR_FinishTime");
                if(Rs.getInt("FR_SetFinishOrg")!=0)
                    Grid.AddCol("<font color=#0000ff><img src='/images/approve.gif' >&nbsp;申請通過:"+JOrg.getOrgName(Rs.getString("FR_SetFinishOrg"))+"</font><br>"+FinishTime+CancelStr,"align=center nowrap");   
                else
                    Grid.AddCol("<font color=#0000ff><img src='/images/approve.gif' >&nbsp;申請通過</font><br>"+FinishTime+CancelStr,"align=center nowrap");   
                break;
            case 2:
                if(Rs.getInt("FI_isReApply")==1) ReApply="&nbsp;<a href='javascript:ReApplyViewForm("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'><img src='/Modules/JFlow_FormWizard/Form_apply.png' border=0>重新申請</a>";
                FinishTime=Rs.getDate("FR_FinishTime").toString().replaceAll("-","/")+"<br>"+Rs.getTime("FR_FinishTime");
                Grid.AddCol("<font color=#ff0000><img src='/images/delete.gif'>&nbsp;申請退件</font><Br>"+FinishTime,"align=center nowrap");   
                break;
            case 3: //FR_SetFinishOrg 0:正常  其它:表示抽單人員
                DeleteFunction="&nbsp;"+UI.addLinkWithConfirm("<img src='/images/delete.gif' border=0>刪除抽單","Form_Tracert.jsp?OP=DelDraw&FR_RecId="+Rs.getString("FR_RecId"),"您確定要刪除此抽單資料嗎?");
                if(Rs.getInt("FI_isReApply")==1) ReApply="&nbsp;<a href='javascript:ReApplyViewForm("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'><img src='/Modules/JFlow_FormWizard/Form_apply.png' border=0>重新申請</a>";
                FinishTime=Rs.getDate("FR_FinishTime").toString().replaceAll("-","/")+"<br>"+Rs.getTime("FR_FinishTime");
                Grid.AddCol("<font color=#336600><img src='/Modules/JFlow_FormWizard/Form_Draw.png' >&nbsp;抽單:"+JOrg.getOrgName(Rs.getString("FR_SetFinishOrg"))+"</font><br>"+FinishTime,"align=center nowrap");   
                break;           
        }
        Grid.AddCol(Rs.getDate("FD_RecDate").toString().replaceAll("-","/")+"<br>"+Rs.getTime("FD_RecDate"),"align=center");       
        DrawFunctionStr="";
        if(FR_FinishState==0 && RI_DrawForm==1) {DrawFunctionStr=UI.addSpace()+UI.addLinkWithConfirm("<img src='/Modules/JFlow_FormWizard/Form_Draw.png' border=0>抽單","Form_Tracert.jsp?OP=Draw&FR_RecId="+Rs.getString("FR_RecId"),"抽單後則無法繼續申請,您確定要抽單嗎?");}
        Grid.AddRow("");
		Grid.AddCol("<a href='javascript:perViewForm("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'><img src='/Modules/JFlow_FormWizard/form.png' border=0>申請內容</a>&nbsp;&nbsp;&nbsp;<a href='javascript:perViewStage("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'><img src='/images/view.gif' border=0>進度檢視</a>"+DrawFunctionStr+ReApply+DeleteFunction,"nowrap colspan="+(4+TitleArr.size())+" align=right"); 
        //Grid.AddCol("<a href='javascript:perPrintForm("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'><img src='/Modules/JFlow_FormWizard/form.png' border=0>下載檔案</a>&nbsp;&nbsp;&nbsp;<a href='javascript:perViewForm("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'><img src='/Modules/JFlow_FormWizard/form.png' border=0>申請內容</a>&nbsp;&nbsp;&nbsp;<a href='javascript:perViewStage("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'><img src='/images/view.gif' border=0>進度檢視</a>"+DrawFunctionStr+ReApply+DeleteFunction,"nowrap colspan="+(4+TitleArr.size())+" align=right"); 
        if(!Rs.next()) break;
	
	}
	
	
	
	
	
	
	/*
    Rs.relative((Page-1)*PageSize);
    for(int i=0;i<PageSize;i++)
    {    
        if(Rs.isAfterLast()) break;          
        Grid.AddRow("");
        Grid.AddCol(String.valueOf((Page-1)*PageSize+i+1),"align=center nowrap");
        Grid.AddCol(Rs.getString("FI_Name")+"(Ver&nbsp;"+Rs.getString("FI_Version")+")","align=center nowrap");
        Grid.AddCol(Rs.getString("OrgName"),"align=center nowrap");
        FR_FinishState=Rs.getInt("FR_FinishState");
        RI_DrawForm=Rs.getInt("RI_DrawForm");
        
        switch(FR_FinishState)
        {
            case 0:
                Grid.AddCol("申請中","align=center nowrap");    
                break;
            case 1:
                FinishTime=Rs.getDate("FR_FinishTime").toString().replaceAll("-","/")+"<br>"+Rs.getTime("FR_FinishTime");
                if(Rs.getInt("FR_SetFinishOrg")!=0)
                    Grid.AddCol("<font color=#0000ff><img src='/images/approve.gif' >&nbsp;申請通過:"+JOrg.getOrgName(Rs.getString("FR_SetFinishOrg"))+"</font><br>"+FinishTime,"align=center nowrap");   
                else
                    Grid.AddCol("<font color=#0000ff><img src='/images/approve.gif' >&nbsp;申請通過</font><br>"+FinishTime,"align=center nowrap");   
                break;
            case 2:
                FinishTime=Rs.getDate("FR_FinishTime").toString().replaceAll("-","/")+"<br>"+Rs.getTime("FR_FinishTime");
                Grid.AddCol("<font color=#ff0000><img src='/images/delete.gif'>&nbsp;申請退件</font><Br>"+FinishTime,"align=center nowrap");   
                break;
            case 3: //FR_SetFinishOrg 0:正常  其它:表示抽單人員
                FinishTime=Rs.getDate("FR_FinishTime").toString().replaceAll("-","/")+"<br>"+Rs.getTime("FR_FinishTime");
                Grid.AddCol("<font color=#336600><img src='/Modules/JFlow_FormWizard/Form_Draw.png' >&nbsp;抽單:"+JOrg.getOrgName(Rs.getString("FR_SetFinishOrg"))+"</font><br>"+FinishTime,"align=center nowrap");   
                break;           
        }
        Grid.AddCol(Rs.getDate("FD_RecDate").toString().replaceAll("-","/")+"<br>"+Rs.getTime("FD_RecDate"),"align=center");       
        DrawFunctionStr="";
        if(FR_FinishState==0 && RI_DrawForm==1) {DrawFunctionStr=UI.addSpace()+UI.addLinkWithConfirm("<img src='/Modules/JFlow_FormWizard/Form_Draw.png' border=0>抽單","Form_Tracert.jsp?OP=Draw&FR_RecId="+Rs.getString("FR_RecId"),"抽單後則無法繼續申請,您確定要抽單嗎?");}
        Grid.AddRow("");
        Grid.AddCol("<a href='javascript:perViewForm("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'><img src='/Modules/JFlow_FormWizard/form.png' border=0>申請內容</a>&nbsp;&nbsp;&nbsp;<a href='javascript:perViewStage("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'><img src='/images/view.gif' border=0>進度檢視</a>"+DrawFunctionStr,"nowrap align=right colspan=5"); 
        if(!Rs.next()) break;
    }
	*/
	
}
Rs.close();Rs=null;
Grid.Show();
Grid=null;
UI=null;
closeConn(Data,Conn);
%>
<iframe id='FrmTemp' src='' style='display:none'></iframe>
<script>
function perViewForm(FI_RecId,FD_RecId)
{
   var OK=popDialog('perViewForm','/Modules/<%=SysCurrModuleId%>/Form_Apply_Content.jsp?OP=View&FI_RecId='+FI_RecId+'&FD_RecId='+FD_RecId,screen.availWidth*0.8,587);   
}

function perViewStage(FI_RecId,FD_RecId)
{
    var OK=popDialog('perViewStage','/Modules/JFlow_RuleWizard/Form_Apply_Finish.jsp?OP=View&FId='+FI_RecId+'&FDId='+FD_RecId,screen.availWidth*0.8,400);       
}

<%
if(OP.equals("ReloadTree")) out.println("parent.FrmTree.document.location.reload();");
out.println(ScriptStr);
%>
</script>

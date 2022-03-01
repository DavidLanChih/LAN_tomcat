<%@ include file="/kernel.jsp" %><%@ include file="/Modules/JFlow_FormWizard/Util_Form.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%@ include file="/Modules/JFlow_RuleWizard/Util_Rule.jsp" %>
<%@ include file="Form_Config.jsp" %> 
<%
String SqlStr="",SqlStr1="",SqlStr2="",OP="",OrgId="",InputStyle="",FI_TitleWidth="";
String FI_RecId="",FI_Version="",O_FI_Version="",FormName="",field_where="",after_field="",DeleteStr="",FI_Script="";
String FF_Property="",First_FF_Name="",FF_Name="",FF_Name_View="",FF_View="",FF_Space="",FF_Value="",TmpFF_Name="",FF_Type="",FF_TypeArr[]=null,TmpColGroup="",MustKeying="",ColGroup="",Size="",FD_Data="";
String ItemScript="",ScriptStr="",ColContent="",PutContent="",PropertyArr[]=null;
String FI_Descript="",FI_Rule="",FD_RecId="",ReadStr="",OverApply="",SurveyLog="";
String ApplyDepartment="",EventScriptStr="",EventType="",FieldType="",ItemValueArr[]=null;
int FI_Descript_ShowType=0,FI_isStop=0,CurrStage=0,RealStage=0,ModifyStage=0;
int num_fields=0,FormFieldCount=0,FieldCount=0,FI_ColCount=1,RowCount=0,ColNum=1;
int F_D_UserData=0,F_D_DBId=0,F_D_CmdId=0;
boolean theSameFormVersion=false,hasChangeColor=false;
String F_D_SqlString="",F_Item="",F_Value="",F_D_Item="",F_D_Value="";
String F_D_Item1="",F_D_Value1="",F_D_Item2="",F_D_Value2="",F_D_Item3="",F_D_Item4="";
String F_D_Connectstring="",F_D_ID="",F_D_PWD="";
leeten.DataClass DB=null;

Enumeration FieldTypeDict=null; 
Hashtable FieldTypeHash=new Hashtable();
Hashtable FormVarHash=new Hashtable();

ArrayList DepOptValue=new ArrayList();
ArrayList DepOptDesc=new ArrayList();
ArrayList PeoOptValue=new ArrayList();
ArrayList PeoOptDesc=new ArrayList();

HttpCore HttpCore=new leeten.HttpCore(pageContext,Data,Conn);
leeten.FileManager FileMgr=new leeten.FileManager();

boolean insField_finish=false;
StringBuffer MStr=new StringBuffer();
StringBuffer MenuItem=new StringBuffer();
ResultSet MRs=null,Rs=null,TmpRs=null,ItemRs=null,DataRs=null,EventRs=null;
session.setAttribute("Apply","");

NoCatch(response);
Html UI=new Html(pageContext,Data,Conn);

leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();

OrgId=req("OrgId",request);
if(OrgId.equals("")) OrgId=J_OrgId;

OP=req("OP",request);
FI_RecId=req("FI_RecId",request);
if(FI_RecId.equals("")) FI_RecId=Data.toSql(JForm_ID);
FD_RecId=req("FD_RecId",request);

int isFinish=getFormState_ByDataId(Conn,Data,FD_RecId);
CurrStage=getCurrStage_ByDataId(Conn,Data,FD_RecId)+1; //目前已審核關數
if(OP.equalsIgnoreCase("Return")) ModifyStage=999;
OverApply=getSession("OverApply",session);

SqlStr="select * from flow_forminfo where FI_RecId="+JForm_ID+" limit 1";
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
    O_FI_Version=Rs.getString("FI_Version");    
}
Rs.close();Rs=null;

SqlStr="select * from flow_forminfo where FI_RecId="+FI_RecId+" limit 1";
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
    FI_Version=Rs.getString("FI_Version");
    FormName=Rs.getString("FI_Name");
    FI_Descript=Rs.getString("FI_Descript");
    FI_Descript_ShowType=Rs.getInt("FI_Descript_ShowType");
    for(int i=0;i<=Rs.getInt("FI_TitleWidth");i++) FI_TitleWidth+=UI.addSpace(1);    
    FI_ColCount=Rs.getInt("FI_ColCount");       
    FI_isStop=Rs.getInt("FI_isStop");
    FI_Rule=Rs.getString("FI_Rule");
    FI_Script=Rs.getString("FI_Script");    
    FormFieldCount=Rs.getInt("FI_FieldCount");
}
Rs.close();Rs=null;

if(O_FI_Version.equals(FI_Version)) theSameFormVersion=true;

if(isPost(request) && OverApply.equals(J_OrgId) && theSameFormVersion)
{  
    //讀取原欄位資訊   
    SqlStr="select * from flow_formfieldinfo  where FF_FormRecId=" + Data.toSql(FI_RecId) + " limit 1";
    MRs=Data.getSmt(Conn,SqlStr);
    for(int i=0;i<FormFieldCount;i++)
    {
          if(MRs.next())
          {
                FF_Name=MRs.getString("FF_F"+(i+1)+"_Name");
                FF_TypeArr=MRs.getString("FF_F"+(i+1)+"_Type").split(":");
                FF_Type=FF_TypeArr[0];
 
                if(FF_Type.equals("DateRange"))
                {
                    FD_Data=req("FD_Data"+(FieldCount+1),request);
                    SqlStr1+="FD_Data"+(FieldCount+1)+"='"+Data.toSql(FD_Data)+"',";
                    FieldCount++;
                    FD_Data=req("FD_Data"+(FieldCount+1),request);
                    SqlStr1+="FD_Data"+(FieldCount+1)+"='"+Data.toSql(FD_Data)+"',";
                }
                else if(FF_Type.equals("DTRange"))
                {
                    FD_Data=req("FD_Data"+(FieldCount+1),request);
                    SqlStr1+="FD_Data"+(FieldCount+1)+"='"+Data.toSql(FD_Data)+"',";
                    FieldCount++;
                    FD_Data=req("FD_Data"+(FieldCount+1),request);
                    SqlStr1+="FD_Data"+(FieldCount+1)+"='"+Data.toSql(FD_Data)+"',";
                }                
                else if(FF_Type.equals("WebEdit"))
                {
                    FD_Data=HttpCore.ParseHTMLSourseByFieldName(SysCurrModuleId+"_"+OrgId,"FD_Data"+(FieldCount+1));
                    SqlStr1+="FD_Data"+(FieldCount+1)+"='"+Data.toSql(FD_Data)+"',";
                }
                else if(FF_Type.equals("File"))
                {
                    //處理上傳檔案
                    FD_Data=req("FD_Data"+(FieldCount+1),request);     
                    SqlStr1+="FD_Data"+(FieldCount+1)+"=FD_Data"+(FieldCount+1)+"+'"+Data.toSql(FD_Data)+"',";
                    String FileArr[] = FD_Data.split("\\|");
                    if(FileArr.length>0)
                    {
                        FileMgr.createDirectory(SysStorage+SysCurrModuleId+Separator);        
                        FileMgr.createDirectory(SysStorage+SysCurrModuleId+Separator+OrgId+Separator);
                        for(int j=0;j<FileArr.length;j++)
                        {
                            if(FileArr[j].length()>0)
                            { 
                                String FileItem[] = FileArr[j].split("\\*");                     
                                FileMgr.copyFile(SysTmpPath+FileItem[1],SysStorage+SysCurrModuleId+Separator+OrgId+Separator);
                                FileMgr.deleteFile(SysTmpPath+FileItem[1]);
                            }
                        }
                    }
                }
                else
                {
                    FD_Data=req("FD_Data"+(FieldCount+1),request);
                    SqlStr1+="FD_Data"+(FieldCount+1)+"='"+Data.toSql(FD_Data)+"',";
                }
                FieldCount++;
           }
           MRs.beforeFirst();
    }
    MRs.close();MRs=null;
    if(!SqlStr1.equals("")) SqlStr1=SqlStr1.substring(0,SqlStr1.length()-1);
    

    //更新寫入表單申請資料
    SqlStr="update flow_formdata set "+SqlStr1+" where FD_RecId="+Data.toSql(FD_RecId)+" and FD_FormId="+Data.toSql(FI_RecId)+" and FD_OrgId="+Data.toSql(OrgId);
    //out.println(SqlStr);
    Data.ExecUpdateSql(Conn,SqlStr);
    session.setAttribute("OverApply","");    
    out.println("<html><head><META HTTP-EQUIV='expires' CONTENT='0'><META HTTP-EQUIV='pragma' CONTENT='no-cache'><meta http-equiv='Content-Type' content='text/html; charset=big5'></head><body onContextMenu='return false;'><table width='100%' height='100%'><tr><td width='100%' align=center valign=middle><img src=/Modules/JICon_Style/Process/14.gif>&nbsp;處理中,請稍後...</td></tr></table><script>parent.SendSurvey();</script></body></html>");            
    return;
}    

leeten.Org JOrg=new leeten.Org(Data,Conn);
leeten.Crypt JCrypt=new leeten.Crypt();
/*FI_RecId=Data.toSql(FI_RecId);

SqlStr="select * from flow_forminfo where FI_RecId="+FI_RecId+" limit 1";
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
    FormName=Rs.getString("FI_Name");
    FI_Descript=Rs.getString("FI_Descript");
    FI_Descript_ShowType=Rs.getInt("FI_Descript_ShowType");
    for(int i=0;i<=Rs.getInt("FI_TitleWidth");i++) FI_TitleWidth+=UI.addSpace(1);
    FI_ColCount=Rs.getInt("FI_ColCount");  
    FI_isStop=Rs.getInt("FI_isStop");
    FI_Rule=Rs.getString("FI_Rule");
    FormFieldCount=Rs.getInt("FI_FieldCount");
}
Rs.close();Rs=null;
*/
String TimeSel=ProceTimeSel();

SurveyLog=getSurveyLog(Conn,Data,OrgId,FI_RecId,FD_RecId);

SqlStr="select * from flow_formdata where FD_RecId="+Data.toSql(FD_RecId)+" and FD_OrgId="+OrgId+" limit 1";

DataRs=Data.getSmt(Conn,SqlStr);
DataRs.next();
ApplyDepartment=JOrg.getMainDepartmentNameByUser(OrgId);
UI.Start();

out.println("<div id='Div_Wait_Do' style='display:' class='skin2'>");
out.println("<table width='100%' height='100%' border=0><tr><td width='100%' valign=middle align=center><img src='/images/busy.gif'>&nbsp;<font color=#0000ff>處理中...請稍後...</font></td></tr></table>");
out.println("</div>");
out.flush();
    
    Grid Grid=new Grid(pageContext); 
    Grid.Init();
    Grid.isCatchBuffer(false);
    Grid.setGridWidth("100%");
    Grid.AddTab(FormName,1);    
 /*   if(OP.equals("ReApply")) 
    {
        Grid.AddTab("<a href='javascript:if(DataCheck(document.Frm)) document.Frm.submit();'><img src='/Modules/JFlow_FormWizard/Form_apply.png' border=0>重新申請</a>",0);
        Grid.setBackTab(true);
    }*/
    Grid.setForm(true); 
    Grid.FormCheck("DataCheck(this)");
    Grid.AddRestTab("<font color=#0000ff><b><u>申請者:"+ApplyDepartment+"&nbsp;&nbsp;&nbsp;"+JOrg.getOrgName(OrgId)+"</u></b></font>");
    
    if(FI_Descript_ShowType==1 || FI_Descript_ShowType==3)
    {
        Grid.AddRow("",2);
        Grid.AddCol("表單說明:","nowrap width=80 valign=top nowrap");
        Grid.AddCol("<font color=#0000ff>"+FI_Descript.replaceAll("\n","<br>")+"</font>","colspan=2 valign=top nowrap");
    }
    if(FormFieldCount>0)
    {
        FieldCount=0;        
        SqlStr="select * from flow_formfieldinfo  where FF_FormRecId=" + FI_RecId + " limit 1";
        MRs=Data.getSmt(Conn,SqlStr);
 
        for(int i=0;i<FormFieldCount;i++)
        {        
              DepOptValue.clear();DepOptDesc.clear();
              PeoOptValue.clear();PeoOptDesc.clear();
                     
              if(MRs.next())
              {                           
                    FF_Name=FF_Name_View=MRs.getString("FF_F"+(i+1)+"_Name");
                    FF_TypeArr=MRs.getString("FF_F"+(i+1)+"_Type").split(":");                                
                    FF_Type=FF_TypeArr[0];
                    PropertyArr=(MRs.getString("FF_F"+(i+1)+"_Property")+";;;;").split(";",8);
                    ColGroup=PropertyArr[0];Size=PropertyArr[1];MustKeying=PropertyArr[2];
                    FF_View=PropertyArr[4];
                    FF_Space=PropertyArr[5];
                    FF_Value=retrunValue(PropertyArr[6],FormVarHash);
                    FieldCount++;
                    if(FF_View.equals("0")) FF_Name_View=""; else FF_Name_View+=":";
                    //取得欄位Event Script
                    EventScriptStr=getFormControlEvent(FI_RecId,FieldCount,FF_TypeArr,Data,Conn);
                    
                    if(ColGroup.equals("0"))
                    {
                        First_FF_Name=FF_Name_View;
                        if(!FF_Type.equals("Hidden") && !FF_Type.equals("HDescript"))
                        {
                            if(i>0) Grid.AddCol(PutContent," valign=top nowrap");
                            PutContent="";
                        }   
                    }
                    else if(!ColGroup.equals(TmpColGroup))
                    {
                        First_FF_Name=FF_Name_View;
                        if(!FF_Type.equals("Hidden") && !FF_Type.equals("HDescript"))
                        {
                            if(i>0) Grid.AddCol(PutContent," valign=top nowrap");  
                            PutContent="";
                        }                        
                    }
                    else
                    {
                        if(!FF_Type.equals("Hidden") && !FF_Type.equals("HDescript"))
                        {
                            PutContent+=(FF_Space.equals("1")?FI_TitleWidth:"")+FF_Name_View;
                        }                        
                    }

                    if(FF_Type.equals("Input"))
                    {                                 
                        PutContent+="<input type=text name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' readonly value='"+DataRs.getString("FD_Data"+FieldCount)+"' size='"+Size+"' maxlength='"+Size+"' "+EventScriptStr+">";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請輸入"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}                        
                    }
                    else if(FF_Type.equals("TextArea"))
                    {                        
                        PutContent+="<textarea name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' rows='10' readonly cols='70' "+EventScriptStr+">"+DataRs.getString("FD_Data"+FieldCount)+"</textarea>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請輸入"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                    }
                    else if(FF_Type.equals("Descript"))
                    {
                        PutContent+="<span id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"'>"+FF_Value+"</span>";
                    }              
                    else if(FF_Type.equals("HDescript"))
                    {
                        PutContent+="<span id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"' style='display:none'>"+FF_Value+"</span>";
                    }                 
                    else if(FF_Type.equals("Int"))
                    {
                        PutContent+="<input type=text name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' readonly value='"+DataRs.getString("FD_Data"+FieldCount)+"' size='"+Size+"' maxlength='"+Size+"' onkeypress='only_Number(event)' "+EventScriptStr+">";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請輸入"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                    }
                    else if(FF_Type.equals("Float"))
                    {
                        PutContent+="<input type=text name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' readonly value='"+DataRs.getString("FD_Data"+FieldCount)+"' size='"+Size+"' maxlength='"+Size+"' onkeypress='only_Number_Dot(event)' "+EventScriptStr+">";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請輸入"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                    }
                    else if(FF_Type.equals("Date"))
                    {
                        PutContent+="<input type=text readonly value='"+DataRs.getString("FD_Data"+FieldCount)+"' name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' onclick='return false;calendar(this);' maxlength=10 size=8>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請選擇"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                    }
                    else if(FF_Type.equals("Time"))
                    {
                        PutContent+="<select size=1 id='FD_Data"+FieldCount+"'  name='FD_Data"+FieldCount+"' onclick='disabledSelect()'>"+TimeSel+"</select>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請選擇"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                        if(!DataRs.getString("FD_Data"+FieldCount).equals(""))
                        {                            
                            ItemScript+="SetSelectItem(document.getElementById('FD_Data"+FieldCount+"'),'"+DataRs.getString("FD_Data"+FieldCount)+"');";
                        }                        
                    }     
                    else if(FF_Type.equals("DateTime"))
                    {
                        PutContent+="<input type=hidden  value='' id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"'><input type=text readonly value=\""+(DataRs.getString("FD_Data"+FieldCount).equals("")?JDate.ToDay():DataRs.getString("FD_Data"+FieldCount).split(" ")[0])+"\" id='D_FD_Data"+FieldCount+"' name='D_FD_Data"+FieldCount+"' onclick='return false;calendar(this);' maxlength=10 size=8 onblur=\"return false;ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\"><select size=1 id='T_FD_Data"+FieldCount+"' name='T_FD_Data"+FieldCount+"' onclick='disabledSelect()' onblur=\"return false;ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\">"+TimeSel+"</select>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請選擇"+FF_Name+"!');document.Frm.D_FD_Data"+FieldCount+".focus();return false;}\n";}
                        if(!DataRs.getString("FD_Data"+FieldCount).equals(""))
                        {                            
                            ItemScript+="SetSelectItem(document.getElementById('T_FD_Data"+FieldCount+"'),'"+DataRs.getString("FD_Data"+FieldCount).split(" ")[1]+"');";
                        }
                        ItemScript+="ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"');";
                    }                        
                    else if(FF_Type.equals("DateRange"))
                    {
                        PutContent+="<input type=text readonly value='"+DataRs.getString("FD_Data"+FieldCount)+"' name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' onclick='return false;calendar(this);' maxlength=10 size=8>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請選擇"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                        FieldCount++;
                        PutContent+="&nbsp;~&nbsp;<input type=text readonly value='"+DataRs.getString("FD_Data"+FieldCount)+"' name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' onclick='return false;calendar(this);' maxlength=10 size=8>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請選擇"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                    }
                    else if(FF_Type.equals("DTRange"))
                    {
                        PutContent+="<input type=hidden  value='' id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"'><input type=text readonly value=\""+(DataRs.getString("FD_Data"+FieldCount).equals("")?JDate.ToDay():DataRs.getString("FD_Data"+FieldCount).split(" ")[0])+"\" id='D_FD_Data"+FieldCount+"' name='D_FD_Data"+FieldCount+"' onclick='return false;calendar(this);' maxlength=10 size=8 onblur=\"return false;ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\"><select size=1 id='T_FD_Data"+FieldCount+"' name='T_FD_Data"+FieldCount+"' onclick='disabledSelect()' onblur=\"return false;ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\">"+TimeSel+"</select>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請選擇"+FF_Name+"!');document.Frm.D_FD_Data"+FieldCount+".focus();return false;}\n";}
                        if(!DataRs.getString("FD_Data"+FieldCount).equals(""))
                        {                            
                            ItemScript+="SetSelectItem(document.getElementById('T_FD_Data"+FieldCount+"'),'"+DataRs.getString("FD_Data"+FieldCount).split(" ")[1]+"');";
                        }
                        ItemScript+="ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"');";
                        FieldCount++;
                        PutContent+="&nbsp;~&nbsp;<input type=hidden  value='' id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"'><input type=text readonly value=\""+(DataRs.getString("FD_Data"+FieldCount).equals("")?JDate.ToDay():DataRs.getString("FD_Data"+FieldCount).split(" ")[0])+"\" id='D_FD_Data"+FieldCount+"' name='D_FD_Data"+FieldCount+"' onclick='return false;calendar(this);' maxlength=10 size=8 onblur=\"return false;ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\"><select size=1 id='T_FD_Data"+FieldCount+"' name='T_FD_Data"+FieldCount+"' onclick='disabledSelect()' onblur=\"return false;ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\">"+TimeSel+"</select>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請選擇"+FF_Name+"!');document.Frm.D_FD_Data"+FieldCount+".focus();return false;}\n";}
                        if(!DataRs.getString("FD_Data"+FieldCount).equals(""))
                        {                            
                            ItemScript+="SetSelectItem(document.getElementById('T_FD_Data"+FieldCount+"'),'"+DataRs.getString("FD_Data"+FieldCount).split(" ")[1]+"');";
                        }    
                        ItemScript+="ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"');";
                    }    
                    else if(FF_Type.equals("Money"))
                    {
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='' || document.Frm.FD_Data"+FieldCount+".value=='0') {alert('請輸入"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                        PutContent+="N.T.$<input type=text name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' value='"+DataRs.getString("FD_Data"+FieldCount)+"' size='"+Size+"' maxlength='"+Size+"' readonly onkeypress='only_Number(event)' onkeyup=\"document.getElementById('tmpMoney_"+FieldCount+"').innerHTML=getRegular(this.value)+'元正'\">";                
                        PutContent+="&nbsp;&nbsp;新台幣(大寫):<span id=tmpMoney_"+FieldCount+" name=txtMoneytxtMoney_"+FieldCount+" style='WIDTH: 50%; HEIGHT: 18px;' >零元正</span>"; 
                        ItemScript+=" document.getElementById('tmpMoney_"+FieldCount+"').innerHTML=getRegular(Frm.FD_Data"+FieldCount+".value)+'元正';\n";
                    }
                    else if(FF_Type.equals("WebEdit"))
                    {                        
                        PutContent+=HttpCore.HTMLView(DataRs.getString("FD_Data"+FieldCount),"FD_Data"+FieldCount);
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請輸入"+FF_Name+"!');return false;}\n";}
                    }
                    else if(FF_Type.equals("File"))
                    {
                        if(!DataRs.getString("FD_Data"+FieldCount).equals(""))
                        {
                            String FileArr[]=DataRs.getString("FD_Data"+FieldCount).split("\\|");                        
                            for(int f=0;f<FileArr.length;f++)
                            {
                                if(FileArr[f].length()>0)
                                {                                 
                                    if(CurrStage==ModifyStage ) DeleteStr=UI.addSpace()+UI.addLinkWithConfirm("<img src='/images/delete.gif' border=0>刪除","javascript:DelPic('File_"+FieldCount+"_"+f+"','"+FileArr[f].split("\\*")[1]+"',"+FieldCount+")","您確定要刪除此附檔嗎?"); else DeleteStr="";
                                    PutContent+="<div id='File_"+FieldCount+"_"+f+"'>"+UI.addLink("<img src=/images/dn.gif border=0>&nbsp;"+FileArr[f].split("\\*")[0],"javascript:SysDownloadFile('Download.jsp?OrgId="+DataRs.getString("FD_OrgId")+"&RecId="+DataRs.getString("FD_RecId")+"&FieldCount="+FieldCount+"&FileItem="+f+"')")+DeleteStr+"</div>";
                                }                            
                            }
                        }
                        if(CurrStage==ModifyStage )
                        {
                            PutContent+=UI.UpFile("FD_Data"+FieldCount,"",10,0,false);
                            if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('尚未上傳"+FF_Name+"!');return false;}\n";}                        
                        }                       
                    }
                    else if(FF_Type.equals("Employee"))
                    {
                        SqlStr="select * from Org where OrgId="+DataRs.getString("FD_Data"+FieldCount)+" limit 1";
                        TmpRs=Data.getSmt(Conn,SqlStr);
                        TmpRs.next();
                        PeoOptDesc.add(TmpRs.getString("OrgName"));
                        PeoOptValue.add(TmpRs.getString("OrgId"));
                        TmpRs.close();TmpRs=null;
                        PutContent+=UI.ShowOrg("FD_Data"+FieldCount,DataRs.getString("FD_Data"+FieldCount),PeoOptDesc,PeoOptValue,false);
                      //  ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請挑選"+FF_Name+"!');return false;}\n";
                    }
                    else if(FF_Type.equals("Department"))
                    {
                        SqlStr="select * from Org where OrgId="+DataRs.getString("FD_Data"+FieldCount)+" limit 1";
                        TmpRs=Data.getSmt(Conn,SqlStr);
                        TmpRs.next();
                        DepOptDesc.add(TmpRs.getString("OrgName"));
                        DepOptValue.add(TmpRs.getString("OrgId"));
                        TmpRs.close();TmpRs=null;
                        PutContent+=UI.ShowOrg("FD_Data"+FieldCount,DataRs.getString("FD_Data"+FieldCount),DepOptDesc,DepOptValue,false);
                       // ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請挑選"+FF_Name+"!');return false;}\n";
                    }        
                    else if(FF_Type.equals("Hidden"))
                    {
                        PutContent+="<input type=hidden name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' value='"+DataRs.getString("FD_Data"+FieldCount)+"'>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請輸入"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}                        
                    }
                    else
                    {
                         
                        MStr.setLength(0);
                        SqlStr="select * from flow_fieldtypemgr where F_RecId="+Data.toSql(FF_TypeArr[1])+" limit 1";
                        Rs=Data.getSmt(Conn,SqlStr);
                        if(Rs.next())
                        {
                            String F_Name=Rs.getString("F_Name");                            
                            F_D_UserData=Rs.getInt("F_D_UserData");
                            F_D_DBId=Rs.getInt("F_D_DBId");F_D_CmdId=Rs.getInt("F_D_CmdId");
                            F_D_Item=Rs.getString("F_D_Item");F_D_Value=Rs.getString("F_D_Value");    
                            F_D_Item1=Rs.getString("F_D_Item1");F_D_Value1=Rs.getString("F_D_Value1");                      
                            F_D_Item2=Rs.getString("F_D_Item2");F_D_Value2=Rs.getString("F_D_Value2");      
                            F_D_Item3=Rs.getString("F_D_Item3");                                   
                            F_D_Item4=Rs.getString("F_D_Item4");
                            if(F_D_UserData!=1) {F_D_Item="I_Name";F_D_Value="I_Value";}
                            String F_Type=Rs.getString("F_Type");
                            int F_MaxCount=Rs.getInt("F_MaxCount");

                            switch(Integer.parseInt(F_Type))
                            {
                                case 1:  //radio
                                    MStr.append("<input type=hidden name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' value='"+DataRs.getString("FD_Data"+FieldCount)+"'><span onfocus='return false;' onclick='return false;'>");
                                    if(MustKeying.equals("1")) {ScriptStr+=" if(!checkRadioData('FD_Data"+FieldCount+"')) {alert('請選擇"+FF_Name+"!');return false;}\n";}
                                    break;
                                case 2:  //checkbox
                                    MStr.append("<input type=hidden name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' value='"+DataRs.getString("FD_Data"+FieldCount)+"'><span onfocus='return false;' onclick='return false;'>");
                                    if(MustKeying.equals("1")) {ScriptStr+=" if(!checkCheckBoxData('FD_Data"+FieldCount+"')) {alert('請選擇"+FF_Name+"!');return false;}\n";}
                                    break;
                                case 3:  //select
                                    MStr.append("<input type=hidden FF_Type='"+FF_TypeArr[1]+"' FieldType='3' FieldCount="+FieldCount+" id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"' value='"+DataRs.getString("FD_Data"+FieldCount)+"'>");
                                    MStr.append("<select size=1  name='tmp_FD_Data"+FieldCount+"' id='tmp_FD_Data"+FieldCount+"' onfocus='disabledSelect()' "+EventScriptStr+">");
                                    MStr.append("<option value=''>請選擇...</option>");
                                    if(MustKeying.equals("1")) {ScriptStr+=" if(!checkSelecData('FD_Data"+FieldCount+"')) {alert('請選擇"+FF_Name+"!');return false;}\n";}
		    if(!DataRs.getString("FD_Data"+FieldCount).equals(""))
		    {
                                      	ItemValueArr=DataRs.getString("FD_Data"+FieldCount).split("\\,");
	                                ItemScript+=" Item(document.getElementById('tmp_FD_Data"+FieldCount+"'),document.getElementById('tmp_FD_Data"+FieldCount+"'),'"+ItemValueArr[0]+"','"+ItemValueArr[1]+"');\n";
                	                ItemScript+=" getSelectData('FD_Data"+FieldCount+"','tmp_FD_Data"+FieldCount+"');\n";
		    }
                                    break;                                    
                                case 4:  //MultiList
                                    if(MustKeying.equals("1")) {ScriptStr+=" if(!checkSelecData('FD_Data"+FieldCount+"')) {alert('請選擇"+FF_Name+"!');document.Frm.MenuItem"+FieldCount+".focus();return false;}\n";}
                                    MStr.append("<table border=0 cellpadding=2 cellspacing=0>");
                                    MStr.append("<tr>");
                                    MStr.append("  <td><img src=/images/folder1.gif>&nbsp;項目</td>");
                                    MStr.append("  <td>&nbsp;</td>");
                                    MStr.append("  <td><img src=/images/folder1.gif>&nbsp;內容<input type=hidden FF_Type='"+FF_TypeArr[1]+"' FieldType='4' FieldCount="+FieldCount+" id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"' value=''></td>");
                                    MStr.append("</tr>");
                                    String ItemArr[]=DataRs.getString("FD_Data"+FieldCount).split("\\|");
                                    for(int i_Item=0;i_Item<ItemArr.length;i_Item++)
                                    {
                                        ItemValueArr=ItemArr[i_Item].split("\\,");
                                        ItemScript+=" Item(document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'),'"+ItemValueArr[0]+"','"+ItemValueArr[1]+"');\n";
                                    }
                                    ItemScript+=" select_in(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'),"+F_MaxCount+");\n";
                                    break;
                                 case 5:  //Button
                                    if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('請輸入"+FF_Name+"!');return false;}\n";}
                                    MStr.append("<input type=text readonly style='width:"+F_MaxCount+"' id='FD_Data"+FieldCount+"' name=FD_Data"+FieldCount+" value='"+DataRs.getString("FD_Data"+FieldCount)+"' ><input type=button value='挑選...' disabled onclick=\"ChooseItemByButton("+FF_Type+",'FD_Data"+FieldCount+"')\">");            
                                    break;                                        
                            }
                            MenuItem.setLength(0);
                            ItemRs=(ResultSet)FieldTypeHash.get(FF_TypeArr[0]+"-"+FF_TypeArr[1]);
                            if(ItemRs==null)
                            {           
                                if(F_D_UserData!=1)
                                {
                                    SqlStr="select * from flow_fieldtypeitem where I_FRecId=" + Data.toSql(FF_TypeArr[1]) + " and I_isHidden=0 order by I_Sort asc";
                                    ItemRs=Data.getSmt(Conn,SqlStr);
                                    F_D_Item="I_Name";F_D_Value="I_Value";
                                }
                                else
                                {
                                    ItemRs=Data.getSmt(F_D_DBId,F_D_CmdId);    
                                }
                            }
                            while(ItemRs.next())
                            {
                                F_Item=ItemRs.getString(F_D_Item);
                                if(F_D_UserData==1)
                                {
                                    if(!F_D_Item1.equals("")) F_Item+=(F_D_Item1.startsWith("'")?F_D_Item1.substring(1,F_D_Item1.length()-1):ItemRs.getString(F_D_Item1));
                                    if(!F_D_Item2.equals("")) F_Item+=(F_D_Item2.startsWith("'")?F_D_Item2.substring(1,F_D_Item2.length()-1):ItemRs.getString(F_D_Item2));
                                    if(!F_D_Item3.equals("")) F_Item+=(F_D_Item3.startsWith("'")?F_D_Item3.substring(1,F_D_Item3.length()-1):ItemRs.getString(F_D_Item3));
                                    if(!F_D_Item4.equals("")) F_Item+=(F_D_Item4.startsWith("'")?F_D_Item4.substring(1,F_D_Item4.length()-1):ItemRs.getString(F_D_Item4));
                                }
                                F_Value=ItemRs.getString(F_D_Value);
                                if(F_D_UserData==1)
                                {
                                    if(!F_D_Value1.equals("")) F_Value+=(F_D_Value1.startsWith("'")?F_D_Value1.substring(1,F_D_Value1.length()-1):ItemRs.getString(F_D_Value1));
                                    if(!F_D_Value2.equals("")) F_Value+=(F_D_Value2.startsWith("'")?F_D_Value2.substring(1,F_D_Value2.length()-1):ItemRs.getString(F_D_Value2));
                                }
                                switch(Integer.parseInt(F_Type))
                                {
                                    case 1:
                                        MStr.append("<input type=radio value='"+F_Value+"' onfocus='disabledSelect(event);' "+JUtil.isChecked(DataRs.getString("FD_Data"+FieldCount),F_Value)+" id='tmpFD_Data"+FieldCount+"' name='tmpFD_Data"+FieldCount+"' onclick=\"getRadioData('FD_Data"+FieldCount+"','tmpFD_Data"+FieldCount+"')\">"+F_Item+"&nbsp;");                
                                        break;
                                    case 2:
                                        MStr.append("<input type=checkbox value='"+F_Value+"'  onfocus='disabledSelect(event);' onclick='disabledSelect(event);' "+((DataRs.getString("FD_Data"+FieldCount).indexOf(","+F_Value+",")>-1)?"checked":"")+" name='tmpFD_Data"+FieldCount+"' id='tmpFD_Data"+FieldCount+"' onclick=\"getCheckBoxData("+F_MaxCount+",'FD_Data"+FieldCount+"','tmpFD_Data"+FieldCount+"')\">"+F_Item+"&nbsp;");                                
                                        break;
                                    case 3:
                                        MStr.append("<option value='"+F_Value+"' "+JUtil.isSelect(DataRs.getString("FD_Data"+FieldCount),F_Value)+">"+F_Item+"</option>");
                                        break;
                                    case 4:                                        
                                        MenuItem.append("<option value='"+F_Value+"'>"+F_Item+"</option>");
                                        break;
                                    case 5:
                                        break;
                                }
                            }                            
                            ItemRs.beforeFirst();
                            FieldTypeHash.put(FF_TypeArr[0]+"-"+FF_TypeArr[1], ItemRs);
                            switch(Integer.parseInt(F_Type))
                            {
                                case 1:
                                    MStr.append("</span>");
                                    break;
                                case 2:
                                    MStr.append("</span>");
                                    break;
                                case 3:
                                    MStr.append("</select>");
                                    break;
                                case 4:
                                    MStr.append("<tr>");
                                    MStr.append("  <td><select id=MenuItem"+FieldCount+" Name=MenuItem"+FieldCount+" multiple style=\"height:153pt;width:140pt;font-size:12px\" ondblclick=\"return false;select_in(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'),"+F_MaxCount+");\">"+MenuItem.toString()+"</select></td>");
                                    MStr.append("  <td align=center>");
                                    MStr.append("		    <input Type=button Name=allin"+FieldCount+" Value=\"&gt; &gt;\" disabled onclick=\"all_in(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'),"+F_MaxCount+");\">");
                                    MStr.append("		    <p><input Type=button Name=selectin"+FieldCount+" Value=\"--&gt;\" disabled onclick=\"select_in(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'),"+F_MaxCount+");\">");
                                    MStr.append("		    <p><input Type=button Name=removeout"+FieldCount+" Value=\"&lt;--\" disabled onclick=\"remove_out(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'));\">");
                                    MStr.append("		    <p><input Type=button Name=allout"+FieldCount+" Value=\"&lt; &lt;\" disabled onclick=\"all_out(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'));\">");
                                    MStr.append("		    </td>");
                                    MStr.append("  <td><select id=Content"+FieldCount+" Name=Content"+FieldCount+" multiple style=\"height:153pt;width:140pt;font-size:12px\" ondblclick=\"return false;remove_out(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'));\"></select></td>");
                                    MStr.append("</tr>");
                                    MStr.append("</table>");
                                    break;
                                case 5:
                                    break;
                            }
                        }
                        Rs.close();Rs=null;
                        PutContent+=MStr.toString();
                    }
                    if(ColGroup.equals("0"))
                    {
                        if(!FF_Type.equals("Hidden") && !FF_Type.equals("HDescript"))
                        {
                            Grid.AddRow("",ColNum);
                            Grid.AddCol(First_FF_Name,"nowrap width=80 valign=top");  
                            RowCount++;
                            if(RowCount%FI_ColCount==0) {hasChangeColor=true;ColNum=ColNum-1;}
                            else hasChangeColor=false;
                            if(ColNum==-1) ColNum=1;
                        }
                    }
                    else if(!ColGroup.equals(TmpColGroup))
                    {
                        if(!FF_Type.equals("Hidden") && !FF_Type.equals("HDescript"))
                        {                        
                            Grid.AddRow("",ColNum);
                            Grid.AddCol(First_FF_Name,"nowrap width=80 valign=top"); 
                            RowCount++;
                            if(RowCount%FI_ColCount==0) {hasChangeColor=true;ColNum=ColNum-1;}
                            else hasChangeColor=false;
                            if(ColNum==-1) ColNum=1;                        
                        }
                    }
                    TmpColGroup=ColGroup;
              }
              MRs.beforeFirst();
        }
        MRs.close();MRs=null;
        Grid.AddCol(PutContent+"<div id='FieldContent' style=\"display:''\"></div><input type=hidden name=OP id=OP value='"+OP+"'><input type='hidden' name='FI_RecId' id='FI_RecId' value='"+FI_RecId+"'><input type='hidden' name='ApplyDepartment' id='ApplyDepartment' value='"+ApplyDepartment+"'>"," valign=top nowrap");  
    }
    if(!hasChangeColor) ColNum=ColNum+1; 
    if(!SurveyLog.equals(""))
    {        
        Grid.AddRow("",ColNum);        
        Grid.AddCol("<font color=#0000ff>表單審核記錄:</font>","");
        Grid.AddCol(SurveyLog,"");   
        ColNum=ColNum-1;         
    }        
    Grid.AddRow("",ColNum);
    if(OP.equals("View"))
        Grid.AddCol("<input type='button' value='關閉視窗' onclick='top.close();'>"," colspan=2 align=center");
   /* else if(OP.equals("ReApply"))
        Grid.AddCol((theSameFormVersion?"<input type=hidden name=OP value='ReApply'><input type=submit name=go value='重新申請' >&nbsp;&nbsp;&nbsp;":"")+"<input type='button' value='回上一頁' onclick='history.back();'>"," colspan=2 align=center");*/
    Grid.Show();
    Grid=null;
    
    FieldTypeDict=FieldTypeHash.keys();
    while(FieldTypeDict.hasMoreElements())
    {           
        Rs=(ResultSet)FieldTypeHash.get(FieldTypeDict.nextElement().toString());
        Rs.close();Rs=null;
    }
FieldTypeDict=null;    
DataRs.close();DataRs=null;   
    
UI=null;
JOrg=null;
closeConn(Data,Conn);
%>

<iframe id='A_Tmp_Frm' src='' style='width:0;height:0' frameborder=0></iframe>
<style>
.SilverEdit {font-size:9pt;border-top-style:none; border-left-style:none; border-right-style:none; background-color:#ffffff; height:14px}
</style>
<script src='/Modules/JEIPKernel/JEIP_WebControl.js'></script>
<%=FI_Script%>    
<script>    
   
function DelPic(DivId,FMD5,FieldCount)
{
    $('A_Tmp_Frm').src='/Modules/JFlow_FormFolder/DelPic.jsp?FD_RecId=<%=FD_RecId%>&OrgId=<%=OrgId%>&&DivId='+DivId+'&MD5='+FMD5+'&FieldCount='+FieldCount;
} 
    
function ReApply(FI_RecId,FD_RecId)
{    
    document.Frm.target='_parent';
    document.Frm.action='Form_Apply.jsp?OP=ReApply&FI_RecId='+FI_RecId+'&FD_RecId='+FD_RecId;
    document.Frm.submit();     
}

function DataCheck(Frm)
{
    <%=ScriptStr%>
    document.Frm.action='Form_Apply.jsp';
    document.Frm.go.disabled=true;
    return true;
}
<%=ItemScript%>

<%
/*if(!OP.equals("View") && FI_Descript_ShowType==2 || FI_Descript_ShowType==3)
{
    out.println("alert('"+FI_Descript.replaceAll("\r\n","\\\\n")+"');");
}*/

if(OP.equals("ReApply")) out.println("ReApply("+FI_RecId+","+FD_RecId+");");
%>      

document.getElementById('Div_Wait_Do' ).style.display='none';
</script>

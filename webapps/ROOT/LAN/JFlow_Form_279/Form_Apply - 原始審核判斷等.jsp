<%@ page contentType="text/html;charset=MS950" %><%@ include file="/kernel.jsp" %><%@ include file="/Modules/JFlow_FormWizard/Util_Form.jsp" %><%@ include file="Form_Config.jsp" %><%
NoCatch(response);
String SqlStr="",SqlStr1="",SqlStr2="",OP="",RI_AlertDay="",FI_RuleMethod="",FI_MultiRule="",FI_Script="";
String FI_RecId="",FI_ID="",FormName="",field_where="",FR_ReDataId="",after_field="",FI_TitleWidth="";
String FF_Property="",First_FF_Name="",FF_Name="",FF_Name_View="",FF_View="",FF_Space="",FF_Value="",TmpFF_Name="",FF_Type="",FF_TypeArr[]=null,TmpColGroup="",MustKeying="",ColGroup="",Size="",FD_Data="";
String ItemScript="",ScriptStr="",ColContent="",PutContent="",PropertyArr[]=null;
String FI_Descript="",FI_Rule="",RI_ReturnTo="",ApplyTitle="",ApplyDepartment="",ApplyName="",ApplyOrgId="",Command="",Re_FD_RecId="";
String RI_AlertToArr[]=null,value="",MailSubject="",isAutoPass="";
String EventScriptStr="",ItemValueArr[]=null,StageInfo[]=null;
String RI_SendMailToSurver="",Curr_Stage="",DeptValue="",PathSurvey="";
int FI_Descript_ShowType=0,FI_isStop=0,StageCount=0;
int num_fields=0,FormFieldCount=0,FieldCount=0,FI_ColCount=1,RowCount=0,ColNum=1;
boolean hasChangeColor=false;
Enumeration FieldTypeDict=null; 
Hashtable FieldTypeHash=new Hashtable();
Hashtable FormVarHash=new Hashtable();

int F_D_UserData=0,F_D_DBId=0,F_D_CmdId=0;
String F_D_SqlString="",F_Item="",F_Value="",F_D_Item="",F_D_Value="";
String F_D_Item1="",F_D_Value1="",F_D_Item2="",F_D_Value2="",F_D_Item3="",F_D_Item4="";
String F_D_Connectstring="",F_D_ID="",F_D_PWD="";
leeten.DataClass DB=null;

ArrayList DepOptValue=new ArrayList();ArrayList DepOptDesc=new ArrayList();
ArrayList PeoOptValue=new ArrayList();ArrayList PeoOptDesc=new ArrayList();

StringBuffer MStr=new StringBuffer();
StringBuffer MenuItem=new StringBuffer();
ResultSet MRs=null,Rs=null,TmpRs=null,ItemRs=null,EventRs=null;
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
Html UI=new Html(pageContext,Data,Conn);
UI.setOnLoad("a");
OP=req("OP",request);
FI_RecId=JForm_ID;
ApplyOrgId=req("ApplyOrgId",request); //�ӽЪ�
Re_FD_RecId=req("FD_RecId",request);

if(ApplyOrgId.equals("")) ApplyOrgId=J_OrgId;


//--------------���IP--------------------
String ipAddress = request.getHeader("X-FORWARDED-FOR");
if (ipAddress == null || "".equals(ipAddress))
{
	ipAddress = request.getRemoteAddr();
}



HttpCore HttpCore=new leeten.HttpCore(pageContext,Data,Conn);
leeten.Org JOrg=new leeten.Org(Data,Conn);
leeten.FileManager FileMgr=new leeten.FileManager();
ApplyName=JOrg.getOrgName(ApplyOrgId);
FI_RecId=Data.toSql(FI_RecId);

SqlStr="select * from flow_forminfo where FI_RecId="+FI_RecId+" limit 1";
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
    FI_ID=Rs.getString("FI_ID");
    FormName=Rs.getString("FI_Name");
    FI_Descript=Rs.getString("FI_Descript");
    FI_Descript_ShowType=Rs.getInt("FI_Descript_ShowType");
    for(int i=0;i<=Rs.getInt("FI_TitleWidth");i++) FI_TitleWidth+=UI.addSpace(1);
    FI_ColCount=Rs.getInt("FI_ColCount");    
    FI_isStop=Rs.getInt("FI_isStop");
    FI_RuleMethod=Rs.getString("FI_RuleMethod");  //2���ҥΦh���W�h
    FI_Rule=Rs.getString("FI_Rule");  //�w�]�W�h
    FI_MultiRule=Rs.getString("FI_MultiRule");
    FI_Script=Rs.getString("FI_Script");
    FormFieldCount=Rs.getInt("FI_FieldCount");
}
Rs.close();Rs=null;

if(FI_isStop==1)
{
    response.sendRedirect("/Modules/JFlow_FormWizard/Form_Stop.jsp");
    return;
}

if(isPost(request) && session.getAttribute("Apply").toString().equals(ApplyOrgId))
{  
    Curr_Stage=req("Curr_Stage",request);
    PathSurvey=req("PathSurvey",request);
    //�������s�ӽЪ�DataId    
    if(Re_FD_RecId.equals("")) Re_FD_RecId="0";
    
    //�N���]���w�ϥ�
    SqlStr="update flow_forminfo set FI_isLock=1 where FI_RecId="+Data.toSql(FI_RecId);
    Data.ExecUpdateSql(Conn,SqlStr);  
    
    //Ū��������T   
    SqlStr="select * from flow_formfieldinfo  where FF_FormRecId=" + Data.toSql(FI_RecId) + " limit 1";
    MRs=Data.getSmt(Conn,SqlStr);
    for(int i=0;i<FormFieldCount;i++)
    {
          if(MRs.next())
          {
                FF_Name=MRs.getString("FF_F"+(i+1)+"_Name");
                FF_TypeArr=MRs.getString("FF_F"+(i+1)+"_Type").split(":");
                FF_Type=FF_TypeArr[0];
                
                if(FF_Type.equals("DateRange") || FF_Type.equals("DTRange"))
                {
                    FD_Data=req("FD_Data"+(FieldCount+1),request);
                    SqlStr1+="FD_Data"+(FieldCount+1)+",";
                    SqlStr2+="'"+Data.toSql(FD_Data)+"',";
                    FieldCount++;
                    FD_Data=req("FD_Data"+(FieldCount+1),request);
                    SqlStr1+="FD_Data"+(FieldCount+1)+",";
                    SqlStr2+="'"+Data.toSql(FD_Data)+"',";
                }
                else if(FF_Type.equals("WebEdit"))
                {
                    FD_Data=HttpCore.ParseHTMLSourseByFieldName(SysCurrModuleId+"_"+ApplyOrgId,"FD_Data"+(FieldCount+1));
                    SqlStr1+="FD_Data"+(FieldCount+1)+",";
                    SqlStr2+="'"+Data.toSql(FD_Data)+"',";
                }
                else if(FF_Type.equals("File"))
                {
                    //�B�z�W���ɮ�
                    FD_Data=req("FD_Data"+(FieldCount+1),request);     
                    SqlStr1+="FD_Data"+(FieldCount+1)+",";
                    SqlStr2+="'"+Data.toSql(FD_Data)+"',";
                    String FileArr[] = FD_Data.split("\\|");
                    if(FileArr.length>0)
                    {
                        FileMgr.createDirectory(SysStorage+SysCurrModuleId+Separator);        
                        FileMgr.createDirectory(SysStorage+SysCurrModuleId+Separator+ApplyOrgId+Separator);
                        for(int j=0;j<FileArr.length;j++)
                        {
                            if(FileArr[j].length()>0)
                            { 
                                String FileItem[] = FileArr[j].split("\\*");                     
                                FileMgr.copyFile(SysTmpPath+FileItem[1],SysStorage+SysCurrModuleId+Separator+ApplyOrgId+Separator);
                                FileMgr.deleteFile(SysTmpPath+FileItem[1]);
                            }
                        }
                    }
                }
                else
                {
                    FD_Data=req("FD_Data"+(FieldCount+1),request);
                    SqlStr1+="FD_Data"+(FieldCount+1)+",";
                    SqlStr2+="'"+Data.toSql(FD_Data)+"',";
                }
                FieldCount++;
           }
           MRs.beforeFirst();
    }
    MRs.close();MRs=null;
    if(!SqlStr1.equals("")) SqlStr1=SqlStr1.substring(0,SqlStr1.length()-1);
    if(!SqlStr2.equals("")) SqlStr2=SqlStr2.substring(0,SqlStr2.length()-1);

    String ApplyDate=JDate.Now();  //�ӽЮɶ�
    //�g�J���ӽи��
    SqlStr="insert into flow_formdata (FD_FormId,FD_DeptId,FD_OrgId,"+SqlStr1+",FD_RecDate) values ("+FI_RecId+","+J_Department+","+ApplyOrgId+","+SqlStr2+",'"+ApplyDate+"')";
    Data.ExecUpdateSql(Conn,SqlStr);
    SqlStr="select * from flow_formdata where FD_FormId="+FI_RecId+" and FD_OrgId="+ApplyOrgId+" order by FD_RecId desc limit 1";
    Rs=Data.getSmt(Conn,SqlStr);
    Rs.next();
    String FD_RecId=Rs.getString("FD_RecId");  //���ӽ�ID
    Rs.close();Rs=null;

    //�ˬd�O�_���h������,���ܧ�RuleId  1:�L   2:��    
    if(FI_RuleMethod.equals("2")) FI_Rule=req("FI_Rule",request);
    
    //Ū���W�h��T
    SqlStr="select * from flow_ruleinfo where RI_RecId="+Data.toSql(FI_Rule)+" limit 1";
    Rs=Data.getSmt(Conn,SqlStr);
    Rs.next();
    StageCount=Rs.getInt("RI_StageCount");
    RI_SendMailToSurver=Rs.getString("RI_SendMailToSurver");  // �_�q���f�֪�
    RI_AlertDay=Rs.getString("RI_AlertDay");  //�O�ɳq���Ѽ�
    RI_AlertToArr=Rs.getString("RI_AlertTo").split(";");
    Rs.close();Rs=null;    

    //Ū�����d��T,�oMail�q���Ĥ@�����f�֤H�� ;Ū���Ĥ@�����f�֤H��;�p�L���d,�h�����o�e���^��H��   
    String SurveyOrgId=req("SurveyOrgId",request);  //�f�֪�
    String SendToStr="";
    if(StageCount==0) //�S�����d,Ū���^��H�����
    {
        String ReturnOrgStr="";
        String RI_ReturnToArr[]=RI_ReturnTo.split(";");
        if(RI_ReturnToArr[0].equals("1")) //�ӽЪ�
            ReturnOrgStr=","+ApplyOrgId;
        if(RI_ReturnToArr[1].equals("1")) //�����D��       
            ReturnOrgStr+=","+JOrg.getMainDepartmentMangerInfoByUser(ApplyOrgId,"OrgId");

        String RI_ReturnToMemberArr[]=RI_ReturnToArr[2].split("#",2);  //�ˬd�^��O�_���S�w�H��
        if(RI_ReturnToMemberArr[0].equals("1")) //�S�w�H��
        {
            ReturnOrgStr+=RI_ReturnToMemberArr[1];
        }
        if(!ReturnOrgStr.endsWith(",")) ReturnOrgStr+=",";        
        
        String ReturnToArr[]=RI_ReturnTo.split(";");
        if(ReturnToArr[0].equals("1")) SendToStr+=ApplyOrgId+",";
        if(ReturnToArr[1].equals("1")) SendToStr+=JOrg.getMainDepartmentMangerInfoByUser(ApplyOrgId,"OrgId")+",";
        if(ReturnToArr[2].indexOf("1#")>-1)
        {
            if(!SendToStr.equals("")) SendToStr=SendToStr.substring(0,SendToStr.length()-1);
            String SomeUsers[]=ReturnToArr[2].split("#");
            SendToStr+=SomeUsers[1];
        }
        if(!SendToStr.equals("")) SendToStr=SendToStr.substring(0,SendToStr.length()-1);
        //�g�J������d���,�ó]�w����,�]���S�����d
        SqlStr="insert into flow_form_rulestage (FR_FormAP,FR_FormId,FR_RuleId,FR_OrgId,FR_DataId,FR_ReDataId,FR_ReturnTo,FR_FinishState,FR_FinishTime) values ('"+FI_ID+"',"+FI_RecId+","+FI_Rule+","+ApplyOrgId+","+FD_RecId+","+Re_FD_RecId+",'"+ReturnOrgStr+"',1,'"+ApplyDate+"')";
        Data.ExecUpdateSql(Conn,SqlStr);
        MailSubject="���^��q��";
    }
    else
    {   //�B�z�üg�J�Ĥ@���f�֤H�� �Τ�|�H��;SurveyOrgId���ʺA���ͪ��f�֤H��(�ʺA�f��or�e�ݲ���),�B������ɤ~�|�����.
        //PathSurvey���g�J�h�����d���f�֤H����T,�榡 1#2,4#6 .��ܼg�J�T��,�ĤG�����G�Ӽf�֤H��.
        StageInfo=ProcStageRule(Curr_Stage,SurveyOrgId,PathSurvey,FI_ID,FI_RecId,FI_Rule,ApplyOrgId,J_Department,FD_RecId,Re_FD_RecId,JDate,JOrg,Data,Conn);
        SurveyOrgId=StageInfo[0];
        SendToStr=StageInfo[1];
        isAutoPass=StageInfo[2];
        MailSubject="���f�ֳq��";
    }
    
    //�M���ӽ�,�קK�^�W�@���ӭ��s����
    session.setAttribute("Apply","");    
    if(StageCount==0 || isAutoPass.equals("0"))
    {//�L���d�H�^��;�S���۰�Pass�h�H�f�ֳq��
        String To="",From="";
        From=SysCore.getSysVar("PortalAdminEMail"); 
        String PortalTitle=SysCore.getApplication("PortalTitle");    
        String MailContent=FileMgr.ReadFile(SysRootPath+"Modules"+Separator+"JEIPKernel"+Separator+"Mail.txt","big5");    
        String ApplyMailContent=Data.Replace(MailContent,"{PortalTitle}",PortalTitle);    
        ApplyMailContent=Data.Replace(ApplyMailContent,"{Subject}",PortalTitle+"-"+MailSubject);            
        ApplyMailContent=Data.Replace(ApplyMailContent,"{Body}","<table><tr><td><font color=#0000ff>�ӽЪ��:</font></td><td>"+FormName+"</td></tr><tr><td valign=top><font color=#0000ff>�ӽЪ�:</font></td><td>"+ApplyName+"</td></tr><tr><td valign=top><font color=#0000ff>�ӽЮɶ�:</font></td><td>"+ApplyDate+"</td></tr><tr><td colspan=2 ><br><br><a href='"+PortalLink+"?ModuleId=JFlow_FormFolder'><font color=#ff0000>�Цܪ���ƧX,�˵������.</font></a></font></td></tr></table>");    
        if(!SendToStr.equals("") && RI_SendMailToSurver.equals("1"))
        {          
            SqlStr="select Org.OrgName,Org.EMail from Org where OrgId in ("+SendToStr+") ";  
            Rs=Data.getSmt(Conn,SqlStr);        
            while(Rs.next()) To+=Rs.getString("EMail")+"##";                
            Rs.close();Rs=null;   
            HttpCore.SendMail(From,To,PortalTitle+"-"+MailSubject,ApplyMailContent);
        }
        //�g�JAlertSchedule,�p�G�O��,�h�q��,SurveyOrgId���ūh���B�z
        if(isAutoPass.equals("0")) ProcessAlert(SysCurrModuleId,FD_RecId,ApplyOrgId,PortalTitle,MailContent,FormName,ApplyName,ApplyDate,PortalLink,SurveyOrgId,StageCount,RI_AlertDay,RI_AlertToArr,JDate,JOrg,Data,Conn);    
        response.sendRedirect("/Modules/JFlow_RuleWizard/Form_Apply_Finish.jsp?OP=OK&FId="+FI_RecId+"&FDId="+FD_RecId);  
    }
    else if(isAutoPass.equals("1"))
    {
        String FR_RecId="";
        Rs=Data.getSmt(Conn,"select * from flow_form_rulestage where FR_OrgId="+ApplyOrgId+" order by FR_RecId desc limit 1");
        Rs.next();
        FR_RecId=Rs.getString("FR_RecId");
        Rs.close();Rs=null;
        String FormStr="";
        FormStr="<html><head><META HTTP-EQUIV='expires' CONTENT='-1'><META HTTP-EQUIV='pragma' CONTENT='no-cache'><meta http-equiv='Content-Type' content='text/html; charset=MS950'></head><body>";
        FormStr+="<form name=Frm_Auto method=post action='/Modules/JFlow_FormFolder/Form_Check_Content.jsp'>";
        FormStr+="<input type=hidden name='CheckOrgId' value='"+(SurveyOrgId.equals("")?"0":J_OrgId)+"'>"; //�f�֪�(�ۤv�� 0 Pass)
        FormStr+="<input type=hidden name='OrgId' value='"+ApplyOrgId+"'>";
        FormStr+="<input type=hidden name='FR_RecId' value='"+FR_RecId+"'>";
        FormStr+="<input type=hidden name='FI_RecId' value='"+FI_RecId+"'>";
        FormStr+="<input type=hidden name='FD_RecId' value='"+FD_RecId+"'>";
        FormStr+="<input type=hidden name='CheckResult' value='1'>";
        FormStr+="<input type=hidden name='FromAP' value='FormApply'>";
        FormStr+="<input type=hidden name='Command' value='"+(SurveyOrgId.equals("")?"��:�䤣�즹���f�֤H��,�۰�PASS.":"��:�ӽЪ̬��f�֪�,�۰�PASS.")+"'>";
        FormStr+="<script>Frm_Auto.submit();</script></body></html>";
        out.println(FormStr);
    }
    return;
}
else if(isPost(request) && !OP.equals("ReApply"))
{
    out.println("<script>alert('�z�ӽЪ���Ƥw�g�e�X!,�i�H�Ѫ��l�ܬd�߱z���ӽжi��!');document.location.href='Form_Tracert.jsp';</script>");
    return;
}

//Form Var
SqlStr="select * from flow_formvar where V_FormId="+Data.toSql(FI_RecId);
Rs=Data.getSmt(Conn,SqlStr);
while(Rs.next())
{
    if(Rs.getInt("V_VarType")==1)
    {    
        value=Data.Replace(Data.Replace(Rs.getString("V_VarValue"),"{UID}",Data.getSession("J_UD_Id")),"{ID}",Data.getSession("J_Id"));
        value=Data.exeScript(value);
    }
    else
        value=HttpCore.doWebProcedure("WP_"+Rs.getString("V_VarValue"));
    FormVarHash.put("{##Var_"+Rs.getString("V_VarName")+"}", value);
}
Rs.close();Rs=null;

Rs=JOrg.getMainDepartmentByUser(J_OrgId);
if(Rs.next())
{   DepOptValue.add(Rs.getString("OrgId"));DepOptDesc.add(Rs.getString("OrgName"));DeptValue=Rs.getString("OrgId");}
else
{   DepOptValue.add("");DepOptDesc.add("");}

PeoOptValue.add("");PeoOptDesc.add("");

//�]�w�ӽЪ��A
session.setAttribute("Apply",ApplyOrgId);

String TimeSel=ProceTimeSel();
UI.Start();

out.println("<div id='Div_Wait_Do' style='display:' class='skin2'>");
out.println("<table width='100%' height='100%' border=0><tr><td width='100%' valign=middle align=center><img src='/images/busy.gif'>&nbsp;<font color=#0000ff>�B�z��...�еy��...</font></td></tr></table>");
out.println("</div>");
out.flush();
    
if(FI_Rule.equals("0"))
{
    out.println("<script language=javascript>alert('�����ҨϥΪ��y�{�W�h�w�Q�R��,�гq���t�κ޲z��!');</script>");
    return;
}        
    ApplyDepartment=JOrg.getMainDepartmentNameByUser(ApplyOrgId);
    ApplyTitle=JOrg.getUserTitle(ApplyOrgId);
    Grid Grid=new Grid(pageContext); 
    Grid.Init();
    Grid.isCatchBuffer(false);
    Grid.setGridWidth("100%");
    Grid.AddTab("<img src='/Modules/JFlow_FormWizard/Form_apply.png'>&nbsp;"+FormName,1);    
    Grid.setForm(true);     
    Grid.AddRestTab("<font color=#0000ff><b><u>�ӽЪ�:"+ApplyDepartment+UI.addSpace()+ApplyTitle+UI.addSpace()+ApplyName+"</u></b></font>");
    
    if(FI_Descript_ShowType==1 || FI_Descript_ShowType==3)
    {        
        Grid.AddRow("",2);
        Grid.AddCol("��满��:","nowrap width=80 valign=top nowrap");
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
                    //���o���Event Script
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
						if(FieldCount==1)
                        {PutContent+="<input type=text name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' value='"+(UI.req("FD_Data"+FieldCount).equals("")?FF_Value:UI.req("FD_Data"+FieldCount))+"' size='"+Size+"' maxlength='"+Size+"' "+EventScriptStr+">";}
                        else if(FieldCount==5||FieldCount==6||FieldCount==7||FieldCount==8)
                        {PutContent+="<input type=text name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"'  readonly value='"+(UI.req("FD_Data"+FieldCount).equals("")?FF_Value:UI.req("FD_Data"+FieldCount))+"' size='"+Size+"' maxlength='"+Size+"' "+EventScriptStr+">";}
                        else      
                        {PutContent+="<input type=text name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' value='"+(UI.req("FD_Data"+FieldCount).equals("")?FF_Value:UI.req("FD_Data"+FieldCount))+"' size='"+Size+"' maxlength='"+Size+"' "+EventScriptStr+">";}
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п�J"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
						
					}
                    else if(FF_Type.equals("TextArea"))
                    {
                        PutContent+="<textarea name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' rows='10' cols='70' "+EventScriptStr+">"+(UI.req("FD_Data"+FieldCount).equals("")?FF_Value:UI.req("FD_Data"+FieldCount))+"</textarea>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п�J"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
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
                        PutContent+="<input type=text name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' value='"+(UI.req("FD_Data"+FieldCount).equals("")?FF_Value:UI.req("FD_Data"+FieldCount))+"' size='"+Size+"' maxlength='"+Size+"' onkeypress='only_Number(event)' "+EventScriptStr+">";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п�J"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                    }
                    else if(FF_Type.equals("Float"))
                    {
                        PutContent+="<input type=text name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' value='"+(UI.req("FD_Data"+FieldCount).equals("")?FF_Value:UI.req("FD_Data"+FieldCount))+"' size='"+Size+"' maxlength='"+Size+"' onkeypress='only_Number_Dot(event)(event)' "+EventScriptStr+">";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п�J"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                    }
                    else if(FF_Type.equals("Date"))
                    {
                        PutContent+="<input type=text readonly value=\""+(req("FD_Data"+FieldCount,request).equals("")?(FF_Value.equals("")?JDate.ToDay():FF_Value):req("FD_Data"+FieldCount,request))+"\" name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"'  "+EventScriptStr+" maxlength=10 size=10 ><img src='/Modules/JIcon/newappointment.gif' "+EventScriptStr+" style='cursor:pointer' title='�]�w���' valign=middle >";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п��"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                    }
                    else if(FF_Type.equals("Time"))
                    {
                        PutContent+="<select size=1 id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"'  >"+TimeSel+"</select>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п��"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                        if(!req("FD_Data"+FieldCount,request).equals(""))
                        {                            
                            ItemScript+="SetSelectItem(document.getElementById('FD_Data"+FieldCount+"'),'"+(UI.req("FD_Data"+FieldCount).equals("")?FF_Value:UI.req("FD_Data"+FieldCount))+"');";
                        }                        
                    }               
                    else if(FF_Type.equals("DateTime"))
                    {
                        PutContent+="<input type=hidden  value='' id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"'><input type=text readonly value=\""+(req("FD_Data"+FieldCount,request).equals("")?JDate.ToDay():req("FD_Data"+FieldCount,request).split(" ")[0])+"\" id='D_FD_Data"+FieldCount+"' name='D_FD_Data"+FieldCount+"' onclick='calendar(this);' maxlength=10 size=10 onblur=\"ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\"><img src='/Modules/JIcon/newappointment.gif' onclick=\"calendar(document.all['FD_Data"+FieldCount+"']);\" style='cursor:pointer' title='�]�w���' valign=middle onblur=\"ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\" ><select size=1 id='T_FD_Data"+FieldCount+"' name='T_FD_Data"+FieldCount+"' onblur=\"ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\">"+TimeSel+"</select>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п��"+FF_Name+"!');document.Frm.D_FD_Data"+FieldCount+".focus();return false;}\n";}
                        if(!req("FD_Data"+FieldCount,request).equals(""))
                        {                            
                            ItemScript+="SetSelectItem(document.getElementById('T_FD_Data"+FieldCount+"'),'"+req("FD_Data"+FieldCount,request).split(" ")[1]+"');";
                        }
                        ItemScript+="ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"');";                        
                    }                       
                    else if(FF_Type.equals("DateRange"))
                    {
                        PutContent+="<input type=text readonly value=\""+(req("FD_Data"+FieldCount,request).equals("")?JDate.ToDay():req("FD_Data"+FieldCount,request))+"\" name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' onclick='calendar(this);' maxlength=10 size=10 ><img src='/Modules/JIcon/newappointment.gif' onclick=\"calendar(document.all['FD_Data"+FieldCount+"']);\" style='cursor:pointer' title='�]�w���' valign=middle >";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п��"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                        FieldCount++;
                        PutContent+="&nbsp;~&nbsp;<input type=text readonly value=\""+(req("FD_Data"+FieldCount,request).equals("")?JDate.ToDay():req("FD_Data"+FieldCount,request))+"\" name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' onclick='calendar(this);' maxlength=10 size=10 ><img src='/Modules/JIcon/newappointment.gif' onclick=\"calendar(document.all['FD_Data"+FieldCount+"']);\" style='cursor:pointer' title='�]�w���' valign=middle >";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п��"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                    }
                    else if(FF_Type.equals("DTRange"))
                    {
                        PutContent+="<input type=hidden  value='' id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"'><input type=text readonly value=\""+(req("FD_Data"+FieldCount,request).equals("")?JDate.ToDay():req("FD_Data"+FieldCount,request).split(" ")[0])+"\" id='D_FD_Data"+FieldCount+"' name='D_FD_Data"+FieldCount+"' onclick='calendar(this);' maxlength=10 size=10  onblur=\"ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\"><img src='/Modules/JIcon/newappointment.gif' onclick=\"calendar(document.all['FD_Data"+FieldCount+"']);\" style='cursor:pointer' title='�]�w���' valign=middle onblur=\"ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\"><select size=1 id='T_FD_Data"+FieldCount+"' name='T_FD_Data"+FieldCount+"' onblur=\"ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\">"+TimeSel+"</select>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п��"+FF_Name+"!');document.Frm.D_FD_Data"+FieldCount+".focus();return false;}\n";}
                        if(!req("FD_Data"+FieldCount,request).equals(""))
                        {                            
                            ItemScript+="SetSelectItem(document.getElementById('T_FD_Data"+FieldCount+"'),'"+req("FD_Data"+FieldCount,request).split(" ")[1]+"');";
                        }
                        ItemScript+="ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"');";
                        FieldCount++;
                        PutContent+="&nbsp;~&nbsp;<input type=hidden  value='' id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"'><input type=text readonly value=\""+(req("FD_Data"+FieldCount,request).equals("")?JDate.ToDay():req("FD_Data"+FieldCount,request).split(" ")[0])+"\" id='D_FD_Data"+FieldCount+"' name='D_FD_Data"+FieldCount+"' onclick='calendar(this);' maxlength=10 size=10  onblur=\"ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\"><img src='/Modules/JIcon/newappointment.gif' onclick=\"calendar(document.all['FD_Data"+FieldCount+"']);\" style='cursor:pointer' title='�]�w���' valign=middle onblur=\"ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\"><select size=1 id='T_FD_Data"+FieldCount+"' name='T_FD_Data"+FieldCount+"' onblur=\"ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"')\">"+TimeSel+"</select>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п��"+FF_Name+"!');document.Frm.D_FD_Data"+FieldCount+".focus();return false;}\n";}
                        if(!req("FD_Data"+FieldCount,request).equals(""))
                        {                            
                            ItemScript+="SetSelectItem(document.getElementById('T_FD_Data"+FieldCount+"'),'"+req("FD_Data"+FieldCount,request).split(" ")[1]+"');";
                        }     
                        ItemScript+="ProceDate('FD_Data"+FieldCount+"','D_FD_Data"+FieldCount+"','T_FD_Data"+FieldCount+"');";
                    }                    
                    else if(FF_Type.equals("Money"))
                    {
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='' || document.Frm.FD_Data"+FieldCount+".value=='0') {alert('�п�J"+FF_Name+"!');document.Frm.FD_Data"+FieldCount+".focus();return false;}\n";}
                        PutContent+="N.T.$<input type=text name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' value='"+req("FD_Data"+FieldCount,request)+"' size='"+Size+"' maxlength='"+Size+"' onkeypress='only_Number(event)' onkeyup=\"document.getElementById('tmpMoney_"+FieldCount+"').innerHTML=getRegular(this.value)+'����'\" "+EventScriptStr+">";                
                        PutContent+="&nbsp;&nbsp;�s�x��(�j�g):<span id=tmpMoney_"+FieldCount+" name=txtMoneytxtMoney_"+FieldCount+" style='WIDTH: 50%; HEIGHT: 18px;' >�s����</span>";                
                        if(!req("FD_Data"+FieldCount,request).equals("")) ItemScript+=" document.getElementById('tmpMoney_"+FieldCount+"').innerHTML=getRegular(Frm.FD_Data"+FieldCount+".value)+'����';\n";
                    }
                    else if(FF_Type.equals("WebEdit"))
                    {
                        PutContent+=HttpCore.HTMLEditor(req("FD_Data"+FieldCount,request),"FD_Data"+FieldCount,false);
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п�J"+FF_Name+"!');return false;}\n";}
                    }
                    else if(FF_Type.equals("File"))
                    {
                        if(Size.equals("0"))
                            PutContent+=UI.UpFile("FD_Data"+FieldCount,"",0,0,false);
                        else
                            PutContent+=UI.UpFile("FD_Data"+FieldCount,req("FD_Data"+FieldCount,request),Integer.parseInt(Size),0,false);                        
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�|���W��"+FF_Name+"!');return false;}\n";}
                    }
                    else if(FF_Type.equals("Employee"))
                    {
                        if(!req("FD_Data"+FieldCount,request).equals(""))
                        {
                            PeoOptDesc.clear();PeoOptValue.clear();
                            SqlStr="select * from Org where OrgId="+req("FD_Data"+FieldCount,request)+" limit 1";
                            TmpRs=Data.getSmt(Conn,SqlStr);
                            TmpRs.next();
                            PeoOptDesc.add(TmpRs.getString("OrgName"));
                            PeoOptValue.add(TmpRs.getString("OrgId"));
                            TmpRs.close();TmpRs=null;
                        }
                        PutContent+=UI.SelectOrgWithExecuteScript("FD_Data"+FieldCount,req("FD_Data"+FieldCount,request),PeoOptDesc,PeoOptValue,false,8,1,EventScriptStr);
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�ЬD��"+FF_Name+"!');return false;}\n";}
                    }
                    else if(FF_Type.equals("Department"))
                    {
                        if(!req("FD_Data"+FieldCount,request).equals(""))
                        {
                            DepOptDesc.clear();DepOptValue.clear();
                            DeptValue=req("FD_Data"+FieldCount,request);
                            SqlStr="select * from Org where OrgId="+DeptValue+" limit 1";
                            TmpRs=Data.getSmt(Conn,SqlStr);
                            TmpRs.next();
                            DepOptDesc.add(TmpRs.getString("OrgName"));
                            DepOptValue.add(TmpRs.getString("OrgId"));
                            TmpRs.close();TmpRs=null;
                        }
                        PutContent+=UI.SelectOrgWithExecuteScript("FD_Data"+FieldCount,DeptValue,DepOptDesc,DepOptValue,false,1,1,EventScriptStr);
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�ЬD��"+FF_Name+"!');return false;}\n";}
                    }        
                    else if(FF_Type.equals("Hidden"))
                    {
                        PutContent+="<input type=hidden name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' value='"+(UI.req("FD_Data"+FieldCount).equals("")?FF_Value:UI.req("FD_Data"+FieldCount))+"'>";
                        if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�п�J"+FF_Name+"!');return false;}\n";}
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
                                case 1:
                                    MStr.append("<input type=hidden name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' value='"+req("FD_Data"+FieldCount,request)+"'>");
                                    if(MustKeying.equals("1")) {ScriptStr+=" if(!checkRadioData('FD_Data"+FieldCount+"')) {alert('�п��"+FF_Name+"!');return false;}\n";}
                                    break;
                                case 2:
                                    MStr.append("<input type=hidden name='FD_Data"+FieldCount+"' id='FD_Data"+FieldCount+"' value='"+req("FD_Data"+FieldCount,request)+"'>");
                                    if(MustKeying.equals("1")) {ScriptStr+=" if(!checkCheckBoxData('FD_Data"+FieldCount+"')) {alert('�п��"+FF_Name+"!');return false;}\n";}
                                    break;
                                case 3: 
                                    MStr.append("<input type=hidden FF_Type='"+FF_TypeArr[1]+"' FieldType='3' FieldCount="+FieldCount+" id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"' value='"+req("FD_Data"+FieldCount,request)+"'>");
                                    MStr.append("<select size=1  name='tmp_FD_Data"+FieldCount+"' id='tmp_FD_Data"+FieldCount+"' "+EventScriptStr+">");
                                    MStr.append("<option value=''>�п��...</option>");
                                    if(MustKeying.equals("1")) {ScriptStr+=" if(!checkSelecData('FD_Data"+FieldCount+"')) {alert('�п��"+FF_Name+"!');return false;}\n";}
                                    if(!req("FD_Data"+FieldCount,request).equals(""))
                                    {
                                        ItemValueArr=req("FD_Data"+FieldCount,request).split(",");
                                        ItemScript+=" Item(document.getElementById('tmp_FD_Data"+FieldCount+"'),document.getElementById('tmp_FD_Data"+FieldCount+"'),'"+ItemValueArr[0]+"','"+ItemValueArr[1]+"');\n";
                                        ItemScript+=" getSelectData('FD_Data"+FieldCount+"','tmp_FD_Data"+FieldCount+"');\n";
                                    }
                                    if(!FF_Value.equals("")) ItemScript+=Data.Replace(EventScriptStr,"onchange=","");                                     
                                    break;
                                case 4:
                                    if(MustKeying.equals("1")) {ScriptStr+=" if(!checkSelecData('FD_Data"+FieldCount+"')) {alert('�п��"+FF_Name+"!');document.Frm.MenuItem"+FieldCount+".focus();return false;}\n";}
                                    MStr.append("<table border=0 cellpadding=2 cellspacing=0>");
                                    MStr.append("<tr>");
                                    MStr.append("  <td><img src=/images/folder1.gif>&nbsp;����</td>");
                                    MStr.append("  <td>&nbsp;</td>");
                                    MStr.append("  <td><img src=/images/folder1.gif>&nbsp;���e<input type=hidden FF_Type='"+FF_TypeArr[1]+"' FieldType='4' FieldCount="+FieldCount+" id='FD_Data"+FieldCount+"' name='FD_Data"+FieldCount+"' ></td>");
                                    MStr.append("</tr>");
                                    if(!req("FD_Data"+FieldCount,request).equals(""))
                                    {
                                        String ItemArr[]=req("FD_Data"+FieldCount,request).split("\\|");
                                        for(int i_Item=0;i_Item<ItemArr.length;i_Item++)
                                        {
                                            ItemValueArr=ItemArr[i_Item].split("\\,");
                                            ItemScript+=" Item(document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'),'"+ItemValueArr[0]+"','"+ItemValueArr[1]+"');\n";
                                        }
                                        ItemScript+=" select_in(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'),"+F_MaxCount+");\n";
                                    }
                                    break;
                                 case 5:
                                    if(MustKeying.equals("1")) {ScriptStr+=" if(document.Frm.FD_Data"+FieldCount+".value=='') {alert('�ЬD��"+FF_Name+"!');return false;}\n";}
                                    MStr.append("<input type=text style='width:"+F_MaxCount+"' name=FD_Data"+FieldCount+" id='FD_Data"+FieldCount+"' value='"+req("FD_Data"+FieldCount,request)+"' ><input type=button value='�D��...' "+EventScriptStr+">");            
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
                                    ItemRs=Data.getSmt(F_D_DBId,F_D_CmdId,FI_RecId,FormVarHash);     
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
                                        MStr.append("<input type=radio value='"+F_Value+"' "+JUtil.isChecked(req("FD_Data"+FieldCount,request),F_Value)+" id='tmpFD_Data"+FieldCount+"' name='tmpFD_Data"+FieldCount+"' onclick=\"getRadioData('FD_Data"+FieldCount+"','tmpFD_Data"+FieldCount+"')\">"+F_Item+"&nbsp;");                
                                        break;
                                    case 2:
                                        MStr.append("<input type=checkbox value='"+F_Value+"' "+((req("FD_Data"+FieldCount,request).indexOf(","+F_Value+",")>-1)?"checked":"")+" name='tmpFD_Data"+FieldCount+"' id='tmpFD_Data"+FieldCount+"' onclick=\"getCheckBoxData("+F_MaxCount+",'FD_Data"+FieldCount+"','tmpFD_Data"+FieldCount+"')\">"+F_Item+"&nbsp;");                                
                                        break;
                                    case 3:
                                        MStr.append("<option value='"+F_Value+"' "+JUtil.isSelect((req("FD_Data"+FieldCount,request).equals("")?FF_Value:req("FD_Data"+FieldCount,request)),F_Value)+">"+F_Item+"</option>");
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
                                    break;
                                case 2:

                                    break;
                                case 3:
                                    MStr.append("</select>");
                                    break;
                                case 4:
                                    MStr.append("<tr>");
                                    MStr.append("  <td><select id=MenuItem"+FieldCount+" Name=MenuItem"+FieldCount+" multiple style=\"height:153pt;width:140pt;font-size:12px\" ondblclick=\"select_in(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'),"+F_MaxCount+");\">"+MenuItem.toString()+"</select></td>");
                                    MStr.append("  <td align=center>");
                                    MStr.append("		    <input Type=button Name=allin"+FieldCount+" Value=\"&gt; &gt;\" onclick=\"all_in(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'),"+F_MaxCount+");\">");
                                    MStr.append("		    <p><input Type=button Name=selectin"+FieldCount+" Value=\"--&gt;\" onclick=\"select_in(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'),"+F_MaxCount+");\">");
                                    MStr.append("		    <p><input Type=button Name=removeout"+FieldCount+" Value=\"&lt;--\" onclick=\"remove_out(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'));\">");
                                    MStr.append("		    <p><input Type=button Name=allout"+FieldCount+" Value=\"&lt; &lt;\" onclick=\"all_out(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'));\">");
                                    MStr.append("		    </td>");
                                    MStr.append("  <td><select id=Content"+FieldCount+" Name=Content"+FieldCount+" multiple style=\"height:153pt;width:140pt;font-size:12px\" ondblclick=\"remove_out(document.getElementById('FD_Data"+FieldCount+"'),document.getElementById('MenuItem"+FieldCount+"'),document.getElementById('Content"+FieldCount+"'));\"></select></td>");
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
                if(!FF_Type.equals("Hidden")  && !FF_Type.equals("HDescript"))
                {
                    Grid.AddRow("",ColNum);
                    Grid.AddCol(First_FF_Name,"nowrap width=80 valign=top");
                    RowCount++;
                    if(RowCount%FI_ColCount==0) ColNum=ColNum-1;
                    if(ColNum==-1) ColNum=1;
                }
            }
                    TmpColGroup=ColGroup;
              }
              MRs.beforeFirst();
        }
        MRs.close();MRs=null;
        Grid.AddCol(PutContent," valign=top nowrap");      
    
    if(!hasChangeColor) ColNum=ColNum+1; 
    Grid.AddRow("",ColNum);
    //J_OrgId,J_Department,SurveyOrgId���Ȭ��f�֤H��,�榡3 or 1,5,9
    Grid.AddCol("<div id='FieldContent' style=\"display:''\"></div><input type=hidden name='MustChoose' id='MustChoose' value=''><input type=hidden name='SurveyOrgId' id='SurveyOrgId' value=''><input type=hidden name='PathSurvey' value=''><input type='hidden' name='Curr_Stage' id='Curr_Stage' value='1'><input type='hidden' name='OP' id='OP' value='"+OP+"'><input type=hidden name=FI_Rule value='"+FI_Rule+"'><input type=hidden name=FI_RuleMethod value='"+FI_RuleMethod+"'><input type=hidden name=FI_MultiRule value='"+FI_MultiRule+"'><input type='hidden' name='FI_RecId' id='FI_RecId' value='"+FI_RecId+"'><input type='hidden' name='J_OrgId' id='J_OrgId' value='"+J_OrgId+"'><input type='hidden' name='J_Department' id='J_Department' value='"+J_Department+"'><input type='hidden' name='ApplyDepartment' id='ApplyDepartment' value='"+ApplyDepartment+"'><input type=hidden name=<input type='hidden' name='FD_RecId' value='"+Re_FD_RecId+"'><input type=button name=go value='�T�w�ӽ�' onclick=\"doApply()\">&nbsp;&nbsp;&nbsp;<input type='button' name=btnBack value='����' onclick=\"document.location.href='Form_Tracert.jsp';\">"," colspan=2 align=center");
    }
    Grid.Show();
    Grid=null;

    FieldTypeDict=FieldTypeHash.keys();
    while(FieldTypeDict.hasMoreElements())
    {           
        Rs=(ResultSet)FieldTypeHash.get(FieldTypeDict.nextElement().toString());
        Rs.close();Rs=null;
    }
FieldTypeDict=null;    
UI=null;
JOrg=null;
closeConn(Data,Conn);
%>
<iframe id=FrmRule name=FrmRule src='' width="100%" height="200" style="display:none" frameborder=0></iframe>
<script src='/Modules/JEIPKernel/JEIP_WebControl.js'></script>
<script>

//�۰ʱa�J�ɶ���ĤG���(����ܧ�)
var Today=new Date();
	year=Today.getFullYear();
	month=Today.getMonth()+1;
	day=Today.getDate();
if(month<10)
{
   month = "0" + month;
}
if(day<10)
{
   day = "0" + day;
}
	
d1= year+"/"+month+"/"+day;

document.getElementById("FD_Data2").value=d1;
var Obj1 = document.getElementById("FD_Data2");
    Obj1.setAttribute("readOnly",'true');

//�NIP�g�J�ĤT���(����ܧ�)
document.getElementById('FD_Data3').value='<%=ipAddress %>';
var Obj2 = document.getElementById("FD_Data3");
    Obj2.setAttribute("readOnly",'true');

//Step 1
function doApply()
{
	//���b�]�w:(�D�ޤ��o�f�ۤv)
	var APArr=Frm.FD_Data1.value.split(' ');
		AP=APArr[0].substring(0,5).trim();
		SurverArr_1=Frm.FD_Data9.value.split(':');		
		S1=SurverArr_1[1].substring(0,5).trim();
	if(AP==S1)
	{
		alert('�Ĥ@���G�D�ޤ��o�f�ۤv!');
		Frm.tmp_FD_Data9.focus();
		return false;
	}
	   
	var list = [];
	var listfid = [];
	var UID="";
	
	//�Ĥ@��
	if(document.getElementById('tmp_FD_Data9').value=='')
	{
		document.getElementById('FD_Data13').innerText='';
		alert('�п�ܲĤ@���f�֤H��!');
		Frm.tmp_FD_Data9.focus();
		return false;
	}
	else
	{		  
		var SurverArr=Frm.FD_Data9.value.split(':');	  
		var ID=SurverArr[1].substring(0,5).trim(); 		  		  
		if(ID!='' && SurverArr[1].substring(0,5).trim().length==4)
		{
			UID="cy"+Frm.tmp_FD_Data9.value.trim();
		}
		if(ID!='' && SurverArr[1].substring(0,5).trim().length==5)
		{
			UID="c"+Frm.tmp_FD_Data9.value.trim()+1;
		}		
		var Field1 = 'FD_Data13'; 
		list.push(UID);
		listfid.push(Field1);	 
	}
	  
	  
	//�ĤG��
	if(document.getElementById('tmp_FD_Data10').value=='')
	{
		document.getElementById('FD_Data14').innerText='';
		alert('�п�ܲĤG���f�֤H��!');
		Frm.tmp_FD_Data10.focus();
		return false;
	}
	else
	{
		var SurverArr=Frm.FD_Data10.value.split(':');	  
		var ID=SurverArr[1].substring(0,5).trim(); 		  
		  
		if(ID!='' && SurverArr[1].substring(0,5).trim().length==4)
		{
			UID="cy"+Frm.tmp_FD_Data10.value.trim();
		}
		if(ID!='' && SurverArr[1].substring(0,5).trim().length==5)
		{
			UID="c"+Frm.tmp_FD_Data9.value.trim()+1;
		}
		
		var Field1 = 'FD_Data14'; 
		list.push(UID);
		listfid.push(Field1);
	}
	 
	//�ĤT��
	if(document.getElementById('tmp_FD_Data11').value=='')
	{
		document.getElementById('FD_Data15').innerText='';
		alert('�п�ܲĤT���f�֤H��!');
		Frm.tmp_FD_Data11.focus();
		return false;
	}
	else(document.getElementById('tmp_FD_Data11').value!='')
	{
		var SurverArr=Frm.FD_Data11.value.split(':');
		var ID=SurverArr[1].substring(0,5).trim();  
		  
		if(ID!='' && SurverArr[1].substring(0,5).trim().length==4)
		{
			UID="cy"+ID;
		}
		if(ID!='' && SurverArr[1].substring(0,5).trim().length==5)
		{
			UID="c"+ID+1;
		}
		var Field1 = 'FD_Data15'; 
		list.push(UID);
		listfid.push(Field1);
	}
	  
	//�ĥ|��
	if(document.getElementById('tmp_FD_Data12').value=='')
	{
		document.getElementById('FD_Data16').innerText='';
		alert('�п�ܲĥ|���f�֤H��!');
		Frm.tmp_FD_Data12.focus();
		return false;
	}
	else
	{
		UID=document.getElementById('tmp_FD_Data12').value.trim()+1;
		var Field1 = 'FD_Data16'; 
		list.push(UID);
		listfid.push(Field1);
	}
	
	document.getElementById('FrmRule').src ='/Form/getOrgId2.jsp?UID='+list+'&Field1='+listfid+'';  
	setTimeout(function ()
	{
		if(DataCheck())
		{
			Frm.action='parseRule.jsp';
			Frm.target='FrmRule';
			Frm.submit();
		}
	}, 500);	
}

//Step 2
function SendForm()
{
  //  Frm.SurveyOrgId.value=Frm.SurveyOrgId.value.split(",")[0];
  //  alert(Frm.SurveyOrgId.value);
	closeShim('Shim','DynamicChoose');
    ShowWait();
    Frm.action='Form_Apply.jsp';
    Frm.target='';
    Frm.go.disabled=true;
    Frm.btnBack.disabled=true;
    Frm.submit();
}


function DataCheck()
{   
    if(typeof(beforeCheckData)=='function') 
    {
        var val=eval('beforeCheckData();');
        if(!val) return val;
    }
    <%=ScriptStr%>
    if(confirm('�T�w�e�X������?'))     
    {
		var SP='';
		S1=document.getElementById('FD_Data13').innerText;
		S2=document.getElementById('FD_Data14').innerText;
		S3=document.getElementById('FD_Data15').innerText;  //101; //�Ӱȸ�T�ҥD��OrgId
		S4=document.getElementById('FD_Data16').innerText;  //241; //�Ӱȸ�T��OrgId
		   	   
		if(S1==undefined)
		{
			alert("�ЦA���o�e");
			return false;
		}
		else if(S2==undefined)
		{
			alert("�ЦA���o�e");
			return false;
		}
		else if(S3==undefined)
		{
			alert("�ЦA���o�e");
			return false;
		}
		else if(S4==undefined)
		{
			alert("�ЦA���o�e");
			return false;
		}
		else
		{
			if(S1!='') SP=S1+'#'; else {SP+='0#';}
			if(S2!='') SP+=S2+'#'; else {SP+='0#';}
			if(S3!='') SP+=S3+'#';
			if(S4!='') SP+=S4+'#';				   
			Frm.PathSurvey.value=SP.substring(0,SP.length-1);				
			Frm.go.disabled=true;      
			return true;
		}		   
    } 	 
    else
    {
	return false;
    }
}

<%
if(FI_Descript_ShowType==2 || FI_Descript_ShowType==3)
{
    out.println("alert('"+FI_Descript.replaceAll("\r\n","\\\\n")+"');");
}
%>    
<%if(OP.equals("ReApply")) out.println("alert('��歫�s�ӽ�,�Ш̾ڹ�ڸ�ƶ�g!');");%>
    
function openShim(menu,Choose)
{   
    var width=0;
    var height=0;    
    var shim = getShim(menu);        
    var shim_Choose = getShim(Choose);
    if (shim==null) shim = createMenuShim(menu);    
    if (shim_Choose==null) shim_Choose = createMenuShim(Choose);    
    if(window.navigator.userAgent.indexOf('Firefox')>-1) 
    {
        width = document.body.offsetWidth-20;
        height= document.body.scrollHeight-20;
    }
    else
    {
        width = document.body.scrollWidth;
        height= document.body.scrollHeight;       
    }
    shim.style.zIndex = 20;
    shim.style.width = width;
    shim.style.height = height;
    shim.style.frameborder=0;
    shim.style.border=0;
    shim.style.top = 0;
    shim.style.left = 0;        
    shim.style.filter = "alpha(opacity = 50)"; 
    shim.style.MozOpacity = 0.5; 
    shim.style.opacity=0.5; 
    shim.style.position = "absolute";
    shim.style.display = "";    
    
    shim_Choose.style.zIndex = 21;
    shim_Choose.src="/Modules/JEIPKernel/SysChooser.jsp?FromAP=Flow&MustChoose="+Frm.MustChoose.value+"&M=0&c=8&Field=SurveyOrgId&ExecuteFunction=SendForm()";    
    shim_Choose.style.width = 520;
    shim_Choose.style.height = 470;
    shim_Choose.style.frameborder=0;
    shim_Choose.style.border=0;
    shim_Choose.style.top = 0
    shim_Choose.style.left = (width-520)/2;         
    shim_Choose.style.position = "absolute";
    shim_Choose.style.display = "";    
    if(Frm.MustChoose.value=='1')
        alert('�п�ܼf�֤H��.��n��,�Ĥ@���N�|�ѱz��ܪ���H,�f�ֱz�����.');
    else
        alert('�п�ܼf�֤H��.��n��,�Ĥ@���N�|�ѱz��ܪ���H,�f�ֱz�����.\n�p������,�h�ѹw�]�f�֤H���Ӽf�ֱz�����!');
}

function closeShim(menu,Choose)
{     
   var shim = getShim(menu);
   var shim_Choose=getShim(Choose);
   if (shim!=null) shim.style.display = "none";  
   if (shim_Choose!=null) shim_Choose.style.display = "none";  
}

function createMenuShim(menu)
{   
    var shim = null;
    if(window.navigator.userAgent.indexOf('Firefox')>-1) 
    {
        shim=document.createElement("iframe");
        shim.scrolling='no';
        shim.frameborder='0';
        shim.border='0';
        shim.style.position='absolute';
        shim.style.top='0px';
        shim.style.left='0px';
        shim.style.display='none';        
    }
    else
    {    
        shim=document.createElement("<iframe scrolling='no' border=0 frameborder='0'"+
                                      "style='border:0;position:absolute; top:0px;"+
                                      "left:0px; display:none;'></iframe>"); 
    }
    shim.name = getShimId(menu);
    shim.id = getShimId(menu);
    window.document.body.appendChild(shim);
    return shim;
}

function getShimId(menu)
{
    return "__shim"+menu;
}

function getShim(menu)
{
    return document.getElementById(getShimId(menu));
}    

document.getElementById('Div_Wait_Do').style.display='none';
</script>
<%=FI_Script%> 
<script>
<%=ItemScript%>
</script>
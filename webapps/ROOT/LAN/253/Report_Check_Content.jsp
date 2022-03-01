<%@ page contentType="text/html;charset=MS950" %><%@ include file="/kernel.jsp" %><%@ include file="/Modules/JFlow_RuleWizard/Util_Rule.jsp" %><%@ include file="/Modules/JFlow_FormWizard/Util_Form.jsp" %><%
String SqlStr="",SqlStr1="",SqlStr2="",OP="";
String FR_RecId="",OrgId,FI_RecId="",FI_ModuleId="",FormName="",field_where="",after_field="";
String FF_Property="",First_FF_Name="",FF_Name="",TmpFF_Name="",FF_Type="",TmpColGroup="",ColGroup="",Size="",FD_Data="";
String ItemScript="",ScriptStr="",ColContent="",PutContent="",PropertyArr[]=null;
String FI_Descript="",FD_RecId="",RI_ReturnTo="",ApplyOrgId="",ApplyName="",FR_RuleId="";
String Command="",CheckResult="",BackPreStage="",ReApplyDataId="",ReApplyFunction="";
String RI_AlertTo1="",RI_AlertTo2="",RI_AlertTo3="",RI_AlertTo4="",RI_AlertTo_Member="";
String DrawForm="",BackForm="",NextState="",FI_Procedure="";       
String RI_AlertToMemberArr[]=null,RI_AlertToArr[]=null;
String UnitManagerOrgId="",ManagerOrgId="",OrgStr="",SendTo="",OnlyView="",hasPrint="",CanPrint="";
String FR_Stage_State="",FR_Stage_Survey="",FR_Stage_Foward="",Pre_Stage_State="",Pre_Stage_Survey="";
String ReturnOrgStr="",ApplyDate="",RI_AlertDay="";
String AdminOrgId="",CheckOrgId="",AgentOrgId="",FinishState="";
String To="",From="",ToName="";
boolean ApplyIsSurvey=false,isOnlyOneSurvey=false,hasNextStage=false,isPass=true,isSuccess=false;
int FI_Descript_ShowType=0,FI_isStop=0,CurrStage=0,NextStage=0,TTLRI_StageCount=0;
int num_fields=0,FormFieldCount=0,FieldCount=0;
ArrayList DepOptValue=new ArrayList();ArrayList DepOptDesc=new ArrayList();ArrayList PeoOptValue=new ArrayList();ArrayList PeoOptDesc=new ArrayList();

leeten.HttpCore HttpCore=new leeten.HttpCore(pageContext,Data,Conn);
leeten.Org JOrg=new leeten.Org(Data,Conn);
leeten.FileManager FileMgr=new leeten.FileManager();
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();

boolean insField_finish=false;
StringBuffer MStr=new StringBuffer();
StringBuffer MenuItem=new StringBuffer();
ResultSet Rs=null,MRs=null,TmpRs=null,ItemRs=null,DataRs=null,RRs=null,FSRs=null;

NoCatch(response);

OP=req("OP",request);
FR_RecId=req("FR_RecId",request);
FI_RecId=req("FI_RecId",request);
FD_RecId=req("FD_RecId",request);
OrgId=req("OrgId",request);  //申請者
String MainDept=JOrg.getMainDepartmentIdByUser(OrgId);  //申請者所屬單位

CheckOrgId=req("CheckOrgId",request);
if(CheckOrgId.equals("")) CheckOrgId=J_OrgId;  //審核人員
AgentOrgId=req("AgentOrgId",request);
AdminOrgId=req("AdminOrgId",request);

FI_RecId=Data.toSql(FI_RecId);

SqlStr="select * from flow_forminfo where FI_RecId="+FI_RecId+" limit 1";
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
    FI_ModuleId=Rs.getString("FI_ID");
    FormName=Rs.getString("FI_Name");
    FI_Descript=Rs.getString("FI_Descript");
    FI_Descript_ShowType=Rs.getInt("FI_Descript_ShowType");    
    FormFieldCount=Rs.getInt("FI_FieldCount");
    FI_Procedure=Rs.getString("FI_Procedure");
}
Rs.close();Rs=null;

CheckResult=req("CheckResult",request);
if(isPost(request) && !CheckResult.equals(""))  //進入審核
{
    leeten.Alert JAlert=new leeten.Alert(Data,Conn);   
    Command=req("Command",request);
    
    //讀取此流程申請審核資訊
    SqlStr="select flow_form_rulestage.*,flow_formdata.FD_RecDate from flow_form_rulestage,flow_formdata  where flow_form_rulestage.FR_RecId="+Data.toSql(FR_RecId)+"  and flow_form_rulestage.FR_DataId="+Data.toSql(FD_RecId)+" and flow_form_rulestage.FR_DataId=flow_formdata.FD_RecId limit 1";    
    MRs=Data.getSmt(Conn,SqlStr);
    if(MRs.next())
    {
        FinishState=MRs.getString("FR_FinishState");
        ApplyOrgId=MRs.getString("FR_OrgId"); //申請者ID
        ApplyDate=MRs.getDate("FD_RecDate").toString().replaceAll("-","/")+" "+MRs.getTime("FD_RecDate");
        FR_RuleId=MRs.getString("FR_RuleId");

            //讀取此規則主檔資訊:關數及回函人員,逾期資訊(規則主檔)
            SqlStr="select * from flow_ruleinfo where RI_RecId="+FR_RuleId+" limit 1";
            RRs=Data.getSmt(Conn,SqlStr);
            RRs.next();
            TTLRI_StageCount=RRs.getInt("RI_StageCount");
            RI_AlertDay=RRs.getString("RI_AlertDay");  //是否要逾時通知,0則不用,其餘為逾期天數
            RI_AlertToArr=RRs.getString("RI_AlertTo").split(";"); //逾時通知人員
            RI_AlertTo1=RI_AlertToArr[0];  //申請者
            RI_AlertTo2=RI_AlertToArr[1];  //審核者
            RI_AlertTo3=RI_AlertToArr[2];  //審核者的部門主管
            RI_AlertToMemberArr=RI_AlertToArr[3].split("#",2); //特定人員
            RI_AlertTo4=RI_AlertToMemberArr[0];  //是否有指定特定人員
            RI_AlertTo_Member=RI_AlertToMemberArr[1];  //特定人員ID
            RI_ReturnTo=RRs.getString("RI_ReturnTo");  //回函人員
            RRs.close();RRs=null;                    

    
        UnitManagerOrgId=JOrg.getMainDepartmentMangerInfoByUser(ApplyOrgId,"OrgId"); //讀取申請者單位主管的OrgId
        if(UnitManagerOrgId.equals("")) UnitManagerOrgId="0";  //抓不到人,則自動Pass        
        ManagerOrgId=JOrg.getDepartmentMangerId(JOrg.getMainDepartmentInfoByUser(ApplyOrgId,"ParentOrg")); //讀取申請者部門主管的OrgId
        if(ManagerOrgId.equals("")) ManagerOrgId="0";  //抓不到人,則自動Pass
        CurrStage=getCurrStage(MRs,TTLRI_StageCount)+1; //檢查審核到第幾關了
        MRs.close();MRs=null;  
     }
     if(FinishState.equals("0"))
     {
        NextStage=CurrStage+1;    
        ApplyName=JOrg.getOrgName(ApplyOrgId);    
        //讀取此規則關數資訊,知會人員,全部通過時,則發Mail知會,並寫入知會人員欄位,以便查閱
        SqlStr="select * from flow_rulestage where RS_RuleId ="+FR_RuleId+" limit 1";
        FSRs=Data.getSmt(Conn,SqlStr);
        FSRs.next();          
        From=SysCore.getSysVar("PortalAdminEMail");    
        //此為判斷是否每關都是設定申請者如為審核者則自動Pass,且只有一人之狀況,如每關都是申請者同審核者,則會自動Pass到最後一關之情況
        //如果關卡無人,也會自動Pass
        while(isPass)
        {   
            ApplyIsSurvey=false;isOnlyOneSurvey=false;hasNextStage=false;isPass=false;      
            SqlStr="select * from flow_form_rulestage  where FR_RecId="+Data.toSql(FR_RecId)+" and FR_FinishState=0 limit 1";    
            Rs=Data.getSmt(Conn,SqlStr);
            Rs.next();
            FR_Stage_State=Rs.getString("FR_Stage"+CurrStage+"_State");  //此關的審核狀態,格式:0;,5,29,  0表不通過,1表通過
            //格式: 是否通過;;,審核人員,代理人,管理者,;;意見;;日期##
            FR_Stage_Survey=Rs.getString("FR_Stage"+CurrStage+"_Survey");  //讀取目前的審核內容     
            NextState=Rs.getString("FR_Stage"+NextStage+"_State");  //下關審核人員資訊
            Rs.close();Rs=null;
            //讀取本關知會人員, 2:特定人員 3:部門主管  1:不需知會    
            //Property格式: [0]審核人員;[1]知會人員;[2]是否Pass,如審核人員為特定人員,則 RS_Stage_Survey 為特定人員的ORG,格式為 ,OrgId,;
            //[3]角色-自己部門;[4]動態-必選;[5]特定-1And_2Or
            PropertyArr=(FSRs.getString("RS_Stage"+CurrStage+"_Property")+";;;;").split(";",7);
            switch(Integer.parseInt(PropertyArr[1]))
            {
                case 1:  //不需知會
                    FR_Stage_Foward="";
                    break;
                case 2:  //知會特定人員
                    FR_Stage_Foward=FSRs.getString("RS_Stage"+CurrStage+"_Foward");  //前後有逗號
                    break;
                case 3:  //知會部門主管
                    FR_Stage_Foward=","+ManagerOrgId+",";  //前後有逗號
                    break;
            }

            //格式->審核狀態;;,審核者,代審核者,管理者,;;意見;;審核時間##
            //累加此關目前的審核內容(同一關可能有多人審核);如為代理審核或管理者審核,皆為將原審核者存入
            if(FR_Stage_Survey.indexOf("1;;,"+ApplyOrgId+",")<0) //表示已有審核資料,不累加
                FR_Stage_Survey+=CheckResult+";;,"+CheckOrgId+","+AgentOrgId+","+AdminOrgId+",;;"+Command+";;"+JDate.Now()+"##";
            String TmpArr[]=FR_Stage_State.split(";"); //此關的審核狀態,格式:0;,5,29,  0表不通過,1表通過
            String SurveyArr[]=TmpArr[1].split(","); //此關的審核者,可能會有多個
            isSuccess=true;  //預設此關的所有審核者皆已審核過
            if(!TmpArr[1].equals(",0,")) //如果有審核人員,而自動Pass
            {
                for(int i_survey=0;i_survey<SurveyArr.length;i_survey++)
                {
                    if(!SurveyArr[i_survey].equals(""))  //審核者不為空白,因為 ,3, 透過split後,陣列0與陣列2,會是空白
                    {
                        if(FR_Stage_Survey.indexOf("1;;,"+SurveyArr[i_survey]+",")==-1) //檢查審核者是否已審核過,並一個一個檢查
                        {
                            isSuccess=false;  //有一個沒審核過,則表示此關尚未全部通過.
                            break;
                        }
                    }
                }
           }
            //如果是特定人員,且設為OR,則設為此關通過
           if(PropertyArr[0].equals("2") && PropertyArr[5].equals("2")) isSuccess=true;
            //刪除此關此審核者逾時通知資料(如果是代審,還是要刪除原Alert人員.        
            JAlert.DeleteAlert_By_APRecId_AlertTo(Integer.parseInt(FD_RecId),Integer.parseInt(CheckOrgId)); //只刪除此審核者的Alert

            //是否有下一關 ===========================================================================================================
            //讀取此規則下一關的審核人員,以便本關全數通過,則可以發Mail通知下一關審核者     
            String RS_Stage_Property="";
            String RS_Stage_Survey="";  //下一關的審核人員        

            if(NextStage<=TTLRI_StageCount) //是否有下一關
            {
                hasNextStage=true;    
                if(NextState.equals("")) //下一關無審核人員,則抓規則的審核人員.
                {
                    //Property格式: 審核人員;知會人員;是否Pass,如審核人員為特定人員,則 RS_Stage_Survey 為特定人員的ORG,格式為 ,OrgId,
                    // 2:特定人員   3:部門主管   4:角色    5:動態審核
                    RS_Stage_Property=FSRs.getString("RS_Stage"+NextStage+"_Property");        
                    RS_Stage_Survey=FSRs.getString("RS_Stage"+NextStage+"_Survey");           
                    PropertyArr=(RS_Stage_Property+";;;;").split(";",7); //檢查是否有啟用申請者為審核者,則下一關自動Pass功能
                   /* if(RS_Stage_Property.startsWith("5;")) //此關為動態審核
                    {        
                        if(Org_SurveyOrgId.equals(""))  //沒有選擇審核人員
                        {
                            if(!RS_Stage_Survey.equals("")) 
                            {
                                OrgStr=RS_Stage_Survey;  //此關的預設審核者,有前後逗號
                                SurveyOrgId=RS_Stage_Survey.substring(1,RS_Stage_Survey.length()-1);  //發Mail所以去前後豆號
                                SendToStr=SurveyOrgId;  //設定到SendTo
                            }
                            else
                            {
                                SendToStr="";
                                OrgStr=",0,";  //無設定預設審核人員,自動Pass
                            }
                        }
                        else
                        {
                            OrgStr=","+Org_SurveyOrgId+",";  //此關的審核者,有前後逗號
                            SurveyOrgId=Org_SurveyOrgId;  //發Mail所以去前後豆號
                            SendToStr=SurveyOrgId;  //設定到SendTo
                        }
                    }            
                    else */if(RS_Stage_Property.startsWith("2;")) //特定人員(可能會有多個,格式為:,3,16,5,)
                    {            
                        if(!RS_Stage_Survey.equals("")) OrgStr=RS_Stage_Survey;    //OrgStr為下一關的審核者,前後有逗號
                        //是否下一關只有一個人審核
                        if(RS_Stage_Survey.substring(1,RS_Stage_Survey.length()-1).split(",").length==1) isOnlyOneSurvey=true;
                    }
                    else if(RS_Stage_Property.startsWith("3;")) //單位主管
                    {            
                        OrgStr=","+UnitManagerOrgId+",";   //OrgStr為下一關的審核者,前後有逗號,如果是,0,抓不到人,則自動Pass
                        isOnlyOneSurvey=true;  //部門主管表示只有一人審核
                    }        
                    else if(RS_Stage_Property.startsWith("6;")) //部門主管
                    {            
                        OrgStr=","+ManagerOrgId+",";   //OrgStr為下一關的審核者,前後有逗號,如果是,0,抓不到人,則自動Pass
                        isOnlyOneSurvey=true;  //部門主管表示只有一人審核
                    }                        
                    else if(RS_Stage_Property.startsWith("4#")) //角色(可能會有多個,格式為:,3,16,5,)
                    {            
                        String RuleArr[]=PropertyArr[0].split("#");
                        if(!RS_Stage_Survey.equals("")) //有設定單位
                        {
                            String DeptArr[]=RS_Stage_Survey.substring(1,RS_Stage_Survey.length()-1).split(",");
                            for(int d=0;d<DeptArr.length;d++)
                            {
                                //取主要部門
                                SqlStr="select org.* from orgmb,org where orgmb.DepartmentId="+DeptArr[d]+" and orgmb.OrgId=org.orgid and orgmb.isMain=1 and org.JobTitle="+RuleArr[1]+" limit 1";
                                TmpRs=Data.getSmt(Conn,SqlStr);
                                if(TmpRs.next()) OrgStr+=TmpRs.getString("OrgId")+",";  
                                TmpRs.close();TmpRs=null;
                            }                
                        }    
                        else //表示抓申請者所屬單位
                        {
                            SqlStr="select * from org where Department="+MainDept+" and JobTitle="+RuleArr[1]+" limit 1";
                            TmpRs=Data.getSmt(Conn,SqlStr);
                            if(TmpRs.next()) OrgStr=TmpRs.getString("OrgId")+","; 
                            TmpRs.close();TmpRs=null;
                        }
                        if(!OrgStr.equals(""))
                        {
                            OrgStr=","+OrgStr; //OrgStr為下一關的審核者,前後有逗號
                            //是否下一關只有一個人審核                
                            if(OrgStr.substring(1,OrgStr.length()-1).split(",").length==1) isOnlyOneSurvey=true;
                        }
                        else
                        {
                            OrgStr=",0,";
                        }
                    }            
                }
                else
                {  //取出下關的審核人員
                    OrgStr=NextState.substring(2);
                }
                if(PropertyArr[2].equals("1")) //檢查申請者是否包含於審核者,有則寫入已審核記錄,這樣自己就不用審自己
                {
                    if(OrgStr.indexOf(","+ApplyOrgId+",")>-1) 
                        ApplyIsSurvey=true;  //下一關的申請者,即為審核人員
                    else
                        ApplyIsSurvey=false;
                }
            }        
           // System.out.println("OrgStr->"+OrgStr+":ApplyIsSurvey->"+ApplyIsSurvey+":isOnlyOneSurvey->"+":"+isOnlyOneSurvey);

            SqlStr="select * from flow_form_rulestage  where FR_RecId="+Data.toSql(FR_RecId)+" and FR_FinishState=0 limit 1";    
            Rs=Data.getSmt(Conn,SqlStr);
            Rs.next();

            if(isSuccess) //本關全部通過
            {
                JAlert.DeleteAlertByFromAP_RecId(FD_RecId); //刪除本關所有的逾時通知資料(申請者,審核者,部門主管or其它)
                FR_Stage_State=Data.Replace(FR_Stage_State,"0;,","1;,");   //設定此關狀態通過     
            }   
            Rs.updateString("FR_Stage"+CurrStage+"_State",FR_Stage_State);  
            //如果本關不是上一關寫入的自動Pass,則將審核記錄寫入
            if(!FR_Stage_State.equals("1;,0,")) Rs.updateString("FR_Stage"+CurrStage+"_Survey",FR_Stage_Survey);
            if(isSuccess)  //此關全部都有審核通過,則將知會人員儲存,並發Mail通知
            {
                Rs.updateString("FR_Stage"+CurrStage+"_Foward",FR_Stage_Foward);
                Rs.updateString("FR_FinishTime",JDate.Now());
            }

            if(isSuccess && hasNextStage) //本關的審核者全通過,且有下一關
            {   
                if(ApplyIsSurvey) //有啟用申請者即為審核者,且下一關的申請者,即為審核人員,則自動審核
                {
                    if(isOnlyOneSurvey) 
                    {   //寫入下一關的審核人員,並自動審核通過
                        Rs.updateString("FR_Stage"+(CurrStage+1)+"_State","1;"+OrgStr);  
                        isPass=true;
                    }
                    else  //將自己寫入下一關的審核者,但下一關有多人審,且其它人並未審核,審核人員會有多個的可能,格式為 1;,1,4,
                    {   
                        if(OrgStr.equals(",0,"))  //如果找不到審核人員,則自動Pass
                        {    Rs.updateString("FR_Stage"+(CurrStage+1)+"_State","1;"+OrgStr);isPass=true;}
                        else
                        {    Rs.updateString("FR_Stage"+(CurrStage+1)+"_State","0;"+OrgStr);}
                    }
                    //自已就是下一關的審核者,則將自己寫入下一關的審核資訊
                    Command="註:申請者為審核者,自動PASS.";
                    FR_Stage_Survey="1;;,"+ApplyOrgId+",,,;;"+Command+";;"+JDate.Now()+"##";
                    Rs.updateString("FR_Stage"+(CurrStage+1)+"_Survey",FR_Stage_Survey); //寫入此自動審核的內容            
                }
                else    
                {     
                    if(OrgStr.equals(",0,"))  //找不到審核人員,則自動Pass                                                   
                    {
                        Command="註:找不到此關審核人員,自動PASS.";
                        FR_Stage_Survey="1;;,0,,,;;"+Command+";;"+JDate.Now()+"##";  
                        FR_Stage_State="1;"+OrgStr; 
                        Rs.updateString("FR_Stage"+(CurrStage+1)+"_State",FR_Stage_State);
                        Rs.updateString("FR_Stage"+(CurrStage+1)+"_Survey",FR_Stage_Survey); //寫入此自動審核的內容   
                        isPass=true;}
                    else
                    {   Rs.updateString("FR_Stage"+(CurrStage+1)+"_State","0;"+OrgStr);}  //寫入下一關的審核人員,審核人員會有多個的可能,格式為 0;,1,4,                            
                }
            }
            else if(isSuccess && !hasNextStage) //全通過,且沒有下一關
            {        
                Rs.updateInt("FR_FinishState",1);  //無下一關,則此表單狀態設為審核通過 
                //將回函人員寫入,並發Mail通知回函人員        
                String RI_ReturnToArr[]=RI_ReturnTo.split(";");
                if(RI_ReturnToArr[0].equals("1")) //申請者
                    ReturnOrgStr=","+ApplyOrgId;
                if(RI_ReturnToArr[1].equals("1")) //單位主管       
                    ReturnOrgStr+=","+UnitManagerOrgId;

                String RI_ReturnToMemberArr[]=RI_ReturnToArr[2].split("#",2);  //檢查回函是否有特定人員
                if(RI_ReturnToMemberArr[0].equals("1")) //特定人員
                {
                    ReturnOrgStr+=RI_ReturnToMemberArr[1];
                }
                if(!ReturnOrgStr.endsWith(",")) ReturnOrgStr+=",";
                Rs.updateString("FR_ReturnTo",ReturnOrgStr);            
            }

            if(CheckResult.equals("0")) //不通過,並Mail通知申請者
            {
                Rs.updateInt("FR_FinishState",2);  //則此表單狀態設為審核不通過  
                Rs.updateString("FR_FinishTime",JDate.Now());            
            }    
            else if(CheckResult.equals("2")) //退至上一關
            {
                Pre_Stage_State=Rs.getString("FR_Stage"+(CurrStage-1)+"_State");
                Pre_Stage_State=Data.Replace(Pre_Stage_State,"1;,","0;,");        
                Pre_Stage_Survey=Rs.getString("FR_Stage"+(CurrStage-1)+"_Survey");
                Pre_Stage_Survey=Data.Replace(Pre_Stage_Survey,"1;;,","3;;,");    
                Rs.updateString("FR_Stage"+(CurrStage-1)+"_State",Pre_Stage_State);  
                Rs.updateString("FR_Stage"+(CurrStage-1)+"_Survey",Pre_Stage_Survey); 
            }        
            Rs.updateRow();
            Rs.close();Rs=null;

            //##### 使用WebProcedure ##########################################################################################################333
            if(isSuccess && !hasNextStage) //全通過,且沒有下一關,執行該表單欲處理事件
            {
              //  String Link=PortalLink+"/Modules/"+FI_ModuleId+"/DoFinish.jsp?FR_RecId="+FR_RecId;
              //  String RtnValue=HttpCore.getSiteContent(Link);
                String ProcedureArr[]=null;
                if(!FI_Procedure.equals(""))
                {
                    ProcedureArr=FI_Procedure.split("##");
                    for(int R=0;R<ProcedureArr.length;R++)
                    {
                        HttpCore.doWebProcedure("WP_"+ProcedureArr[R]);
                    }
                }
            }

            // 以下為發送Mail ============================================================================================================
            if(isSuccess && !FR_Stage_Foward.equals(""))  //通知知會人員
            {
                To="";ToName="";
                SqlStr="select Org.OrgName,Org.EMail from Org where OrgId in ("+FR_Stage_Foward.substring(1,FR_Stage_Foward.length()-1)+") ";         
                Rs=Data.getSmt(Conn,SqlStr);
                while(Rs.next())
                {            
                    ToName+=Rs.getString("OrgName")+"<br>";
                    To+=Rs.getString("EMail")+"##";        
                }
                Rs.close();Rs=null;   
                String PortalTitle=SysCore.getApplication("PortalTitle");    
                String MailContent=FileMgr.ReadFile(SysRootPath+"Modules"+Separator+"JEIPKernel"+Separator+"Mail.txt","big5");    
                MailContent=Data.Replace(MailContent,"{PortalTitle}",PortalTitle);    
                MailContent=Data.Replace(MailContent,"{Subject}",PortalTitle+"-表單知會通知");            
                MailContent=Data.Replace(MailContent,"{Body}","<table><tr><td><font color=#0000ff>申請表單:</font></td><td>"+FormName+"</td></tr><tr><td valign=top><font color=#0000ff>申請者:</font></td><td>"+JOrg.getOrgName(OrgId)+"</td></tr><tr><td valign=top><font color=#0000ff>申請時間:</font></td><td>"+ApplyDate+"</td></tr><tr><td colspan=2 ><br><br>申請者已通過第&nbsp;"+CurrStage+"&nbsp;關.</font></td></tr><tr><td colspan=2 ><br><br><a href='"+PortalModuleLink+"'><font color=#ff0000>請至表單資料匣,檢視此表單.</font></a></font></td></tr></table>");

                if(To.length()!=0) HttpCore.SendMail(From,To,PortalTitle+"-表單知會通知",MailContent);
            }

            if(isSuccess && hasNextStage) //全通過,且有下一關,則發信通知下一關審核人員
            {         
                if(!isPass) //如果沒有自動Pass到下一關,表示此關還有其它人要審
                {               
                    To="";ToName="";
                    SqlStr="select Org.OrgId,Org.OrgName,Org.EMail from Org where OrgId in ("+OrgStr.substring(1,OrgStr.length()-1)+") ";            
                    Rs=Data.getSmt(Conn,SqlStr);
                    while(Rs.next())
                    {            
                        if(ApplyIsSurvey && !ApplyOrgId.equals("OrgId")) //有啟用申請者即為審核者,且下一關的申請者,即為審核人員,則不發Mail
                        {
                            ToName+=Rs.getString("OrgName")+"<br>";
                            To+=Rs.getString("EMail")+"##";        
                        }
                    }
                    Rs.close();Rs=null;   
                    String PortalTitle=SysCore.getApplication("PortalTitle");    
                    String MailContent=FileMgr.ReadFile(SysRootPath+"Modules"+Separator+"JEIPKernel"+Separator+"Mail.txt","big5");    
                    MailContent=Data.Replace(MailContent,"{PortalTitle}",PortalTitle);    
                    MailContent=Data.Replace(MailContent,"{Subject}",PortalTitle+"-表單審核通知");            
                    MailContent=Data.Replace(MailContent,"{Body}","<table><tr><td><font color=#0000ff>申請表單:</font></td><td>"+FormName+"</td></tr><tr><td valign=top><font color=#0000ff>申請者:</font></td><td>"+JOrg.getOrgName(OrgId)+"</td></tr><tr><td valign=top><font color=#0000ff>申請時間:</font></td><td>"+ApplyDate+"</td></tr><tr><td colspan=2 ><br><br>申請者目前已到第&nbsp;"+NextStage+"&nbsp;關,需要您的審核!</font></td></tr><tr><td colspan=2 ><br><br><a href='"+PortalModuleLink+"'><font color=#ff0000>請至表單資料匣,檢視此表單.</font></a></font></td></tr></table>");
                    if(To.length()!=0) HttpCore.SendMail(From,To,PortalTitle+"-表單審核通知",MailContent);

                    // 以下為逾時處理 ============================================================================================================
                    //寫入AlertSchedule,如果逾期,則通知
                    ProcessAlert(SysCurrModuleId,FD_RecId,ApplyOrgId,PortalTitle,MailContent,FormName,ApplyName,ApplyDate,PortalLink,OrgStr,TTLRI_StageCount,RI_AlertDay,RI_AlertToArr,JDate,JOrg,Data,Conn);
                }
            }
            //如果自動審核到下一關,則將下一關的審核資訊設為空白;
            if(isPass) {CurrStage++;NextStage=CurrStage+1;}
        }
        FSRs.close();FSRs=null;        


        if(isSuccess && !hasNextStage && !ReturnOrgStr.equals("")) //全通過,沒且有下一關,則發信通知回函人員
        {         
            To="";ToName="";        
            SqlStr="select Org.OrgName,Org.EMail from Org where OrgId in ("+ReturnOrgStr.substring(1,ReturnOrgStr.length()-1)+") ";                    
            Rs=Data.getSmt(Conn,SqlStr);
            while(Rs.next())
            {            
                ToName+=Rs.getString("OrgName")+"<br>";
                To+=Rs.getString("EMail")+"##";        
            }
            Rs.close();Rs=null;   
            String PortalTitle=SysCore.getApplication("PortalTitle");    
            String MailContent=FileMgr.ReadFile(SysRootPath+"Modules"+Separator+"JEIPKernel"+Separator+"Mail.txt","big5");    
            MailContent=Data.Replace(MailContent,"{PortalTitle}",PortalTitle);    
            MailContent=Data.Replace(MailContent,"{Subject}",PortalTitle+"-表單回函通知");            
            MailContent=Data.Replace(MailContent,"{Body}","<table><tr><td><font color=#0000ff>申請表單:</font></td><td>"+FormName+"</td></tr><tr><td valign=top><font color=#0000ff>申請者:</font></td><td>"+JOrg.getOrgName(OrgId)+"</td></tr><tr><td valign=top><font color=#0000ff>申請時間:</font></td><td>"+ApplyDate+"</td></tr><tr><td colspan=2 ><br><br>申請者所申請的表單已經通過.</font></td></tr><tr><td colspan=2 ><br><br><a href='"+PortalModuleLink+"'><font color=#ff0000>請至表單資料匣,檢視此表單.</font></a></font></td></tr></table>");

            if(To.length()!=0) HttpCore.SendMail(From,To,PortalTitle+"-表單回函通知",MailContent);
        }

        if(CheckResult.equals("0")) //不通過,並Mail通知申請者
        {   
            To="";ToName="";
            SqlStr="select Org.OrgName,Org.EMail from Org where OrgId in ("+ApplyOrgId+") ";            
            Rs=Data.getSmt(Conn,SqlStr);
            while(Rs.next())
            {            
                ToName+=Rs.getString("OrgName")+"<br>";
                To+=Rs.getString("EMail")+"##";        
            }
            Rs.close();Rs=null;   
            String PortalTitle=SysCore.getApplication("PortalTitle");    
            String MailContent=FileMgr.ReadFile(SysRootPath+"Modules"+Separator+"JEIPKernel"+Separator+"Mail.txt","big5");    
            MailContent=Data.Replace(MailContent,"{PortalTitle}",PortalTitle);    
            MailContent=Data.Replace(MailContent,"{Subject}",PortalTitle+"-表單審核不通過通知");            
            MailContent=Data.Replace(MailContent,"{Body}","<table><tr><td><font color=#0000ff>申請表單:</font></td><td>"+FormName+"</td></tr><tr><td valign=top><font color=#0000ff>申請者:</font></td><td>"+JOrg.getOrgName(OrgId)+"</td></tr><tr><td valign=top><font color=#0000ff>申請時間:</font></td><td>"+ApplyDate+"</td></tr><tr><td colspan=2 ><br><br>申請者所申請的表單被退件,原因如下.</font></td></tr><tr><td colspan=2 ><br><br>"+Command.replaceAll("\n","<br>")+"<br><br><a href='"+PortalLink+"/?ModuleId=JFlow_AllFormTracert'><font color=#ff0000>請至表單追蹤,檢視此表單.</font></a></font></td></tr></table>");

            if(To.length()!=0) HttpCore.SendMail(From,To,PortalTitle+"-表單審核不通過通知",MailContent);
        }
        //如果是管理者代審,則它是從表單佇列來到這邊,則要再轉回去
        if(!AdminOrgId.equals(""))
            response.sendRedirect("/Modules/JFlow_FormQueue/Form_QueueList.jsp?OP=ReloadTree");   
        else if(req("FromAP",request).equals("FormApply")) //從申請單過來的
            response.sendRedirect("/Modules/JFlow_RuleWizard/Form_Apply_Finish.jsp?OP=OK&FId="+FI_RecId+"&FDId="+FD_RecId);  
        else
            response.sendRedirect("Form_CheckList.jsp?OP=ReloadTree");
    }
    else
    {
        response.sendRedirect("Form_CheckList.jsp?OP=ReloadTree&Err="+FinishState);
    }
    closeConn(Data,Conn);
    
   
    return;
}
else if(isPost(request)) {response.sendRedirect("Form_CheckList.jsp?OP=ReloadTree");return;}
//Mail結束===================================================================================
//===================================================================================


if(OP.equals("Foward"))
{
    SqlStr="select * from flow_form_rulestage where FR_RecId="+Data.toSql(FR_RecId)+" and FR_DataId="+Data.toSql(FD_RecId)+" limit 1";    
    TmpRs=Data.getSmt(Conn,SqlStr);
    TmpRs.next();
    
    ApplyOrgId=TmpRs.getString("FR_OrgId");
    
    //讀取此規則關數
    SqlStr="select * from flow_ruleinfo where RI_RecId="+TmpRs.getString("FR_RuleId")+" limit 1";
    RRs=Data.getSmt(Conn,SqlStr);
    RRs.next();
    TTLRI_StageCount=RRs.getInt("RI_StageCount");
    RRs.close();RRs=null;
    
    //檢查每一關是否有知會記錄,有則更新    
    String FowardStageStr="";
    for(int i=0;i<TTLRI_StageCount;i++)
    {
        if(TmpRs.getString("FR_Stage"+(i+1)+"_Foward").indexOf(","+CheckOrgId+",")>-1 && TmpRs.getString("FR_Stage"+(i+1)+"_Foward").indexOf(";"+CheckOrgId+";")==-1)
        {
            TmpRs.updateString("FR_Stage"+(i+1)+"_Foward",TmpRs.getString("FR_Stage"+(i+1)+"_Foward")+";"+CheckOrgId+";");            
            TmpRs.updateRow();
            ItemScript="parent.FrmTree.document.location.reload();\n";
        }
    }
    
    TmpRs.close();TmpRs=null;    
}


if(OP.equals("Return"))
{   
    SqlStr="select * from flow_form_rulestage where FR_RecId="+Data.toSql(FR_RecId)+" and FR_DataId="+Data.toSql(FD_RecId)+" limit 1";    
    TmpRs=Data.getSmt(Conn,SqlStr);
    TmpRs.next();
    if(TmpRs.getString("FR_ReturnTo").indexOf(","+CheckOrgId+",")>-1 && TmpRs.getString("FR_ReturnTo").indexOf(";"+CheckOrgId+";")==-1)
    {
        TmpRs.updateString("FR_ReturnTo",TmpRs.getString("FR_ReturnTo")+";"+CheckOrgId+";");        
        TmpRs.updateRow();
        ItemScript="parent.FrmTree.document.location.reload();\n";
    }        
    TmpRs.close();TmpRs=null;        
 
}

if(OP.equals("Back"))  //退件,設定已讀取
{   
    SqlStr="select * from flow_form_rulestage where FR_RecId="+Data.toSql(FR_RecId)+" and FR_DataId="+Data.toSql(FD_RecId)+" and FR_BackHasRead=0 limit 1";    
    TmpRs=Data.getSmt(Conn,SqlStr);
    if(TmpRs.next())
    {
        TmpRs.updateInt("FR_BackHasRead",1);      
        TmpRs.updateRow();
        ItemScript="parent.FrmTree.document.location.reload();\n";
    }
    TmpRs.close();TmpRs=null;    
}

//抓取申請者及規則的資料
SqlStr="select * from flow_form_rulestage,flow_ruleinfo where flow_form_rulestage.FR_RecId="+Data.toSql(FR_RecId)+" and flow_form_rulestage.FR_DataId="+Data.toSql(FD_RecId)+" and flow_form_rulestage.FR_RuleId=flow_ruleinfo.RI_RecId limit 1";    
//out.println(SqlStr);
TmpRs=Data.getSmt(Conn,SqlStr);
TmpRs.next();
ReApplyDataId=TmpRs.getString("FR_ReDataId");
DrawForm=TmpRs.getString("RI_DrawForm");
BackForm=TmpRs.getString("RI_BackForm");
TmpRs.close();TmpRs=null;    

if(!ReApplyDataId.equals("0"))
{    
    SqlStr="select * from flow_form_rulestage where FR_OrgId="+Data.toSql(OrgId)+" and FR_DataId="+Data.toSql(ReApplyDataId)+" and FR_FinishState=2 limit 1";    
    TmpRs=Data.getSmt(Conn,SqlStr);
    if(TmpRs.next())
    {
        ReApplyFunction="&nbsp;&nbsp;&nbsp;<font color=#ff0000>此為退件後重新申請資料:</font><input type=button value='檢視上次申請內容' onclick='ViewApplyForm("+TmpRs.getString("FR_RecId")+","+TmpRs.getString("FR_FormId")+","+TmpRs.getString("FR_DataId")+","+TmpRs.getString("FR_OrgId")+",1)'>&nbsp;<input type=button value='檢視上次申請流桯'  onclick='perViewStage("+TmpRs.getString("FR_FormId")+","+TmpRs.getString("FR_DataId")+","+TmpRs.getString("FR_OrgId")+")'>";
    }
    TmpRs.close();TmpRs=null;    
}

Html UI=new Html(pageContext,Data,Conn);

UI.Start();   
%>
<table width="100%" height=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
       <td height="95%"><iframe id='Frame_ApplyContent' name='Frame_ApplyContent' src="/Modules/<%=FI_ModuleId%>/Form_Apply_Content.jsp?FromAP=JFlow_FormFolder&OP=Check&FI_RecId=<%=FI_RecId%>&FD_RecId=<%=FD_RecId%>&OrgId=<%=OrgId%>" width="100%" height="100%" scrolling="yes" frameborder="0"  ></iframe></td>
    </tr>
    <tr>
    	  <td hieght="550" valign=top>
    	<%  
     Grid Grid=new Grid(pageContext); 
     Grid.Init();
     if(OP.equals("hasCheck")) 
     {
        	Grid.AddCol("<input type='button' value='列印' onclick='printPage();'>"," colspan=2 align=center");
   				Grid.AddRow("");//20110127已審核表單審核內容要加一個列印選項
   				Grid.AddCol("<input type=button name=cancle value='關閉視窗' onclick='top.close()'>"," colspan=2 align=center");
     }
     else
     {    Grid.AddCol("<input type=button name=cancle value='回上一頁' onclick='history.back()'>"," colspan=2 align=center");}
     Grid.Show();
     Grid=null;
%>
      </td>
    </tr>
</table>    
<%    
UI=null;
JOrg=null;
closeConn(Data,Conn);
%>
<iframe id='Frame_Print' name='Frame_Print' src='' style='width:0;height:0' frameborder=0></iframe>
<div style='display:none'>
    <script src='/Modules/JEIPKernel/JEIP_WebControl.js'></script>
    <script>
<%
//090429如果為以下的表單及關卡,則可修改 
if((FI_ModuleId.equals("JFlow_Form_188") && CurrStage==1) || (FI_ModuleId.equals("JFlow_Form_189") && CurrStage==1) ||
   (FI_ModuleId.equals("JFlow_Form_189") && CurrStage==2) || (FI_ModuleId.equals("JFlow_Form_190") && CurrStage==1))   
   {    
    session.setAttribute("OverApply",J_OrgId);
%>  
    var AContent=null;
    var CurrentStage='<%=CurrStage%>';    
    if(IsMozilla())
    {
        AContent =  window.document.all.Frame_ApplyContent.contentWindow;
    }
    else
        AContent =  Frame_ApplyContent;
    //呼叫對表單送出前的判斷function    
    function DataCheck(frm)
    {   
    		if(CurrentStage==1 && frm.CheckResult[0].checked)
        {
        	if(!AContent.OverApply_DataCheck1()) return false;
        }
    			
    		if(CurrentStage==2 && frm.CheckResult[0].checked)
        {
        	if(!AContent.OverApply_DataCheck2()) return false;
        }
    			
        if(CurrentStage==3 && frm.CheckResult[0].checked)
        {
        	if(!AContent.OverApply_DataCheck3()) return false;
        }
       
				if(CurrentStage==5 && frm.CheckResult[0].checked)
        {
        	if(!AContent.OverApply_DataCheck5()) return false;
        }
        
        if(CurrentStage==6 && frm.CheckResult[0].checked)
        {
        	if(!AContent.OverApply_DataCheck6()) return false;
        }
			 
			 
			 
			  
			  
			  
<%
 			if(FI_ModuleId.equals("JFlow_Form_78") || FI_ModuleId.equals("JFlow_Form_101") || FI_ModuleId.equals("JFlow_Form_111") || FI_ModuleId.equals("JFlow_Form_112") || FI_ModuleId.equals("JFlow_Form_115") ||FI_ModuleId.equals("JFlow_Form_154") || FI_ModuleId.equals("JFlow_Form_158")|| FI_ModuleId.equals("JFlow_Form_189"))
 			{
%>
				//退件
				
 				if(CurrentStage >=2 && frm.CheckResult[1].checked)
      	{
      		alert('此關卡審核結果不可為退件!');!frm.Command.focus();
        	return false;  	
      	}
      	
      	//退回上一關
      	
      	if((CurrentStage ==2 || CurrentStage ==5 || CurrentStage == 6) && frm.CheckResult[2].checked)
      	{
      		alert('此關卡審核結果不可退回上一關!');!frm.Command.focus();
        	return false;  	
      	}
      	
<%
      }
%>
  
//  
<%
 			if(FI_ModuleId.equals("JFlow_Form_122") || FI_ModuleId.equals("JFlow_Form_123"))
 			{
%>
				//退件
				
 				      	
      	//退回上一關
      	
      	if((CurrentStage ==4) && frm.CheckResult[2].checked)
      	{
      		alert('此關卡審核結果不可退回上一關!');!frm.Command.focus();
        	return false;  	
      	}
      	
<%
      }
%>
//
//|| FI_ModuleId.equals("JFlow_Form_154")
<%
 			if(FI_ModuleId.equals("JFlow_Form_148") )
 			{
%>
				//退件
				
 				
      	//退回上一關
      	
      	if(frm.CheckResult[2].checked)
      	{
      		alert('此表單關卡審核流程不可退回上一關!');!frm.Command.focus();
        	return false;  	
      	}
      	
<%
      }
%>

        
        if(!frm.CheckResult[0].checked && !frm.CheckResult[1].checked <%=((CurrStage>1 && BackForm.equals("1"))?" && !frm.CheckResult[2].checked":"")%>)
        {
            alert('請選擇您的審核結果!');frm.CheckResult[0].focus();
            return false;
        }
        if((frm.CheckResult[1].checked <%=((CurrStage>1 && BackForm.equals("1"))?" || frm.CheckResult[2].checked":"")%>) && frm.Command.value=='')
        {
            alert('如果審核結果為退件,請輸入不通過的原因!');!frm.Command.focus();
            return false;
        }
        
        Frame_ApplyContent.document.Frm.submit();
        frm.go.disabled=true;
        return false;
    }
    
    function SendSurvey()
    {
        Frm_Check.submit();
    }
   
<%
}
else
{    
    session.setAttribute("OverApply","");
%>
    function DataCheck(frm)
    {
        if(!frm.CheckResult[0].checked && !frm.CheckResult[1].checked <%=((CurrStage>1 && BackForm.equals("1"))?" && !frm.CheckResult[2].checked":"")%>)
        {
            alert('請選擇您的審核結果!');frm.CheckResult[0].focus();
            return false;
        }
        if((frm.CheckResult[1].checked <%=((CurrStage>1 && BackForm.equals("1"))?" && !frm.CheckResult[2].checked":"")%>) && frm.Command.value=='')
        {
            alert('如果審核結果為退件,請輸入不通過的原因!');!frm.Command.focus();
            return false;
        }
        frm.go.disabled=true;
        frm.cancle.disabled=true;
        return true;
    }
<%
}
%>

function printPage() {
if (window.print)
window.print()
else
alert("抱歉,你的瀏覽器列印格式被更改,無法列印此頁");
}	
   

function ViewApplyForm(FR_RecId,FI_RecId,FD_RecId,OrgId,OnlyView)
{    
    popDialog('ViewApplyForm','/Modules/JFlow_FormFolder/Form_Check_Content.jsp?OP=hasCheck&FR_RecId='+FR_RecId+'&FI_RecId='+FI_RecId+'&FD_RecId='+FD_RecId+'&OrgId='+OrgId+'&OnlyView='+OnlyView,screen.availWidth*0.8,600);      
}

function perViewStage(FI_RecId,FD_RecId,OrgId)
{
    popDialog('perViewStage','/Modules/JFlow_RuleWizard/Form_Apply_Finish.jsp?OP=View&FId='+FI_RecId+'&FDId='+FD_RecId+'&OrgId='+OrgId,screen.availWidth*0.8,400);      
}

<%=ItemScript%>
    </script>    
</div>
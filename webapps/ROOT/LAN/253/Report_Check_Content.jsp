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
OrgId=req("OrgId",request);  //??????
String MainDept=JOrg.getMainDepartmentIdByUser(OrgId);  //??????????????

CheckOrgId=req("CheckOrgId",request);
if(CheckOrgId.equals("")) CheckOrgId=J_OrgId;  //?f???H??
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
if(isPost(request) && !CheckResult.equals(""))  //?i?J?f??
{
    leeten.Alert JAlert=new leeten.Alert(Data,Conn);   
    Command=req("Command",request);
    
    //???????y?{?????f?????T
    SqlStr="select flow_form_rulestage.*,flow_formdata.FD_RecDate from flow_form_rulestage,flow_formdata  where flow_form_rulestage.FR_RecId="+Data.toSql(FR_RecId)+"  and flow_form_rulestage.FR_DataId="+Data.toSql(FD_RecId)+" and flow_form_rulestage.FR_DataId=flow_formdata.FD_RecId limit 1";    
    MRs=Data.getSmt(Conn,SqlStr);
    if(MRs.next())
    {
        FinishState=MRs.getString("FR_FinishState");
        ApplyOrgId=MRs.getString("FR_OrgId"); //??????ID
        ApplyDate=MRs.getDate("FD_RecDate").toString().replaceAll("-","/")+" "+MRs.getTime("FD_RecDate");
        FR_RuleId=MRs.getString("FR_RuleId");

            //???????W?h?D?????T:???????^???H??,?O?????T(?W?h?D??)
            SqlStr="select * from flow_ruleinfo where RI_RecId="+FR_RuleId+" limit 1";
            RRs=Data.getSmt(Conn,SqlStr);
            RRs.next();
            TTLRI_StageCount=RRs.getInt("RI_StageCount");
            RI_AlertDay=RRs.getString("RI_AlertDay");  //?O?_?n?O???q??,0?h????,???l???O??????
            RI_AlertToArr=RRs.getString("RI_AlertTo").split(";"); //?O???q???H??
            RI_AlertTo1=RI_AlertToArr[0];  //??????
            RI_AlertTo2=RI_AlertToArr[1];  //?f????
            RI_AlertTo3=RI_AlertToArr[2];  //?f???????????D??
            RI_AlertToMemberArr=RI_AlertToArr[3].split("#",2); //?S?w?H??
            RI_AlertTo4=RI_AlertToMemberArr[0];  //?O?_?????w?S?w?H??
            RI_AlertTo_Member=RI_AlertToMemberArr[1];  //?S?w?H??ID
            RI_ReturnTo=RRs.getString("RI_ReturnTo");  //?^???H??
            RRs.close();RRs=null;                    

    
        UnitManagerOrgId=JOrg.getMainDepartmentMangerInfoByUser(ApplyOrgId,"OrgId"); //???????????????D????OrgId
        if(UnitManagerOrgId.equals("")) UnitManagerOrgId="0";  //???????H,?h????Pass        
        ManagerOrgId=JOrg.getDepartmentMangerId(JOrg.getMainDepartmentInfoByUser(ApplyOrgId,"ParentOrg")); //???????????????D????OrgId
        if(ManagerOrgId.equals("")) ManagerOrgId="0";  //???????H,?h????Pass
        CurrStage=getCurrStage(MRs,TTLRI_StageCount)+1; //???d?f???????X???F
        MRs.close();MRs=null;  
     }
     if(FinishState.equals("0"))
     {
        NextStage=CurrStage+1;    
        ApplyName=JOrg.getOrgName(ApplyOrgId);    
        //???????W?h???????T,???|?H??,?????q?L??,?h?oMail???|,???g?J???|?H??????,?H?K?d?\
        SqlStr="select * from flow_rulestage where RS_RuleId ="+FR_RuleId+" limit 1";
        FSRs=Data.getSmt(Conn,SqlStr);
        FSRs.next();          
        From=SysCore.getSysVar("PortalAdminEMail");    
        //?????P?_?O?_?C?????O?]?w???????p???f?????h????Pass,?B?u???@?H?????p,?p?C?????O???????P?f????,?h?|????Pass???????@???????p
        //?p?G???d?L?H,?]?|????Pass
        while(isPass)
        {   
            ApplyIsSurvey=false;isOnlyOneSurvey=false;hasNextStage=false;isPass=false;      
            SqlStr="select * from flow_form_rulestage  where FR_RecId="+Data.toSql(FR_RecId)+" and FR_FinishState=0 limit 1";    
            Rs=Data.getSmt(Conn,SqlStr);
            Rs.next();
            FR_Stage_State=Rs.getString("FR_Stage"+CurrStage+"_State");  //???????f?????A,????:0;,5,29,  0?????q?L,1???q?L
            //????: ?O?_?q?L;;,?f???H??,?N?z?H,???z??,;;?N??;;????##
            FR_Stage_Survey=Rs.getString("FR_Stage"+CurrStage+"_Survey");  //???????e???f?????e     
            NextState=Rs.getString("FR_Stage"+NextStage+"_State");  //?U???f???H?????T
            Rs.close();Rs=null;
            //???????????|?H??, 2:?S?w?H?? 3:?????D??  1:???????|    
            //Property????: [0]?f???H??;[1]???|?H??;[2]?O?_Pass,?p?f???H?????S?w?H??,?h RS_Stage_Survey ???S?w?H????ORG,?????? ,OrgId,;
            //[3]????-???v????;[4]???A-????;[5]?S?w-1And_2Or
            PropertyArr=(FSRs.getString("RS_Stage"+CurrStage+"_Property")+";;;;").split(";",7);
            switch(Integer.parseInt(PropertyArr[1]))
            {
                case 1:  //???????|
                    FR_Stage_Foward="";
                    break;
                case 2:  //???|?S?w?H??
                    FR_Stage_Foward=FSRs.getString("RS_Stage"+CurrStage+"_Foward");  //?e?????r??
                    break;
                case 3:  //???|?????D??
                    FR_Stage_Foward=","+ManagerOrgId+",";  //?e?????r??
                    break;
            }

            //????->?f?????A;;,?f????,?N?f????,???z??,;;?N??;;?f??????##
            //???[???????e???f?????e(?P?@???i?????h?H?f??);?p???N?z?f???????z???f??,?????N???f?????s?J
            if(FR_Stage_Survey.indexOf("1;;,"+ApplyOrgId+",")<0) //?????w???f??????,?????[
                FR_Stage_Survey+=CheckResult+";;,"+CheckOrgId+","+AgentOrgId+","+AdminOrgId+",;;"+Command+";;"+JDate.Now()+"##";
            String TmpArr[]=FR_Stage_State.split(";"); //???????f?????A,????:0;,5,29,  0?????q?L,1???q?L
            String SurveyArr[]=TmpArr[1].split(","); //???????f????,?i???|???h??
            isSuccess=true;  //?w?]???????????f???????w?f???L
            if(!TmpArr[1].equals(",0,")) //?p?G???f???H??,??????Pass
            {
                for(int i_survey=0;i_survey<SurveyArr.length;i_survey++)
                {
                    if(!SurveyArr[i_survey].equals(""))  //?f????????????,?]?? ,3, ?z?Lsplit??,?}?C0?P?}?C2,?|?O????
                    {
                        if(FR_Stage_Survey.indexOf("1;;,"+SurveyArr[i_survey]+",")==-1) //???d?f?????O?_?w?f???L,???@???@?????d
                        {
                            isSuccess=false;  //???@???S?f???L,?h?????????|???????q?L.
                            break;
                        }
                    }
                }
           }
            //?p?G?O?S?w?H??,?B?]??OR,?h?]???????q?L
           if(PropertyArr[0].equals("2") && PropertyArr[5].equals("2")) isSuccess=true;
            //?R?????????f?????O???q??????(?p?G?O?N?f,???O?n?R????Alert?H??.        
            JAlert.DeleteAlert_By_APRecId_AlertTo(Integer.parseInt(FD_RecId),Integer.parseInt(CheckOrgId)); //?u?R?????f??????Alert

            //?O?_???U?@?? ===========================================================================================================
            //???????W?h?U?@?????f???H??,?H?K?????????q?L,?h?i?H?oMail?q???U?@???f????     
            String RS_Stage_Property="";
            String RS_Stage_Survey="";  //?U?@?????f???H??        

            if(NextStage<=TTLRI_StageCount) //?O?_???U?@??
            {
                hasNextStage=true;    
                if(NextState.equals("")) //?U?@???L?f???H??,?h???W?h???f???H??.
                {
                    //Property????: ?f???H??;???|?H??;?O?_Pass,?p?f???H?????S?w?H??,?h RS_Stage_Survey ???S?w?H????ORG,?????? ,OrgId,
                    // 2:?S?w?H??   3:?????D??   4:????    5:???A?f??
                    RS_Stage_Property=FSRs.getString("RS_Stage"+NextStage+"_Property");        
                    RS_Stage_Survey=FSRs.getString("RS_Stage"+NextStage+"_Survey");           
                    PropertyArr=(RS_Stage_Property+";;;;").split(";",7); //???d?O?_???????????????f????,?h?U?@??????Pass?\??
                   /* if(RS_Stage_Property.startsWith("5;")) //?????????A?f??
                    {        
                        if(Org_SurveyOrgId.equals(""))  //?S???????f???H??
                        {
                            if(!RS_Stage_Survey.equals("")) 
                            {
                                OrgStr=RS_Stage_Survey;  //???????w?]?f????,???e???r??
                                SurveyOrgId=RS_Stage_Survey.substring(1,RS_Stage_Survey.length()-1);  //?oMail???H?h?e??????
                                SendToStr=SurveyOrgId;  //?]?w??SendTo
                            }
                            else
                            {
                                SendToStr="";
                                OrgStr=",0,";  //?L?]?w?w?]?f???H??,????Pass
                            }
                        }
                        else
                        {
                            OrgStr=","+Org_SurveyOrgId+",";  //???????f????,???e???r??
                            SurveyOrgId=Org_SurveyOrgId;  //?oMail???H?h?e??????
                            SendToStr=SurveyOrgId;  //?]?w??SendTo
                        }
                    }            
                    else */if(RS_Stage_Property.startsWith("2;")) //?S?w?H??(?i???|???h??,??????:,3,16,5,)
                    {            
                        if(!RS_Stage_Survey.equals("")) OrgStr=RS_Stage_Survey;    //OrgStr???U?@?????f????,?e?????r??
                        //?O?_?U?@???u???@???H?f??
                        if(RS_Stage_Survey.substring(1,RS_Stage_Survey.length()-1).split(",").length==1) isOnlyOneSurvey=true;
                    }
                    else if(RS_Stage_Property.startsWith("3;")) //?????D??
                    {            
                        OrgStr=","+UnitManagerOrgId+",";   //OrgStr???U?@?????f????,?e?????r??,?p?G?O,0,???????H,?h????Pass
                        isOnlyOneSurvey=true;  //?????D???????u???@?H?f??
                    }        
                    else if(RS_Stage_Property.startsWith("6;")) //?????D??
                    {            
                        OrgStr=","+ManagerOrgId+",";   //OrgStr???U?@?????f????,?e?????r??,?p?G?O,0,???????H,?h????Pass
                        isOnlyOneSurvey=true;  //?????D???????u???@?H?f??
                    }                        
                    else if(RS_Stage_Property.startsWith("4#")) //????(?i???|???h??,??????:,3,16,5,)
                    {            
                        String RuleArr[]=PropertyArr[0].split("#");
                        if(!RS_Stage_Survey.equals("")) //???]?w????
                        {
                            String DeptArr[]=RS_Stage_Survey.substring(1,RS_Stage_Survey.length()-1).split(",");
                            for(int d=0;d<DeptArr.length;d++)
                            {
                                //???D?n????
                                SqlStr="select org.* from orgmb,org where orgmb.DepartmentId="+DeptArr[d]+" and orgmb.OrgId=org.orgid and orgmb.isMain=1 and org.JobTitle="+RuleArr[1]+" limit 1";
                                TmpRs=Data.getSmt(Conn,SqlStr);
                                if(TmpRs.next()) OrgStr+=TmpRs.getString("OrgId")+",";  
                                TmpRs.close();TmpRs=null;
                            }                
                        }    
                        else //????????????????????
                        {
                            SqlStr="select * from org where Department="+MainDept+" and JobTitle="+RuleArr[1]+" limit 1";
                            TmpRs=Data.getSmt(Conn,SqlStr);
                            if(TmpRs.next()) OrgStr=TmpRs.getString("OrgId")+","; 
                            TmpRs.close();TmpRs=null;
                        }
                        if(!OrgStr.equals(""))
                        {
                            OrgStr=","+OrgStr; //OrgStr???U?@?????f????,?e?????r??
                            //?O?_?U?@???u???@???H?f??                
                            if(OrgStr.substring(1,OrgStr.length()-1).split(",").length==1) isOnlyOneSurvey=true;
                        }
                        else
                        {
                            OrgStr=",0,";
                        }
                    }            
                }
                else
                {  //???X?U?????f???H??
                    OrgStr=NextState.substring(2);
                }
                if(PropertyArr[2].equals("1")) //???d???????O?_?]?t???f????,???h?g?J?w?f???O??,?o?????v?N?????f???v
                {
                    if(OrgStr.indexOf(","+ApplyOrgId+",")>-1) 
                        ApplyIsSurvey=true;  //?U?@??????????,?Y???f???H??
                    else
                        ApplyIsSurvey=false;
                }
            }        
           // System.out.println("OrgStr->"+OrgStr+":ApplyIsSurvey->"+ApplyIsSurvey+":isOnlyOneSurvey->"+":"+isOnlyOneSurvey);

            SqlStr="select * from flow_form_rulestage  where FR_RecId="+Data.toSql(FR_RecId)+" and FR_FinishState=0 limit 1";    
            Rs=Data.getSmt(Conn,SqlStr);
            Rs.next();

            if(isSuccess) //?????????q?L
            {
                JAlert.DeleteAlertByFromAP_RecId(FD_RecId); //?R?????????????O???q??????(??????,?f????,?????D??or????)
                FR_Stage_State=Data.Replace(FR_Stage_State,"0;,","1;,");   //?]?w???????A?q?L     
            }   
            Rs.updateString("FR_Stage"+CurrStage+"_State",FR_Stage_State);  
            //?p?G???????O?W?@???g?J??????Pass,?h?N?f???O???g?J
            if(!FR_Stage_State.equals("1;,0,")) Rs.updateString("FR_Stage"+CurrStage+"_Survey",FR_Stage_Survey);
            if(isSuccess)  //?????????????f???q?L,?h?N???|?H???x?s,???oMail?q??
            {
                Rs.updateString("FR_Stage"+CurrStage+"_Foward",FR_Stage_Foward);
                Rs.updateString("FR_FinishTime",JDate.Now());
            }

            if(isSuccess && hasNextStage) //???????f???????q?L,?B???U?@??
            {   
                if(ApplyIsSurvey) //?????????????Y???f????,?B?U?@??????????,?Y???f???H??,?h?????f??
                {
                    if(isOnlyOneSurvey) 
                    {   //?g?J?U?@?????f???H??,???????f???q?L
                        Rs.updateString("FR_Stage"+(CurrStage+1)+"_State","1;"+OrgStr);  
                        isPass=true;
                    }
                    else  //?N???v?g?J?U?@?????f????,???U?@?????h?H?f,?B?????H?????f??,?f???H???|???h?????i??,?????? 1;,1,4,
                    {   
                        if(OrgStr.equals(",0,"))  //?p?G???????f???H??,?h????Pass
                        {    Rs.updateString("FR_Stage"+(CurrStage+1)+"_State","1;"+OrgStr);isPass=true;}
                        else
                        {    Rs.updateString("FR_Stage"+(CurrStage+1)+"_State","0;"+OrgStr);}
                    }
                    //???w?N?O?U?@?????f????,?h?N???v?g?J?U?@?????f?????T
                    Command="??:?????????f????,????PASS.";
                    FR_Stage_Survey="1;;,"+ApplyOrgId+",,,;;"+Command+";;"+JDate.Now()+"##";
                    Rs.updateString("FR_Stage"+(CurrStage+1)+"_Survey",FR_Stage_Survey); //?g?J???????f???????e            
                }
                else    
                {     
                    if(OrgStr.equals(",0,"))  //???????f???H??,?h????Pass                                                   
                    {
                        Command="??:???????????f???H??,????PASS.";
                        FR_Stage_Survey="1;;,0,,,;;"+Command+";;"+JDate.Now()+"##";  
                        FR_Stage_State="1;"+OrgStr; 
                        Rs.updateString("FR_Stage"+(CurrStage+1)+"_State",FR_Stage_State);
                        Rs.updateString("FR_Stage"+(CurrStage+1)+"_Survey",FR_Stage_Survey); //?g?J???????f???????e   
                        isPass=true;}
                    else
                    {   Rs.updateString("FR_Stage"+(CurrStage+1)+"_State","0;"+OrgStr);}  //?g?J?U?@?????f???H??,?f???H???|???h?????i??,?????? 0;,1,4,                            
                }
            }
            else if(isSuccess && !hasNextStage) //???q?L,?B?S???U?@??
            {        
                Rs.updateInt("FR_FinishState",1);  //?L?U?@??,?h?????????A?]???f???q?L 
                //?N?^???H???g?J,???oMail?q???^???H??        
                String RI_ReturnToArr[]=RI_ReturnTo.split(";");
                if(RI_ReturnToArr[0].equals("1")) //??????
                    ReturnOrgStr=","+ApplyOrgId;
                if(RI_ReturnToArr[1].equals("1")) //?????D??       
                    ReturnOrgStr+=","+UnitManagerOrgId;

                String RI_ReturnToMemberArr[]=RI_ReturnToArr[2].split("#",2);  //???d?^???O?_???S?w?H??
                if(RI_ReturnToMemberArr[0].equals("1")) //?S?w?H??
                {
                    ReturnOrgStr+=RI_ReturnToMemberArr[1];
                }
                if(!ReturnOrgStr.endsWith(",")) ReturnOrgStr+=",";
                Rs.updateString("FR_ReturnTo",ReturnOrgStr);            
            }

            if(CheckResult.equals("0")) //???q?L,??Mail?q????????
            {
                Rs.updateInt("FR_FinishState",2);  //?h?????????A?]???f?????q?L  
                Rs.updateString("FR_FinishTime",JDate.Now());            
            }    
            else if(CheckResult.equals("2")) //?h???W?@??
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

            //##### ????WebProcedure ##########################################################################################################333
            if(isSuccess && !hasNextStage) //???q?L,?B?S???U?@??,?????????????B?z????
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

            // ?H?U???o?eMail ============================================================================================================
            if(isSuccess && !FR_Stage_Foward.equals(""))  //?q?????|?H??
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
                MailContent=Data.Replace(MailContent,"{Subject}",PortalTitle+"-???????|?q??");            
                MailContent=Data.Replace(MailContent,"{Body}","<table><tr><td><font color=#0000ff>????????:</font></td><td>"+FormName+"</td></tr><tr><td valign=top><font color=#0000ff>??????:</font></td><td>"+JOrg.getOrgName(OrgId)+"</td></tr><tr><td valign=top><font color=#0000ff>????????:</font></td><td>"+ApplyDate+"</td></tr><tr><td colspan=2 ><br><br>???????w?q?L??&nbsp;"+CurrStage+"&nbsp;??.</font></td></tr><tr><td colspan=2 ><br><br><a href='"+PortalModuleLink+"'><font color=#ff0000>?????????????X,??????????.</font></a></font></td></tr></table>");

                if(To.length()!=0) HttpCore.SendMail(From,To,PortalTitle+"-???????|?q??",MailContent);
            }

            if(isSuccess && hasNextStage) //???q?L,?B???U?@??,?h?o?H?q???U?@???f???H??
            {         
                if(!isPass) //?p?G?S??????Pass???U?@??,?????????????????H?n?f
                {               
                    To="";ToName="";
                    SqlStr="select Org.OrgId,Org.OrgName,Org.EMail from Org where OrgId in ("+OrgStr.substring(1,OrgStr.length()-1)+") ";            
                    Rs=Data.getSmt(Conn,SqlStr);
                    while(Rs.next())
                    {            
                        if(ApplyIsSurvey && !ApplyOrgId.equals("OrgId")) //?????????????Y???f????,?B?U?@??????????,?Y???f???H??,?h???oMail
                        {
                            ToName+=Rs.getString("OrgName")+"<br>";
                            To+=Rs.getString("EMail")+"##";        
                        }
                    }
                    Rs.close();Rs=null;   
                    String PortalTitle=SysCore.getApplication("PortalTitle");    
                    String MailContent=FileMgr.ReadFile(SysRootPath+"Modules"+Separator+"JEIPKernel"+Separator+"Mail.txt","big5");    
                    MailContent=Data.Replace(MailContent,"{PortalTitle}",PortalTitle);    
                    MailContent=Data.Replace(MailContent,"{Subject}",PortalTitle+"-?????f???q??");            
                    MailContent=Data.Replace(MailContent,"{Body}","<table><tr><td><font color=#0000ff>????????:</font></td><td>"+FormName+"</td></tr><tr><td valign=top><font color=#0000ff>??????:</font></td><td>"+JOrg.getOrgName(OrgId)+"</td></tr><tr><td valign=top><font color=#0000ff>????????:</font></td><td>"+ApplyDate+"</td></tr><tr><td colspan=2 ><br><br>?????????e?w????&nbsp;"+NextStage+"&nbsp;??,???n?z???f??!</font></td></tr><tr><td colspan=2 ><br><br><a href='"+PortalModuleLink+"'><font color=#ff0000>?????????????X,??????????.</font></a></font></td></tr></table>");
                    if(To.length()!=0) HttpCore.SendMail(From,To,PortalTitle+"-?????f???q??",MailContent);

                    // ?H?U???O???B?z ============================================================================================================
                    //?g?JAlertSchedule,?p?G?O??,?h?q??
                    ProcessAlert(SysCurrModuleId,FD_RecId,ApplyOrgId,PortalTitle,MailContent,FormName,ApplyName,ApplyDate,PortalLink,OrgStr,TTLRI_StageCount,RI_AlertDay,RI_AlertToArr,JDate,JOrg,Data,Conn);
                }
            }
            //?p?G?????f?????U?@??,?h?N?U?@?????f?????T?]??????;
            if(isPass) {CurrStage++;NextStage=CurrStage+1;}
        }
        FSRs.close();FSRs=null;        


        if(isSuccess && !hasNextStage && !ReturnOrgStr.equals("")) //???q?L,?S?B???U?@??,?h?o?H?q???^???H??
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
            MailContent=Data.Replace(MailContent,"{Subject}",PortalTitle+"-?????^???q??");            
            MailContent=Data.Replace(MailContent,"{Body}","<table><tr><td><font color=#0000ff>????????:</font></td><td>"+FormName+"</td></tr><tr><td valign=top><font color=#0000ff>??????:</font></td><td>"+JOrg.getOrgName(OrgId)+"</td></tr><tr><td valign=top><font color=#0000ff>????????:</font></td><td>"+ApplyDate+"</td></tr><tr><td colspan=2 ><br><br>???????????????????w?g?q?L.</font></td></tr><tr><td colspan=2 ><br><br><a href='"+PortalModuleLink+"'><font color=#ff0000>?????????????X,??????????.</font></a></font></td></tr></table>");

            if(To.length()!=0) HttpCore.SendMail(From,To,PortalTitle+"-?????^???q??",MailContent);
        }

        if(CheckResult.equals("0")) //???q?L,??Mail?q????????
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
            MailContent=Data.Replace(MailContent,"{Subject}",PortalTitle+"-?????f?????q?L?q??");            
            MailContent=Data.Replace(MailContent,"{Body}","<table><tr><td><font color=#0000ff>????????:</font></td><td>"+FormName+"</td></tr><tr><td valign=top><font color=#0000ff>??????:</font></td><td>"+JOrg.getOrgName(OrgId)+"</td></tr><tr><td valign=top><font color=#0000ff>????????:</font></td><td>"+ApplyDate+"</td></tr><tr><td colspan=2 ><br><br>???????????????????Q?h??,???]?p?U.</font></td></tr><tr><td colspan=2 ><br><br>"+Command.replaceAll("\n","<br>")+"<br><br><a href='"+PortalLink+"/?ModuleId=JFlow_AllFormTracert'><font color=#ff0000>?????????l??,??????????.</font></a></font></td></tr></table>");

            if(To.length()!=0) HttpCore.SendMail(From,To,PortalTitle+"-?????f?????q?L?q??",MailContent);
        }
        //?p?G?O???z???N?f,?h???O?q???????C?????o??,?h?n?A???^?h
        if(!AdminOrgId.equals(""))
            response.sendRedirect("/Modules/JFlow_FormQueue/Form_QueueList.jsp?OP=ReloadTree");   
        else if(req("FromAP",request).equals("FormApply")) //?q???????L????
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
//Mail????===================================================================================
//===================================================================================


if(OP.equals("Foward"))
{
    SqlStr="select * from flow_form_rulestage where FR_RecId="+Data.toSql(FR_RecId)+" and FR_DataId="+Data.toSql(FD_RecId)+" limit 1";    
    TmpRs=Data.getSmt(Conn,SqlStr);
    TmpRs.next();
    
    ApplyOrgId=TmpRs.getString("FR_OrgId");
    
    //???????W?h????
    SqlStr="select * from flow_ruleinfo where RI_RecId="+TmpRs.getString("FR_RuleId")+" limit 1";
    RRs=Data.getSmt(Conn,SqlStr);
    RRs.next();
    TTLRI_StageCount=RRs.getInt("RI_StageCount");
    RRs.close();RRs=null;
    
    //???d?C?@???O?_?????|?O??,???h???s    
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

if(OP.equals("Back"))  //?h??,?]?w?w????
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

//?????????????W?h??????
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
        ReApplyFunction="&nbsp;&nbsp;&nbsp;<font color=#ff0000>?????h???????s????????:</font><input type=button value='?????W?????????e' onclick='ViewApplyForm("+TmpRs.getString("FR_RecId")+","+TmpRs.getString("FR_FormId")+","+TmpRs.getString("FR_DataId")+","+TmpRs.getString("FR_OrgId")+",1)'>&nbsp;<input type=button value='?????W???????y??'  onclick='perViewStage("+TmpRs.getString("FR_FormId")+","+TmpRs.getString("FR_DataId")+","+TmpRs.getString("FR_OrgId")+")'>";
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
        	Grid.AddCol("<input type='button' value='?C?L' onclick='printPage();'>"," colspan=2 align=center");
   				Grid.AddRow("");//20110127?w?f???????f?????e?n?[?@???C?L????
   				Grid.AddCol("<input type=button name=cancle value='????????' onclick='top.close()'>"," colspan=2 align=center");
     }
     else
     {    Grid.AddCol("<input type=button name=cancle value='?^?W?@??' onclick='history.back()'>"," colspan=2 align=center");}
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
//090429?p?G???H?U???????????d,?h?i???? 
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
    //?I?s???????e?X?e???P?_function    
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
				//?h??
				
 				if(CurrentStage >=2 && frm.CheckResult[1].checked)
      	{
      		alert('?????d?f?????G???i???h??!');!frm.Command.focus();
        	return false;  	
      	}
      	
      	//?h?^?W?@??
      	
      	if((CurrentStage ==2 || CurrentStage ==5 || CurrentStage == 6) && frm.CheckResult[2].checked)
      	{
      		alert('?????d?f?????G???i?h?^?W?@??!');!frm.Command.focus();
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
				//?h??
				
 				      	
      	//?h?^?W?@??
      	
      	if((CurrentStage ==4) && frm.CheckResult[2].checked)
      	{
      		alert('?????d?f?????G???i?h?^?W?@??!');!frm.Command.focus();
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
				//?h??
				
 				
      	//?h?^?W?@??
      	
      	if(frm.CheckResult[2].checked)
      	{
      		alert('?????????d?f???y?{???i?h?^?W?@??!');!frm.Command.focus();
        	return false;  	
      	}
      	
<%
      }
%>

        
        if(!frm.CheckResult[0].checked && !frm.CheckResult[1].checked <%=((CurrStage>1 && BackForm.equals("1"))?" && !frm.CheckResult[2].checked":"")%>)
        {
            alert('???????z???f?????G!');frm.CheckResult[0].focus();
            return false;
        }
        if((frm.CheckResult[1].checked <%=((CurrStage>1 && BackForm.equals("1"))?" || frm.CheckResult[2].checked":"")%>) && frm.Command.value=='')
        {
            alert('?p?G?f?????G???h??,?????J???q?L?????]!');!frm.Command.focus();
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
            alert('???????z???f?????G!');frm.CheckResult[0].focus();
            return false;
        }
        if((frm.CheckResult[1].checked <%=((CurrStage>1 && BackForm.equals("1"))?" && !frm.CheckResult[2].checked":"")%>) && frm.Command.value=='')
        {
            alert('?p?G?f?????G???h??,?????J???q?L?????]!');!frm.Command.focus();
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
alert("???p,?A???s?????C?L?????Q????,?L?k?C?L????");
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
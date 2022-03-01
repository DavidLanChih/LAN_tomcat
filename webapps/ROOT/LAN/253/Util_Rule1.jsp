<%@ page pageEncoding="MS950"%><%@ page  import="java.util.*" %><%@ page  import="java.sql.*" %>
<%!
public int getCurrStage(ResultSet tmpRs)  throws Exception
{
    return getCurrStage(tmpRs,0);
}   
   
public int getCurrStage(ResultSet tmpRs,int TTLRI_StageCount)  throws Exception
{
        tmpRs.beforeFirst();
        int i=0;
        if(tmpRs.next())
        {           
            if(TTLRI_StageCount==0) TTLRI_StageCount=tmpRs.getInt("RI_StageCount"); //此規則關數
            //檢查審核到第幾關了
            for(i=0;i<TTLRI_StageCount;i++)
            {
                if(tmpRs.getString("FR_Stage"+(i+1)+"_State").indexOf("0;")>-1)
                {
                    break;
                }
            }
        }
        return i;
}
public int getCurrStageByRsRecord(ResultSet tmpRs)  throws Exception
{        
        int i=0;   
        //檢查審核到第幾關了
        for(i=0;i<19;i++)
        {
            if(tmpRs.getString("FR_Stage"+(i+1)+"_State").indexOf("0;")>-1)
            {
                break;
            }
        }        
        return i;
}

public int getCurrStage_ByRuleStageId(Connection Conn,leeten.DataBean Data,String FR_RecId)  throws Exception
{
    ResultSet tmpRs=null;    
    tmpRs=Data.getSmt(Conn,"select flow_form_rulestage.*,flow_ruleinfo.RI_StageCount from flow_form_rulestage,flow_ruleinfo where flow_form_rulestage.FR_RecId="+Data.toSql(FR_RecId)+" and flow_form_rulestage.FR_FinishState=0 and flow_form_rulestage.FR_RuleId=flow_ruleinfo.RI_RecId limit 1");
    int Stage=getCurrStage(tmpRs);
    tmpRs.close();tmpRs=null;
    return Stage;
}


public int getCurrStage_ByDataId(Connection Conn,leeten.DataBean Data,String FD_RecId)  throws Exception
{
    ResultSet tmpRs=null;    
    tmpRs=Data.getSmt(Conn,"select flow_form_rulestage.*,flow_ruleinfo.RI_StageCount from flow_form_rulestage,flow_ruleinfo where flow_form_rulestage.FR_DataId="+Data.toSql(FD_RecId)+" and flow_form_rulestage.FR_FinishState=0 and flow_form_rulestage.FR_RuleId=flow_ruleinfo.RI_RecId limit 1");
    int Stage=getCurrStage(tmpRs);
    tmpRs.close();tmpRs=null;
    return Stage;
}

public int getFormState_ByDataId(Connection Conn,leeten.DataBean Data,String FD_RecId)  throws Exception
{
    ResultSet tmpRs=null;    
    tmpRs=Data.getSmt(Conn,"select * from flow_form_rulestage where FR_DataId="+Data.toSql(FD_RecId)+" limit 1");    
    tmpRs.next();
    int Result=tmpRs.getInt("FR_FinishState");
    tmpRs.close();tmpRs=null;
    return Result;
}

public String getAgentOwnerByOrgId(Connection Conn,leeten.DataBean Data,String OrgId) throws Exception
{
    ResultSet tmpRs=Data.getSmt(Conn,"select * from Org where AgentOrg="+OrgId);
    String AgentStr="";
    while(tmpRs.next())
    {
        AgentStr+=tmpRs.getString("OrgId")+",";
    }
    tmpRs.close();tmpRs=null;
    return AgentStr;
}

//讀取審核記錄
    //讀取審核人員
public String getSurveyLog(Connection Conn,leeten.DataBean Data,String OrgId,String FI_RecId,String FD_RecId) throws Exception  
{           
    Set<String> set = new TreeSet<String>();
    leeten.Date JDate=new leeten.Date();
    leeten.Org JOrg=new leeten.Org(Data,Conn);
    String StageSurveyStr="",TmpStr="",RS_Stage_Property="",ReallySurveyOrgId="",SurveyName="",RS_Stage_Survey="",FR_Stage_Survey="",SurveyStrArr[]=null,SurveyDetailArr[]=null;
    String UserTitle="",SurveyType="",ReasonStr="",SurveyTime="",SurveyItemArr[]=null,PropertyArr[]=null;
	//權限更改(王20190513)(申請內容)
    String SqlStr="select * from flow_form_rulestage,flow_ruleinfo where  flow_form_rulestage.FR_FormId="+Data.toSql(FI_RecId)+" and flow_form_rulestage.FR_DataId="+Data.toSql(FD_RecId)+" and flow_form_rulestage.FR_RuleId=flow_ruleinfo.RI_RecId limit 1"; 
	//String SqlStr="select * from flow_form_rulestage,flow_ruleinfo where flow_form_rulestage.FR_OrgId="+OrgId+" and flow_form_rulestage.FR_FormId="+Data.toSql(FI_RecId)+" and flow_form_rulestage.FR_DataId="+Data.toSql(FD_RecId)+" and flow_form_rulestage.FR_RuleId=flow_ruleinfo.RI_RecId limit 1"; 
	ResultSet RRs=Data.getSmt(Conn,SqlStr);
    RRs.next();
    int TTLRI_StageCount=RRs.getInt("RI_StageCount");   

   // SqlStr="select * from flow_rulestage where RS_RuleId="+RRs.getString("FR_RuleId")+" limit 1";
   // ResultSet SRs=Data.getSmt(Conn,SqlStr);
   // SRs.next();
    for(int i=0;i<TTLRI_StageCount;i++)
    {
        //取出原關卡審核資訊
       // PropertyArr=SRs.getString("RS_Stage"+(i+1)+"_Property").split(";");
      //  RS_Stage_Property=PropertyArr[0]; //審核人員 ,2:特定人員 3:單位主管 4#:角色  5:動態審核  6:部門主管
        
       /* if(RRs.getString("FR_Stage"+(i+1)+"_State").equals("")) //以規則定的為主
            if(RS_Stage_Property.equals("2"))
                RS_Stage_Survey=SRs.getString("RS_Stage"+(i+1)+"_Survey"); //特定人員
            //else
                //RS_Stage_Survey=","+JOrg.getMainDepartmentMangerInfoByUser(OrgId,"OrgId")+",";   //部門主管Id
        else
            RS_Stage_Survey=RRs.getString("FR_Stage"+(i+1)+"_State").split(";",2)[1]; //以寫入的審核人員為主 
        if(RS_Stage_Survey.equals(",") || RS_Stage_Survey.equals("")) RS_Stage_Survey="0";        
        else RS_Stage_Survey=RS_Stage_Survey.substring(1,RS_Stage_Survey.length()-1); //將前後逗號去掉
        */
        FR_Stage_Survey=RRs.getString("FR_Stage"+(i+1)+"_Survey");                
                           
        if(!FR_Stage_Survey.equals(""))
        {            
            SurveyStrArr=FR_Stage_Survey.split("##"); //每關的所有已審核人員                 
            for(int k=0;k<SurveyStrArr.length;k++)
            {   
                ReallySurveyOrgId="";
                UserTitle="";SurveyType="";
                ReasonStr="";SurveyTime="";

                SurveyItemArr=SurveyStrArr[k].split(";;",4);  //0:審核狀態  1:審核人員分佈   2:審核意見   3:審核時間                  
                SurveyDetailArr=SurveyItemArr[1].substring(1,SurveyItemArr[1].length()).split(",",4);   //0:審核者  1:代理人  2:管理者代審 

                ReasonStr=SurveyItemArr[2];  //審核意見
                SurveyTime=SurveyItemArr[3];  //審核時間   
                if(SurveyDetailArr[1].equals("") && SurveyDetailArr[2].equals("")) ReallySurveyOrgId=SurveyDetailArr[0]; //表示由審核者審核此表單
                if(!SurveyDetailArr[1].equals("")) //表示由代理人審核
                {
                    ReallySurveyOrgId=SurveyDetailArr[1];  
                    SurveyType="&nbsp;(<font color=#0000ff>代理人</font>)";
                }                             
                if(!SurveyDetailArr[2].equals("")) //表示有表單佇列功能的人代審
                {
                    ReallySurveyOrgId=SurveyDetailArr[2];              
		    SurveyType="&nbsp;(<font color=#0000ff>代審</font>)";
                }                              
                
                if(ReallySurveyOrgId.equals("0")) SurveyType="&nbsp;(<font color=#0000ff>系統審核</font>)";
                
                if(SurveyItemArr[0].equals("1"))  //審核通過
                {   
		    if(!ReasonStr.equals("") && !ReallySurveyOrgId.equals("0")) ReasonStr="&nbsp;&nbsp;&nbsp;意見:"+ReasonStr+"";
                    else ReasonStr="&nbsp;&nbsp;&nbsp;"+ReasonStr+"";
                    ReasonStr="通過"+ReasonStr;
                }
                else if(SurveyItemArr[0].equals("2"))  //退件至上一層
                {
		    ReasonStr="退件至上一層&nbsp;&nbsp;&nbsp;意見:"+ReasonStr+"";                    
                }                                           
                else if(SurveyItemArr[0].equals("3"))  //通過但被退
                {
		    ReasonStr="通過,但被上一層退回&nbsp;&nbsp;&nbsp;"+ReasonStr+"";                    
                }                        
                
                if(!ReallySurveyOrgId.equals("0"))
                {
                    UserTitle=JOrg.getUserTitle(ReallySurveyOrgId);
                    SurveyName=JOrg.getOrgInfo(ReallySurveyOrgId,"OrgName")+SurveyType;
                }
                else
                {
                    UserTitle=" ";SurveyName=SurveyType;
                }
                TmpStr="<div>"+(i+1)+"."+JDate.format(JDate.CDateTime(SurveyTime),"yyyy/MM/dd HH:mm:ss")+(UserTitle.equals("")?"未定義":UserTitle)+"&nbsp;"+SurveyName+"&nbsp;"+ReasonStr+"</div>";                
                set.add(TmpStr);
            }  
        }                
    }
   // SRs.close();SRs=null;
    RRs.close();RRs=null;
    Iterator iterator = set.iterator();
    while(iterator.hasNext()) {
        StageSurveyStr+=iterator.next();
    }    
    return StageSurveyStr;
}    
%>
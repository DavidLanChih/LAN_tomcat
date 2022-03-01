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
            if(TTLRI_StageCount==0) TTLRI_StageCount=tmpRs.getInt("RI_StageCount"); //���W�h����
            //�ˬd�f�֨�ĴX���F
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
        //�ˬd�f�֨�ĴX���F
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

//Ū���f�ְO��
    //Ū���f�֤H��
public String getSurveyLog(Connection Conn,leeten.DataBean Data,String OrgId,String FI_RecId,String FD_RecId) throws Exception  
{           
    Set<String> set = new TreeSet<String>();
    leeten.Date JDate=new leeten.Date();
    leeten.Org JOrg=new leeten.Org(Data,Conn);
    String StageSurveyStr="",TmpStr="",RS_Stage_Property="",ReallySurveyOrgId="",SurveyName="",RS_Stage_Survey="",FR_Stage_Survey="",SurveyStrArr[]=null,SurveyDetailArr[]=null;
    String UserTitle="",SurveyType="",ReasonStr="",SurveyTime="",SurveyItemArr[]=null,PropertyArr[]=null;
	//�v�����(��20190513)(�ӽФ��e)
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
        //���X�����d�f�ָ�T
       // PropertyArr=SRs.getString("RS_Stage"+(i+1)+"_Property").split(";");
      //  RS_Stage_Property=PropertyArr[0]; //�f�֤H�� ,2:�S�w�H�� 3:���D�� 4#:����  5:�ʺA�f��  6:�����D��
        
       /* if(RRs.getString("FR_Stage"+(i+1)+"_State").equals("")) //�H�W�h�w�����D
            if(RS_Stage_Property.equals("2"))
                RS_Stage_Survey=SRs.getString("RS_Stage"+(i+1)+"_Survey"); //�S�w�H��
            //else
                //RS_Stage_Survey=","+JOrg.getMainDepartmentMangerInfoByUser(OrgId,"OrgId")+",";   //�����D��Id
        else
            RS_Stage_Survey=RRs.getString("FR_Stage"+(i+1)+"_State").split(";",2)[1]; //�H�g�J���f�֤H�����D 
        if(RS_Stage_Survey.equals(",") || RS_Stage_Survey.equals("")) RS_Stage_Survey="0";        
        else RS_Stage_Survey=RS_Stage_Survey.substring(1,RS_Stage_Survey.length()-1); //�N�e��r���h��
        */
        FR_Stage_Survey=RRs.getString("FR_Stage"+(i+1)+"_Survey");                
                           
        if(!FR_Stage_Survey.equals(""))
        {            
            SurveyStrArr=FR_Stage_Survey.split("##"); //�C�����Ҧ��w�f�֤H��                 
            for(int k=0;k<SurveyStrArr.length;k++)
            {   
                ReallySurveyOrgId="";
                UserTitle="";SurveyType="";
                ReasonStr="";SurveyTime="";

                SurveyItemArr=SurveyStrArr[k].split(";;",4);  //0:�f�֪��A  1:�f�֤H�����G   2:�f�ַN��   3:�f�֮ɶ�                  
                SurveyDetailArr=SurveyItemArr[1].substring(1,SurveyItemArr[1].length()).split(",",4);   //0:�f�֪�  1:�N�z�H  2:�޲z�̥N�f 

                ReasonStr=SurveyItemArr[2];  //�f�ַN��
                SurveyTime=SurveyItemArr[3];  //�f�֮ɶ�   
                if(SurveyDetailArr[1].equals("") && SurveyDetailArr[2].equals("")) ReallySurveyOrgId=SurveyDetailArr[0]; //��ܥѼf�֪̼f�֦����
                if(!SurveyDetailArr[1].equals("")) //��ܥѥN�z�H�f��
                {
                    ReallySurveyOrgId=SurveyDetailArr[1];  
                    SurveyType="&nbsp;(<font color=#0000ff>�N�z�H</font>)";
                }                             
                if(!SurveyDetailArr[2].equals("")) //��ܦ�����C�\�઺�H�N�f
                {
                    ReallySurveyOrgId=SurveyDetailArr[2];              
		    SurveyType="&nbsp;(<font color=#0000ff>�N�f</font>)";
                }                              
                
                if(ReallySurveyOrgId.equals("0")) SurveyType="&nbsp;(<font color=#0000ff>�t�μf��</font>)";
                
                if(SurveyItemArr[0].equals("1"))  //�f�ֳq�L
                {   
		    if(!ReasonStr.equals("") && !ReallySurveyOrgId.equals("0")) ReasonStr="&nbsp;&nbsp;&nbsp;�N��:"+ReasonStr+"";
                    else ReasonStr="&nbsp;&nbsp;&nbsp;"+ReasonStr+"";
                    ReasonStr="�q�L"+ReasonStr;
                }
                else if(SurveyItemArr[0].equals("2"))  //�h��ܤW�@�h
                {
		    ReasonStr="�h��ܤW�@�h&nbsp;&nbsp;&nbsp;�N��:"+ReasonStr+"";                    
                }                                           
                else if(SurveyItemArr[0].equals("3"))  //�q�L���Q�h
                {
		    ReasonStr="�q�L,���Q�W�@�h�h�^&nbsp;&nbsp;&nbsp;"+ReasonStr+"";                    
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
                TmpStr="<div>"+(i+1)+"."+JDate.format(JDate.CDateTime(SurveyTime),"yyyy/MM/dd HH:mm:ss")+(UserTitle.equals("")?"���w�q":UserTitle)+"&nbsp;"+SurveyName+"&nbsp;"+ReasonStr+"</div>";                
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
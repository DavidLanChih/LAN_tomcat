<%@ page contentType="text/html;charset=MS950" %><%@page import="leeten.*" %><%@page import="java.sql.*,java.util.*" %><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Tool.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%@ include file="Util_Rule1.jsp" %><%
String SqlStr="",OP="",Site="Form_Apply_Finish.jsp";
String FDId="",FId="",RS_Stage_Doc="",RS_Stage_Property="",RS_Stage_Survey="",FR_Stage_Survey="",FR_Stage_State="";
String StageNameStr="",StagePicStr="",StageSurveyStr="",UserTitle="",PropertyArr[]=null,SurveyStrArr[]=null,SurveyItemArr[]=null;
String imgStr="",SurveyTime="",SurveyName="",CurrSurveyOrgId="",CurrSurveyName="",SurveyOrgId="",SurveyAdminOrgId="",SurveyAgentOrgId="",ReasonStr="",NoCheck="";
String TmpStr="",SurveyType="",RuleTitle="";
String SurveyDetailArr[]=null;
String OrgId="";
int TTLRI_StageCount=0,i=0,CurrStage=0;
ResultSet RRs=null,Rs=null,SRs=null,TmpRs=null;

leeten.Core SysCore=new leeten.Core(pageContext,Data,Conn);
String J_ID=SysCore.getSession("J_Id"); 
String J_OrgId=SysCore.getSession("J_OrgId");
String J_Department=SysCore.getSession("J_Department");

if(J_ID.equals(""))
{
    response.sendRedirect("/index.jsp");
    return;
}
Hashtable TitleTable=new Hashtable();    

//¾��
SqlStr="select * from UserTitle where U_RecId>1 order by U_RecId";
Rs=Data.getSmt(Conn,SqlStr);
while(Rs.next())
{
    TitleTable.put(Rs.getString("U_RecId"),Rs.getString("U_TitleName"));
}
Rs.close();Rs=null;

leeten.Util JUtil=new leeten.Util();
OP=req("OP",request);
NoCatch(response);
Html UI=new Html(pageContext,Data,Conn);
leeten.Org JOrg=new leeten.Org(Data,Conn);
UI.Start();

OrgId=req("OrgId",request);
if(OrgId.equals("")) OrgId=J_OrgId;
FId=req("FId",request);
FDId=req("FDId",request);
//�v�����(��20190513)(�i���˵�)
//SqlStr="select * from flow_form_rulestage,flow_ruleinfo where flow_form_rulestage.FR_OrgId="+OrgId+" and flow_form_rulestage.FR_FormId="+Data.toSql(FId)+" and flow_form_rulestage.FR_DataId="+Data.toSql(FDId)+" and flow_form_rulestage.FR_RuleId=flow_ruleinfo.RI_RecId limit 1"; 
SqlStr="select * from flow_form_rulestage,flow_ruleinfo where flow_form_rulestage.FR_FormId="+Data.toSql(FId)+" and flow_form_rulestage.FR_DataId="+Data.toSql(FDId)+" and flow_form_rulestage.FR_RuleId=flow_ruleinfo.RI_RecId limit 1"; 
//out.println(SqlStr+"<br>");
RRs=Data.getSmt(Conn,SqlStr);
RRs.next();
TTLRI_StageCount=RRs.getInt("RI_StageCount");
//�ˬd�f�֨�ĴX���F
CurrStage=getCurrStage(RRs);  //�]�q0�}�l�ҥHCurrStage���[1
//out.println("CurrStage->"+CurrStage+":"+TTLRI_StageCount+"<br>");
String MainDept=JOrg.getMainDepartmentIdByUser(OrgId);  //�ӽЪ̩��ݳ��
SqlStr="select * from flow_rulestage where RS_RuleId="+RRs.getString("FR_RuleId")+" limit 1";
//out.println("RuleId->"+SqlStr+"<br>");
SRs=Data.getSmt(Conn,SqlStr);
SRs.next();

    StageNameStr="<td align=center><font color=#0000ff><b><u>�ӽЪ�:"+JOrg.getOrgName(OrgId)+"</u></b></font></td><td></td>";
    StagePicStr="<td align=center><img src='/Modules/JFlow_FormWizard/J_Applyer.gif'></td><td><img src='/Modules/JFlow_FormWizard/"+(CurrStage>=0?"J_BlueLine.gif":"J_RedLine.gif")+"'></td>";
    StageSurveyStr="<td></td><td></td>";
     //�]�q0�}�l�ҥHCurrStage���[1
    for(i=0;i<TTLRI_StageCount;i++)
    {
        /*
        PropertyArr[0]="";//�f�֤H�� ,2:�S�w�H�� 3:���D�� 4:����  5:WebProcedure 6:�����D��
        PropertyArr[1]="";//���|�H�� ,1:�����| 2:�S�w�H�� 3:�����D��
        PropertyArr[2]="";//�ӽЪ̧Y���f�֪�
        PropertyArr[3]="";//����:1:�ӽЪ̩��ݳ��  0:�䥦���
        PropertyArr[4]="";//�ʺA�f��-����:1:����
        PropertyArr[5]="";//�S�w�H��:1:And  2:Or 
        */        
        PropertyArr=(SRs.getString("RS_Stage"+(i+1)+"_Property")+";;;;").split(";",7);
        RS_Stage_Property=PropertyArr[0]; //�f�֤H�� ,2:�S�w�H�� 3:���D�� 4:���� 5:�ʺA�f��  6:�����D��
        RS_Stage_Doc=SRs.getString("RS_Stage"+(i+1)+"_Doc");
        if(CurrStage==i) RS_Stage_Doc="<Blink><font color=#ff0000><b>"+RS_Stage_Doc+"</b></font></Blink>";
        else if(CurrStage>i) RS_Stage_Doc="<font color=#0000ff><b>"+RS_Stage_Doc+"</b></font>";
        
       // out.println("S->"+RS_Stage_Property+"<br>");
        if(RRs.getString("FR_Stage"+(i+1)+"_State").equals("")) //�H�W�h�w�����D
        {
        //    out.println("IN<br>");
            if(RS_Stage_Property.equals("5")) //�ʺA�f��
            {    
                RS_Stage_Survey="";            
            }
            else if(RS_Stage_Property.equals("6")) //�����D��
            {                
                String ParentOrg=JOrg.getMainDepartmentInfoByUser(OrgId,"ParentOrg");
             //   out.println("ParentOrg->"+ParentOrg+"<br>");
                RS_Stage_Survey=","+JOrg.getDepartmentMangerId(ParentOrg)+",";
            }
            else if(RS_Stage_Property.equals("2"))   //�S�w�H��
                RS_Stage_Survey=SRs.getString("RS_Stage"+(i+1)+"_Survey");
            else if(RS_Stage_Property.equals("3"))  //���D��Id
                RS_Stage_Survey=","+JOrg.getMainDepartmentMangerInfoByUser(OrgId,"OrgId")+",";   //���D��Id
            else if(RS_Stage_Property.startsWith("4#"))  //����(¾��)
            {       
                SurveyOrgId="";
                String RuleArr[]=PropertyArr[0].split("#");
                RS_Stage_Survey=SRs.getString("RS_Stage"+(i+1)+"_Survey"); //����
                if(!RS_Stage_Survey.equals(""))
                {                                        
                    String DeptArr[]=RS_Stage_Survey.substring(1,RS_Stage_Survey.length()-1).split(",");                    
                    for(int d=0;d<DeptArr.length;d++)
                    {
                        //���D�n����
                        SqlStr="select org.* from orgmb,org where orgmb.DepartmentId="+DeptArr[d]+" and orgmb.OrgId=org.orgid and orgmb.isMain=1 and org.JobTitle="+RuleArr[1]+" limit 1";                 
                        TmpRs=Data.getSmt(Conn,SqlStr);
                        if(TmpRs.next()) SurveyOrgId+=TmpRs.getString("OrgId")+",";                    
                        TmpRs.close();TmpRs=null;
                    }                        
                }    
                else //��ܧ�ӽЪ̩��ݳ��
                {
                    SqlStr="select * from org where Department="+MainDept+" and JobTitle="+RuleArr[1]+" limit 1";
                    TmpRs=Data.getSmt(Conn,SqlStr);
                    if(TmpRs.next()) SurveyOrgId=TmpRs.getString("OrgId")+","; 
                    TmpRs.close();TmpRs=null;
                }
                RS_Stage_Survey=","+SurveyOrgId; //����H��                
            }            
        }
        else  //�H�g�J���f�֤H�����D 
            RS_Stage_Survey=RRs.getString("FR_Stage"+(i+1)+"_State").split(";",2)[1];
        
      //  out.println("SurveyBef->"+RS_Stage_Survey+"<br>");
        if(RS_Stage_Survey.equals(",") || RS_Stage_Survey.equals(",,") || RS_Stage_Survey.equals("")) RS_Stage_Survey="0";        
        else RS_Stage_Survey=RS_Stage_Survey.substring(1,RS_Stage_Survey.length()-1);
        
  //    out.println("Survey->"+RS_Stage_Survey+"<br>");
        StageNameStr+="<td align=center>"+RS_Stage_Doc+"</td><td></td>";
        StagePicStr+="<td align=center><img src='/Modules/JFlow_FormWizard/J_Computer.gif'></td><td><img src='/Modules/JFlow_FormWizard/"+(CurrStage>i?"J_BlueLine.gif":"J_RedLine.gif")+"'></td>";

            StageSurveyStr+="<td  valign=top>";
            
            if(RS_Stage_Property.equals("5") && RS_Stage_Survey.equals("0")) //�ʺA�f��
            {    
                if(RRs.getString("FR_Stage"+(i+1)+"_State").equals(""))                
                    TmpStr="<div>�ʺA�f��<br>�ѤW�h�f�֪̿�ܼf�֤H��</div><hr size=1>";
                else
                    TmpStr="<div>�t�μf��:�L�f�֤H��,�۰�Pass.</div><hr size=1>";
                StageSurveyStr+=TmpStr;
            }
            else if(RS_Stage_Property.startsWith("4#") && RS_Stage_Survey.equals("0")) //����
            {    
                RuleTitle=RS_Stage_Property.split("#")[1];   
                TmpStr="<div><font color=#0000ff>����(¾��):"+TitleTable.get(RuleTitle)+"</font><div>";                 
                TmpStr+="<div><font color=#ff0000>�䤣��f�֤H��.�۰�Pass.</font></div><hr size=1>";
                StageSurveyStr+=TmpStr;
            }            
            else
            {
                SqlStr="select * from Org where OrgId in ("+RS_Stage_Survey+") order by OrgName";
              // out.println(CurrStage+"<br>"+SqlStr+"<br>");out.flush();
                Rs=Data.getSmt(Conn,SqlStr);
                TmpStr="";
                boolean hasUser=false;  //�H���|��ñ��
                if(Rs.next())
                {
                    Rs.beforeFirst();                
                    while(Rs.next())
                    {
                        hasUser=false;
                        NoCheck="";UserTitle="";SurveyType="";
                        imgStr="";ReasonStr="";SurveyTime="";SurveyAgentOrgId="";
                        CurrSurveyOrgId=Rs.getString("OrgId");                
                        CurrSurveyName=Rs.getString("OrgName");
                        FR_Stage_Survey=RRs.getString("FR_Stage"+(i+1)+"_Survey");                
                        if(CurrStage>i) 
                        {
                            if(FR_Stage_Survey.indexOf("1;;,"+CurrSurveyOrgId+",")>-1) imgStr="<img src='/images/approve.gif'>";
                        }                
                    //    out.println(CurrSurveyOrgId+":"+FR_Stage_Survey+"<br>");
                        if(!FR_Stage_Survey.equals(""))
                        {           
                        //    out.println("In<br>");
                            boolean hasInSurvey=false;
                            SurveyStrArr=FR_Stage_Survey.split("##");
                            for(int k=0;k<SurveyStrArr.length;k++)
                            {                
                                SurveyItemArr=SurveyStrArr[k].split(";;",4);
                                SurveyDetailArr=SurveyItemArr[1].substring(1,SurveyItemArr[1].length()).split(",",4);    
                                NoCheck="";UserTitle="";SurveyType="";
                                imgStr="";ReasonStr="";SurveyTime="";SurveyAgentOrgId="";
		//out.println("SI->"+SurveyItemArr[1]+":"+","+CurrSurveyOrgId+",IndexOf->"+(SurveyItemArr[1].indexOf(","+CurrSurveyOrgId+","))+"<br>");
                                if(SurveyItemArr[1].indexOf(","+CurrSurveyOrgId+",")>-1) 
                                {        
                                    hasInSurvey=true;
                                    SurveyTime=SurveyItemArr[3];
                                    ReasonStr=SurveyItemArr[2];  //�f�ַN��     
                                  //  out.println("Has<br>");
                                    hasUser=true;                                          
                                    if(SurveyDetailArr[1].equals("") && SurveyDetailArr[2].equals("")) SurveyOrgId=SurveyDetailArr[0]; //��ܥѼf�֪̼f�֦����
                                    if(!SurveyDetailArr[1].equals("")) //��ܥѥN�z�H�f��
                                    {
                                        SurveyOrgId=SurveyDetailArr[1];SurveyAgentOrgId=SurveyOrgId;
                                        SurveyType="&nbsp;(<font color=#0000ff>�N�z�H</font>)";
                                    }                             
                                    if(!SurveyDetailArr[2].equals("")) //��ܦ�����C�\�઺�H�N�f
                                    {
                                        SurveyOrgId=SurveyDetailArr[2];SurveyAdminOrgId=SurveyOrgId;
                                        SurveyType="&nbsp;(<font color=#0000ff>�N�f</font>)";
                                    }                              

                                    if(SurveyItemArr[0].equals("1"))  //�f�ֳq�L
                                    {
                                        imgStr="<img src='/images/approve.gif'>";
                                        ReasonStr="<font color=#0000ff>"+ReasonStr+"</font>";
                                    }
                                    else if(SurveyItemArr[0].equals("2"))  //�h��ܤW�@�h
                                    {
                                        imgStr="<img src='/images/arrow-back.gif' title='�h��ܤW�@�h'>";
                                        ReasonStr="<font color=#008000>"+ReasonStr+"</font>";
                                    }                            
                                    else if(SurveyItemArr[0].equals("3"))  //�Q�h��,�ѤW�h�Q�h
                                    {
                                        imgStr="<img src='/images/mapprove.gif' title='�ѤW�h���d�Q�h��'>";
                                        ReasonStr="<font color=#0000ff>"+ReasonStr+"</font>";
                                    }                            
                                    else if(SurveyItemArr[0].equals("0"))    //�f�֤��q�L
                                    {
                                        imgStr="<img src='/images/delete.gif'>";
                                        ReasonStr="<font color=#ff0000>"+ReasonStr+"</font>";
                                    }    
                                    UserTitle=JOrg.getUserTitle(SurveyOrgId);
                                    SurveyName=JOrg.getOrgInfo(SurveyOrgId,"OrgName")+SurveyType+"<div>"+SurveyTime+"</div>";
                                    TmpStr="<div>"+(UserTitle.equals("")?"���w�q":UserTitle)+imgStr+"<br>"+SurveyName+NoCheck+"</div><div align=left>"+ReasonStr.replaceAll("\n","<br>")+"</div><hr size=1>";
                                    StageSurveyStr+=TmpStr;          
                                    break; 		
                                }                                
                            }  

                                if(!hasInSurvey)
                                {
		 //   out.println("No1<br>");
                                    UserTitle=JOrg.getUserTitle(CurrSurveyOrgId);                
                                    NoCheck="<div><font color=#ff0000>�|���f��</font></div>"; 
                                    TmpStr="<div>"+(UserTitle.equals("")?"���w�q":UserTitle)+imgStr+"<br>"+CurrSurveyName+NoCheck+"</div><div align=left>"+ReasonStr.replaceAll("\n","<br>")+"</div><hr size=1>";
                                    StageSurveyStr+=TmpStr; 
                                }

                        }                
                        else
                        {                    
		//out.println("No2<br>");
                            UserTitle=JOrg.getUserTitle(CurrSurveyOrgId);   
                            NoCheck="<div><font color=#ff0000>�|���f��</font></div>"; 
                            TmpStr="<div>"+(UserTitle.equals("")?"���w�q":UserTitle)+imgStr+"<br>"+CurrSurveyName+NoCheck+"</div><div align=left>"+ReasonStr.replaceAll("\n","<br>")+"</div><hr size=1>";
                            StageSurveyStr+=TmpStr;                                
                        }
                    }
                }
                else
                {
                    switch(Integer.parseInt(RS_Stage_Property))
                    {
                        case 3: //���D�� 
                            break;
                        case 4: //���� 
                            break;
                        case 5: //�ʺA�f��  
                            break;
                        case 6: //�����D��
                            break;                        
                    }
                    TmpStr="<div>�����L�f�֤H��"+(CurrStage>=i?"<img src='/images/approve.gif'>":"")+"</div><hr size=1>";
                    StageSurveyStr+=TmpStr;          
                }
                Rs.close();Rs=null;
            }
            StageSurveyStr+="</td><td></td>";
                
    }
    StageNameStr+="<td align=center><font color=#0000ff><b><u>�f�֧���:�k��</u></b></font></td>";
    StagePicStr+="<td align=center><img src='/Modules/JFlow_FormWizard/J_Storage.gif'></td>";
    StageSurveyStr+="<td></td>";
    
SRs.close();SRs=null;
RRs.close();RRs=null;

UI=null;
closeConn(Data,Conn);
%>
<table width=100% height=100% border=0 cellspacing=0 cellpadding=0 valign=middle>
<tr><td width=100%  valign=middle>
    <table width=100% border=0 cellspacing=0 cellpadding=0 valign=middle>
        <tr><td align=center colspan=<%=(TTLRI_StageCount*2)+3%> style='font-size:15pt'><img src='/Modules/JFlow_FormWizard/doc.gif'>&nbsp;<font color=#0000ff><u>��&nbsp;��&nbsp;�y&nbsp;�{&nbsp;�i&nbsp;��</u></font><br><br></td></tr>
        <tr><%=StageNameStr%></tr>
        <tr><%=StagePicStr%></tr>
        <tr><%=StageSurveyStr%></tr>
    </table>
</td></tr>
</table>
<%if(OP.equals("OK")) out.println("<script>parent.FrmTree.document.location.reload();alert('�ӽЧ���!');</script>");%>
<script language=vbscript>
    flag=1
    sub flashfont()

     if flag = 1 then
      for N = 0 to document.all.length - 1
       if lcase(document.all(N).tagname) = "blink" then document.all(N).style.visibility = "hidden"
      next 
      flag = 0
     else
      for N = 0 to document.all.length - 1
       if lcase(document.all(N).tagname) = "blink" then document.all(N).style.visibility = ""
      next 
      flag = 1
     end if

     unknow=window.settimeout("flashfont()",500)
    end sub
    
    flashfont()
</script>
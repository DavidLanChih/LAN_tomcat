<%!
public String ProceTimeSel()
{
    String TimeSel="<option value='00:00' >00:00";
    TimeSel+="<option value='00:15' >00:15";
    TimeSel+="<option value='00:30' >00:30";
    TimeSel+="<option value='00:45' >00:45";
    for(int i=1;i<24;i++)
    {
        if(i<10)
        {
            TimeSel+="<option value='0"+i+":00' >0"+i+":00";TimeSel+="<option value='0"+i+":15' >0"+i+":15";TimeSel+="<option value='0"+i+":30' >0"+i+":30";TimeSel+="<option value='0"+i+":45'>0"+i+":45";
        }
        else
        {
            TimeSel+="<option value='"+i+":00' >"+i+":00";TimeSel+="<option value='"+i+":15' >"+i+":15";TimeSel+="<option value='"+i+":30' >"+i+":30";TimeSel+="<option value='"+i+":45' >"+i+":45";
        }
    }
    return TimeSel;
}

public String RuleSwitch(String FI_MultiRule,String Org_FI_Rule,HttpServletRequest request) throws Exception
{
    String xFI_Rule=Org_FI_Rule;
    leeten.Date JDate=new leeten.Date();
    String MultiRuleArr[]=null;    
    String tmpField="",tmpType="",tmpCmp="",tmpValue="",tmpCmpValue="";        
    if(!FI_MultiRule.equals(""))
    {
        MultiRuleArr=FI_MultiRule.split("##");
        String MultiRuleItem[]=null;
        for(int R=0;R<MultiRuleArr.length;R++)
        {                
            MultiRuleItem=MultiRuleArr[R].split(",,");
            tmpType=MultiRuleItem[0].split("#")[0];
            tmpField=MultiRuleItem[0].split("#")[1];
            tmpCmp=MultiRuleItem[1];
            tmpCmpValue=MultiRuleItem[2];            
            tmpValue=request.getParameter(tmpField).toString();
            if(tmpCmp.equals("include"))
            {
                if(tmpType.equals("Input") || tmpType.equals("TextArea") || tmpType.equals("Radio") || tmpType.equals("CheckBox") || tmpType.equals("List") || tmpType.equals("MultiList"))
                {
                    if(tmpValue.indexOf(tmpCmpValue)>-1) {xFI_Rule=MultiRuleItem[3];break;}
                }                    
                else if(tmpType.equals("Int") || tmpType.equals("Float") || tmpType.equals("Date") || tmpType.equals("Time"))
                {
                    if(tmpValue.indexOf(tmpCmpValue)>-1) {xFI_Rule=MultiRuleItem[3];break;}
                }                    
            }
            else if(tmpCmp.equals("big"))
            {
                if(tmpType.equals("Input") || tmpType.equals("TextArea") || tmpType.equals("Radio") || tmpType.equals("CheckBox") || tmpType.equals("List") || tmpType.equals("MultiList"))
                {
                    if(tmpValue.compareToIgnoreCase(tmpCmpValue)>0) {xFI_Rule=MultiRuleItem[3];break;}
                }                    
                else if(tmpType.equals("Int"))      {if(Integer.parseInt(tmpValue)>Integer.parseInt(tmpCmpValue)) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Float"))    {if(Float.parseFloat(tmpValue)>Float.parseFloat(tmpCmpValue)) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Date"))     {if(JDate.CDate(tmpValue).compareTo(JDate.CDate(tmpCmpValue))>0) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Time"))     {if(JDate.CDate(JDate.ToDay()+" "+tmpValue).compareTo(JDate.CDate(JDate.ToDay()+" "+tmpCmpValue))>0) {xFI_Rule=MultiRuleItem[3];break;}}
            }
            else if(tmpCmp.equals("small"))
            {
                if(tmpType.equals("Input") || tmpType.equals("TextArea") || tmpType.equals("Radio") || tmpType.equals("CheckBox") || tmpType.equals("List") || tmpType.equals("MultiList"))
                {
                    if(tmpValue.compareToIgnoreCase(tmpCmpValue)<0) {xFI_Rule=MultiRuleItem[3];break;}
                }                    
                else if(tmpType.equals("Int"))      {if(Integer.parseInt(tmpValue)<Integer.parseInt(tmpCmpValue)) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Float"))    {if(Float.parseFloat(tmpValue)<Float.parseFloat(tmpCmpValue)) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Date"))     {if(JDate.CDate(tmpValue).compareTo(JDate.CDate(tmpCmpValue))<0) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Time"))     {if(JDate.CDate(JDate.ToDay()+" "+tmpValue).compareTo(JDate.CDate(JDate.ToDay()+" "+tmpCmpValue))<0) {xFI_Rule=MultiRuleItem[3];break;}}
            }                
            else if(tmpCmp.equals("equal"))
            {
                if(tmpType.equals("Input") || tmpType.equals("TextArea") || tmpType.equals("Radio") || tmpType.equals("CheckBox") || tmpType.equals("List") || tmpType.equals("MultiList"))
                {
                    if(tmpValue.compareToIgnoreCase(tmpCmpValue)==0) {xFI_Rule=MultiRuleItem[3];break;}
                }                    
                else if(tmpType.equals("Int"))      {if(Integer.parseInt(tmpValue)==Integer.parseInt(tmpCmpValue)) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Float"))    {if(Float.parseFloat(tmpValue)==Float.parseFloat(tmpCmpValue)) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Date"))     {if(JDate.CDate(tmpValue).compareTo(JDate.CDate(tmpCmpValue))==0) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Time"))     {if(JDate.CDate(JDate.ToDay()+" "+tmpValue).compareTo(JDate.CDate(JDate.ToDay()+" "+tmpCmpValue))==0) {xFI_Rule=MultiRuleItem[3];break;}}
            }                
            else if(tmpCmp.equals("bigequal"))
            {
                if(tmpType.equals("Input") || tmpType.equals("TextArea") || tmpType.equals("Radio") || tmpType.equals("CheckBox") || tmpType.equals("List") || tmpType.equals("MultiList"))
                {
                    if(tmpValue.compareToIgnoreCase(tmpCmpValue)>=0) {xFI_Rule=MultiRuleItem[3];break;}
                }                    
                else if(tmpType.equals("Int"))      {if(Integer.parseInt(tmpValue)>=Integer.parseInt(tmpCmpValue)) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Float"))    {if(Float.parseFloat(tmpValue)>=Float.parseFloat(tmpCmpValue)) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Date"))     {if(JDate.CDate(tmpValue).compareTo(JDate.CDate(tmpCmpValue))>=0) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Time"))     {if(JDate.CDate(JDate.ToDay()+" "+tmpValue).compareTo(JDate.CDate(JDate.ToDay()+" "+tmpCmpValue))>=0) {xFI_Rule=MultiRuleItem[3];break;}}
            }                 
            else if(tmpCmp.equals("smallequal"))
            {
                if(tmpType.equals("Input") || tmpType.equals("TextArea") || tmpType.equals("Radio") || tmpType.equals("CheckBox") || tmpType.equals("List") || tmpType.equals("MultiList"))
                {
                    if(tmpValue.compareToIgnoreCase(tmpCmpValue)<=0) {xFI_Rule=MultiRuleItem[3];break;}
                }                    
                else if(tmpType.equals("Int"))      {if(Integer.parseInt(tmpValue)<=Integer.parseInt(tmpCmpValue)) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Float"))    {if(Float.parseFloat(tmpValue)<=Float.parseFloat(tmpCmpValue)) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Date"))     {if(JDate.CDate(tmpValue).compareTo(JDate.CDate(tmpCmpValue))<=0) {xFI_Rule=MultiRuleItem[3];break;}}
                else if(tmpType.equals("Time"))     {if(JDate.CDate(JDate.ToDay()+" "+tmpValue).compareTo(JDate.CDate(JDate.ToDay()+" "+tmpCmpValue))<=0) {xFI_Rule=MultiRuleItem[3];break;}}
            }                                
        }
    }
    return xFI_Rule;
}    
%>
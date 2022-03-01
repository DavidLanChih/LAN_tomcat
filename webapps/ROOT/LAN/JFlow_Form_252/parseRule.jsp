<%@ page contentType="text/html;charset=MS950" %><%@ include file="/kernel.jsp" %><%@ include file="/Modules/JFlow_FormWizard/Util_Form.jsp" %><%
String Org_FI_Rule=Data.req("FI_Rule");
String FI_RuleMethod=Data.req("FI_RuleMethod");
String FI_MultiRule=Data.req("FI_MultiRule");
String Curr_Stage=Data.req("Curr_Stage");
String FI_Rule=Org_FI_Rule;
String PropertyArr[]=null,ScriptStr="";
 //檢查是否有多重條件,並變更RuleId  1:無   2:有    
if(FI_RuleMethod.equals("2")) FI_Rule=RuleSwitch(FI_MultiRule,Org_FI_Rule,Data,Conn);

String SqlStr="select * from flow_rulestage where RS_RuleId ="+Data.toSql(FI_Rule)+" limit 1";
ResultSet Rs=Data.getSmt(Conn,SqlStr);
Rs.next();
//讀取第 Curr_Stage 關資訊
String RS_Stage_Property=Rs.getString("RS_Stage"+Curr_Stage+"_Property");
String RS_Stage_Survey=Rs.getString("RS_Stage"+Curr_Stage+"_Survey");
Rs.close();Rs=null;
if(RS_Stage_Property.startsWith("5;")) //此關為動態審核
{    
    PropertyArr=(RS_Stage_Property+";;;;").split(";",7);
    if(PropertyArr[4].equals("1")) ScriptStr+="parent.Frm.MustChoose.value='1';";
    ScriptStr+="parent.openShim('Shim','DynamicChoose');";    
}
else
{
    ScriptStr="parent.SendForm();";
}    
%>
<script language="javascript">
    parent.Frm.FI_Rule.value='<%=FI_Rule%>';
    <%=ScriptStr%>
</script>    

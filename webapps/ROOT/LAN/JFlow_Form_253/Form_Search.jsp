<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%@ include file="Form_Config.jsp" %> 
<%
NoCatch(response);

leeten.Html UI=new leeten.Html(pageContext,Data,Conn);
leeten.Date JDate=new leeten.Date();
String OP="",SqlStr="";

UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("100%");
Grid.AddTab("表單追蹤","Form_Tracert.jsp",0);
Grid.AddTab("<img src='/Modules/JFlow_FormWizard/Form_Tracert.gif'>&nbsp;表單搜尋",1);
Grid.AddRestTab(""); 
Grid.setForm(true); 
Grid.FormCheck("DataCheck(this)");
Grid.setFormAction("Form_Search_Result.jsp");
Grid.AddRestTab("");
Grid.AddRow("");
Grid.AddCol("關鍵字:"," width=85 ");
Grid.AddCol("<input type=text name=KeyWord value='' size=20>(申請的內容資訊等...)","");  
Grid.AddRow("");
Grid.AddCol("申請起迄時間:","");  
Grid.AddCol("<input type=text name=StartDate value='"+JDate.MonthOfStartDay()+"' onclick=\"calendar(this);\" readonly maxlength=10 size=10> ~ <input type=text name=EndDate value='"+JDate.MonthOfEndDay()+"' onclick=\"calendar(this);\" readonly maxlength=10 size=10>","");  
Grid.AddRow("");
Grid.AddCol("<input type=hidden name=OP value='Search'><input type=submit name=go value='確定' >　<input type='button' value='取消' onclick='history.back();'>"," colspan=2 align=center");

Grid.Show();
Grid=null;
UI=null;
%>
<script>
function DataCheck(frm)
{  
    if(frm.StartDate.value!='' && frm.EndDate.value=='') {alert('請選擇結束日期!');frm.EndDate.focus();return false;}
    if(frm.StartDate.value=='' && frm.EndDate.value!='') {alert('請選擇起始日期!');frm.StartDate.focus();return false;}
    return true;
}
</script>
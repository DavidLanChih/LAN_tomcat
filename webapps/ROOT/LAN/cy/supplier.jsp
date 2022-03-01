<%@ page contentType="text/html;charset=MS950" pageEncoding="UTF-8" %>
<%@ include file="/kernel.jsp" %><%@ include file="/APP3.0-TC.jsp" %>
<%@ include file="/Modules/JFlow_FormWizard/Util_Form.jsp" %>
<%
//----------------宣告---------------------
String SqlStr="",options="";
String Field=req("Field",request);
//----------防止瀏覽器快取網頁-------------
NoCatch(response);
//------------防止瀏覽器亂碼---------------
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
//--------------資料庫抓取-----------------
Statement stmt=connTC.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
SqlStr="SELECT USERS.COUNTER_ID as COUNTER_ID,COUNTER.SHORT_NAME as short_name from USERS, COUNTER where USERS.STATUS='1' and USERS.COUNTER_ID=COUNTER.COUNTER_ID group by USERS.COUNTER_ID,COUNTER.SHORT_NAME";
ResultSet Rs=stmt.executeQuery(SqlStr);
while(Rs.next())
{   
	String COUNTER_ID=Rs.getString("COUNTER_ID");
	String short_name=Rs.getString("short_name");
	options+="<option value='"+COUNTER_ID+"'>"+COUNTER_ID+":"+short_name+"</option>";	
}
//-------------表格介面設定-----------------
NoCatch(response);
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("500");
Grid.setForm(true); 
Grid.AddTab("廠商櫃號輸入",1);
Grid.AddRestTab("");
Grid.AddRow("");
Grid.AddCol("(請選擇廠商櫃號)<br><select id=S1><option value='0'></option>"+options,"colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("(或輸入廠商櫃號)<br><input type=text size='5' name='T1' id='T1'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onclick='cabinet()' value='送出'>&nbsp;&nbsp;<input type='submit' onClick='clearData();' value='清除資料'>","colspan=2 align=center");
Grid.Show();
Grid=null;
//-----------------釋放--------------------
Rs.close();
stmt.close();
connTC.close();
%>
<iframe id='FrmTemp' src='' frameborder=0 width="0" height="0"  ></iframe>
<script>
//--------櫃位資料回傳至母視窗-------------
function cabinet()
{	
	var S =document.getElementById("S1");
	var T =document.getElementById("T1");
	//--------回傳選單資料--------
	if(S.options[S.selectedIndex].value!=0 & T.value!='')
	{
		alert("只能選擇一個櫃號！");
		return false;
	}
	if(S.options[S.selectedIndex].value!=0)
	{
		opener.document.getElementById('<%=Field%>').value=S.options[S.selectedIndex].text;
		window.close();
	}	
	//--------回傳打字資料--------
	if(T.value!='')
	{
		document.getElementById('FrmTemp').src='check.jsp?UID='+T.value;		//將值傳至check.jsp(當前分割視窗的iframe內)
	}		
	
}
//---------check.jsp回傳值至母視窗---------
function Check()                                                                
{
	opener.document.getElementById('<%=Field%>').value=document.getElementById('T1').value;
	window.close();
}
//--------------清除欄位資料---------------
function clearData()
{
	opener.document.getElementById('<%=Field%>').value='';
	window.close();
}
</script>
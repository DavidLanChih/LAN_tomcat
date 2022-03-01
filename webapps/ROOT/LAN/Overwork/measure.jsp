<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %> 
<%
//-----防止瀏覽器快取網頁--------------------
NoCatch(response);
//-----宣告按鈕------------------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//-----宣告Grid------------------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.AddRow("");
Grid.setGridWidth("100%");
Grid.setForm(true);        //表格建立
Grid.FormCheck("send()");  //選擇程式判斷防呆
Grid.AddTab("過勞量表",1);
Grid.AddCol("「過勞量表」個人評估工具 (包含「個人相關過勞」及「工作相關過勞」狀況)","colspan=9 align=center");
Grid.AddRow("");
Grid.AddCol("評估單位:","width=5% align=center");
Grid.AddCol("OOO","width=60%");
Grid.AddCol("評估結果之數據分析","width=35% colspan=7 align=center");
Grid.AddRow("");
Grid.AddCol("評估目標","colspan=2 align=center");  
Grid.AddCol("評估結果","colspan=7 align=center");
Grid.AddRow("");
Grid.AddCol("一、個人相關過勞分量表","colspan=9");
Grid.AddRow("");
Grid.AddCol("請就以下陳述之內容，勾選右側欄位，分別為：總是、常常、有時候、不常、從未或幾乎從未","colspan=2");
Grid.AddCol("總是","width=5% align=center");  
Grid.AddCol("常常","width=5% align=center");
Grid.AddCol("有時候","width=5% align=center");
Grid.AddCol("不常","width=5% align=center");
Grid.AddCol("從未或<br>幾乎從未","width=5% align=center");
Grid.AddCol("新增欄位1","width=5% align=center");
Grid.AddCol("新增欄位2","width=5% align=center");
Grid.AddRow("");
Grid.AddCol("1.","align=center");
Grid.AddCol("你常覺得疲勞嗎?","");
Grid.AddCol("<input type='radio' name='q1' id='q1-1'value='100'>","align=center");  
Grid.AddCol("<input type='radio' name='q1' value='75'>","align=center");
Grid.AddCol("<input type='radio' name='q1' value='50'>","align=center");
Grid.AddCol("<input type='radio' name='q1' value='25'>","align=center");
Grid.AddCol("<input type='radio' name='q1' value='0'>","align=center");
Grid.AddCol("<input type='radio' name='q1' value='5'>","align=center");
Grid.AddCol("<input type='radio' name='q1' value='10'>","align=center");
Grid.AddRow("");
Grid.AddCol("2.","align=center");
Grid.AddCol("你常覺得身體上體力透支嗎?","");
Grid.AddCol("<input type='radio' name='q2' value='100'>","align=center");  
Grid.AddCol("<input type='radio' name='q2' value='75'>","align=center");
Grid.AddCol("<input type='radio' name='q2' value='50'>","align=center");
Grid.AddCol("<input type='radio' name='q2' value='25'>","align=center");
Grid.AddCol("<input type='radio' name='q2' value='0'>","align=center");
Grid.AddCol("<input type='radio' name='q2' value='5'>","align=center");
Grid.AddCol("<input type='radio' name='q2' value='10'>","align=center");
Grid.AddRow("");
Grid.AddCol("3.","align=center");
Grid.AddCol("你常覺得情緒上心力交瘁嗎？","");
Grid.AddCol("<input type='radio' name='q3' value='100'>","align=center");  
Grid.AddCol("<input type='radio' name='q3' value='75'>","align=center");
Grid.AddCol("<input type='radio' name='q3' value='50'>","align=center");
Grid.AddCol("<input type='radio' name='q3' value='25'>","align=center");
Grid.AddCol("<input type='radio' name='q3' value='0'>","align=center");
Grid.AddCol("<input type='radio' name='q3' value='5'>","align=center");
Grid.AddCol("<input type='radio' name='q3' value='10'>","align=center");
Grid.AddRow("");
Grid.AddCol("4.","align=center");
Grid.AddCol("你常會覺得，「我快要撐不下去了」嗎?","");
Grid.AddCol("<input type='radio' name='q4' value='100'>","align=center");  
Grid.AddCol("<input type='radio' name='q4' value='75'>","align=center");
Grid.AddCol("<input type='radio' name='q4' value='50'>","align=center");
Grid.AddCol("<input type='radio' name='q4' value='25'>","align=center");
Grid.AddCol("<input type='radio' name='q4' value='0'>","align=center");
Grid.AddCol("<input type='radio' name='q4' value='5'>","align=center");
Grid.AddCol("<input type='radio' name='q4' value='10'>","align=center");
Grid.AddRow("");
Grid.AddCol("5.","align=center");
Grid.AddCol("你常覺得精疲力竭嗎?","");
Grid.AddCol("<input type='radio' name='q5' value='100'>","align=center");  
Grid.AddCol("<input type='radio' name='q5' value='75'>","align=center");
Grid.AddCol("<input type='radio' name='q5' value='50'>","align=center");
Grid.AddCol("<input type='radio' name='q5' value='25'>","align=center");
Grid.AddCol("<input type='radio' name='q5' value='0'>","align=center");
Grid.AddCol("<input type='radio' name='q5' value='5'>","align=center");
Grid.AddCol("<input type='radio' name='q5' value='10'>","align=center");
Grid.AddRow("");
Grid.AddCol("6.","align=center");
Grid.AddCol("你常常覺得虛弱，好像快要生病了嗎?","");
Grid.AddCol("<input type='radio' name='q6' value='100'>","align=center");  
Grid.AddCol("<input type='radio' name='q6' value='75'>","align=center");
Grid.AddCol("<input type='radio' name='q6' value='50'>","align=center");
Grid.AddCol("<input type='radio' name='q6' value='25'>","align=center");
Grid.AddCol("<input type='radio' name='q6' value='0'>","align=center");
Grid.AddCol("<input type='radio' name='q6' value='5'>","align=center");
Grid.AddCol("<input type='radio' name='q6' value='10'>","align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' name='Button' value='send' >","colspan=9 align=center");

Grid.setFormAction("send.jsp"); //送出表單的位置
//-----取得表單每個欄位送出的值--------------
String q1=request.getParameter("q1");
String q2=request.getParameter("q2");
String q3=request.getParameter("q3");
String q4=request.getParameter("q4");
String q5=request.getParameter("q5");
String q6=request.getParameter("q6");
Grid.Show();
//-----釋放----------------------------------
Grid=null;
UI=null;
%>

<script>
//-----每個選項防呆機制---------------------- 
function send()
{
	var c1=document.getElementsByName("q1");
	var c2=document.getElementsByName("q2");
	var c3=document.getElementsByName("q3");
	var c4=document.getElementsByName("q4");
	var c5=document.getElementsByName("q5");
	var c6=document.getElementsByName("q6");
	
	if(c1[0].checked==false&&c1[1].checked==false&&c1[2].checked==false&&c1[3].checked==false&&c1[4].checked==false&&c1[5].checked==false&&c1[6].checked==false)
		{
			alert("請勾選第1題選項");
			return false;			
		}		
	if(c2[0].checked==false&&c2[1].checked==false&&c2[2].checked==false&&c2[3].checked==false&&c2[4].checked==false&&c2[5].checked==false&&c2[6].checked==false)
		{
			alert("請勾選第2題選項");
			return false;
		}			
	if(c3[0].checked==false&&c3[1].checked==false&&c3[2].checked==false&&c3[3].checked==false&&c3[4].checked==false&&c3[5].checked==false&&c3[6].checked==false)
		{
			alert("請勾選第3題選項");
			return false;
		}		
	if(c4[0].checked==false&&c4[1].checked==false&&c4[2].checked==false&&c4[3].checked==false&&c4[4].checked==false&&c4[5].checked==false&&c4[6].checked==false)
		{
			alert("請勾選第4題選項");
			return false;
		}
	if(c5[0].checked==false&&c5[1].checked==false&&c5[2].checked==false&&c5[3].checked==false&&c5[4].checked==false&&c5[5].checked==false&&c5[6].checked==false)
		{
			alert("請勾選第5題選項");
			return false;
		}		
	if(c6[0].checked==false&&c6[1].checked==false&&c6[2].checked==false&&c6[3].checked==false&&c6[4].checked==false&&c6[5].checked==false&&c6[6].checked==false)
		{
			alert("請勾選第6題選項");
			return false;
		}
}
//-----若全部都有選，跳出每個欄位的值--------
var q1="<%=q1%>",q2="<%=q2%>",q3="<%=q3%>",q4="<%=q4%>",q5="<%=q5%>",q6="<%=q6%>";
if(q1!="null" && q2!="null" && q3!="null" && q4!="null" && q5!="null" && q6!="null")
{
	alert('第一個值為:'+q1+'\n第二個值為:'+q2+'\n第三個值為:'+q3+'\n第四個值為:'+q4+'\n第五個值為:'+q5+'\n第六個值為:'+q6);
}


</script>

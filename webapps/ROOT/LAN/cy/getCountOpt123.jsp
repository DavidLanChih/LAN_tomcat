<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page contentType="text/html;charset=big5" %> 
<%
leeten.Date JDate=new leeten.Date();
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String SqlStr="";
String UID=J_UD_Id.substring(0,5);
String UUID=J_UD_Id.substring(2);
String SelectUserStr="";
String Dept="",Comp="",p014_divno="",p031_div="";
String Field=req("Field",request);
String Field1=req("Field1",request);
String Field2=req("Field2",request);
String Field3=req("Field3",request);
String Field4=req("Field4",request);
String Field5=req("Field5",request);
String SD="";
String USID=req("USID",request);
String FDept=USID.substring(2,4);

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
/*
61	C8610	營業一處	營一處	化妝品課
62	C8660	營業一處	營一處	名品珠寶課
63	C8630	營業一處	營一處	流行雜貨課
64	C8660	營業一處	營一處	精品課
65	C8650	營業一處	營一處	名品課
67	C8670	營業一處	營一處	品牌服飾課

71	C8770	營業二處	營二處	名媛服飾課
72	C8760	營業二處	營二處	童裝內睡衣課
73	C8730	營業二處	營二處	仕女雜貨課
75	C8750	營業二處	營二處	少女裝課
74	C8740	營業二處	營二處	品牌服飾課
78	C8780	營業二處	營二處	美食食品課
79	C8790	營業二處	營二處	食尚風味館
7A	C87A0	營業二處	營二處	美食餐廳課
7B	C87B0	營業二處	營二處	特賣課

81	C8810	營業三處	營三處	少女裝課
82	C88C0	營業三處	營三處	休閒運動課
83	C8830	營業三處	營三處	品牌服飾課
84	C8840	營業三處	營三處	男裝課
85	C8850	營業三處	營三處	配件雜貨課
86	C8860	營業三處	營三處	童裝課
87	C88C0	營業三處	營三處	運動文教課
89	C8890	營業三處	營三處	男裝童裝課
8B	C88B0	營業三處	營三處	家用課


*/

if(FDept.equals("66"))
{
	p014_divno="p014_divno='62'";
	p031_div="p031_div='62'";
}
else if(FDept.equals("76"))
{
	p014_divno="p014_divno='72'";
	p031_div="p031_div='72'";
}
else if(FDept.equals("77"))
{
	p014_divno="p014_divno='71'";
	p031_div="p031_div='71'";
}
else if(FDept.equals("8C"))
{
	p014_divno="(p014_divno='82' or p014_divno='87')";
	p031_div="(p031_div='82' or p031_div='87')";
}
else 
{
	p014_divno="p014_divno='"+FDept+"'";
	p031_div="p031_div='"+FDept+"'";
}
//select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy@chyusc1:purf014 where length(p014_speno)=5 and p014_divno=61 and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 union select p031_box as speno,p031_mark as sname,p031_blane as blane,p031_div as divno from cy@chyusc1:purf031 where length(p031_box)=5 and p031_div=61"
if(FDept.equals("78"))
{
//20120301因改變公司組織，將原四處美食調至二處
//SqlStr="select p014_venno as venno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy@chyusc1:purf014 where length(p014_venno)=5 and p014_divno matches '[Y7]*' and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 union  select p014_venno as venno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy2@chyusc1:purf014 where length(p014_venno)=5 and p014_venno like 'Y%' union select p031_box as venno,p031_mark as sname,p031_blane as blane,p031_div as divno from cy@chyusc1:purf031 where length(p031_box)=5 and p031_div matches '[Y7]*' " ;
//SqlStr="select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy@chyusc1:purf014 where length(p014_speno)=5 and p014_divno matches '[Y7]*' and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 union  select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy2@chyusc1:purf014 where length(p014_speno)=5 and p014_speno like 'Y%' union select p031_box as speno,p031_mark as sname,p031_blane as blane,p031_div as divno from cy@chyusc1:purf031 where length(p031_box)=5 and p031_div matches '[Y7]*' " ;
//SqlStr="select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy@chyusc1:purf014 where length(p014_speno)=5 and "+p014_divno+" and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 union  select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy2@chyusc1:purf014 where length(p014_speno)=5 and p014_speno like 'Y%' union select p031_box as speno,p031_mark as sname,p031_blane as blane,p031_div as divno from cy@chyusc1:purf031 where length(p031_box)=5 and "+p031_div ;
  SqlStr="select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy@chyusc1:purf014 where length(p014_speno)=5 and "+p014_divno+" and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 union  select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy2@chyusc1:purf014 where length(p014_speno)=5 and p014_speno like 'Y%' union select p031_box as speno,p031_mark as sname,p031_blane as blane,p031_div as divno from cy@chyusc1:purf031 where length(p031_box)=5 and "+p031_div+" and (p031_out is null or p031_out >=today -30)" ;
}
else
{
SqlStr="select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno "+
"from cy@chyusc1:purf014 where length(p014_speno)=5 and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 "+
"union select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno "+
"from cy2@chyusc1:purf014 where length(p014_speno)=5 and p014_speno like 'Y%' "+
"union select p031_box as speno,p031_mark as sname,p031_blane as blane,p031_div as divno "+
"from cy@chyusc1:purf031 where length(p031_box)=5 and (p031_out is null or p031_out >=today -30)" ;

	}
//out.println("Informix "+SqlStr);

NoCatch(response);
UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("500");
Grid.setForm(true); 
Grid.AddTab("專櫃選擇",1);
Grid.AddRestTab("");
Grid.AddRow("");
SelectUserStr="<select size=1 id='user' name='user'>";
if(SqlStr!="")
{
ResultSet Rs=stmt.executeQuery(SqlStr);

SelectUserStr+="<option value=''>";
while(Rs.next())
{           
	SelectUserStr+="<option value='"+Rs.getString("speno")+"'>"+Rs.getString("speno")+":"+Rs.getString("sname")+":"+Rs.getString("blane");	
}
Rs.close();

stmt.close();
conn.close();

	Grid.AddCol("請選擇專櫃","colspan=2 align=center");
	Grid.AddRow("");
	Grid.AddCol(SelectUserStr+="</select>","colspan=2 align=center");
	Grid.AddRow("input type=hidden size='20' name=no id=no  onKeyDown='if(event.keyCode==13) closeWindow();'");
	Grid.AddCol("<input type='submit' onClick='closeWindow();' value='送出'>","colspan=2 align=center");
	Grid.AddRow("");
	Grid.AddCol("<input type='submit' onClick='clearData();' value='清除資料'>","colspan=2 align=center");

//Grid.AddCol("請選擇專櫃","colspan=2 align=center");
//Grid.AddRow("");
//Grid.AddCol(SelectUserStr+="</select>","colspan=2 align=center");
//Grid.AddRow("");
//Grid.AddCol("<input type='submit' onClick='closeWindow();' value='送出'>","colspan=2 align=center");
//Grid.AddRow("");
//Grid.AddCol("<input type='submit' onClick='clearData();' value='清除資料'>","colspan=2 align=center"); //點選清除資料，會跳轉clearData()函式

}
else
{
  Grid.AddCol("無櫃位","colspan=2 align=center");
  Grid.AddRow("");
  Grid.AddCol("<input type='submit' onClick='closeWindow1();' value='確認'>","colspan=2 align=center");
Grid.AddRow("");
}

Grid.Show();
Grid=null;
%>
<iframe id='FrmTemp' src='' style='width:0;height:0' frameborder=0></iframe>
<script language="javascript">

function clearData()
{
	opener.document.getElementById('<%=Field%>').value='';                                            //使選擇的欄位值為空值
	window.close();                                                                                   //然後關閉子視窗
	}
	
function closeWindow()
{
	//var no;                                                                                           //宣告no為變數
	//no=document.getElementById('user').value;   	                                                    //no=下拉式選單的值
	
    if(document.getElementById('user').options.value=='')                                               //如果選單的值為空值，
		{alert('請選擇專櫃!!');return false;}                                                           //則跳出警告，並停止往下
		var ID=document.getElementById("user").value.split(':');                                        //宣告ID=下拉式選單的id的值，並將:切開形成陣列表示
		document.getElementById('FrmTemp').src='/cy/Checkfloor.jsp?UID='+ID[0];                         //設定跳出的視窗框架的連結為Checkfloor.jsp，並給UID的值為下拉式選單的id的第一個陣列                                                            
	
	//window.close();                                                                                   //然後關閉子視窗
	
}
function CheckOk1()
{
	var x =document.getElementById("user");
	opener.document.getElementById('<%=Field%>').value=x.options[x.selectedIndex].text;
	
	var ss=document.getElementById("no").value.split(':');
	
	
	//alert('123'+Poll+'123');
	
	var poll = ss[2].replace(/\b(0+)/gi,'');
	if(poll != '')
	{
		poll = poll+'F';
	}
	else 
	{
		poll='';
	}

	opener.document.getElementById('<%=Field1%>').value=ss[0];
	opener.document.getElementById('<%=Field2%>').value=ss[1];
	opener.document.getElementById('<%=Field3%>').value=ss[1]+','+ss[1]+'棟';
	opener.document.getElementById('<%=Field4%>').value=poll;
	opener.document.getElementById('<%=Field5%>').value=poll+','+poll;
	
	//alert(document.getElementById("no").value.split(':'));
	window.close();
	
}
function closeWindow1()
{

			window.close();
	
}
</script>
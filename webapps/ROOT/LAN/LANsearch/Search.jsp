<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %>
<%
//----------頁面顯示比數宣告-------------------------
int Page=1,PageSize=15,TTLPage=1,TTLRec=0;
//-------------日期範圍------------------------------
String D1=req("C1",request);
String D2=req("C2",request);
//--------------換頁按鈕-----------------------------
if(req("P",request)=="") Page=1; else Page=Integer.parseInt(req("P",request));
//------------防止瀏覽器快取網頁---------------------
NoCatch(response);
//-------------日期選擇範圍1補零---------------------
String FD_Data1Arr[]=null,d1="",d2="",d3="";
FD_Data1Arr=D1.split("/");
d1=FD_Data1Arr[0];
d2=String.format("%02d",  Integer.parseInt(FD_Data1Arr[1])); //將字串轉換成數字，然後再轉換成字串//強制在數字前補1個0   //1=前面0皆去除;2=沒0補1個0，有則不補;3=補2個0;依此類推
d3=String.format("%02d",  Integer.parseInt(FD_Data1Arr[2]));
//-------------日期選擇範圍2補零---------------------
String FD_Data2Arr[]=null,d4="",d5="",d6="";
FD_Data2Arr=D2.split("/");
d4=FD_Data2Arr[0];
d5=String.format("%02d",  Integer.parseInt(FD_Data2Arr[1])); 
d6=String.format("%02d",  Integer.parseInt(FD_Data2Arr[2]));
//------------宣告按鈕-------------------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//--------------宣告Grid-----------------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
//--------------MS-SQL資料庫欄位呼叫-----------------
String SqlStr="";
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select m002_no,m002_name,m002_ddate from manf002 where m002_ddate BETWEEN'"+d1+"-"+d2+"-"+d3+"' AND'"+d4+"-"+d5+"-"+d6+"' order by m002_ddate"; //依照選取日期範圍
ResultSet Rs=stmt.executeQuery(SqlStr);
//-----------------選擇表單--------------------------
Grid.AddTab("表單查詢","index.jsp",0);//(標籤名，跳轉頁面，將此標籤放在第幾個位置)
Grid.AddTab("<img src='/Modules/JFlow_FormWizard/Form_Tracert.gif'>&nbsp;搜尋結果",1);
Grid.AddRestTab(""); 
Grid.AddRow("");
//----------------標頭-------------------------------
Grid.AddRestTab(""); 
Grid.AddGridTitle("<font color ='0000FF'>"+""+"</font>","","colspan=8");
Grid.AddRow(""); 
Grid.AddGridTitle("工號","","");
Grid.AddGridTitle("姓名","","");
Grid.AddGridTitle("離職日期","","");
//------------------頁面顯示筆數Size-----------------
Grid.setDataInfo(Rs,Page,PageSize);
//-------------------判斷有無資料--------------------
if(Rs.next())
{		
	Grid.moveToPage();
	//---------------顯示資料迴圈--------------------
	for(int i=0;i<PageSize;i++)
	{
		if(Rs.isAfterLast()) break;
        //---------------工號------------------------
		Grid.AddRow("");
		Grid.AddCol(Rs.getString("m002_no"),"align=center nowrap");
		//---------------員工姓名-------------------- 
		Grid.AddCol(Rs.getString("m002_name"),"align=center nowrap");
		//---------------日期------------------------
		Grid.AddCol(Rs.getString("m002_ddate"),"align=center nowrap");        
		if(!Rs.next()) break;
				
	}
	Grid.AddRow("");
    Grid.AddCol("<input type='button' onclick='sendmail' value='將此表單發送至email'>","colspan=8 align=center nowrap");
	out.print(D1);
}   
else{
	Grid.AddRow("");
	Grid.AddRow("");
	Grid.AddCol("沒有資料","align=center colspan=8");
}
//-------------------釋放----------------------------
Rs.close();
stmt.close();
conn.close();
Grid.Show();
Grid=null;
UI=null;
%>
<script>
//var Start=new Array;
//var End=new Array;
var C1="<%=D1%>";
var C2="<%=D2%>";
</script>

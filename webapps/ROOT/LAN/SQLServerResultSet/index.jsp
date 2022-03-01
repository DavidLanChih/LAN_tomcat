<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %>
<%
//----------防止瀏覽器快取網頁------------
NoCatch(response);
//---------------宣告按鈕-----------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
String SqlStr="",FD_RecId="",FD_Data1="",FD_Data2="",FD_Data3="",FD_Data4="",FD_Data5="";
SqlStr="select * from flow_formdata where FD_FormId='274'";
Statement stmt=Conn.createStatement();                                        //內定的游標類型，只能往前移動紀錄，不能往回走

//-------------表格介面設定---------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.AddRow("");
Grid.AddCol("<B>抓取FD_FormId='274'所有資料</B>","colspan=9 align=center");
Grid.AddRow("");
Grid.AddGridTitle("<font color='blue'>使用Statement stmt=Conn.createStatement()&nbsp;&nbsp;/預設類型:只能往前移動紀錄，不能往回走/</font>","","colspan=9");
Grid.AddRow("");
Grid.AddGridTitle("表單單號","","colspan=1");
Grid.AddGridTitle("取得機台號資料","","colspan=4");
Grid.AddGridTitle("說明資料","","colspan=4");
Grid.AddRow("");
Grid.AddRow("");

//------------第一次抓取資料--------------
Grid.AddCol("&nbsp;&nbsp;使用<font color='red'>while(RS.next())</font)，抓全部資料","colspan=9 align=left"); 
Grid.AddRow("");
ResultSet Rs= stmt.executeQuery(SqlStr);
while(Rs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+Rs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+Rs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+Rs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");
}
Rs.close();

//------------第二次抓取資料--------------
Grid.AddCol("&nbsp;&nbsp;重跑，使用while(Rs1.next()){<font color='red'>if(Rs1.isFirst())</font>}，抓取第一筆資料","colspan=9 align=left"); 
Grid.AddRow("");
ResultSet Rs1= stmt.executeQuery(SqlStr);
while(Rs1.next())
{
	FD_RecId=Rs1.getString("FD_RecId");
	FD_Data5=Rs1.getString("FD_Data5");
	
	if(Rs1.isFirst())
	{
		Grid.AddCol("&nbsp;&nbsp;"+Rs1.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
		Grid.AddCol("&nbsp;&nbsp;"+Rs1.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
		Grid.AddCol("&nbsp;&nbsp;"+Rs1.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
		Grid.AddRow("");
	}
}
Rs1.close();

//------------第三次抓取資料--------------
Grid.AddCol("&nbsp;&nbsp;重跑，使用while(Rs2.next()){<font color='red'>if(Rs2.isLast())</font>}，抓取最後一筆資料","colspan=9 align=left"); 
Grid.AddRow("");
ResultSet Rs2= stmt.executeQuery(SqlStr);
while(Rs2.next())
{
	FD_RecId=Rs2.getString("FD_RecId");
	FD_Data5=Rs2.getString("FD_Data5");	
	
	if(Rs2.isLast())
	{
		Grid.AddCol("&nbsp;&nbsp;"+Rs2.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
		Grid.AddCol("&nbsp;&nbsp;"+Rs2.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
		Grid.AddCol("&nbsp;&nbsp;"+Rs2.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
		Grid.AddRow("");		
	}
}
Rs2.close();

//--------------------------------------------------------------------------------------------------------------------------------------
Statement stmtALL=Conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);    //允許ResultSet在任意形式中移動

Grid.AddGridTitle("<font color='blue'>使用Statement stmtALL=Conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);&nbsp;&nbsp;/ResultSet可任意形式中移動/</font>","","colspan=9");
Grid.AddRow("");
Grid.AddGridTitle("表單單號","","colspan=1");
Grid.AddGridTitle("取得機台號資料","","colspan=4");
Grid.AddGridTitle("說明資料","","colspan=4");
Grid.AddRow("");

ResultSet ARs= stmtALL.executeQuery(SqlStr);
Grid.AddCol("&nbsp;&nbsp;使用<font color='red'>if(ARS.next())</font>，抓第一筆資料&nbsp;&nbsp;","colspan=9 align=left"); 
Grid.AddRow("");
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}

Grid.AddCol("&nbsp;&nbsp;再次使用if(ARS.next())，抓第二筆資料&nbsp;&nbsp;","colspan=9 align=left"); 
Grid.AddRow("");
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}

Grid.AddCol("&nbsp;&nbsp;再次使用if(ARS.next())，抓第三筆資料&nbsp;&nbsp;","colspan=9 align=left"); 
Grid.AddRow("");
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}

Grid.AddCol("&nbsp;&nbsp;使用<font color='red'>ARS.first();</font>，將指標移到第一筆資料，然後再使用if(ARS.next())，抓到第二筆資料&nbsp;&nbsp;","colspan=9 align=left"); 
Grid.AddRow("");
ARs.first();
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}

Grid.AddCol("&nbsp;&nbsp;使用<font color='red'>ARS.beforeFirst();</font>，將指標移到第一筆資料前面，然後再使用if(ARS.next())，抓到第一筆資料&nbsp;&nbsp;","colspan=9 align=left"); 
Grid.AddRow("");
ARs.beforeFirst();
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}

Grid.AddCol("&nbsp;&nbsp;使用<font color='red'>ARs.absolute(2);</font>，將指標移到第二筆資料，然後再使用while(ARS.next())，抓到第3~4筆資料&nbsp;&nbsp;","colspan=9 align=left"); 
Grid.AddRow("");
ARs.absolute(2);
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}

Statement stmtUP=Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);    //允許ResultSet在任意形式中移動且修改
ResultSet UPs = stmtUP.executeQuery(SqlStr);
Grid.AddGridTitle("<font color='blue'>使用Statement stmtUP=Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);&nbsp;&nbsp;/ResultSet可任意形式中移動且修改/</font>","","colspan=9");
Grid.AddRow("");
Grid.AddGridTitle("表單單號","","colspan=1");
Grid.AddGridTitle("取得機台號資料","","colspan=4");
Grid.AddGridTitle("說明資料","","colspan=4");
Grid.AddRow("");
 
//UPs.absolute(2); //鎖定資料庫第幾筆資料
//UPs.deleteRow(); //刪除資料庫此筆資料

ARs.beforeFirst();
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}
Grid.AddCol("<input type='button' value='從資料庫刪除第一列資料' onclick='D()'","colspan=9 align=left");
%>
<script>
function D()
{
	<% 
	Grid.AddRow("");	
	Grid.AddCol("&nbsp;&nbsp;123&nbsp;&nbsp;","colspan=9 align=left"); 
	%>
	alert("123");
}
</script>
<%
//------------------釋放------------------
stmt.close();
stmtALL.close();
stmtUP.close();
ARs.close();
UPs.close();
Grid.Show();
Grid=null;
UI=null;
%>
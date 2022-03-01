<%@ include file="/kernel.jsp" %><%@ include file="/cycy2kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %>
<%
leeten.Date JDate=new leeten.Date();
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String SelectUserStr="";

String FieNam=req("FieNam",request);
String USID=req("USID",request);

ResultSet Rs=null,Rs2=null;
String Content="",SqlStr="",SqlStr2="",floor="",floorno="",speno="",Content2="",Content3="",Content4="",Content5="";
String UID=req("STRNO",request);
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
Statement stmt2 = conn2.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

	SqlStr="select  s026_mno,s026_ecr,s026_lan,p014_sname as Namep,p031_mark as Namep2 from  cy@chyusc1: salf026 left join purf014 on s026_lan = p014_speno left join purf031 on s026_lan = p031_box where s026_ecr not matches 'Z*'";
	SqlStr2="select s026_mno,s026_ecr,s026_lan,p014_sname as Namep  from cy2@chyusc1: salf026, purf014 where p014_speno = s026_lan ";
	
	NoCatch(response);
	UI.Start();
	Grid Grid=new Grid(pageContext); 
	Grid.Init();
	Grid.setGridWidth("300");
	Grid.setForm(true); 
	Grid.AddTab("機台選擇",1);
	Grid.AddRestTab("");
	Grid.AddRow("");
	SelectUserStr="<select size=1 id=user name=user>";
	if(SqlStr!=""||SqlStr2!="")
	{
		Rs=stmt.executeQuery(SqlStr);
		
		SelectUserStr+="<option value=''>";
		while(Rs.next())
		{   
			Content3=Rs.getString("s026_mno");	
			Content=Rs.getString("s026_ecr");
			 if(Rs.getString("s026_lan")!=null)
			   {
				   Content2=Rs.getString("s026_lan");
			   }
			   else
			   {
				   Content2="";
			   }
			   
			   if(Rs.getString("Namep")!=null)
			   {
				   Content4=Rs.getString("Namep");
			   }
			   else
			   {
				   Content4="";
			   }
			    if(Rs.getString("Namep2")!=null)
			   {
				   Content5=Rs.getString("Namep2");
			   }
			   else
			   {
				   Content5="";
			   }
			  
			
			SelectUserStr+="<option value='"+Content+"'>"+Content3+":"+Content2+" "+"  "+" "+Content4+" "+Content5+" ";	
				
		}
		if(SqlStr2!="")
		{
			Rs2=stmt2.executeQuery(SqlStr2);
			
			SelectUserStr+="<option value=''>";
			while(Rs2.next())
			{   
				Content3=Rs2.getString("s026_mno");	
				Content=Rs2.getString("s026_ecr");
				 if(Rs2.getString("s026_lan")!=null)
				   {
					   Content2=Rs2.getString("s026_lan");  
				   }
				   else
				   {
					   Content2="";
				   }
				   
				   if(Rs2.getString("Namep")!=null)
				   {
					   Content4=Rs2.getString("Namep");
				   }
				   else
				   {
					   Content4="";
				   }
				
				SelectUserStr+="<option value='"+Content+"'>"+Content3+":"+Content2+" "+"  "+" "+Content4+"";	
					
			}
		}
	
			
	Rs.close();Rs=null;
	stmt.close();
	conn.close();
			
	Rs2.close();Rs2=null;
	stmt2.close();
	conn2.close();

	Grid.AddCol("請選擇機台號","colspan=2 align=center");
	Grid.AddRow("");
	Grid.AddCol(SelectUserStr+="</select>","colspan=2 align=center");
	Grid.AddRow("");
	Grid.AddCol("(如下拉選單中無所需機台號，<br>請輸入機台號)<br><input type=text size='20' name=no id=no  onKeyDown='if(event.keyCode==13) closeWindow();'>","colspan=2 align=center");
    Grid.AddRow("");
	Grid.AddCol("<input type='submit' onClick='closeWindow();' value='送出'>","colspan=2 align=center");
	Grid.AddRow("");
	Grid.AddCol("<input type='submit' onClick='clearData();' value='清除資料'>","colspan=2 align=center");
	}
	else
	{
	  Grid.AddCol("無機台號","colspan=2 align=center");
	  Grid.AddRow("");
	  Grid.AddCol("<input type='submit' onClick='closeWindow1();' value='確認'>","colspan=2 align=center");
	Grid.AddRow("");
	}

Grid.Show();
Grid=null;
%>

<iframe id='FrmTemp' src='' style='width:1200;height:500' frameborder=0></iframe>
<script language="javascript">

	function clearData()
	{

		opener.document.getElementById('<%=FieNam%>').value='';
		window.close();
	}

	function closeWindow()
	{	
		if(document.getElementById('user').options.value==''&& document.getElementById('no').value=='')
		{alert('請選擇機台!!');return false;}
		if(document.getElementById('no').value!='')
		{
			var x =document.getElementById("no").value;
			
			document.getElementById('FrmTemp').src='/cy/CheckposId.jsp?UID='+x;
			
			
			
		}
		else
		{
			var x =document.getElementById("user");

			opener.document.getElementById('<%=FieNam%>').value=x.options[x.selectedIndex].text;
			window.close();
		}
		
	}
	function closeWindow1()
	{

		window.close();
		
	}
	function CheckOk()
	{
		
		opener.document.getElementById('<%=FieNam%>').value=document.getElementById('no').value;
	
		window.close();
		
	}


</script>

<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
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


String USID=req("USID",request);
String FDept=USID.substring(2,4);

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
/*
61	C8610	��~�@�B	��@�B	�Ƨ��~��
62	C8660	��~�@�B	��@�B	�W�~�]�_��
63	C8630	��~�@�B	��@�B	�y�����f��
64	C8660	��~�@�B	��@�B	��~��
65	C8650	��~�@�B	��@�B	�W�~��
67	C8670	��~�@�B	��@�B	�~�P�A����

71	C8770	��~�G�B	��G�B	�W�D�A����
72	C8760	��~�G�B	��G�B	���ˤ��Φ��
73	C8730	��~�G�B	��G�B	�K�k���f��
75	C8750	��~�G�B	��G�B	�֤k�˽�
74	C8740	��~�G�B	��G�B	�~�P�A����
78	C8780	��~�G�B	��G�B	�������~��
79	C8790	��~�G�B	��G�B	���|�����]
7A	C87A0	��~�G�B	��G�B	�����\�U��
7B	C87B0	��~�G�B	��G�B	�S���

81	C8810	��~�T�B	��T�B	�֤k�˽�
82	C88C0	��~�T�B	��T�B	�𶢹B�ʽ�
83	C8830	��~�T�B	��T�B	�~�P�A����
84	C8840	��~�T�B	��T�B	�k�˽�
85	C8850	��~�T�B	��T�B	�t�����f��
86	C8860	��~�T�B	��T�B	���˽�
87	C88C0	��~�T�B	��T�B	�B�ʤ�н�
89	C8890	��~�T�B	��T�B	�k�˵��˽�
8B	C88B0	��~�T�B	��T�B	�a�ν�


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
//20120301�]���ܤ��q��´�A�N��|�B�����զܤG�B
//SqlStr="select p014_venno as venno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy@chyusc1:purf014 where length(p014_venno)=5 and p014_divno matches '[Y7]*' and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 union  select p014_venno as venno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy2@chyusc1:purf014 where length(p014_venno)=5 and p014_venno like 'Y%' union select p031_box as venno,p031_mark as sname,p031_blane as blane,p031_div as divno from cy@chyusc1:purf031 where length(p031_box)=5 and p031_div matches '[Y7]*' " ;
//SqlStr="select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy@chyusc1:purf014 where length(p014_speno)=5 and p014_divno matches '[Y7]*' and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 union  select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy2@chyusc1:purf014 where length(p014_speno)=5 and p014_speno like 'Y%' union select p031_box as speno,p031_mark as sname,p031_blane as blane,p031_div as divno from cy@chyusc1:purf031 where length(p031_box)=5 and p031_div matches '[Y7]*' " ;
//SqlStr="select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy@chyusc1:purf014 where length(p014_speno)=5 and "+p014_divno+" and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 union  select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy2@chyusc1:purf014 where length(p014_speno)=5 and p014_speno like 'Y%' union select p031_box as speno,p031_mark as sname,p031_blane as blane,p031_div as divno from cy@chyusc1:purf031 where length(p031_box)=5 and "+p031_div ;
  SqlStr="select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy@chyusc1:purf014 where length(p014_speno)=5 and "+p014_divno+" and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 union  select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy2@chyusc1:purf014 where length(p014_speno)=5 and p014_speno like 'Y%' union select p031_box as speno,p031_mark as sname,p031_blane as blane,p031_div as divno from cy@chyusc1:purf031 where length(p031_box)=5 and "+p031_div+" and (p031_out is null or p031_out >=today -30)" ;
}
else
{
	
	SqlStr="select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy@chyusc1:purf014 where length(p014_speno)=5 and "+p014_divno+" and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 union select p031_box as speno,p031_mark as sname,p031_blane as blane,p031_div as divno from cy@chyusc1:purf031 where length(p031_box)=5 and "+p031_div+" and (p031_out is null or p031_out >=today -30)" ;
}

//9�N��|�B
//else if(FDept.equals("9")){
//	SqlStr="select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy@chyusc1:purf014 where length(p014_speno)=5 and p014_divno like '9%' and (p014_out is null or p014_out >=today -30) and p014_end >=today -30 union  select p014_speno as speno,p014_sname as sname,p014_blane as blane,p014_divno as divno from cy2@chyusc1:purf014 where length(p014_speno)=5 and p014_speno like 'Y%' union select p031_box as speno,p031_mark as sname,p031_blane as blane,p031_div as divno from cy@chyusc1:purf031 where length(p031_box)=5 and p031_div like '9%' " ;
//	}
//System.out.println("Informix "+SqlStr);

NoCatch(response);
UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("300");
Grid.setForm(true); 
Grid.AddTab("�M�d���",1);
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

Grid.AddCol("�п�ܱM�d","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol(SelectUserStr+="</select>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='closeWindow();' value='�e�X'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='clearData();' value='�M�����'>","colspan=2 align=center");

}
else
{
  Grid.AddCol("�L�d��","colspan=2 align=center");
  Grid.AddRow("");
  Grid.AddCol("<input type='submit' onClick='closeWindow1();' value='�T�{'>","colspan=2 align=center");
Grid.AddRow("");
}

Grid.Show();
Grid=null;
%>
<iframe id='FrmTemp' src='' style='width:0;height:0' frameborder=0></iframe>
<script language="javascript">

function clearData()
{
	opener.document.getElementById('<%=Field%>').value='';
	window.close();
	}
function closeWindow()
{
	var no;
	no=document.getElementById('user').value;
	
	if(document.getElementById('user').options.value=='')
	{alert('�п�ܱM�d!!');return false;}
			var x =document.getElementById("user");

			opener.document.getElementById('<%=Field%>').value=x.options[x.selectedIndex].text;
			window.close();
	
}
function closeWindow1()
{

			window.close();
	
}
function CheckOk()
{	
	opener.document.getElementById('<%=Field%>').value=x.options[x.selectedIndex].text;
	window.close();
	}
</script>
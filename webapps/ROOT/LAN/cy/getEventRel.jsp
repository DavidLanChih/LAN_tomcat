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
String Dept="",Dept1="",Dept2="",Comp="";
String Field=req("Field",request);
String USID=req("USID",request);

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select m002_comp,m002_dept from manf002,manf000 where m002_dept='"+UID+"' or m002_no='"+UUID+"'";
//System.out.println("Informix "+SqlStr);
ResultSet rs=stmt.executeQuery(SqlStr);
rs.next();


Dept=rs.getString("m002_dept");
Dept1=Dept.substring(0,3);
Dept2=Dept.substring(0,4);


Comp=rs.getString("m002_comp");
rs.close();

if(Dept1.equals("C8D"))//���������ͥd��
{
   SqlStr="select m002_name,m002_no,m002_no||m002_name as ID from manf002 where m002_dept like '"+Dept1+"%' and (m002_ddate is null or m002_ddate >=today-60) union all select m002_name,m002_no,m002_no||m002_name as ID from manf074,manf002 where m074_work_dept like '"+Dept1+"%' and m074_no=m002_no";
}
else if(Dept2.equals("C804"))//�������U�ȪA�Ȥ���
{
	SqlStr="select m002_name,m002_no,m002_no||m002_name as ID from manf002 where m002_dept like '"+Dept2+"%' and (m002_ddate is null or m002_ddate >=today-60) union all select m002_name,m002_no,m002_no||m002_name as ID from manf074,manf002 where m074_work_dept like '"+Dept2+"%' and m074_no=m002_no";
	}
else
{
	SqlStr="select m002_name,m002_no,m002_no||m002_name as ID from manf002 where m002_dept='"+Dept+"' and (m002_ddate is null or m002_ddate >=today-60) union all select m002_name,m002_no,m002_no||m002_name as ID from manf074,manf002 where m074_work_dept='"+Dept+"' and m074_no=m002_no";
}	 


//SqlStr="select m002_name,m002_no,m002_no||m002_name as ID from manf002 where m002_dept='"+Dept+"' and (m002_ddate is null or m002_ddate >=today-60) union all select m002_name,m002_no,m002_no||m002_name as ID from manf074,manf002 where m074_work_dept='"+Dept+"' and m074_no=m002_no";

//System.out.println("Informix "+SqlStr);
NoCatch(response);
UI.Start();
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.setGridWidth("200");
Grid.setForm(true); 
Grid.AddTab("�ƥ����Y�H���1",1);
Grid.AddRestTab("");
Grid.AddRow("");
SelectUserStr="<select size=1 name=user>";
ResultSet Rs=stmt.executeQuery(SqlStr);
SelectUserStr+="<option value=''>";
while(Rs.next())
{           
	SelectUserStr+="<option value='"+Rs.getString("ID")+"'>"+Rs.getString("m002_no")+":"+Rs.getString("m002_name");	
}
Grid.AddCol("�п�ܭ��u","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol(SelectUserStr+="</select>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("(�п�J�M�d�H���d��)<br><input type=text size='7' name=no   onKeyDown='if(event.keyCode==13) closeWindow();'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='closeWindow();' value='�e�X���'>","colspan=2 align=center");
Grid.AddRow("");
Grid.AddCol("<input type='submit' onClick='clearData();' value='�M�����'>","colspan=2 align=center");

Rs.close();Rs=null;
stmt.close();
conn.close();
Grid.Show();
Grid=null;
closeConn(Data,Conn);
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
	no=document.getElementById('no').value;
	var USID;
	USID='<%=USID%>';
	if(document.getElementById('user').options.value=='' && document.getElementById('no').value=='')
	{alert('�п�ܭ��u!!');return false;}
	if(document.getElementById('user').options.value!='' && document.getElementById('no').value!='')
	{alert('������ŦP�ɿ�J!!');return false;}
	if(document.getElementById('no').value!='')
	{
		document.getElementById('FrmTemp').src='/cy/CheckCountName1.jsp?UID='+no;
		//document.write('<iframe frameborder="0" name="myFrame" src="/cy/CheckCountId.jsp?UID='+no+'&Fid='+Fid+'"></iframe>');
	
	}
	else
	{
		if(document.getElementById('user').options.value.substring(0,5).trim()==USID)
		{alert('�ƥ����Y�H���o���ۤv!!');return false;}
		else
		{
			var x =document.getElementById("user");
			opener.document.getElementById('<%=Field%>').value=x.options[x.selectedIndex].text +":���u";
			//opener.document.getElementById('<%=Field%>').value=document.getElementById('user').options.value.trim()+":���u";
			window.close();
		}
	}
}
function CheckOk()
{	
	var USID;
	USID='<%=USID%>';
	if(document.getElementById('no').value==USID)
	{alert('�N�z�H���o���ۤv!!');return false;}
	else
	{
	opener.document.getElementById('<%=Field%>').value=document.getElementById('no').value;
	window.close();
	}
}
</script>
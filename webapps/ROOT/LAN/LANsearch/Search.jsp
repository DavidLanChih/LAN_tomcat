<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %>
<%
//----------������ܤ�ƫŧi-------------------------
int Page=1,PageSize=15,TTLPage=1,TTLRec=0;
//-------------����d��------------------------------
String D1=req("C1",request);
String D2=req("C2",request);
//--------------�������s-----------------------------
if(req("P",request)=="") Page=1; else Page=Integer.parseInt(req("P",request));
//------------�����s�����֨�����---------------------
NoCatch(response);
//-------------�����ܽd��1�ɹs---------------------
String FD_Data1Arr[]=null,d1="",d2="",d3="";
FD_Data1Arr=D1.split("/");
d1=FD_Data1Arr[0];
d2=String.format("%02d",  Integer.parseInt(FD_Data1Arr[1])); //�N�r���ഫ���Ʀr�A�M��A�ഫ���r��//�j��b�Ʀr�e��1��0   //1=�e��0�ҥh��;2=�S0��1��0�A���h����;3=��2��0;�̦�����
d3=String.format("%02d",  Integer.parseInt(FD_Data1Arr[2]));
//-------------�����ܽd��2�ɹs---------------------
String FD_Data2Arr[]=null,d4="",d5="",d6="";
FD_Data2Arr=D2.split("/");
d4=FD_Data2Arr[0];
d5=String.format("%02d",  Integer.parseInt(FD_Data2Arr[1])); 
d6=String.format("%02d",  Integer.parseInt(FD_Data2Arr[2]));
//------------�ŧi���s-------------------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//--------------�ŧiGrid-----------------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
//--------------MS-SQL��Ʈw���I�s-----------------
String SqlStr="";
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select m002_no,m002_name,m002_ddate from manf002 where m002_ddate BETWEEN'"+d1+"-"+d2+"-"+d3+"' AND'"+d4+"-"+d5+"-"+d6+"' order by m002_ddate"; //�̷ӿ������d��
ResultSet Rs=stmt.executeQuery(SqlStr);
//-----------------��ܪ��--------------------------
Grid.AddTab("���d��","index.jsp",0);//(���ҦW�A���୶���A�N�����ҩ�b�ĴX�Ӧ�m)
Grid.AddTab("<img src='/Modules/JFlow_FormWizard/Form_Tracert.gif'>&nbsp;�j�M���G",1);
Grid.AddRestTab(""); 
Grid.AddRow("");
//----------------���Y-------------------------------
Grid.AddRestTab(""); 
Grid.AddGridTitle("<font color ='0000FF'>"+""+"</font>","","colspan=8");
Grid.AddRow(""); 
Grid.AddGridTitle("�u��","","");
Grid.AddGridTitle("�m�W","","");
Grid.AddGridTitle("��¾���","","");
//------------------������ܵ���Size-----------------
Grid.setDataInfo(Rs,Page,PageSize);
//-------------------�P�_���L���--------------------
if(Rs.next())
{		
	Grid.moveToPage();
	//---------------��ܸ�ưj��--------------------
	for(int i=0;i<PageSize;i++)
	{
		if(Rs.isAfterLast()) break;
        //---------------�u��------------------------
		Grid.AddRow("");
		Grid.AddCol(Rs.getString("m002_no"),"align=center nowrap");
		//---------------���u�m�W-------------------- 
		Grid.AddCol(Rs.getString("m002_name"),"align=center nowrap");
		//---------------���------------------------
		Grid.AddCol(Rs.getString("m002_ddate"),"align=center nowrap");        
		if(!Rs.next()) break;
				
	}
	Grid.AddRow("");
    Grid.AddCol("<input type='button' onclick='sendmail' value='�N�����o�e��email'>","colspan=8 align=center nowrap");
	out.print(D1);
}   
else{
	Grid.AddRow("");
	Grid.AddRow("");
	Grid.AddCol("�S�����","align=center colspan=8");
}
//-------------------����----------------------------
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

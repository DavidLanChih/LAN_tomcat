<%@ include file="/kernel.jsp" %><%@page import="leeten.*" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=MS950" %>
<%!
int g_SolarMonth[]={31,28,31,30,31,30,31,31,30,31,30,31};

public int SolarDays(int xYear,int xMonth)
{
   int Days = g_SolarMonth[xMonth];
   if(xMonth == 2)
   {
      if ((xYear % 4 == 0) && (xYear % 100 != 0) || (xYear % 400 == 0)) {Days = 29;}      //�p��2��O�_���|�몺�覡
   }
   return Days;
}
%>
<%
//----------------�ŧi----------------------
leeten.Date JDate=new leeten.Date();
String SqlStr="";
String CurrDate="",StartDate="",EndDate="";
int i=0;
Date Now = new Date();

CurrDate=req("D",request);
if(CurrDate.equals("")) CurrDate=JDate.ToDay();
String DateArr[]=CurrDate.split("/");
String PYear=DateArr[0];
String PMonth=DateArr[1];
String PDay=DateArr[2];
String days[]=new String[42];  
int Days=0;

for(i=0;i<42;i++)  
{  
    days[i]="";   
}  

Days=SolarDays(Integer.parseInt(PYear),Integer.parseInt(PMonth)-1);
StartDate=PYear+"/"+PMonth+"/1";
EndDate=PYear+"/"+PMonth+"/"+Days;

//--------�����s�����֨�����-----------------
NoCatch(response);
//------------�ŧi���s----------------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//------------MS SQL�]�w-----------------------------
String SelectUserStr="";
ResultSet Rs=null;
SqlStr="select UD_ID,OrgName from Org where UD_ID NOT like 'cy%' and UD_ID<>'' and UD_ID = substring( UD_ID, 1, 5 ) and UD_ID NOT like 'p%' and UD_ID NOT like 'x%'";
//out.println(SqlStr);
Rs=Data.getSmt(Conn,SqlStr);
//-------------�ŧiGrid-------------------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.AddRow("");
//----------------����d��(�_�l��ε�����)------------------------------
Grid.AddGridTitle("�ӿ����G","",""); 
Grid.AddCol("<input type=text name=Year1 id=Year1 value='"+StartDate+"' onclick=\"calendar(this);\" readonly maxlength=10 size=10> ~ <input type=text name=Month1 id=Month1 value='"+EndDate+"' onclick=\"calendar(this);\" readonly maxlength=10 size=10>","colspan=7 rowspan=1 align=left");  
Grid.AddRow("");
//------------------�ӽг檬�A(�U�Ԧ����)----------------------------
Grid.AddGridTitle("���A�G","","");
Grid.AddCol("<select size=1 name='Status' id='Status'><option value=>�п��</option><option value=0>�ӽФ�</option><option value=1>�q�L</option><option value=2>�h��</option><option value=3>���</option></select>","colspan=7 rowspan=1 align=left");
Grid.AddRow("");
//-----------------(�T�w)���s-----------------------
Grid.AddCol(UI.addButtonForSubmit()+"<input type=hidden name='Button' value='new'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;","colspan=2 rowspan=8 align=center");
Grid.setForm(true); 
Grid.setFormAction("Search.jsp");
//-----------------(�ץXExcel)���s-----------------------
Grid.AddCol("<input type='button' name='op' onclick='printExcel(253)' value='���K���ץXExcel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;","colspan=2 rowspan=8 align=center");
Grid.AddCol("<input type='button' name='op' onclick='printExcel_1(253)' value='�h�˼Ҫ��ץXExcel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;","colspan=2 rowspan=8 align=center");
Grid.AddCol("<input type='button' name='op' onclick='printExcel_2(253)' value='����]�w���ץXExcel'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;","colspan=2 rowspan=8 align=center");
Grid.setForm(true); 
Grid.AddRow("");
//------------------����-----------------------------
Rs.close();Rs=null;
Grid.Show();
Grid=null;
UI=null;
closeConn(Data,Conn);
%>

<script>

function printExcel(num)                                                 //����EXCEL
{
	var Year1=document.getElementById("Year1").value;                    //�_�l���
	var Month1=document.getElementById("Month1").value;                  //�������
	var Fcategory="";

    if(num=="253")                                                       //�N�ܼ��ഫ���ҲեN�X�W�١A�s�bFcategory
	{
		 Fcategory="JFlow_Form_253";
	}
			
	window.open("Report_Print.jsp?SDate="+Year1+"&EDate="+Month1+"&Fcategory="+Fcategory, "",'width=900,height=1200,toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
}

function printExcel_1(num)                                               //����EXCEL
{
	var Year1=document.getElementById("Year1").value;                    //�_�l���
	var Month1=document.getElementById("Month1").value;                  //�������
	var Fcategory="";

    if(num=="253")                                                       //�N�ܼ��ഫ���ҲեN�X�W�١A�s�bFcategory
	{
		 Fcategory="JFlow_Form_253";
	}
			
	window.open("Report_Print_1.jsp?SDate="+Year1+"&EDate="+Month1+"&Fcategory="+Fcategory, "",'width=900,height=1200,toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
}

function printExcel_2(num)                                               //����EXCEL
{
	var Year1=document.getElementById("Year1").value;                    //�_�l���
	var Month1=document.getElementById("Month1").value;                  //�������
	var S=document.getElementById("Status");
	var Status=S.options[S.selectedIndex].value;
	var Fcategory="";

    if(num=="253")                                                       //�N�ܼ��ഫ���ҲեN�X�W�١A�s�bFcategory
	{
		 Fcategory="JFlow_Form_253";
	}
			
	window.open("Report_Print_2.jsp?SDate="+Year1+"&EDate="+Month1+"&Fcategory="+Fcategory+"&Status="+Status, "",'width=900,height=1200,toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
}
</script>

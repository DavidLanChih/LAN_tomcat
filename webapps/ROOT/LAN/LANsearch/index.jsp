<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %>
<%!
int g_SolarMonth[]={31,28,31,30,31,30,31,31,30,31,30,31};
public int SolarDays(int xYear,int xMonth)                                               //�M��w�]�榡(���̫�@�Ѫ����)
{
   int Days = g_SolarMonth[xMonth];
   if(xMonth == 2)
   {
      if ((xYear % 4 == 0) && (xYear % 100 != 0) || (xYear % 400 == 0)) {Days = 29;}     //�p��2��O�_���|�몺�覡
   }
   return Days;
}
%>
<%
//-----�ŧi���------------------------------
leeten.Date JDate=new leeten.Date();
String CurrDate="";
CurrDate=JDate.ToDay();
String DateArr[]=CurrDate.split("/"),PYear=DateArr[0],PMonth=DateArr[1],PDay=DateArr[2];
//-----(�ܧ������:�e�@�Ӥ몺"��")---------
int Days=0;
int iPMonth=Integer.parseInt(PMonth);                                                    //�N�r��(���)PMonth�ন���(���)iPMonth
int iBMonth=iPMonth-1;                                                                   //�N���-1
String sBMonth=Integer.toString(iBMonth);                                                //�N���(�e�Ӥ�)iBMonth�ন�r��(�e�Ӥ�)sBMonth
//-----(�ܧ������:�e�@�Ӥ몺"��")---------
Days=SolarDays(Integer.parseInt(PYear),Integer.parseInt(PMonth)-1);                      //"��"�ϥήM��榡
int iPYear= Integer.parseInt(PYear);                                                     //�N�r��(��~)PYear�ন���(��~)iPYear
if (Days==31)
	{
		Days=30;
	}
else if (Days==30)
	{
		Days=31;
	}
else if (Days==28||Days==29)
	{
		Days=31;
	}
else if ((Days==31&&iPMonth==3&&iPYear%4==0&&iPYear%100!=0)||(Days==31&&iPMonth==3&&iPYear%400==0))
	{
		Days=29;
	}
else if (Days==31&&iPMonth==3)
	{
		Days=28;
	}
//-----���������(�e�@�Ӥ몺"�~/��/��")----
String StartDate="",EndDate="";
StartDate=PYear+"/"+sBMonth+"/1";
EndDate=PYear+"/"+sBMonth+"/"+Days;
//-----�����s�����֨�����--------------------
NoCatch(response);
//-----�ŧi���s------------------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//-----�ŧiGrid------------------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.AddRow("");
//-----����d��(�_�l��ε�����)--------------
Grid.AddGridTitle("<font size=2>�d�ߴ����G</font>","","colspan=6 rowspan=1 align=center"); 
Grid.AddCol("<input type='text' name='C1' id='C1' value='"+StartDate+"' onclick=\"calendar(this);\" readonly maxlength=10 size=20 > ~ <input type='text' name='C2' id='C2' value='"+EndDate+"' onclick=\"calendar(this);\" readonly maxlength=10 size=20>&nbsp;&nbsp;&nbsp;&nbsp;"+UI.addButtonForSubmit("�d�ߵ��G")+"<input type='hidden' name='Button' value='new'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='button' name='mail' value='�o�eE-mail' onclick='sendmail()'>","colspan=2 rowspan=1 align=left");  
Grid.AddRow("");
//-----(�d�ߵ��G)���s+(�o�eE-mail)���s------------------------
Grid.setForm(true); 
Grid.setFormAction("Search.jsp");
//-----����----------------------------------
Grid.Show();
Grid=null;
UI=null;
%>
<script>

//var Start=new Array;
//var End=new Array;
var C1=document.getElementById("C1").value;
var C2=document.getElementById("C2").value;

//Start=C1.split("/");
//End=C2.split("/");

function sendmail()
{
	//window.open("S_mw0505.jsp?d1="+Start[0]+"&d2="+Start[1]+"&d3="+Start[2]+"&d4="+End[0]+"&d5="+End[1]+"&d6="+End[2]+"","��¾�H�����","width=1200,height=1000,scrollbar=1");
	window.open("S_mw0505.jsp?D1="+C1+"&D2="+C2+"","��¾�H�����","width=1200,height=1000,scrollbar=1");
	alert(C1+"\n"+C2);
	
}
	
</script>
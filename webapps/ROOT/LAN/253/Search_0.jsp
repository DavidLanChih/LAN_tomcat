<%@ include file="/kernel.jsp" %><%@page import="leeten.*" %>
<%@page import="java.net.*,java.lang.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat,java.sql.*,java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=MS950" %>
<%
//----------------�ŧi-----------------------------------
String OP="",Site="index.jsp",UpdateLink="";
String SqlStr="",SqlStr2="",UserNo="",UserName="",ADYear="",yadd="",Seniority="",Mark="";
String FD_Data1Arr[]=null;
String FD_Data2Arr[]=null;
String FD_Data1="",FD_Data3="",FD_Data2="",FD_Data5="",FD_Data4="",FD_Data8="",FD_RecDate="";
ResultSet Rs=null;
//----------������ܤ�ƫŧi-------------------------
int Page=1,PageSize=15,TTLPage=1,TTLRec=0;
String ReApply="",DeleteFunction="",CancelStr="";
//------------�����ȫŧi------------------------------

//-------------����d��-----------------------
String Year1=req("Year1",request);
String Year2=req("Month1",request);
//---------------�ӽг檬�A-------------------
String Status=req("Status",request);
//--------------�������s---------------------
if(req("P",request)=="") Page=1; else Page=Integer.parseInt(req("P",request));
//------------�����s�����֨�����-----------------
NoCatch(response);
//-----------------------------------------------
//-------------�����ܽd��1�ɹs-----------------------------

String d1="",d2="",d3="";
FD_Data1Arr=Year1.split("/");
d1=FD_Data1Arr[0];
d2=String.format("%02d",  Integer.parseInt(FD_Data1Arr[1]));
d3=String.format("%02d",  Integer.parseInt(FD_Data1Arr[2]));

//-------------�����ܽd��2�ɹs------------------------

String d4="",d5="",d6="";
FD_Data2Arr=Year2.split("/");
d4=FD_Data2Arr[0];
d5=String.format("%02d",  Integer.parseInt(FD_Data2Arr[1]));
d6=String.format("%02d",  Integer.parseInt(FD_Data2Arr[2]));

//------------------------------------------
Date Now = new Date();
NoCatch(response);
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//--------------�ŧiGrid------------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
//------------------MS-SQL��Ʈw���I�s--------------------------
SqlStr="select FR_RecId,FD_OrgId,FR_FormId,FR_DataId,FD_FormId,FD_Data1,FD_Data2,FD_Data3,FD_Data4,FD_Data5,FD_Data8,FD_Data9,FR_FinishState from flow_formdata,flow_form_rulestage where flow_formdata.FD_RecId="+"flow_form_rulestage.FR_DataId and flow_formdata.FD_FormId IN ('232','235','237')"+"and (CONVERT(varchar(10),CONVERT(datetime,FD_Data1,111),111)  BETWEEN  '"+d1+"/"+d2+"/"+d3+"' and '"+d4+"/"+d5+"/"+d6+"')";
//��X�Ҳ�ID=232,235,237���U�����Ǹ�����줺�e���
//out.println();


//------------------�ӽг檬�A------------------------------------
if(Status!=""){
SqlStr+="and (FR_FinishState = '"+Status+"')";
}


//-----------------------------------------------------------------
//out.println(SqlStr);
//out.flush();
Rs=Data.getSmt(Conn,SqlStr);

//-----------------��ܪ��-------------------------------
Grid.AddTab("���d��","index.jsp",0);
Grid.AddTab("<img src='/Modules/JFlow_FormWizard/Form_Tracert.gif'>&nbsp;�d�ߵ��G",1);
Grid.AddRestTab(""); 
Grid.AddRow("");
//----------------���Y----------------------------
Grid.AddRestTab(""); 
Grid.AddGridTitle("<font color ='0000FF'>"+""+"</font>","","colspan=8");
Grid.AddRow(""); 
Grid.AddGridTitle("����","","");
Grid.AddGridTitle("�ӿ�H","","");;
Grid.AddGridTitle("�ӿ���","","");
Grid.AddGridTitle("������O","","");
Grid.AddGridTitle("���x��","","");
Grid.AddGridTitle("�ӽЪ��A","","");
//------------------������ܵ���Size-------------------------------
Grid.setDataInfo(Rs,Page,PageSize);
//-------------------�P�_���L���---------------------------
if(Rs.next())
{		
	Grid.moveToPage();
	//---------------��ܸ�ưj��----------------------------
	for(int i=0;i<PageSize;i++)
	{
		if(Rs.isAfterLast()) break;
		ReApply="";DeleteFunction="";CancelStr="";
        Grid.AddRow("");
        Grid.AddCol(Grid.getGridSN(i),"align=center nowrap");                                        //�Ĥ@��(����)�ҧe�{���
		//---------------�ӿ�H------------------
		FD_Data2Arr=Rs.getString("FD_Data5").split(",");
		FD_Data5=FD_Data2Arr[1];
		Grid.AddCol(FD_Data5,"align=center nowrap");                                                 //�ĤG��(�ӿ�H)�ҧe�{���
		//--------------�ӿ���-----------------
		Grid.AddCol(Rs.getString("FD_Data1"),"align=center nowrap");                                 //�ĤT��(�ӿ���)�ҧe�{���
		//--------------������O-----------------
		FD_Data3=Rs.getString("FD_FormId");
		if(FD_Data3.equals("232"))
		{
			Grid.AddCol("�I�ڽվ�","align=center nowrap");                                           //�ĥ|��(������O)�ҧe�{���
		}else if(FD_Data3.equals("235"))
			{
				Grid.AddCol("�H�Υd�b��","align=center nowrap");
			}else if(FD_Data3.equals("237")){
				Grid.AddCol("�o��(�M����)","align=center nowrap");
			}
		
		//---------------���x��--------------------	
		Grid.AddCol(Rs.getString("FD_Data2"),"align=center nowrap");                                 //�Ĥ���(���x��)�ҧe�{���
		//--------------�������-----------------
		/*FD_Data1Arr=Rs.getString("FD_Data8").split(",");
		FD_Data8=FD_Data1Arr[1];
		Grid.AddCol(FD_Data8,"align=center nowrap");	*/                                           //�Ĥ���ҧe�{���
		//--------------�ӽЪ��A-------------------
		Mark=Rs.getString("FR_FinishState");
		if(Mark==null)Grid.AddCol("","align=center nowrap");			                             //�ĤC��ҧe�{���
			else if(Mark.equals(""))Grid.AddCol("","align=center nowrap");
			else if(Mark.equals("0"))Grid.AddCol("�ӽФ�","align=center nowrap");
			else if(Mark.equals("1"))Grid.AddCol("�q�L","align=center nowrap");
			else if(Mark.equals("2"))Grid.AddCol("�h��","align=center nowrap");
			else if(Mark.equals("3"))Grid.AddCol("���","align=center nowrap");		
		//-------------���ﶵ(�U��,���e,���d)------------------
		Grid.AddRow("");
		//Grid.AddCol("&nbsp;&nbsp;<img src='/Modules/JFlow_FormWizard/form.png' border=0>&nbsp;<a href='javascript:perViewForm("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'>�ӽФ��e</a>&nbsp;&nbsp;&nbsp;<img src='/images/view.gif' border=0>&nbsp;<a href='javascript:perViewStage("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'>�i���˵�</a>","align=right nowrap  colspan=8");
		Grid.AddCol("&nbsp;&nbsp;<img src='/Modules/JFlow_FormWizard/form.png' border=0>&nbsp;<a href='javascript:ProcEditEvent("+Rs.getString("FR_RecId")+","+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+","+Rs.getString("FD_OrgId")+")'>�ӽФ��e</a>&nbsp;&nbsp;&nbsp;<img src='/images/view.gif' border=0>&nbsp;<a href='javascript:perViewStage("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'>�i���˵�</a>","align=right nowrap  colspan=8");                         //�ĤK��ҧe�{���
		//-------------------------------------------
		if(!Rs.next()) break;		
	}
}   
else{
	Grid.AddRow("");
	Grid.AddRow("");
	Grid.AddCol("�S�����","align=center colspan=8");
}
//-------------------����-------------------------
Rs.close();Rs=null;
Grid.Show();
Grid=null;
UI=null;
closeConn(Data,Conn);
%>
<iframe id='FrmTemp' src='' style='width:0;height:0' frameborder=0></iframe>
<script>
//--------------------------�U���ɮ�--------------------------------------------------
function perPrintForm(FR_FormId,FR_DataId)
{
   window.open("/Modules/ServiceFormCheck8/Form_Apply_Content_Print1.jsp?FI_RecId="+FR_FormId+"&FD_RecId="+FR_DataId, "��|��x",'width=900,height=1200,toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
}
//--------------------------�ɮפ��e--------------------------------------------------
function perViewForm(FR_FormId,FR_DataId)
{
   var OK=popDialog('perViewForm','/Modules/ServiceFormCheck8/Form_Apply_ContentWang1.jsp?OP=View&FI_RecId='+FR_FormId+'&FD_RecId='+FR_DataId,screen.availWidth*0.8,587);   
}  

function ProcEditEvent(FR_RecId,FR_FormId,FR_DataId,FD_OrgId)
{
   var OK=popDialog('EditEvent','/Modules/ServiceFormCheck8/Report_Check_Content.jsp?OP=hasCheck&FR_RecId='+FR_RecId+'&FI_RecId='+FR_FormId+'&FD_RecId='+FR_DataId+'&OrgId='+FD_OrgId,screen.availWidth*0.8,800);

} 
//--------------------------�i���˵�--------------------------------------------------
function perViewStage(FR_FormId,FR_DataId)
{
    var OK=popDialog('perViewStage','/Modules/ServiceFormCheck8/Form_Apply_FinishWang1.jsp?OP=View&FId='+FR_FormId+'&FDId='+FR_DataId,screen.availWidth*0.8,400);       
}

</script>

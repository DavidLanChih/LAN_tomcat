<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950"%>
<%
//-----------������ܤ�ƫŧi--------------
int Page=1,PageSize=15,TTLPage=1,TTLRec=0;
//-----------���o�����------------------
String D1=req("T1",request);                          //���o�}�l���
String D2=req("T2",request);                          //���o�������
String Status=req("Status",request);                  //���o�d�ߪ��A
//-----------�������s----------------------
if(req("P",request)=="") Page=1; else Page=Integer.parseInt(req("P",request));
//-----------�����s�����֨�����------------
NoCatch(response);
//-----------�����ܽd��1�ɹs-------------
String FD_Data1Arr[]=null,d1="",d2="",d3="";
FD_Data1Arr=D1.split("/");
d1=FD_Data1Arr[0];
d2=String.format("%02d",  Integer.parseInt(FD_Data1Arr[1])); 
d3=String.format("%02d",  Integer.parseInt(FD_Data1Arr[2]));
//-----------�����ܽd��2�ɹs-------------
String FD_Data2Arr[]=null,d4="",d5="",d6="";
FD_Data2Arr=D2.split("/");
d4=FD_Data2Arr[0];
d5=String.format("%02d",  Integer.parseInt(FD_Data2Arr[1])); 
d6=String.format("%02d",  Integer.parseInt(FD_Data2Arr[2]));
//-----------�ŧi���s----------------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
//-----------�ŧiGrid----------------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
//-----------MS-SQL��Ʈw���I�s----------
String SqlStr="";
ResultSet Rs=null;
SqlStr="select FR_RecId,FD_OrgId,FR_FormId,FR_DataId,FD_FormId,FD_Data1,FD_Data3,FD_Data4,FD_Data5,FD_Data15,FR_FinishState,FD_RecDate from flow_formdata,flow_form_rulestage where flow_formdata.FD_RecId="+
"flow_form_rulestage.FR_DataId and flow_formdata.FD_FormId = '207'"+
"and (CONVERT(varchar(10),CONVERT(datetime,FD_Data2,111),111)  BETWEEN  '"+d1+"/"+d2+"/"+d3+"' and '"+d4+"/"+d5+"/"+d6+"')"; 
//-----------���o�ӽг檬�A----------------
if(Status!="")
{
	SqlStr+="and (FR_FinishState = '"+Status+"')";
}
Rs=Data.getSmt(Conn,SqlStr);
//-----------��ܪ��----------------------
Grid.AddTab("���d��","index.jsp",0);
Grid.AddTab("<img src='/Modules/JFlow_FormWizard/Form_Tracert.gif'>&nbsp;�j�M���G",1);
Grid.AddRestTab(""); 
Grid.AddRow("");
//-----------���Y--------------------------
Grid.AddRestTab(""); 
Grid.AddGridTitle("<font color ='0000FF'>���C���̤W��C(�i�]�w�U����즳�X��)"+""+"</font>","","colspan=8");
Grid.AddRow(""); 
Grid.AddGridTitle("����","","");
Grid.AddGridTitle("���ɤH","","");
Grid.AddGridTitle("�ӽнs��","","");
Grid.AddGridTitle("�ӽ����O","","");
Grid.AddGridTitle("�D��","","");
Grid.AddGridTitle("�f�֧_","","");
Grid.AddGridTitle("�ӽЪ��A","","");
Grid.AddGridTitle("�ӽЮɶ�","","");
//-----------������ܵ���Size--------------
Grid.setDataInfo(Rs,Page,PageSize);
//-----------�P�_���o�������--------------
	if(Rs.next())
	{			
		Grid.moveToPage();
		//---------------��ܸ�ưj��-------------------
		for(int i=0;i<PageSize;i++)
		{
			if(Rs.isAfterLast()) break;
			Grid.AddRow("");
			//-----------����---------------------------
			Grid.AddCol(Grid.getGridSN(i),"align=center nowrap");
			//-----------���ɤH-------------------------
			String build[]=null;
			build=Rs.getString("FD_Data1").split(",");
			String buildman=build[1];
			Grid.AddCol(buildman,"align=center nowrap");
			//-----------�ӽнs��-----------------------
			Grid.AddCol(Rs.getString("FD_Data3"),"align=center nowrap");
			//-----------�ӽ����O-----------------------
			String applytype[]=null;
			applytype=Rs.getString("FD_Data4").split(",");
			String AT=applytype[1];
			Grid.AddCol(AT,"align=center nowrap");  
			//-----------�D��---------------------------
			Grid.AddCol(Rs.getString("FD_Data5"),"align=center nowrap"); 
			//-----------�Ĥ����f�ֶ�gN��Y-------------
			String Judge[]=null;
			Judge=Rs.getString("FD_Data15").split(",");
			String J=Judge[0];
			Grid.AddCol(J,"align=center nowrap"); 
			//-----------�ӽЪ��A-----------------------
			String Mark="";
			Mark=Rs.getString("FR_FinishState");
			if(Mark.equals("")||Mark==null){Grid.AddCol("","align=center nowrap");}
			else if(Mark.equals("0")){Grid.AddCol("�ӽФ�","align=center nowrap");}
			else if(Mark.equals("1")){Grid.AddCol("�w�f��","align=center nowrap");}
			else if(Mark.equals("2")){Grid.AddCol("�h��","align=center nowrap");}
			else if(Mark.equals("3")){Grid.AddCol("���","align=center nowrap");}
			//-----------�ӽЮɶ�-----------------------
			String applydate[]=null;
			applydate=Rs.getString("FD_RecDate").split(" ");
			String AD1=applydate[0];
			String AD2=applydate[1];
			String AD2_1=AD2.substring(0,8);          //�u��(��:��:��)
			Grid.AddCol(AD1+"<br>"+AD2_1,"align=center nowrap");
			//-----------���ﶵ(�U��,���e,���d)-------
			Grid.AddRow("");
			Grid.AddCol("&nbsp;&nbsp;<img src='/Modules/JFlow_FormWizard/form.png' border=0>&nbsp;<a href='javascript:ProcEditEvent("+Rs.getString("FR_RecId")+","+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+","+Rs.getString("FD_OrgId")+")'>�ӽФ��e</a>&nbsp;&nbsp;&nbsp;<img src='/images/view.gif' border=0>&nbsp;<a href='javascript:perViewStage("+Rs.getString("FR_FormId")+","+Rs.getString("FR_DataId")+")'>�i���˵�</a>","align=right nowrap  colspan=8");
			//------------------------------------------
			if(!Rs.next()) break;
		}				
	}
	else
	{
		Grid.AddRow("");
		Grid.AddRow("");
		Grid.AddCol("�S�����","align=center colspan=8");
	}
Grid.Show();	
//-----------����--------------------------
Rs.close();
Conn.close();
Grid=null;
UI=null;
%>
<script>
//-----------�ɮפ��e----------------------
function perViewForm(FR_FormId,FR_DataId)
{
	var OK=popDialog('perViewForm','/Modules/ServiceFormCheck9/Form_Apply_ContentWang1.jsp?OP=View&FI_RecId='+FR_FormId+'&FD_RecId='+FR_DataId,screen.availWidth*0.8,587);   
}  
function ProcEditEvent(FR_RecId,FR_FormId,FR_DataId,FD_OrgId)
{
	var OK=popDialog('EditEvent','/Modules/ServiceFormCheck9/Report_Check_Content.jsp?OP=hasCheck&FR_RecId='+FR_RecId+'&FI_RecId='+FR_FormId+'&FD_RecId='+FR_DataId+'&OrgId='+FD_OrgId,screen.availWidth*0.8,800);
} 
//-----------�i���˵�----------------------
function perViewStage(FR_FormId,FR_DataId)
{
	var OK=popDialog('perViewStage','/Modules/ServiceFormCheck9/Form_Apply_FinishWang1.jsp?OP=View&FId='+FR_FormId+'&FDId='+FR_DataId,screen.availWidth*0.8,400);       
}
</script>

<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
ResultSet Rs=null;
leeten.Date JDate=new leeten.Date();
String SqlStr="";
String OrgId=req("OrgId",request);//�ѳ]�ƶǤJ

String RecId=req("RecId",request);
String isAllChecked=req("isAllChecked",request);
String SD=req("SD",request);
String ED=req("ED",request);
String ST=req("ST",request);
String ET=req("ET",request);
String RecIdStr="";
boolean hasChoosed=false,isEnable=false;

if(!RecId.equals("")) RecIdStr=" and J_RecId<>"+Data.toSql(RecId)+" ";

SqlStr="Select isEnable from Org where OrgId="+OrgId+" limit 1";
Rs=Data.getSmt(Conn,SqlStr);
if(Rs.next())
{
	if(Rs.getString("isEnable").equals("1")) isEnable=true;
}

if(isEnable)
{
	if(isAllChecked.equals("1"))//���
	{
		SqlStr ="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and J_StartDate<='"+Data.toSql(SD)+"' and J_EndDate>='"+Data.toSql(SD)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and J_StartDate<='"+Data.toSql(ED)+"' and J_EndDate>='"+Data.toSql(ED)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and J_StartDate>='"+Data.toSql(SD)+"' and J_EndDate<='"+Data.toSql(ED)+"') limit 1";
	}else if(SD.equals(ED))//���w��������P�@��
	{
		//���p1: �w������� 1��2�餶�� 1/1 ~ 1/5���� ,�h1/2�w�Q�w�q
		//���p2: �w������� 1��1��(��1��5��) 13:00~14:00 ,�H 1/1 ~ 1/5���� ,�h�P�_ 1/1(��1/5)�� 13:00~14:00�O�_�Q�w�q
		SqlStr ="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate<'"+Data.toSql(SD)+"' and J_EndDate>'"+Data.toSql(SD)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and (J_StartDate='"+Data.toSql(SD)+"' or  J_EndDate='"+Data.toSql(SD)+"') and J_StartTime<='"+Data.toSql(ST)+"' and J_EndTime>'"+Data.toSql(ST)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and (J_StartDate='"+Data.toSql(SD)+"' or  J_EndDate='"+Data.toSql(SD)+"') and J_StartTime<'"+Data.toSql(ET)+"' and J_EndTime>='"+Data.toSql(ET)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and (J_StartDate='"+Data.toSql(SD)+"' or  J_EndDate='"+Data.toSql(SD)+"') and J_StartTime>'"+Data.toSql(ST)+"' and J_EndTime<'"+Data.toSql(ET)+"') limit 1";
	}else if(!SD.equals(ED))//���w����������P�@��
	{
		//���p1: �w������� �}�l��:1��2�餶�� 1/1 ~ 1/5���� ,�h1/2�w�Q�w�q
		//���p2: �w������� ������:1��2�餶�� 1/1 ~ 1/5���� ,�h1/2�w�Q�w�q
		//���p3: �w������� 1��1��~1��3��, �H 1/1 ~ 1/5���� (�w���_�鬰��ư_��),�h�w�Q�w�� (�Y��ƫD����,�h���P�_�w���_�餧�ɶ�,�H���p4����)
		//���p4: �w������� 1��1��~1��3��, �H 1/1 ~ 1/1���� (�w���_�鬰��ư_��=����),�h���P�_�w���_�餧�ɶ� "�}�l�ɶ�" �O�_�����ƪ� "�_���ɶ�"
		//���p5: �w������� 1��5��~1��7��, �H 1/1 ~ 1/5���� (�w���_�鬰��ƨ���),�h���P�_�w���_�餧�ɶ� "�}�l�ɶ�" �O�_�p���ƪ� "���骺�����ɶ�"
		//���p6: �w������� 1��1��~1��3��, �H 1/3 ~ 1/5���� (�w�����鬰��ư_��),�h���P�_�w�����餧�ɶ� "�����ɶ�" �O�_�j���ƪ� "�_�骺�}�l�ɶ�"
		//���p7: �w������� 1��1��~1��3��, �H 1/3 ~ 1/3���� (�w�����鬰��ư_��=����),�h���P�_�w�����餧�ɶ� "�����ɶ�" �O�_�����ƪ� "�_���ɶ�"
		//���p8: �w������� 1��3��~1��5��, �H 1/1 ~ 1/5���� (�w�����鬰��ƨ���),�h�w�Q�w�� (�Y��ƫD����,�h���P�_�w�����餧�ɶ�,�H���p7����)
		//���p9: �w������� 1��1��~1��5��, �H 1/2 ~ 1/3���� (�w���_����]�t��ư_����),�h�w�Q�w��
	
		
		SqlStr ="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate<'"+Data.toSql(SD)+"' and J_EndDate>'"+Data.toSql(SD)+"')   union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate<'"+Data.toSql(ED)+"' and J_EndDate>'"+Data.toSql(ED)+"')   union";
	
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate='"+Data.toSql(SD)+"' and J_StartDate<>J_EndDate)           union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate='"+Data.toSql(SD)+"' and J_StartDate=J_EndDate      and J_StartTime<'"+Data.toSql(ST)+"' and J_EndTime>'"+Data.toSql(ST)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_EndDate='"+Data.toSql(SD)+"'   and J_EndTime>'"+Data.toSql(ST)+"')   union";
	
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate='"+Data.toSql(ED)+"' and J_StartTime<'"+Data.toSql(ET)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate='"+Data.toSql(ED)+"' and J_StartDate=J_EndDate      and J_StartTime<'"+Data.toSql(ET)+"' and J_EndTime>'"+Data.toSql(ET)+"') union";
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_EndDate='"+Data.toSql(ED)+"'   and J_StartDate<>J_EndDate)           union";
	
		SqlStr+="(select J_RecId from J_Job where J_Type=7 "+RecIdStr+" and J_OrgId="+Data.toSql(OrgId)+" and  J_StartDate>'"+Data.toSql(SD)+"' and J_StartDate<'"+Data.toSql(ED)+"' and J_EndDate>'"+Data.toSql(SD)+"' and J_EndDate<'"+Data.toSql(ED)+"')   limit 1";
	}
	Rs=Data.getSmt(Conn,SqlStr);
	if(Rs.next())
	{
		hasChoosed=true;
	}
	Rs.close();Rs=null;
	
	
	if(hasChoosed) out.println("<script>alert('�z�w�����ɶ��w�Q�w��,�ЦA�T�w�@�U!');</script>");
	else out.println("<script>parent.document.Frm.submit();</script>");
}
else
{
	out.println("<script>alert('���]�ƥثe�L�k�w��!');</script>");
}



%>


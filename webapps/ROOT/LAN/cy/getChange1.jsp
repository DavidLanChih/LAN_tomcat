<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
ResultSet Rs=null;
ResultSet Rs1=null;
ResultSet Rs2=null;
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="";
String Data1=UI.req("WhereValue").trim();
String Field=UI.req("Field");
String F_Type=UI.req("FF_Type");
String DataArr[]=Data1.split(":");
String UID=DataArr[0];
String Year=String.valueOf(Integer.parseInt(DataArr[1].split("/")[0]));
String Month=DataArr[1].split("/")[1];
if(Month.length()==1) Month="0"+Month;
String OrgId=DataArr[2];//��Ʈw��OrgID
%>
<html>
<head><META HTTP-EQUIV='expires' CONTENT='-1'><META HTTP-EQUIV='pragma' CONTENT='no-cache'><meta http-equiv="Content-Type" content="text/html; charset=big5"><LINK REL="SHORTCUT ICON" HREF="/images/favicon.ico"><link rel="stylesheet" href="/Modules/JEIPKernel/lion.css" type="text/css"><link rel='STYLESHEET' type='text/css' href='/Template/default/style.css'><link rel='STYLESHEET' type='text/css' href='/Template/default/style1.css'>
<script language="javascript" src="/Modules/JEIPKernel/lion.js"></script><script language="javascript" src="/Modules/JEIPKernel/prototype.js"></script><title>JEIP ���~��T�J�f���x</title></head><body bgcolor="#ffffff" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<%
try
{

	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	SqlStr="select * from manf013 where m013_no='"+UID+"' and m013_yy='"+Year+"' and m013_mm='"+Month+"'";
	//System.out.println("Informix "+SqlStr);
	ResultSet rs=stmt.executeQuery(SqlStr);
	%>
	<script language="javascript">      
			parent.document.getElementById('<%=Field%>').options.length=0;       
			var o = parent.document.createElement("OPTION");
			parent.document.getElementById('<%=Field%>').options.add(o);                   
			o.value = "";        
			o.text = "�п��...";        
	<%
	//�w�����u�ճ�����A�Z�O���@�ˡA����m013���Z�O�A�p�G�S���N���Τ��e���Z�O�C
	if(rs.next())
	{
		rs.close();rs=null;
		SqlStr="select m019_brk_kind,m019_code,m019_name,m019_hh1,m019_mm1,m019_hh2,m019_mm2,m019_abc,m019_thh from manf013,manf019 where m013_no='"+UID+"' and m013_yy='"+Year+"' and m013_mm='"+Month+"' and m019_brk_kind matches '*'||m013_brk_kind||'*' and m019_type is null group by m019_brk_kind,m019_code,m019_name,m019_hh1,m019_mm1,m019_hh2,m019_mm2,m019_abc,m019_thh order by m019_code";  
		//System.out.println("Informix "+SqlStr);
		ResultSet rs1=stmt.executeQuery(SqlStr);          
		while(rs1.next())
		{
	%>
			var o = parent.document.createElement("OPTION");
			var Orgid = '<%=OrgId%>';
			parent.document.getElementById('<%=Field%>').options.add(o);    
			o.value = "<%=rs1.getString("m019_code")%>";    
			if ((Orgid!='60' && o.value=='N6') || (Orgid!='2' && o.value=='P1'))//�J�줣�O�X�ǽ�orgid�O60�AN6�X�ǭ��w�Z�N��show�X�ӡC�J���O�޲z�̡AP1���\�Z��show
			{
				o.value = "";
				o.text = "";
			}
			else
			{
				o.text = "<%=rs1.getString("m019_code")+":"+rs1.getString("m019_name").trim()+"("+rs1.getString("m019_hh1")+":"+(rs1.getString("m019_mm1").length()==1?"0":"")+rs1.getString("m019_mm1")+"~"+rs1.getString("m019_hh2")+":"+(rs1.getString("m019_mm2").length()==1?"0":"")+rs1.getString("m019_mm2")+")"+" �ɼ�:"+rs1.getString("m019_thh")+"�p��:"+rs1.getString("m019_abc")%>";
			}
	<%
		}
		rs1.close();rs1=null;
	}
	else
	{
		rs.close();rs=null;
		SqlStr="select manf019.m019_brk_kind,manf019.m019_code,manf019.m019_name,manf019.m019_hh1,manf019.m019_mm1,manf019.m019_hh2,manf019.m019_mm2 from manf003,manf019 where manf003.m003_no='"+UID+"' and manf019.m019_brk_kind matches '*'||manf003.m003_brk_kind||'*'  and manf019.m019_type is null group by manf019.m019_brk_kind,manf019.m019_code,manf019.m019_name,manf019.m019_hh1,manf019.m019_mm1,manf019.m019_hh2,manf019.m019_mm2 order by manf019.m019_code ";
		//System.out.println("Informix "+SqlStr);
		ResultSet rs2=stmt.executeQuery(SqlStr);
		while(rs2.next())
		{
	%>
			var o = parent.document.createElement("OPTION");
			var Orgid = '<%=OrgId%>';
			parent.document.getElementById('<%=Field%>').options.add(o);    
			o.value = "<%=rs2.getString("m019_code")%>";
			if (Orgid!='60' && o.value=='N6')//�J�줣�O�X�ǽ�orgid�O60�AN6�X�ǭ��w�Z�N��show�X��
			{
				o.value = "";
				o.text = "";
			}
			else
			{
				o.text = "<%=rs2.getString("m019_code")+":"+rs2.getString("m019_name").trim()+"("+rs2.getString("m019_hh1")+":"+(rs2.getString("m019_mm1").length()==1?"0":"")+rs2.getString("m019_mm1")+"~"+rs2.getString("m019_hh2")+":"+(rs2.getString("m019_mm2").length()==1?"0":"")+rs2.getString("m019_mm2")+")"%>";
			}
		<%
		}
		rs2.close();rs2=null;
	}
}
catch(Exception sqlEx)
{
	out.println("Error msg: " + sqlEx.getMessage());

}
conn.close();
%>
parent.getSelectData('<%=Field.substring(4)%>','<%=Field%>');
</script>
<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="",Kind="",dd="",abc="";
int a=0,b=0,c=0,d=0,z=0,e1=0,e2=0,e3=0,e8=0;
String Field=req("Field",request);
String UID=req("UID",request);
String SDate=req("SDate",request);
String m013_dd[];
m013_dd=new String[32];
//out.println(SDate);
String Year=SDate.split("/")[0];
String Month=SDate.split("/")[1];
if(Month.length()==1) Month="0"+Month;
//UI.Start();
%>
<html>
<head><META HTTP-EQUIV='expires' CONTENT='-1'><META HTTP-EQUIV='pragma' CONTENT='no-cache'><meta http-equiv="Content-Type" content="text/html; charset=big5"><LINK REL="SHORTCUT ICON" HREF="/images/favicon.ico"><link rel="stylesheet" href="/Modules/JEIPKernel/lion.css" type="text/css"><link rel='STYLESHEET' type='text/css' href='/Template/default/style.css'><link rel='STYLESHEET' type='text/css' href='/Template/default/style1.css'>
<script language="javascript" src="/Modules/JEIPKernel/lion.js"></script><script language="javascript" src="/Modules/JEIPKernel/prototype.js"></script><title>JEIP 企業資訊入口平台</title></head><body bgcolor="#ffffff" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<%
try
{


	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	Statement stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	Statement stmt2 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//090330主管職等大於等於5 or 4職等的必需職位代號為G15 ，不受調班當日班別限制
	//SqlStr="select manf073.*,manf002.m002_pno from manf073,manf002 where (m073_boss='"+UID+"' and m002_no='"+UID+"' and m002_pno >= 5) or (m073_boss='"+UID+"' and m002_no='"+UID+"' and m002_pno=4 and m002_sno1 like 'G15%')";
	//20111119主管職等大於5，不受調班當日班別限制
	//SqlStr="select manf073.*,manf002.m002_pno from manf073,manf002 where (m073_boss='"+UID+"' and m002_no='"+UID+"' and m002_pno > 5)";
	//營業行政不受調班當日班別限制
	SqlStr="select manf002.* from manf002 where m002_sno1='G321' and m002_no='"+UID+"' ";
	//out.println("Informix "+SqlStr);
	ResultSet rs2=stmt2.executeQuery(SqlStr);
	if(!rs2.next())
	{
		SqlStr="select * from manf013 where m013_yy = '"+Year+"' and m013_mm ='"+Month+"' and m013_no = '"+UID+"' and m013_chk_date is not null";
		//out.println("2Informix "+SqlStr);
		ResultSet rs=stmt.executeQuery(SqlStr);
		if(rs.next())
		{
			rs.beforeFirst();
			while(rs.next())
			{
				Kind=rs.getString("m013_brk_kind");	
			//	out.println("K->"+Kind);
			//manf019 br
			//排休別[ ](A早晚B顧服C後勤D設維E收銀F監控G安管H商管I員餐J中賓K中友卡L收銀組)
			
				if(Kind.equals("A")||Kind.equals("B")||Kind.equals("E")||Kind.equals("I")||Kind.equals("K")||Kind.equals("L"))
				{
					
					for(int i=1;i<32;i++)
					{			
						if(String.valueOf(i).length()==1) dd="0"+String.valueOf(i);
						if(String.valueOf(i).length()==2) dd=String.valueOf(i);
						m013_dd[i]=rs.getString("m013_dd"+dd);
					//	out.println("<BR>"+i+">>"+m013_dd[i]);				
					}						
					for(int i=1;i<32;i++)
					{			
						SqlStr="select * from manf019 where m019_code='"+m013_dd[i]+"' and m019_type is null";
					//	out.println("<br>Informix "+i+":"+SqlStr);
					  ResultSet rs1=stmt1.executeQuery(SqlStr);          
						while(rs1.next())
						{
							abc=rs1.getString("m019_abc");
						//out.println("<BR>"+i+">>"+abc);
							if(abc.equals("a")) a=a+1;
							else if(abc.equals("b")) b=b+1;
							else if(abc.equals("c")) c=c+1;
							else if(abc.equals("d")) d=d+1;
							else if(abc.equals("z")) z=z+1;
							else if(abc.equals("1")) e1=e1+1;
							else if(abc.equals("2")) e2=e2+1;
							else if(abc.equals("3")) e3=e3+1;
							else if(abc.equals("8")) e8=e8+1;
						}
						rs1.close();rs1=null;
						
					
					}
				
					/*out.println("<BR>a:"+a);			
					out.println("<BR>b:"+b);			
					out.println("<BR>c:"+c);			
					out.println("<BR>d:"+d);			
					out.println("<BR>z:"+z);*/
					%>
						<script language="javascript">			
							var a='<%=a%>';
							var b='<%=b%>';
							var c='<%=c%>';
							var d='<%=d%>';
							var z='<%=z%>';		
							var e1='<%=e1%>';		
							var e2='<%=e2%>';		
							var e3='<%=e3%>';		
							var e8='<%=e8%>';	
							parent.document.getElementById('<%=Field%>').value=a+":"+b+":"+c+":"+d+":"+z+":"+e1+":"+e2+":"+e3+":"+e8;
							//parent.document.getElementById('<%=Field%>').value=c+":"+d+":"+z+":"+e1+":"+e2+":"+e3+":"+e8;
						</script>
					
					<%	 
			  }
			}   	
		}
	}

}
catch(Exception sqlEx)
{
	out.println("Error msg: " + sqlEx.getMessage());
}
rs.close();rs=null;
rs2.close();rs2=null;
stmt2.close();
stmt.close();
conn.close();
%>
<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %><%@ page import="java.util.Date"%>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="";
String p023_qty="",strNo="";
String FID="";
String Field9=req("Field9",request);//remark1
String UDate1=req("UDate",request);
String UID1=req("UID",request);
int thisYear = Integer.valueOf(UDate1.split("/")[0])-1911;
int thisMonth =Integer.valueOf(UDate1.split("/")[1]);
int thisDate =Integer.valueOf(UDate1.split("/")[2]);

String SYear =String.valueOf(thisYear)+String.format("%02d",thisMonth)+String.format("%02d",thisDate);

/*Date myDate = new Date();
int thisYear = myDate.getYear()-11;
int thisMonth = myDate.getMonth()+1;
int thisDate = myDate.getDate();
String SYear =String.valueOf(thisYear)+String.format("%02d",thisMonth)+String.format("%02d",thisDate);*/
int n=1,y=0; 
if(UID1.equals("1"))
  {FID="���ͦr��"+thisYear;}
else if(UID1.equals("2"))
	{FID="���ͤ��r��"+thisYear;}
else if(UID1.equals("3"))
	{FID="�����r��"+thisYear;}
else if(UID1.equals("4"))
	{FID="���p�r��"+thisYear;}
	else if(UID1.equals("5"))
	{FID="���ֱЦr��"+thisYear;}
	else if(UID1.equals("6"))
	{FID="�ɳ����r��"+thisYear;}
	else if(UID1.equals("7"))
	{FID="�c�ʦr��"+thisYear;}
	else if(UID1.equals("8"))
	{FID="���ΰ�ڦr��"+thisYear;}
	else if(UID1.equals("9"))
	{FID="�y���r��"+thisYear;}
	else if(UID1.equals("10"))
	{FID="�s�f�r��"+thisYear;}
	else if(UID1.equals("11"))
	{FID="�f���r��"+thisYear;}
	else if(UID1.equals("12"))
	{FID="�����ɳ���r��"+thisYear;}
	else if(UID1.equals("13"))
	{FID="�@���ܤ@�s���ީe�r��"+thisYear;}
	else if(UID1.equals("14"))
	{FID="�����r��"+thisYear;}
	else if(UID1.equals("15"))
	{FID="�H���r��"+thisYear;}
else
	{FID="�L";}
	 if(UID1.equals("2")||UID1.equals("5")||UID1.equals("6")||UID1.equals("14"))
	 {SqlStr="select top 1 convert(int,(SUBSTRING(FD_Data1,6,10))) AS Expr1 from Company_info where FD_Data1 like '%"+FID+"%' order by id desc";  }
	 else if(UID1.equals("8")||UID1.equals("12"))
	 {SqlStr="select top 1 convert(int,(SUBSTRING(FD_Data1,7,10))) AS Expr1 from Company_info where FD_Data1 like '%"+FID+"%' order by id desc";  }
	 else
	 	{SqlStr="select top 1 convert(int,(SUBSTRING(FD_Data1,5,10))) AS Expr1 from Company_info where FD_Data1 like '%"+FID+"%' order by id desc";  }
	
  ResultSet rs=Data.getSmt(Conn,SqlStr);

if(!rs.next())
{
strNo =FID +String.format("%02d",thisMonth)+String.format("%02d",thisDate)+ String.format("%03d",n)+"��"; 
p023_qty=strNo;
}
else
{
    strNo=rs.getString("Expr1");
      if (strNo != null)
      { 
       	  y = Integer.valueOf(strNo.substring(8,10))+1; 
      }
       if (n > y)
       { strNo =FID +String.format("%02d",thisMonth)+String.format("%02d",thisDate)+ String.format("%03d",n)+"��"; } 
       else 
       {strNo =FID +String.format("%02d",thisMonth)+String.format("%02d",thisDate)+ String.format("%03d",y)+"��"; }
     
       p023_qty=strNo;
}
	rs.close();
	rs=null;
	conn.close();

%>

<script language="javascript">	
	parent.document.getElementById('<%=Field9%>').value='<%=p023_qty%>';

 </script>

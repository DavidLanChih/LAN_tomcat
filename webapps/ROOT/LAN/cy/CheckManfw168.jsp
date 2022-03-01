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
  {FID="中友字第"+thisYear;}
else if(UID1.equals("2"))
	{FID="中友分字第"+thisYear;}
else if(UID1.equals("3"))
	{FID="中賓字第"+thisYear;}
else if(UID1.equals("4"))
	{FID="友聯字第"+thisYear;}
	else if(UID1.equals("5"))
	{FID="惜福教字第"+thisYear;}
	else if(UID1.equals("6"))
	{FID="玉雪分字第"+thisYear;}
	else if(UID1.equals("7"))
	{FID="宮廷字第"+thisYear;}
	else if(UID1.equals("8"))
	{FID="中屋國際字第"+thisYear;}
	else if(UID1.equals("9"))
	{FID="宜民字第"+thisYear;}
	else if(UID1.equals("10"))
	{FID="新宸字第"+thisYear;}
	else if(UID1.equals("11"))
	{FID="宸堡字第"+thisYear;}
	else if(UID1.equals("12"))
	{FID="中賓玉雪營字第"+thisYear;}
	else if(UID1.equals("13"))
	{FID="世紀廿一廣場管委字第"+thisYear;}
	else if(UID1.equals("14"))
	{FID="日日昌字第"+thisYear;}
	else if(UID1.equals("15"))
	{FID="埔里字第"+thisYear;}
else
	{FID="無";}
	 if(UID1.equals("2")||UID1.equals("5")||UID1.equals("6")||UID1.equals("14"))
	 {SqlStr="select top 1 convert(int,(SUBSTRING(FD_Data1,6,10))) AS Expr1 from Company_info where FD_Data1 like '%"+FID+"%' order by id desc";  }
	 else if(UID1.equals("8")||UID1.equals("12"))
	 {SqlStr="select top 1 convert(int,(SUBSTRING(FD_Data1,7,10))) AS Expr1 from Company_info where FD_Data1 like '%"+FID+"%' order by id desc";  }
	 else
	 	{SqlStr="select top 1 convert(int,(SUBSTRING(FD_Data1,5,10))) AS Expr1 from Company_info where FD_Data1 like '%"+FID+"%' order by id desc";  }
	
  ResultSet rs=Data.getSmt(Conn,SqlStr);

if(!rs.next())
{
strNo =FID +String.format("%02d",thisMonth)+String.format("%02d",thisDate)+ String.format("%03d",n)+"號"; 
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
       { strNo =FID +String.format("%02d",thisMonth)+String.format("%02d",thisDate)+ String.format("%03d",n)+"號"; } 
       else 
       {strNo =FID +String.format("%02d",thisMonth)+String.format("%02d",thisDate)+ String.format("%03d",y)+"號"; }
     
       p023_qty=strNo;
}
	rs.close();
	rs=null;
	conn.close();

%>

<script language="javascript">	
	parent.document.getElementById('<%=Field9%>').value='<%=p023_qty%>';

 </script>

<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %><%@page import="java.util.*" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
NoCatch(response);
request.setCharacterEncoding("big5"); 
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String OP="",SqlStr="";
String p023_responsor="",p023_qty="",p023_place="",p023_area="";
String p023_kind="",p023_type="",p023_r="",p023_yy="",p023_mm="";
String p023_d="",p023_r1="",p023_r2="",p023_r3="",p023_ddate="";
String p023_talk="",p023_pyy="",p023_pmm="",p023_r4="",p023_r5="",p023_r6="";
String p023_danger="",p023_effect="",p023_statute="",p023_keep="";

String Field=req("Field",request);//放置地點
String Field1=req("Field1",request);//使用地區
String Field2=req("Field2",request);//數量
String Field3=req("Field3",request);//個資對象
String Field4=req("Field4",request);//個資形式
String Field5=req("Field5",request);//保管人
String Field6=req("Field6",request);//使用期限 年
String Field7=req("Field7",request);//使用期限 月
String Field8=req("Field8",request);//是否銷毀

String Field9=req("Field9",request);//remark1
String Field10=req("Field10",request);//remark2
String Field11=req("Field11",request);//remark3
String Field12=req("Field12",request);//del_date
String Field13=req("Field13",request);//告知方式
String Field14=req("Field14",request);//銷毀 年
String Field15=req("Field15",request);//銷毀 月
String Field16=req("Field16",request);//告知內容remark6
String Field17=req("Field17",request);//remark4
String Field18=req("Field18",request);//remark5
String Field19=req("Field19",request);//風險高低
String Field20=req("Field20",request);//影響高低
String Field21=req("Field21",request);//法令
String Field22=req("Field22",request);//利用期間




String C_billno=req("C_Billno",request);

Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

SqlStr="select * from  pubf023 where  p023_billno='"+C_billno+"'";   
	
ResultSet rs=stmt.executeQuery(SqlStr);

if(!rs.next())
{
%>
	<script language="javascript">
		alert('查無此筆個資清冊!!');		
	</script>
<%	
}
else
{
  p023_qty=rs.getString("p023_qty").trim();
	p023_place=rs.getString("p023_place").trim();
	p023_area=rs.getString("p023_area").trim();
	p023_kind=rs.getString("p023_kind").trim();
	p023_type=rs.getString("p023_type").trim();
	p023_danger=rs.getString("p023_danger").trim();
	p023_effect=rs.getString("p023_effect").trim();
	
	p023_r=rs.getString("p023_responsor").trim();
	p023_yy=rs.getString("p023_keep_yy").trim();
	p023_mm=rs.getString("p023_keep_mm").trim();
	p023_d=rs.getString("p023_need_del_yn").trim();
	p023_r1=rs.getString("p023_remark1").trim();
	p023_r2=rs.getString("p023_remark2").trim();
	p023_r3=rs.getString("p023_remark3").trim();
	p023_r4=rs.getString("p023_remark4").trim();
	p023_r5=rs.getString("p023_remark5").trim();
	
	p023_ddate=rs.getString("p023_del_date");
	
	if(p023_ddate == null){p023_ddate ="";}
	
	else{p023_ddate=rs.getDate("p023_del_date").toString().replaceAll("-","/");}
	
	p023_talk=rs.getString("p023_talk_type");
	p023_pyy=rs.getString("p023_per_yy").trim();
	p023_pmm=rs.getString("p023_per_mm").trim();
	p023_r6=rs.getString("p023_remark6").trim();
	
	p023_statute=rs.getString("p023_statute").trim();
	p023_keep=rs.getString("p023_keep");
	
	if(p023_keep == null){p023_keep ="";}
	
}	
rs.close();
rs=null;
stmt.close();
conn.close();

%>

<script language="javascript">	
	
	parent.document.getElementById('<%=Field%>').value='<%=p023_place%>';
	parent.document.getElementById('<%=Field1%>').value='<%=p023_area%>';
  parent.document.getElementById('<%=Field2%>').value='<%=p023_qty%>';
  
  parent.document.getElementById('<%=Field3%>').value='<%=p023_kind%>';
  parent.getSelectData('FD_Data6','tmp_FD_Data6');
  //alert(parent.document.getElementById('FD_Data4').value);
  
  parent.document.getElementById('<%=Field4%>').value='<%=p023_type%>';
  parent.getSelectData('FD_Data7','tmp_FD_Data7');
  
  parent.document.getElementById('<%=Field5%>').value='<%=p023_r%>';
  parent.document.getElementById('<%=Field6%>').value='<%=p023_yy%>';
  parent.document.getElementById('<%=Field7%>').value='<%=p023_mm%>';
  
  parent.document.getElementById('<%=Field8%>').value='<%=p023_d%>';
  parent.getSelectData('FD_Data17','tmp_FD_Data17');
  
  parent.document.getElementById('<%=Field9%>').value='<%=p023_r1%>';
  parent.document.getElementById('<%=Field10%>').value='<%=p023_r2%>';
  parent.document.getElementById('<%=Field11%>').value='<%=p023_r3%>';
  parent.document.getElementById('<%=Field12%>').value='<%=p023_ddate%>';
  
  parent.document.getElementById('<%=Field13%>').value='<%=p023_talk%>';
  parent.getSelectData('FD_Data22','tmp_FD_Data22');
  
  parent.document.getElementById('<%=Field14%>').value='<%=p023_pyy%>';
  parent.document.getElementById('<%=Field15%>').value='<%=p023_pmm%>';
  parent.document.getElementById('<%=Field16%>').value='<%=p023_r6%>';
  parent.document.getElementById('<%=Field17%>').value='<%=p023_r4%>';
  parent.document.getElementById('<%=Field18%>').value='<%=p023_r5%>';
  parent.document.getElementById('<%=Field19%>').value='<%=p023_danger%>';
  parent.getSelectData('FD_Data8','tmp_FD_Data8');
  
  parent.document.getElementById('<%=Field20%>').value='<%=p023_effect%>';
  parent.getSelectData('FD_Data9','tmp_FD_Data9');
  
  parent.document.getElementById('<%=Field21%>').value='<%=p023_statute%>';
  
  parent.document.getElementById('<%=Field22%>').value='<%=p023_keep%>';
  
 </script>

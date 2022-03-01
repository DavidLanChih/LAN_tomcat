<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %> 
<%
leeten.Date JDate=new leeten.Date();
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
String SqlStr="";
String UID=J_UD_Id.substring(0,5);
String UUID=J_UD_Id.substring(2);
String check="";

String Password=req("Password",request);
String UserID=req("UserID",request);
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
SqlStr="select m002_dept from manf002 where m002_no='"+UserID+"' and m002_passwd='"+Password+"'";

ResultSet rs=stmt.executeQuery(SqlStr);
while(rs.next())
{ 
   if(!rs.getString("m002_dept").trim().equals(""))
	{
		check="OK";
	}
	else
	{
		check="NO";
	}
	
		
}

rs.close();rs=null;
conn.close();




%>
<iframe id='FrmTemp' src='' style='width:0;height:0' frameborder=0></iframe>
<script language="javascript">


parent.document.getElementById('checkt').value='<%=check%>';
 parent.CheckOk();
</script>
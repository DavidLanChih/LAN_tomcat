<%@page import="leeten.*" %><%@page contentType="text/xml; charset=big5"%><%@ include file="/Modules/JEIPKernel/Util_IO.jsp" %><%@ include file="/Modules/JEIPKernel/Util_Data.jsp" %><%@page import="java.net.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*" %>
<%@ page pageEncoding="big5"%>
<%@ page import="java.net.*, java.io.*, java.sql.*, java.util.*" %>

<%

NoCatch(response);

ResultSet Rs=null;
String Content="",SqlStr="",FidContent="";
String Field1=req("Field1",request);
String UID=req("UID",request);

ArrayList<String> list = new ArrayList<String>();

String[] tokens = UID.split(",");

for (String token:tokens) 
{
	SqlStr="select top 1 * from Org where UD_ID='"+token+"'";

	Rs=Data.getSmt(Conn,SqlStr);
	while(Rs.next()) 
	{
		
		 list.add(Rs.getString("OrgId"));
	}
   // out.println("C->"+list);
	
	
}
int Fidnum = list.size();
//out.println(Fidnum);
//out.println(UID);
Rs.close();Rs=null;


%>

<script language="javascript">
var strArray = <%= list %>;
var strArray2 = '<%= Field1 %>';

var words = strArray2.split(",");
for(j=0;j < <%=Fidnum%>;j++)
{
	var carray = strArray[j];
	var Fidarray = words[j];

	//alert("document.getElementById('"+Fidarray+"').innerText='"+carray+"'");
	parent.document.getElementById(Fidarray).innerText=carray;
}
</script>



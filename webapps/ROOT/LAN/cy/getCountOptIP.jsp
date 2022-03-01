<%@ include file="/kernel.jsp" %><%@ include file="/cykernel.jsp" %>
<%@ page contentType="text/html;charset=big5" %> 


<%
leeten.Date JDate=new leeten.Date();
leeten.Util JUtil=new leeten.Util();
Html UI=new Html(pageContext,Data,Conn);
out.println("hi");
%>
<br><br>
若有 proxy server 或是 load balancer server ，則透過此找到原始IP:
<%
String ipAddress = request.getHeader("X-FORWARDED-FOR");
if (ipAddress == null || "".equals(ipAddress)) {
ipAddress = request.getRemoteAddr();
}
%>
<%=ipAddress%>
<br>
<hr>
一般找到IP的方法:
<%=request.getRemoteAddr() %> 

<%@ page language="java" import="java.util.*" pageEncoding="BIG5"%>
<% 
//------原始IP(可排除反向伺服器)----
String ipAddress = request.getHeader("X-FORWARDED-FOR");
if (ipAddress == null || "".equals(ipAddress))
{
	ipAddress = request.getRemoteAddr();
}
//-------------原始IP--------------- 
String IP=request.getRemoteAddr();
//------------主機位置--------------
String host=request.getRemoteHost();
//----------伺服器+PORT端-----------
String HT=request.getHeader("Host");
//------------伺服器位置------------
String ServerName=request.getServerName();
//------------伺服器Port------------
int ServerPort=request.getServerPort();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>JSP page</title>
	<style>
	@keyframes move_method
	{
		from {color:Blue;}
		to {color:red;}
	}
	span
	{
		color:Blue;
		animation:move_method 3s linear 1s alternate infinite;
	}
	</style>
  </head>
  <body>
    <H2>This is a JSP page of test IP and servername. </H2>
    origin IP: <span><%=IP %></span> <br>
    origin IP (remove Apache, Squid against-IP): <span><%=ipAddress %> </span><br>
    HOST name: <span><%=host %></span> <br>
    Server+port: <span><%=HT %> </span><br>
    ServerName: <span><%=ServerName %></span> <br>
    ServerPort: <span><%=ServerPort %></span>
    <br>
    0:0:0:0:0:0:0:1 is ipv6 LocalHost form; 127.0.0.1 is ipv4 LocalHost form.
  </body>
</html>

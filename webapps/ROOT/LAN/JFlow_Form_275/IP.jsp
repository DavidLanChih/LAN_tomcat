<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
//------原始IP(可排除反向伺服器)----
String ipAddress = request.getHeader("X-FORWARDED-FOR");
if (ipAddress == null || "".equals(ipAddress))
{
	ipAddress = request.getRemoteAddr();
}
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
    IP位置: <span><%=ipAddress %> </span><br>
	<input onclick="window.close();" value="關閉視窗" type="button">
  </body>
</html>
<script>
var _parentWin = window.parent ;                    //宣告母視窗
_parentWin.FD_Data3.value = "<%=ipAddress %>";      //帶入母視窗的指定位置的值
</script>

<%
//---------SQLServer資料庫連結-------------
Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver").newInstance();
String url="jdbc:sqlserver://172.16.11.8;database=CHIEFPOS-EC-CY-TEST";
String user="web2";
String password="energyUTK123";
Connection connTC= DriverManager.getConnection(url,user,password);
%>
<%
//Class.forName("com.jdbc.odbc.JdbcOdbcDriver"); 
Class.forName("com.informix.jdbc.IfxDriver");
Connection conn2=DriverManager.getConnection("jdbc:informix-sqli://172.16.10.12:1622/cy2:informixserver=chyusct;NEWLOACLE=zh_tw,en_us,zh_cn;NEWCODESET=Big5,GB2312-80,8859-1,819", "ftpguest", "2253456");


%>
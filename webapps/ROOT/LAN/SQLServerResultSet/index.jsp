<%@ include file="/kernel.jsp" %>
<%@ page contentType="text/html;charset=MS950" %>
<%
//----------�����s�����֨�����------------
NoCatch(response);
//---------------�ŧi���s-----------------
Html UI=new Html(pageContext,Data,Conn);
UI.Start();
String SqlStr="",FD_RecId="",FD_Data1="",FD_Data2="",FD_Data3="",FD_Data4="",FD_Data5="";
SqlStr="select * from flow_formdata where FD_FormId='274'";
Statement stmt=Conn.createStatement();                                        //���w����������A�u�੹�e���ʬ����A���੹�^��

//-------------��椶���]�w---------------
Grid Grid=new Grid(pageContext); 
Grid.Init();
Grid.AddRow("");
Grid.AddCol("<B>���FD_FormId='274'�Ҧ����</B>","colspan=9 align=center");
Grid.AddRow("");
Grid.AddGridTitle("<font color='blue'>�ϥ�Statement stmt=Conn.createStatement()&nbsp;&nbsp;/�w�]����:�u�੹�e���ʬ����A���੹�^��/</font>","","colspan=9");
Grid.AddRow("");
Grid.AddGridTitle("���渹","","colspan=1");
Grid.AddGridTitle("���o���x�����","","colspan=4");
Grid.AddGridTitle("�������","","colspan=4");
Grid.AddRow("");
Grid.AddRow("");

//------------�Ĥ@��������--------------
Grid.AddCol("&nbsp;&nbsp;�ϥ�<font color='red'>while(RS.next())</font)�A��������","colspan=9 align=left"); 
Grid.AddRow("");
ResultSet Rs= stmt.executeQuery(SqlStr);
while(Rs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+Rs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+Rs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+Rs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");
}
Rs.close();

//------------�ĤG��������--------------
Grid.AddCol("&nbsp;&nbsp;���]�A�ϥ�while(Rs1.next()){<font color='red'>if(Rs1.isFirst())</font>}�A����Ĥ@�����","colspan=9 align=left"); 
Grid.AddRow("");
ResultSet Rs1= stmt.executeQuery(SqlStr);
while(Rs1.next())
{
	FD_RecId=Rs1.getString("FD_RecId");
	FD_Data5=Rs1.getString("FD_Data5");
	
	if(Rs1.isFirst())
	{
		Grid.AddCol("&nbsp;&nbsp;"+Rs1.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
		Grid.AddCol("&nbsp;&nbsp;"+Rs1.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
		Grid.AddCol("&nbsp;&nbsp;"+Rs1.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
		Grid.AddRow("");
	}
}
Rs1.close();

//------------�ĤT��������--------------
Grid.AddCol("&nbsp;&nbsp;���]�A�ϥ�while(Rs2.next()){<font color='red'>if(Rs2.isLast())</font>}�A����̫�@�����","colspan=9 align=left"); 
Grid.AddRow("");
ResultSet Rs2= stmt.executeQuery(SqlStr);
while(Rs2.next())
{
	FD_RecId=Rs2.getString("FD_RecId");
	FD_Data5=Rs2.getString("FD_Data5");	
	
	if(Rs2.isLast())
	{
		Grid.AddCol("&nbsp;&nbsp;"+Rs2.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
		Grid.AddCol("&nbsp;&nbsp;"+Rs2.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
		Grid.AddCol("&nbsp;&nbsp;"+Rs2.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
		Grid.AddRow("");		
	}
}
Rs2.close();

//--------------------------------------------------------------------------------------------------------------------------------------
Statement stmtALL=Conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);    //���\ResultSet�b���N�Φ�������

Grid.AddGridTitle("<font color='blue'>�ϥ�Statement stmtALL=Conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);&nbsp;&nbsp;/ResultSet�i���N�Φ�������/</font>","","colspan=9");
Grid.AddRow("");
Grid.AddGridTitle("���渹","","colspan=1");
Grid.AddGridTitle("���o���x�����","","colspan=4");
Grid.AddGridTitle("�������","","colspan=4");
Grid.AddRow("");

ResultSet ARs= stmtALL.executeQuery(SqlStr);
Grid.AddCol("&nbsp;&nbsp;�ϥ�<font color='red'>if(ARS.next())</font>�A��Ĥ@�����&nbsp;&nbsp;","colspan=9 align=left"); 
Grid.AddRow("");
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}

Grid.AddCol("&nbsp;&nbsp;�A���ϥ�if(ARS.next())�A��ĤG�����&nbsp;&nbsp;","colspan=9 align=left"); 
Grid.AddRow("");
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}

Grid.AddCol("&nbsp;&nbsp;�A���ϥ�if(ARS.next())�A��ĤT�����&nbsp;&nbsp;","colspan=9 align=left"); 
Grid.AddRow("");
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}

Grid.AddCol("&nbsp;&nbsp;�ϥ�<font color='red'>ARS.first();</font>�A�N���в���Ĥ@����ơA�M��A�ϥ�if(ARS.next())�A���ĤG�����&nbsp;&nbsp;","colspan=9 align=left"); 
Grid.AddRow("");
ARs.first();
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}

Grid.AddCol("&nbsp;&nbsp;�ϥ�<font color='red'>ARS.beforeFirst();</font>�A�N���в���Ĥ@����ƫe���A�M��A�ϥ�if(ARS.next())�A���Ĥ@�����&nbsp;&nbsp;","colspan=9 align=left"); 
Grid.AddRow("");
ARs.beforeFirst();
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}

Grid.AddCol("&nbsp;&nbsp;�ϥ�<font color='red'>ARs.absolute(2);</font>�A�N���в���ĤG����ơA�M��A�ϥ�while(ARS.next())�A����3~4�����&nbsp;&nbsp;","colspan=9 align=left"); 
Grid.AddRow("");
ARs.absolute(2);
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}

Statement stmtUP=Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);    //���\ResultSet�b���N�Φ������ʥB�ק�
ResultSet UPs = stmtUP.executeQuery(SqlStr);
Grid.AddGridTitle("<font color='blue'>�ϥ�Statement stmtUP=Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);&nbsp;&nbsp;/ResultSet�i���N�Φ������ʥB�ק�/</font>","","colspan=9");
Grid.AddRow("");
Grid.AddGridTitle("���渹","","colspan=1");
Grid.AddGridTitle("���o���x�����","","colspan=4");
Grid.AddGridTitle("�������","","colspan=4");
Grid.AddRow("");
 
//UPs.absolute(2); //��w��Ʈw�ĴX�����
//UPs.deleteRow(); //�R����Ʈw�������

ARs.beforeFirst();
if(ARs.next())
{
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_RecId")+"&nbsp;&nbsp;","colspan=1 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data5")+"&nbsp;&nbsp;","colspan=4 align=left"); 
	Grid.AddCol("&nbsp;&nbsp;"+ARs.getString("FD_Data10")+"&nbsp;&nbsp;","colspan=4 align=left");
	Grid.AddRow("");		
}
Grid.AddCol("<input type='button' value='�q��Ʈw�R���Ĥ@�C���' onclick='D()'","colspan=9 align=left");
%>
<script>
function D()
{
	<% 
	Grid.AddRow("");	
	Grid.AddCol("&nbsp;&nbsp;123&nbsp;&nbsp;","colspan=9 align=left"); 
	%>
	alert("123");
}
</script>
<%
//------------------����------------------
stmt.close();
stmtALL.close();
stmtUP.close();
ARs.close();
UPs.close();
Grid.Show();
Grid=null;
UI=null;
%>
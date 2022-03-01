<%@ include file="/kernel.jsp" %>
<%@page import="leeten.*" %>
<%@page import="java.net.*,java.lang.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat,java.sql.*,java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="application/msword;charset=Big5" %>
<%
leeten.Org JOrg=new leeten.Org(Data,Conn);
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String OrgId=req("OrgId",request);//由設備傳入
String FI_RecId=req("FI_RecId",request);
String FD_RecId=req("FD_RecId",request);


String ApplyOrgId=req("ApplyOrgId",request);
String SqlStr="";
String PosStatus="",BuildA="",BuildB="",BuildC="",BuildZ="",Pic="";
int CheckTime=0,PosTotal=0,AA=0,BB=0,CC=0,DD=0,EE=0,FF=0,GG=0,HH=0,II=0;
int s=0,x=0,y=0,i=0,count=0;
ResultSet Rs=null;
String OrgName="",UD_ID1="",UD_ID2="";
String FD_Data1="",FD_Data2="",FD_Data4="",FD_Data6="",FD_Data7="",FD_Data8="",FD_Data9="",FD_Data10="",FD_Data11="",FD_Data12="",FD_Data13="",FD_Data14="",FD_Data15="",FD_Data16="",FD_Data17="",FD_Data18="",FD_Data19="",FD_Data20="";
String FD_Data30="",FD_Data31="",FD_Data35="",FD_Data36="",FD_Data37="",FD_Data38="",FD_Data39="",FD_Data40="",FD_Data41="",FD_Data42="",FD_Data43="",FD_Data44="",FD_Data46="",FD_Data49="",FD_Data50="",FD_Data51="";



String year="",month="",day="";
String mergeContent="",mergeRelationship="",mergeWay="",mergeSuggest="",mergeVendor="";
String CurDate=JDate.format(new Date(),"yyyy/MM/dd");
String StartDate="";

String FD_Data1Arr[]=null,FD_Data8Arr[]=null,FD_Data9Arr[]=null;
String FD_Data30Arr[]=null,FD_Data46Arr[]=null;
year=CurDate.split("/")[0];
month=CurDate.split("/")[1];
day=CurDate.split("/")[2];
StartDate=year+"/"+month+"/1";


try
{
	SqlStr="select * FROM flow_formdata,flow_form_rulestage where flow_form_rulestage.FR_DataId=flow_formdata.FD_RecId and FR_FormId='"+FI_RecId+"' and FD_RecId='"+FD_RecId+"'";
	
	Rs=Data.getSmt(Conn,SqlStr);
	
	if(Rs.next())
	{
		FD_Data1Arr=Rs.getString("FD_Data1").split(",");
		FD_Data1=FD_Data1Arr[1].substring(5);//承辦人
		FD_Data2=Rs.getString("FD_Data2");//承辦日期
		FD_Data4=Rs.getString("FD_Data4");//單號
		FD_Data6=Rs.getString("FD_Data6");//發生日期
		FD_Data7=Rs.getString("FD_Data7");//發生時間
		FD_Data8Arr=Rs.getString("FD_Data8").split(",");
		FD_Data8=FD_Data8Arr[1].substring(5).replaceAll("　", "");//單位
		if(!Rs.getString("FD_Data9").equals(""))
		{
			FD_Data9Arr=Rs.getString("FD_Data9").split(":");
			FD_Data9=FD_Data9Arr[2];//專櫃櫃名
		}
		FD_Data10=Rs.getString("FD_Data10");//關係人(特徵)
		FD_Data11=Rs.getString("FD_Data11");//事件內容
		FD_Data12=Rs.getString("FD_Data12");//2
		FD_Data13=Rs.getString("FD_Data13");//3
		FD_Data14=Rs.getString("FD_Data14");//4
		FD_Data15=Rs.getString("FD_Data15");//5
		FD_Data16=Rs.getString("FD_Data16");//6
		FD_Data17=Rs.getString("FD_Data17");//7
		FD_Data18=Rs.getString("FD_Data18");//8
		FD_Data19=Rs.getString("FD_Data19");//9
		FD_Data20=Rs.getString("FD_Data20");//10

		
		if(!Rs.getString("FD_Data30").equals(""))
		{
			FD_Data30Arr=Rs.getString("FD_Data30").split(",");
			FD_Data30=FD_Data30Arr[1].substring(5);//承辦人
		}
		FD_Data31=Rs.getString("FD_Data31");//處理日期
		FD_Data35=Rs.getString("FD_Data35");//處理方式
		FD_Data36=Rs.getString("FD_Data36");//2
		FD_Data37=Rs.getString("FD_Data37");//3
		FD_Data38=Rs.getString("FD_Data38");//4
		FD_Data39=Rs.getString("FD_Data39");//5
		FD_Data40=Rs.getString("FD_Data40");//6
		FD_Data41=Rs.getString("FD_Data41");//7
		FD_Data42=Rs.getString("FD_Data42");//8
		FD_Data43=Rs.getString("FD_Data43");//廠商想法
		FD_Data44=Rs.getString("FD_Data44");//2
		if(!Rs.getString("FD_Data46").equals(""))
		{
			FD_Data46Arr=Rs.getString("FD_Data46").split(":");
			FD_Data46=FD_Data46Arr[1].substring(5);//單位主管
		}
		FD_Data49=Rs.getString("FD_Data49");//建議
		FD_Data50=Rs.getString("FD_Data50");//2
		FD_Data51=Rs.getString("FD_Data51");//3
		
		
		
			
		
		if(!FD_Data11.equals(""))
		{mergeContent+=FD_Data11+"<br>";}
		if(!FD_Data12.equals(""))
		{mergeContent+=FD_Data12+"<br>";}
		if(!FD_Data13.equals(""))
		{mergeContent+=FD_Data13+"<br>";}
		if(!FD_Data14.equals(""))
		{mergeContent+=FD_Data14+"<br>";}
		if(!FD_Data15.equals(""))
		{mergeContent+=FD_Data15+"<br>";}
		if(!FD_Data16.equals(""))
		{mergeContent+=FD_Data16+"<br>";}
		if(!FD_Data17.equals(""))
		{mergeContent+=FD_Data17+"<br>";}
		if(!FD_Data18.equals(""))
		{mergeContent+=FD_Data18+"<br>";}
		if(!FD_Data19.equals(""))
		{mergeContent+=FD_Data19+"<br>";}
		if(!FD_Data20.equals(""))
		{mergeContent+=FD_Data20+"<br>";}
	
		
		if(!FD_Data35.equals(""))
		{mergeWay=FD_Data35+"<br>";}
		if(!FD_Data36.equals(""))
		{mergeWay+=FD_Data36+"<br>";}
		if(!FD_Data37.equals(""))
		{mergeWay+=FD_Data37+"<br>";}
		if(!FD_Data38.equals(""))
		{mergeWay+=FD_Data38+"<br>";}
		if(!FD_Data39.equals(""))
		{mergeWay+=FD_Data39+"<br>";}
		if(!FD_Data40.equals(""))
		{mergeWay+=FD_Data40+"<br>";}
		if(!FD_Data41.equals(""))
		{mergeWay+=FD_Data41+"<br>";}
		if(!FD_Data42.equals(""))
		{mergeWay+=FD_Data42+"<br>";}
	
	
		if(!FD_Data43.equals(""))
		{mergeVendor=FD_Data43+"<br>";}
		if(!FD_Data44.equals(""))
		{mergeVendor+=FD_Data44+"<br>";}
	
		if(!FD_Data49.equals(""))
		{mergeSuggest=FD_Data49+"<br>";}
		if(!FD_Data50.equals(""))
		{mergeSuggest+=FD_Data50+"<br>";}
		if(!FD_Data51.equals(""))
		{mergeSuggest+=FD_Data51+"<br>";}
	}
	Rs.close();Rs=null;
	Conn.close();
	
 
}
catch(Exception e)
{
 out.println("連結錯誤:" + e);
 
}
response.setHeader("Content-Disposition","attachment; filename="+ java.net.URLEncoder.encode(FD_Data4+"_顧客意見單.doc", "UTF-8"));


%>

<HTML>
<head>
<style>
@page
{
	mso-page-border-surround-header:no;
    mso-page-border-surround-footer:no;
}
@page Section1
{
	size:595.3pt 841.9pt;
    margin:1.0cm 1.0cm 1.0cm 1.2cm;
    mso-header-margin:42.55pt;
    mso-footer-margin:49.6pt;
    mso-paper-source:0;
    layout-grid:18.0pt;
	}
div.Section1
{page:Section1;}
.Section2
{
	font-size:24pt;
	line-height:50px;
	margin-left:250px;
	font-family: Microsoft JhengHei;
	font-weight:bold;
}
table
{
	margin-left:-8pt;
	font-size:14pt;
	font-family: Microsoft JhengHei;
	border: 1px solid #00; border-collapse: collapse;

	/*border:1px #000000 double;雙框線*/
}
table td
{
	/*border:0px solid #000;*/
}
span
{
	font-size:12pt;
}
</style>


</head>
<BODY onload='GetWaterMarked('window','1.png','this')' >
<div class='Section1'>
	<div left='20' class='Section2'>顧客意見處理單</div>

	<table height='1000' width='730' cellpadding='0' cellspacing='0' border='1'>
		<tr>
            <td width='120' height='50' align='center'>單號</td>
            <td width='120' height='50' align='center'><%=FD_Data4%></td>
            <td width='120' height='50' align='center'>專櫃櫃名</td>
            <td width='120' height='50' align='center'><%=FD_Data9%></td>
            <td width='120' height='50' align='center'>發生日期</td>
            <td width='120' height='50' align='center'><%=FD_Data6%></td>
        </tr>
		<tr>
            <td width='120' height='50' align='center'>單位</td>
            <td width='120' height='50' align='center'><%=FD_Data8%></td>
            <td width='120' height='50' align='center'>關係人(特徵)</td>
            <td width='120' height='50' align='center'><%=FD_Data10%></td>
            <td width='120' height='50' align='center'>發生時間</td>
            <td width='120' height='50' align='center'><%=FD_Data7%></td>
        </tr>
		<tr>
            <td colspan='6' valign='top' height="800"><span>事件內容：<br><%=mergeContent%></span></td>
        </tr>
		<tr>
            <td width='120' height='50' align='center'>客服中心主管</td>
            <td width='120' height='50' align='center'>陳婉娟</td>
            <td width='120' height='50' align='center'>承辦人</td>
            <td width='120' height='50' align='center'><%=FD_Data1%></td>
            <td width='120' height='50' align='center'>承辦日期</td>
            <td width='120' height='50' align='center'><%=FD_Data2%></td>
        </tr>
	</table>


	
	<div left='20' class='Section2'>顧客意見回覆單</div>
	<table height='1000' width='730' cellpadding='0' cellspacing='0' border='1'>
		<tr>
            <td colspan='6' valign='top' height='290'><span>處理方式：<br><%=mergeWay%></span></td>
        </tr>
		<tr>
            <td colspan='6' valign='top' height='290'><span>廠商想法：<br><%=mergeVendor%></span></td>
        </tr>
		<tr>
            <td colspan='6' valign='top' height='290'><span>建議：<br><%=mergeSuggest%></span></td>
        </tr>
		<tr>
            <td width='120' height='50' align='center'>單位主管</td>
            <td width='120' height='50' align='center'><%=FD_Data46%></td>
            <td width='120' height='50' align='center'>承辦人</td>
            <td width='120' height='50' align='center'><%=FD_Data30%></td>
            <td width='120' height='50' align='center'>承辦日期</td>
            <td width='120' height='50' align='center'><%=FD_Data31%></td>
        </tr>
	</table>
</div>
</BODY>
</HTML>





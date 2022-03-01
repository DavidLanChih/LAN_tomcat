<%@ include file="/kernel.jsp" %>
<%@ page import="leeten.*" %>
<%@ page contentType="text/html;charset=MS950" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.xssf.usermodel.*" %>
<%@ page import="org.apache.poi.ss.usermodel.*" %>
<%@ page import="org.apache.poi.ss.util.RegionUtil" %>
<%@ page import="org.apache.poi.ss.util.CellRangeAddress" %>
<%@ page import="java.io.*" %>

<%
leeten.Org JOrg=new leeten.Org(Data,Conn);
int i=0;
ArrayList<String> list = new ArrayList<String>();
ArrayList<String> fidelists = new ArrayList<String>();
ResultSet rs=null,rs1=null,rs2=null;
String SqlStr="",SqlStr1="";
String Fcategory=req("Fcategory",request);
String SDate=req("SDate",request);
String EDate=req("EDate",request);
String Status=req("Status",request);
%><script>alert("Status:<%=Status%>");</script><%
//-----------日期補零--------------
String SDateArr[]=SDate.split("/");
String d1="",d2="",d3="";
d1=SDateArr[0];
d2=String.format("%02d",  Integer.parseInt(SDateArr[1])); 
d3=String.format("%02d",  Integer.parseInt(SDateArr[2]));
String EDateArr[]=EDate.split("/");
String d4="",d5="",d6="";
d4=EDateArr[0];
d5=String.format("%02d",  Integer.parseInt(EDateArr[1])); 
d6=String.format("%02d",  Integer.parseInt(EDateArr[2]));
//--------------------創建EXCEL工作簿---------------------
XSSFWorkbook workbook = new XSSFWorkbook();
XSSFSheet sheet = workbook.createSheet("收銀機台裝測移");                         //生成表單(表單名稱)
for(i = 0; i <= 10;i++)                                                           //第1-10行的欄位寬度
{
	if(i==2 || i==8)
	{
		sheet.setColumnWidth( i, 8000);
	}
	else
	{
		sheet.setColumnWidth( i, 5000);
	}
}

//------表單列印設定------
sheet.setFitToPage(false);                                                        //true:列印時會將工作表單放在同一頁面
sheet.setHorizontallyCenter(true);//水平                                          //設置列印表單文本整體位置
sheet.getPrintSetup().setLandscape(true);                                         //設置列印方向(true為橫向,false為直向)
sheet.getPrintSetup().setPaperSize(XSSFPrintSetup.A4_PAPERSIZE);                  //設置為A4紙張
sheet.setMargin(XSSFSheet.TopMargin, 0.24);                                       //設置列印上緣距離
sheet.setMargin(XSSFSheet.BottomMargin, 0.24);                                    //設置列印下緣距離
sheet.setMargin(XSSFSheet.LeftMargin, 0.24);                                      //設置列印左緣距離
sheet.setMargin(XSSFSheet.RightMargin, 0.24);                                     //設置列印右緣距離

//-----第一組配色設計-----
XSSFColor color = new XSSFColor(new java.awt.Color(234, 234, 234));               //顏色設定:(RGB三原色色盤: 紅色, 綠色, 藍色)

//設置字體
Font font = workbook.createFont();
font.setFontHeightInPoints((short) 12);                                            //字體大小
font.setFontName("標楷體");                                                        //字體樣式
font.setBoldweight(Font.BOLDWEIGHT_BOLD);                                          //設定為粗體字
font.setColor(HSSFColor.BLACK.index);                                              //字體顏色

//設定樣式
XSSFCellStyle style = workbook.createCellStyle();
style.setWrapText(true);                                                           //強制換行  
style.setFillForegroundColor(HSSFColor.WHITE.index);                               //背景白色
style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style.setAlignment(XSSFCellStyle.ALIGN_CENTER);                                    //水平置中
style.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);                         //垂直置中
style.setBorderBottom(HSSFCellStyle.BORDER_THIN);                                  //下框線粗細 Thin;//細實線 Thick;//粗 Hair;//虛線
style.setBorderLeft(HSSFCellStyle.BORDER_THIN);                                    //左框線粗細
style.setBorderRight(HSSFCellStyle.BORDER_THIN);                                   //右框線粗細
style.setBorderTop(HSSFCellStyle.BORDER_THIN);                                     //上框線粗細
style.setBottomBorderColor(HSSFColor.BLACK.index);                                 //下框線顏色
style.setLeftBorderColor(HSSFColor.BLACK.index);                                   //左框線顏色
style.setRightBorderColor(HSSFColor.BLACK.index);                                  //右框線顏色
style.setTopBorderColor(HSSFColor.BLACK.index);                                    //上框線顏色
style.setFont(font);

//-------------表單欄位內容設定-------------
XSSFRow row = null;
XSSFCell cell = null;

//---------------標題所有欄位---------------    
for(int s=1;s<=10;s++)
{
	fidelists.add("FF_F"+s+"_Name");                                                         //所有FF_F"+s+"_Name代號寫進fidelists陣列[ , , , , , ]
}
String fidenumst=fidelists.toString();
String stringstat=fidenumst.replace("[","");
String stringstat2=stringstat.replace("]","");

SqlStr="select "+stringstat2+" FROM flow_formfieldinfo "+
"INNER JOIN flow_forminfo ON flow_forminfo.FI_RecId = flow_formfieldinfo.FF_FormRecId "+     //結合FF的表單代號=FI的表單代號的所有資料
"where flow_forminfo.FI_ID='"+Fcategory+"' order by flow_forminfo.FI_RecDate desc limit 1";  //條件為FI最新發佈的表單

rs=Data.getSmt(Conn,SqlStr);
if(rs.next())
{
	row=sheet.createRow(0);                                                                  //創建EXCEL第一行，第一行參數=0...類推
	int f=0;
	for(int m=1;m<=10;m++)                                                                   //創建第一行m個欄位
	{
		if(m!=2 && !rs.getString("FF_F"+(m)+"_Name").trim().equals(""))
		{
			cell=row.createCell(f);                                                          //創建第一格欄位，參數=0...類推
			cell.setCellValue(rs.getString("FF_F"+(m)+"_Name").trim());                      //輸入此格的內容
			cell.setCellStyle(style);                                                        //設定此格的外框等設計
			f++;	                                                                         //欄位參數+1
		}		
	}	
}

//---------------搜尋資料內容---------------
SqlStr1+="select * from flow_formdata ";
SqlStr1+="INNER JOIN flow_form_rulestage ON flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId ";
SqlStr1+="where flow_formdata.FD_FormId IN ('253','255','257','274') ";
//SqlStr1+="and (CONVERT(varchar(10),CONVERT(datetime,flow_formdata.FD_Data3,111),111)  BETWEEN  '"+d1+"/"+d2+"/"+d3+"' and '"+d4+"/"+d5+"/"+d6+"')";  //用此SQL也可行
SqlStr1+="and (CONVERT(varchar(10),CONVERT(datetime,flow_formdata.FD_Data3,111),111)  >=  '"+d1+"/"+d2+"/"+d3+"')";
SqlStr1+="and (CONVERT(varchar(10),CONVERT(datetime,flow_formdata.FD_Data3,111),111)  <=  '"+d4+"/"+d5+"/"+d6+"')";
if(Status!="")
{
	SqlStr1+="and flow_form_rulestage.FR_FinishState='"+Status+"'";
}

rs1=Data.getSmt(Conn,SqlStr1);
int s=1;
while(rs1.next())
{	
	row=sheet.createRow(s);
	int si=0;
	for(int d=1;d<=10;d++)
	{				
		if(d==1 || d==6 || d==7 || d==8 || d==9)
		{
			String FD_Datad[]=rs1.getString("FD_Data"+d).split(",");
			cell=row.createCell(si);
			cell.setCellValue(FD_Datad[1]);
			cell.setCellStyle(style);
			si++;
		}
		else if(d==4)
		{
			String FD_Datad[]=rs1.getString("FD_Data"+d).split(" ");
			cell=row.createCell(si);
			cell.setCellValue(FD_Datad[0]);
			cell.setCellStyle(style);
			si++;
		}
		else if(d!=2)
		{
			cell=row.createCell(si);
			cell.setCellValue(rs1.getString("FD_Data"+d));
			cell.setCellStyle(style);
			si++;
		}		
	}	
	s++;	
}

//-----------------下載資料-----------------
String Fcategoryname="";
if(Fcategory.equals("JFlow_Form_253"))
{
	 Fcategoryname="收銀機台裝測移";
}	
response.addHeader("Content-Disposition", "attachment;filename*=utf-8'zh_tw'" +  URLEncoder.encode(Fcategoryname+".xlsx", "UTF-8"));
response.setContentType("application/octet-stream");//二進位流，不知道下載檔案類型
workbook.write(response.getOutputStream());

//-------------------釋放-------------------
if (rs != null) rs.close();rs=null;
if (rs1 != null) rs1.close();rs1=null;
Conn.close();

%>
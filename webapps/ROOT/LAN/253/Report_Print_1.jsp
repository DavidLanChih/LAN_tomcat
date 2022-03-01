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
String SqlStr="",SqlStr1="";
String Fcategory=req("Fcategory",request);
int i=0;
ArrayList<String> list = new ArrayList<String>();
ArrayList<String> fidelists = new ArrayList<String>();
ResultSet rs=null,rs1=null,rs2=null;

//--------------------創建EXCEL工作簿---------------------
XSSFWorkbook workbook = new XSSFWorkbook();

XSSFSheet sheet = workbook.createSheet("sheet1");                                 //生成表單(表單名稱)
//sheet.setColumnWidth( 0, 5000);                                                 //第一行欄位寬度
for(i = 0; i <= 20;i++)                                                           //第1-20行的欄位寬度
{
	sheet.setColumnWidth( i, 8000);
}
//sheet.addMergedRegion(new CellRangeAddress(0,1,0,0));                           //合併列數 (起始行號,終止行號,起始列號,終止列號)


//------表單列印設定------
sheet.setFitToPage(false);                                                        //true:列印時會將工作表單放在同一頁面
sheet.setHorizontallyCenter(true);//水平                                          //設置列印表單文本整體位置
//sheet.setVerticallyCenter(true);//垂直
sheet.getPrintSetup().setLandscape(true);                                         //設置列印方向(true為橫向,false為直向)
sheet.getPrintSetup().setPaperSize(XSSFPrintSetup.A4_PAPERSIZE);                  //設置為A4紙張
sheet.setMargin(XSSFSheet.TopMargin, 0.24);                                       //設置列印上緣距離
sheet.setMargin(XSSFSheet.BottomMargin, 0.24);                                    //設置列印下緣距離
sheet.setMargin(XSSFSheet.LeftMargin, 0.24);                                      //設置列印左緣距離
sheet.setMargin(XSSFSheet.RightMargin, 0.24);                                     //設置列印右緣距離

//-----第一組配色設計-----
XSSFColor color = new XSSFColor(new java.awt.Color(234, 234, 234));               //顏色設定:(RGB三原色色盤: 紅色, 綠色, 藍色)
XSSFColor color_underline = new XSSFColor(new java.awt.Color(0, 153, 255));

//設置字體
Font font = workbook.createFont();
font.setFontHeightInPoints((short) 14);                                            //字體大小
font.setFontName("新細明體");                                                      //字體樣式
font.setBoldweight(Font.BOLDWEIGHT_BOLD);                                          //設定為粗體字
font.setColor(HSSFColor.BLACK.index);                                              //字體顏色

//font.setColor(color);                                                            //字體套用色盤顏色
//font.setItalic(true);                                                            //斜體
//font.setBold(true);                                                              //加粗
//font.setColor(new XSSFColor(Color.decode("#7CFC00")));                           //字體套用色盤顏色

//設定樣式
XSSFCellStyle style = workbook.createCellStyle();
style.setWrapText(true);                                                           //強制換行  
style.setFillForegroundColor(color);                                               //套用色盤顏色
//style.setFillForegroundColor(HSSFColor.WHITE.index);                             //設定背景顏色（白色）
style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style.setAlignment(XSSFCellStyle.ALIGN_CENTER);                                    //水平置中
style.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);                         //垂直置中
style.setBorderBottom(HSSFCellStyle.BORDER_THICK);                                 //下框線粗細 Thin;//細實線 Thick;//粗 Hair;//虛線
style.setBorderLeft(HSSFCellStyle.BORDER_THIN);                                    //左框線粗細
style.setBorderRight(HSSFCellStyle.BORDER_THIN);                                   //右框線粗細
style.setBorderTop(HSSFCellStyle.BORDER_THIN);                                     //上框線粗細
style.setBottomBorderColor(color_underline);                                       //下框線顏色
style.setLeftBorderColor(HSSFColor.BLACK.index);                                   //左框線顏色
style.setRightBorderColor(HSSFColor.BLACK.index);                                  //右框線顏色
style.setTopBorderColor(HSSFColor.BLACK.index);                                    //上框線顏色
style.setFont(font);


//-----第二組配色設計-----
XSSFColor color1 = new XSSFColor(new java.awt.Color(65, 105, 225));

Font font1 = workbook.createFont();
font1.setFontHeightInPoints((short) 10);
font1.setFontName("標楷體");
//font1.setBoldweight(Font.BOLDWEIGHT_BOLD); 
font1.setColor(HSSFColor.BLACK.index);

XSSFCellStyle style1 = workbook.createCellStyle();
style1.setWrapText(true);
//style1.setFillForegroundColor(color);
style1.setFillForegroundColor(HSSFColor.WHITE.index);
style1.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style1.setAlignment(XSSFCellStyle.ALIGN_CENTER);
style1.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER); 
style1.setBorderBottom(HSSFCellStyle.BORDER_THIN);
style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);
style1.setBorderRight(HSSFCellStyle.BORDER_THIN);
style1.setBorderTop(HSSFCellStyle.BORDER_THIN);
style1.setBottomBorderColor(HSSFColor.BLACK.index);
style1.setLeftBorderColor(HSSFColor.BLACK.index);
style1.setRightBorderColor(HSSFColor.BLACK.index);
style1.setTopBorderColor(HSSFColor.BLACK.index);
style1.setFont(font1);


//-------------表單欄位內容設定-------------
XSSFRow row = null;
XSSFCell cell = null;

//------------創建第一行所有欄位------------    
for(int s=1;s<=16;s++)
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
	for(int m=1;m<=16;m++)                                                                   //創建第一行m個欄位
	{
		if(!rs.getString("FF_F"+(m)+"_Name").trim().equals(""))
		{
			cell=row.createCell(f);                                                          //創建第一格欄位，參數=0...類推
			cell.setCellValue(rs.getString("FF_F"+(m)+"_Name").trim());                      //輸入此格的內容
			cell.setCellStyle(style);                                                        //設定此格的外框等設計
			f++;	                                                                         //欄位參數+1
		}		
	}	
}

//---------------創造多行+多欄位------------
SqlStr1="select * from flow_formdata where FD_FormId='253'";
rs1=Data.getSmt(Conn,SqlStr1);
int s=1;
while(rs1.next())
{	
	row=sheet.createRow(s);
	int si=0;
	for(int d=1;d<17;d++)
	{		
		cell=row.createCell(si);
		cell.setCellValue(rs1.getString("FD_Data"+d));
		cell.setCellStyle(style1);
		si++;
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
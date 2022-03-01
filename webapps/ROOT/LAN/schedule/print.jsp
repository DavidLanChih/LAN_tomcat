<%@ include file="/kernel.jsp" %>
<%@ include file="/cykernel.jsp" %>
<%@page import="leeten.*" %>
<%@page import="java.net.*,java.lang.*,java.net.URLEncoder,javax.mail.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat,java.sql.*,java.util.*" %>

<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCellStyle" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFColor" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFPrintSetup" %>
<%@ page import="org.apache.poi.ss.util.CellRangeAddress" %>
<%@ page import="org.apache.poi.ss.usermodel.CellStyle" %>
<%@ page import="org.apache.poi.ss.usermodel.Font" %>

<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="org.apache.poi.ss.util.RegionUtil" %>



<%@ page contentType="text/html;charset=MS950" %>
<%!
    private String week(int n){
  String [] w={"日","一","二","三","四","五","六"};
  return w[n-1];
    }
%>
<%
leeten.Org JOrg=new leeten.Org(Data,Conn);
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String SqlStr="",formatAns="";
String formatStr = "%02d";
int i=0,y=0,maxDay=0,start=0;
ResultSet rs=null,rs1=null;
Calendar c =null;
XSSFRow row = null;
XSSFCell cell = null;	
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

c = Calendar.getInstance();
//獲得當前月的最大日期數
maxDay = c.getActualMaximum(Calendar.DATE);
//輸出該月中的所有日期

//創建工作簿
XSSFWorkbook workbook = new XSSFWorkbook();
//生成表單
XSSFSheet sheet = workbook.createSheet("sheet1");
sheet.setColumnWidth( 0, 1800);//第一行欄位寬度
sheet.setColumnWidth( 1, 3000);//第二行欄位寬度
for(i = 1; i <= maxDay;i++)
{
	sheet.setColumnWidth( i+1, 1600);//第三行以後欄位寬度
}

//合併列數 引數1：行號 引數2：行號 引數3：起始列號 引數4：終止列號
sheet.addMergedRegion(new CellRangeAddress(0,1,0,0));
//設置表單文本居中
sheet.setHorizontallyCenter(true);//水平
//sheet.setVerticallyCenter(true);//垂直
sheet.setFitToPage(false);
sheet.getPrintSetup().setLandscape(true);//true設置橫向列印false 直向
sheet.getPrintSetup().setPaperSize(XSSFPrintSetup.A3_PAPERSIZE);//設置為A4紙張
//上下左右邊距
sheet.setMargin(XSSFSheet.TopMargin, 0.24);
sheet.setMargin(XSSFSheet.BottomMargin, 0.24);
sheet.setMargin(XSSFSheet.LeftMargin, 0.24);
sheet.setMargin(XSSFSheet.RightMargin, 0.24);




//創建Excel 樣板字體
//XSSFColor color = new XSSFColor(new java.awt.Color(255, 0, 0));//RGB三原色色盤 紅色 綠色 藍色
//設置字體
Font font = workbook.createFont();
font.setFontHeightInPoints((short) 10);//字體大小
font.setFontName("新細明體");//字體樣式
font.setBoldweight(Font.BOLDWEIGHT_BOLD); // 粗體字
font.setColor(HSSFColor.BLACK.index);//字體顏色黑色

//font.setColor(color);//套用色盤顏色
//font.setItalic(true);//斜體
//font.setBold(true); // 加粗

//設定樣式
XSSFCellStyle style = workbook.createCellStyle();
style.setWrapText(true);//強制換行/r/n  
//style.setFillForegroundColor(color);//套用色盤顏色
style.setFillForegroundColor(HSSFColor.WHITE.index);//設定背景顏色（白色）
style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style.setAlignment(XSSFCellStyle.ALIGN_CENTER); // 水平置中
style.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER); // 垂直置中
style.setBorderBottom(HSSFCellStyle.BORDER_THIN);//下框線粗細 Thin;//細實線 Thick;//粗 Hair;//虛線
style.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左框線粗細
style.setBorderRight(HSSFCellStyle.BORDER_THIN);//右框線粗細
style.setBorderTop(HSSFCellStyle.BORDER_THIN);//上框線粗細
style.setBottomBorderColor(HSSFColor.BLACK.index);//下框線顏色
style.setLeftBorderColor(HSSFColor.BLACK.index);//左框線顏色
style.setRightBorderColor(HSSFColor.BLACK.index);//右框線顏色
style.setTopBorderColor(HSSFColor.BLACK.index);//上框線顏色
style.setFont(font);



XSSFCellStyle style1 = workbook.createCellStyle();
style1.setWrapText(true);//強制換行/r/n   
style1.setFillForegroundColor(HSSFColor.TAN.index);//設定背景顏色（棕褐色）
style1.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style1.setAlignment(XSSFCellStyle.ALIGN_CENTER); // 水平置中
style1.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER); // 垂直置中
style1.setBorderBottom(HSSFCellStyle.BORDER_THIN);//下框線粗細
style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左框線粗細
style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右框線粗細
style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上框線粗細
style1.setBottomBorderColor(HSSFColor.BLACK.index);//下框線顏色
style1.setLeftBorderColor(HSSFColor.BLACK.index);//左框線顏色
style1.setRightBorderColor(HSSFColor.BLACK.index);//右框線顏色
style1.setTopBorderColor(HSSFColor.BLACK.index);//上框線顏色
style1.setFont(font);



//設置字體
Font font1 = workbook.createFont();
font1.setFontHeightInPoints((short) 10);//字體大小
font1.setFontName("新細明體");//字體樣式
font1.setBoldweight(Font.BOLDWEIGHT_BOLD); // 粗體字
font1.setColor(HSSFColor.RED.index);//字體顏色紅色
//font1.setItalic(true);//斜體
//font1.setBold(true); // 加粗

//設定樣式
XSSFCellStyle style2 = workbook.createCellStyle();
style2.setWrapText(true);//強制換行/r/n  
style2.setFillForegroundColor(HSSFColor.WHITE.index);//設定背景顏色（白色）
style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style2.setAlignment(XSSFCellStyle.ALIGN_CENTER); // 水平置中
style2.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER); // 垂直置中
style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);//下框線粗細
style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左框線粗細
style2.setBorderRight(HSSFCellStyle.BORDER_THIN);//右框線粗細
style2.setBorderTop(HSSFCellStyle.BORDER_THIN);//上框線粗細
style2.setBottomBorderColor(HSSFColor.BLACK.index);//下框線顏色
style2.setLeftBorderColor(HSSFColor.BLACK.index);//左框線顏色
style2.setRightBorderColor(HSSFColor.BLACK.index);//右框線顏色
style2.setTopBorderColor(HSSFColor.BLACK.index);//上框線顏色
style2.setFont(font1);


XSSFCellStyle style3 = workbook.createCellStyle();
style3.setWrapText(true);//強制換行/r/n  
style3.setFillForegroundColor(HSSFColor.TAN.index);//設定背景顏色（棕褐色）
style3.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style3.setAlignment(XSSFCellStyle.ALIGN_CENTER); // 水平置中
style3.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER); // 垂直置中
style3.setBorderBottom(HSSFCellStyle.BORDER_THIN);//下框線粗細
style3.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左框線粗細
style3.setBorderRight(HSSFCellStyle.BORDER_THIN);//右框線粗細
style3.setBorderTop(HSSFCellStyle.BORDER_THIN);//上框線粗細
style3.setBottomBorderColor(HSSFColor.BLACK.index);//下框線顏色
style3.setLeftBorderColor(HSSFColor.BLACK.index);//左框線顏色
style3.setRightBorderColor(HSSFColor.BLACK.index);//右框線顏色
style3.setTopBorderColor(HSSFColor.BLACK.index);//上框線顏色
style3.setFont(font1);

try
{
		
	//第一行資料表格
	row = sheet.createRow(0);//創建第一行，為標題，index從0開始
	cell = row.createCell(0);
	cell.setCellValue("工號");
	cell.setCellStyle(style);
	cell = row.createCell(1);
	cell.setCellValue("日期/星期");
	cell.setCellStyle(style);

	for(i = 1; i <= maxDay;i++)
	{
		
		//輸出日期數字
		c.set(Calendar.DATE,i);
		start = c.get(Calendar.DAY_OF_WEEK);
		if(week(start).equals("六")||week(start).equals("日"))
		{
			row.createCell(i+1).setCellValue(i);//1 row i+2 column
			cell = row.createCell(i+1);
			cell.setCellValue(i);
			cell.setCellStyle(style2);
		}
		else 
		{
			row.createCell(i+1).setCellValue(i);//1 row i+2 column
			cell = row.createCell(i+1);
			cell.setCellValue(i);
			cell.setCellStyle(style);
		}
		
	}	

	row=sheet.createRow(1);//創建第三行
	cell = row.createCell(0);
	cell.setCellStyle(style);
	cell = row.createCell(1);
	cell.setCellValue("姓名/班別");
	cell.setCellStyle(style);
	for(i = 1; i <= maxDay;i++)
	{
		//獲得1號是星期幾
		c.set(Calendar.DATE,i);
		start = c.get(Calendar.DAY_OF_WEEK);
		if(week(start).equals("六")||week(start).equals("日"))
		{
			row.createCell(i+1).setCellValue(week(start));//1 row i+2 column
			cell = row.createCell(i+1);
			cell.setCellValue(week(start));
			cell.setCellStyle(style2);
		}
		else 
		{
			row.createCell(i+1).setCellValue(week(start));//1 row i+2 column
			cell = row.createCell(i+1);
			cell.setCellValue(week(start));
			cell.setCellStyle(style);
		}

		
	}


	y=1;
	SqlStr="select * from manf013,manf073,manf002 where m002_no=m013_no and m073_boss=m013_no and m073_code='1' and m013_yy='2019' and m013_mm='12'" +
	" and m073_dept!='C8000' and m073_dept!='C804T' and m073_dept!='Z1000' and m073_dept!='X0300' and m073_dept!='P0000' and m073_dept!='Z0000' and m073_dept!='C8E00'"+
	" order by  m073_dept ";
	rs=stmt.executeQuery(SqlStr);
	while(rs.next())
	{
		if((y - 1) % 2 == 0)
		{
			row=sheet.createRow(y+1);//創建第三行
			cell = row.createCell(0);
			cell.setCellValue(rs.getString("m013_no").trim());
			cell.setCellStyle(style1);
			cell = row.createCell(1);
			cell.setCellValue(rs.getString("m002_name").trim());
			cell.setCellStyle(style1);
			
			for(i = 1; i <= maxDay;i++)
			{
				
				c.set(Calendar.DATE,i);
				start = c.get(Calendar.DAY_OF_WEEK);
				formatAns = String.format(formatStr, i);
				if(week(start).equals("六")||week(start).equals("日"))
				{
					cell = row.createCell(i+1);
					cell.setCellValue(rs.getString("m013_dd"+formatAns).trim());
					cell.setCellStyle(style3);
				}
				else 
				{
					cell = row.createCell(i+1);
					cell.setCellValue(rs.getString("m013_dd"+formatAns).trim());
					cell.setCellStyle(style1);
				}
				
				
			}
		}
		else
		{
			row=sheet.createRow(y+1);//創建第三行
			cell = row.createCell(0);
			cell.setCellValue(rs.getString("m013_no").trim());
			cell.setCellStyle(style);
			cell = row.createCell(1);
			cell.setCellValue(rs.getString("m002_name").trim());
			cell.setCellStyle(style);
			
			for(i = 1; i <= maxDay;i++)
			{
				
				c.set(Calendar.DATE,i);
				start = c.get(Calendar.DAY_OF_WEEK);
				formatAns = String.format(formatStr, i);
				if(week(start).equals("六")||week(start).equals("日"))
				{
					cell = row.createCell(i+1);
					cell.setCellValue(rs.getString("m013_dd"+formatAns).trim());
					cell.setCellStyle(style2);
				}
				else 
				{
					cell = row.createCell(i+1);
					cell.setCellValue(rs.getString("m013_dd"+formatAns).trim());
					cell.setCellStyle(style);
				}
			
				
			}
		}
		y++;
	}
	SqlStr="select * from manf019 where m019_type is null and (m019_code='E' or m019_code='F' or m019_code='A7' or m019_code='E9' or m019_code='K1' or m019_code='K2' or m019_code='F1' or m019_code='E9' or m019_code='E1' or m019_code='E3' or m019_code='E4' or m019_code='E6' or m019_code='E8' or m019_code='K')";
	rs1=stmt.executeQuery(SqlStr);
	String ss="";
	while(rs1.next())
	{
		if(rs1.getString("m019_code").equals("F1"))
		{ss+=rs1.getString("m019_code")+"("+rs1.getString("m019_hh1")+":"+String.format(formatStr, rs1.getInt("m019_mm1"))+"~"+rs1.getString("m019_hh2")+":"+String.format(formatStr, rs1.getInt("m019_mm2"))+")。\r\n";}
		else 
		{ss+=rs1.getString("m019_code")+"("+rs1.getString("m019_hh1")+":"+String.format(formatStr, rs1.getInt("m019_mm1"))+"~"+rs1.getString("m019_hh2")+":"+String.format(formatStr, rs1.getInt("m019_mm2"))+")。";}
		
	}
	
	//合併行數 引數1：行號 引數2：行號 引數3：起始列號 引數4：終止列號
	sheet.addMergedRegion(new CellRangeAddress((y+1),(y+2),0,(maxDay+1)));
	row=sheet.createRow(y+1);//創建倒數第二行
	//合併儲存格無框線，所以必須每一格欄位都設定框線
	for( i=0;i<=(maxDay+1);i++)
	{
	    cell = row.createCell(i);
		if(i == 0){cell.setCellValue(ss);}
		cell.setCellStyle(style);
	}
	row=sheet.createRow(y+2);//創建第最後一行
	//合併儲存格無框線，所以必須每一格欄位都設定框線
	for( i=0;i<=(maxDay+1);i++)
	{
	    cell = row.createCell(i);
		cell.setCellStyle(style);
	}
	
	
	
	
	//下載資料
	response.addHeader("Content-Disposition", "attachment;filename*=utf-8'zh_tw'" +  URLEncoder.encode("主管"+ (c.get(Calendar.MONTH)+1)+"月份班表.xlsx", "UTF-8"));
	response.setContentType("application/octet-stream");//二進位流，不知道下載檔案類型
	workbook.write(response.getOutputStream());
}
catch(Exception e)
{
	out.println("連結錯誤:" + e);
 
}

rs.close();rs=null;
rs1.close();rs1=null;
stmt.close();
conn.close();
closeConn(Data,Conn);



%>

</body>
</html>



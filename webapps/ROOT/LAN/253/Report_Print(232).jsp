<%@ include file="/kernel.jsp" %>
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


<%@ page import=" org.apache.poi.ss.usermodel.Cell" %>
<%@ page import=" org.apache.poi.ss.usermodel.Row" %>
<%@ page import=" org.apache.poi.ss.usermodel.Sheet" %>



<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="org.apache.poi.ss.util.RegionUtil" %>


<%@ page contentType="text/html;charset=MS950" %>
<%!
private String week(int n)
{
	String [] w={"日","一","二","三","四","五","六"};
	return w[n-1];
}
%>
<%
leeten.Org JOrg=new leeten.Org(Data,Conn);
leeten.Util JUtil=new leeten.Util();
leeten.Date JDate=new leeten.Date();
String SqlStr="",formatAns="",SqlStr1="";
String strYear="",strMonth="",strDay="",strdate1="",strdate2="";
String FD_Data1="",FD_Data2="",FD_Data3="",FD_Data4="",FD_Data8="",FD_Data9="",FD_Data6="",startTime="";
String FD_Data6Arr[]=null;
Date startDate=null,endDate1=null,endDate2=null;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd"); 
Calendar start1 =null;
Calendar end1 =null;
Calendar end2 =null; 
String FI_RecId="";
String I_Value="";
String FNamet5=null;
String Fcategory=req("Fcategory",request);

int Yeari1=0,Monthi1=0,Dayi1=0,Yeari2=0,Monthi2=0,Dayi2=0;

String SDate=req("SDate",request);
String DateArr1[]=SDate.split("/");
String SYear=DateArr1[0];

Yeari1=Integer.parseInt(DateArr1[0]);
Monthi1 =Integer.parseInt(DateArr1[1]);
Dayi1=Integer.parseInt(DateArr1[2]);

String SMonth=String.format("%02d", Monthi1);
String SDay=String.format("%02d", Dayi1);
String SDate1=SYear+"/"+SMonth+"/"+SDay;

String EDate=req("EDate",request);
String DateArr2[]=EDate.split("/");
String EYear=DateArr2[0];
Yeari2=Integer.parseInt(DateArr2[0]);
Monthi2 =Integer.parseInt(DateArr2[1]);
Dayi2=Integer.parseInt(DateArr2[2]);
String EMonth=String.format("%02d", Monthi2);
String EDay=String.format("%02d", Dayi2);
String EDate1=EYear+"/"+EMonth+"/"+EDay;

String[] months = {"一月", "二月", "三月", "四月",
                    "五月", "六月", "七月", "八月",
                    "九月", "十月", "十一月", "十二月"};
String[] w1={"日","一","二","三","四","五","六"};
int i=0,j=0,x=0,y=0,z=0,maxDay=0,start=0,count=0;
ResultSet rs=null,rs1=null,rs2=null;
Calendar c =null;
XSSFRow row = null;
XSSFCell cell = null;	

ArrayList<String> list = new ArrayList<String>();

ArrayList<String> fidelist = new ArrayList<String>();

ArrayList<String> fidelists = new ArrayList<String>();



c = Calendar.getInstance();
c.set(Yeari1, Monthi1-1, Dayi1, 0, 0, 0);
//out.println(Monthi1);
//獲得當前月的最大日期數
maxDay = c.getActualMaximum(Calendar.DATE);
//輸出該月中的所有日期

//創建工作簿
XSSFWorkbook workbook = new XSSFWorkbook();
//生成表單
XSSFSheet sheet = workbook.createSheet("sheet1");
/*sheet.setColumnWidth( 0, 5000);//第一行欄位寬度
sheet.setColumnWidth( 1, 5000);
sheet.setColumnWidth( 2, 5000);
sheet.setColumnWidth( 3, 5000);*/
for(i = 0; i <= 100;i++)
{
	sheet.setColumnWidth( i, 5000);//第三行以後欄位寬度
}

//合併列數 引數1：行號 引數2：行號 引數3：起始列號 引數4：終止列號
//sheet.addMergedRegion(new CellRangeAddress(0,1,0,0));
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
//font.setColor(new XSSFColor(Color.decode("#7CFC00"))); 

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
     
for(int s=1;s<=2;s++)
{
	fidelists.add("FF_F"+s+"_Name");
}
String fidenumst = fidelists.toString();
String stringstat= fidenumst.replace("[","");
String stringstat2= stringstat.replace("]","");


SqlStr1="select "+stringstat2+" FROM flow_formfieldinfo "+
"INNER JOIN flow_forminfo ON flow_forminfo.FI_RecId = flow_formfieldinfo.FF_FormRecId "+
"where flow_forminfo.FI_ID='"+Fcategory+"' order by flow_forminfo.FI_RecDate desc limit 1";

rs2=Data.getSmt(Conn,SqlStr1);

if(rs2.next())
{
	row = sheet.createRow(0);//創建第一行，為標題，index從0開始
	int f =0;
	for(int m=1;m<=2;m++)
	{
		if(!rs2.getString("FF_F"+(m)+"_Name").trim().equals(""))
		{
			cell = row.createCell(f);
			cell.setCellValue(rs2.getString("FF_F"+(m)+"_Name").trim());
			cell.setCellStyle(style);
			list.add(rs2.getString("FF_F"+(m)+"_Name").trim());		
			f++;	
		}
		else
		{
			list.add(null);	
		}
	}	
	cell = row.createCell(f);

}

for(int N=1;N<100;N++)
{
	fidelist.add("flow_formdata.FD_Data"+N+"");
}
String fidenum = fidelist.toString();
String stringsta= fidenum.replace("[","");
String stringsta2= stringsta.replace("]","");

	

SqlStr="select flow_formdata.FD_RecId,"+ stringsta2+",FD_Data1 FROM flow_formdata"+
" INNER JOIN flow_form_rulestage ON flow_formdata.FD_RecId = flow_form_rulestage.FR_DataId"+
" INNER JOIN flow_forminfo ON flow_forminfo.FI_RecId = flow_formdata.FD_FormId "+
"WHERE (CONVERT(varchar(10),CONVERT(datetime,FD_Data1,111),111)  BETWEEN '"+SDate1+"' AND '"+EDate1+"') "+
"and flow_forminfo.FI_ID ='"+Fcategory+"'and flow_form_rulestage.FR_FinishState='1'"+
" order by flow_formdata.FD_RecDate desc";

rs=Data.getSmt(Conn,SqlStr);
y=1; 
String optiontest="";

while(rs.next())
{
	
	row=sheet.createRow(y);//創建第六行內容
	int f =0;
	for(int k=0;k<=1;k++)
	{	
		if(k==101)
		{
			
					cell.setCellValue(rs.getString("FD_RecDate").trim());
					cell.setCellStyle(style);
					cell.setCellValue(rs.getString("FD_RecDate").trim());
					cell.setCellStyle(style);
		}
		else{
			optiontest = list.get(k);
		
			if(optiontest != null)
			{
				
				cell = row.createCell(f);
				if(Fcategory.equals("JFlow_Form_232"))
				{
					/*if(f==0||f==2||f==6||f==10||f==14)
					{
						if(!rs.getString("FD_Data"+(k+1)).trim().equals(""))
						{
							String Cellname[] = rs.getString("FD_Data"+(k+1)).trim().split(",");
							cell.setCellValue(Cellname[1]);
						}
					}*/
				
						if(k==100)
						{cell.setCellValue(rs.getString("FD_RecDate").trim());}
						if(k<=99)
						{cell.setCellValue(rs.getString("FD_Data"+(k+1)).trim());}
					
					
				}
				else if(Fcategory.equals("JFlow_Form_235"))
				{
					
						if(k==100)
						{cell.setCellValue(rs.getString("FD_RecDate").trim());}
						if(k<=99)
						{cell.setCellValue(rs.getString("FD_Data"+(k+1)).trim());}
					
					out.println();
					
				}
				else if(Fcategory.equals("JFlow_Form_237"))
				{
					
						if(k==100)
						{cell.setCellValue(rs.getString("FD_RecDate").trim());}
						if(k<=99)
						{cell.setCellValue(rs.getString("FD_Data"+(k+1)).trim());}
					
				}
				
				else
				{
					cell.setCellValue(rs.getString("FD_Data"+(k+1)).trim());
					
				}
			
				cell.setCellStyle(style);
				f++;
		
				
			}
		}
	}	
	
					
	y++;
}
if (rs != null) rs.close();rs=null;
if (rs2 != null) rs2.close();rs2=null;
	

//下載資料
String Fcategoryname = "";
if(Fcategory.equals("JFlow_Form_232"))
{
	 Fcategoryname="付款調整帳務";
}
else if(Fcategory.equals("JFlow_Form_235"))
{
	Fcategoryname="信用卡帳務";
}
else if(Fcategory.equals("JFlow_Form_237"))
{
	Fcategoryname="發票清機條帳務";
}

	
response.addHeader("Content-Disposition", "attachment;filename*=utf-8'zh_tw'" +  URLEncoder.encode(Fcategoryname+".xlsx", "UTF-8"));
response.setContentType("application/octet-stream");//二進位流，不知道下載檔案類型
workbook.write(response.getOutputStream());
if (rs != null) rs.close();
//rs=null;rs.close();
closeConn(Data,Conn);



%>





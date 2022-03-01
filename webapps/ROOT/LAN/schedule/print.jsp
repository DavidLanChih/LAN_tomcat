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
  String [] w={"��","�@","�G","�T","�|","��","��"};
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
//��o��e�몺�̤j�����
maxDay = c.getActualMaximum(Calendar.DATE);
//��X�Ӥ뤤���Ҧ����

//�Ыؤu�@ï
XSSFWorkbook workbook = new XSSFWorkbook();
//�ͦ����
XSSFSheet sheet = workbook.createSheet("sheet1");
sheet.setColumnWidth( 0, 1800);//�Ĥ@�����e��
sheet.setColumnWidth( 1, 3000);//�ĤG�����e��
for(i = 1; i <= maxDay;i++)
{
	sheet.setColumnWidth( i+1, 1600);//�ĤT��H�����e��
}

//�X�֦C�� �޼�1�G�渹 �޼�2�G�渹 �޼�3�G�_�l�C�� �޼�4�G�פ�C��
sheet.addMergedRegion(new CellRangeAddress(0,1,0,0));
//�]�m���奻�~��
sheet.setHorizontallyCenter(true);//����
//sheet.setVerticallyCenter(true);//����
sheet.setFitToPage(false);
sheet.getPrintSetup().setLandscape(true);//true�]�m��V�C�Lfalse ���V
sheet.getPrintSetup().setPaperSize(XSSFPrintSetup.A3_PAPERSIZE);//�]�m��A4�ȱi
//�W�U���k��Z
sheet.setMargin(XSSFSheet.TopMargin, 0.24);
sheet.setMargin(XSSFSheet.BottomMargin, 0.24);
sheet.setMargin(XSSFSheet.LeftMargin, 0.24);
sheet.setMargin(XSSFSheet.RightMargin, 0.24);




//�Ы�Excel �˪O�r��
//XSSFColor color = new XSSFColor(new java.awt.Color(255, 0, 0));//RGB�T����L ���� ��� �Ŧ�
//�]�m�r��
Font font = workbook.createFont();
font.setFontHeightInPoints((short) 10);//�r��j�p
font.setFontName("�s�ө���");//�r��˦�
font.setBoldweight(Font.BOLDWEIGHT_BOLD); // ����r
font.setColor(HSSFColor.BLACK.index);//�r���C��¦�

//font.setColor(color);//�M�Φ�L�C��
//font.setItalic(true);//����
//font.setBold(true); // �[��

//�]�w�˦�
XSSFCellStyle style = workbook.createCellStyle();
style.setWrapText(true);//�j���/r/n  
//style.setFillForegroundColor(color);//�M�Φ�L�C��
style.setFillForegroundColor(HSSFColor.WHITE.index);//�]�w�I���C��]�զ�^
style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style.setAlignment(XSSFCellStyle.ALIGN_CENTER); // �����m��
style.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER); // �����m��
style.setBorderBottom(HSSFCellStyle.BORDER_THIN);//�U�ؽu�ʲ� Thin;//�ӹ�u Thick;//�� Hair;//��u
style.setBorderLeft(HSSFCellStyle.BORDER_THIN);//���ؽu�ʲ�
style.setBorderRight(HSSFCellStyle.BORDER_THIN);//�k�ؽu�ʲ�
style.setBorderTop(HSSFCellStyle.BORDER_THIN);//�W�ؽu�ʲ�
style.setBottomBorderColor(HSSFColor.BLACK.index);//�U�ؽu�C��
style.setLeftBorderColor(HSSFColor.BLACK.index);//���ؽu�C��
style.setRightBorderColor(HSSFColor.BLACK.index);//�k�ؽu�C��
style.setTopBorderColor(HSSFColor.BLACK.index);//�W�ؽu�C��
style.setFont(font);



XSSFCellStyle style1 = workbook.createCellStyle();
style1.setWrapText(true);//�j���/r/n   
style1.setFillForegroundColor(HSSFColor.TAN.index);//�]�w�I���C��]�ĽŦ�^
style1.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style1.setAlignment(XSSFCellStyle.ALIGN_CENTER); // �����m��
style1.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER); // �����m��
style1.setBorderBottom(HSSFCellStyle.BORDER_THIN);//�U�ؽu�ʲ�
style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//���ؽu�ʲ�
style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//�k�ؽu�ʲ�
style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//�W�ؽu�ʲ�
style1.setBottomBorderColor(HSSFColor.BLACK.index);//�U�ؽu�C��
style1.setLeftBorderColor(HSSFColor.BLACK.index);//���ؽu�C��
style1.setRightBorderColor(HSSFColor.BLACK.index);//�k�ؽu�C��
style1.setTopBorderColor(HSSFColor.BLACK.index);//�W�ؽu�C��
style1.setFont(font);



//�]�m�r��
Font font1 = workbook.createFont();
font1.setFontHeightInPoints((short) 10);//�r��j�p
font1.setFontName("�s�ө���");//�r��˦�
font1.setBoldweight(Font.BOLDWEIGHT_BOLD); // ����r
font1.setColor(HSSFColor.RED.index);//�r���C�����
//font1.setItalic(true);//����
//font1.setBold(true); // �[��

//�]�w�˦�
XSSFCellStyle style2 = workbook.createCellStyle();
style2.setWrapText(true);//�j���/r/n  
style2.setFillForegroundColor(HSSFColor.WHITE.index);//�]�w�I���C��]�զ�^
style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style2.setAlignment(XSSFCellStyle.ALIGN_CENTER); // �����m��
style2.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER); // �����m��
style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);//�U�ؽu�ʲ�
style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);//���ؽu�ʲ�
style2.setBorderRight(HSSFCellStyle.BORDER_THIN);//�k�ؽu�ʲ�
style2.setBorderTop(HSSFCellStyle.BORDER_THIN);//�W�ؽu�ʲ�
style2.setBottomBorderColor(HSSFColor.BLACK.index);//�U�ؽu�C��
style2.setLeftBorderColor(HSSFColor.BLACK.index);//���ؽu�C��
style2.setRightBorderColor(HSSFColor.BLACK.index);//�k�ؽu�C��
style2.setTopBorderColor(HSSFColor.BLACK.index);//�W�ؽu�C��
style2.setFont(font1);


XSSFCellStyle style3 = workbook.createCellStyle();
style3.setWrapText(true);//�j���/r/n  
style3.setFillForegroundColor(HSSFColor.TAN.index);//�]�w�I���C��]�ĽŦ�^
style3.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style3.setAlignment(XSSFCellStyle.ALIGN_CENTER); // �����m��
style3.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER); // �����m��
style3.setBorderBottom(HSSFCellStyle.BORDER_THIN);//�U�ؽu�ʲ�
style3.setBorderLeft(HSSFCellStyle.BORDER_THIN);//���ؽu�ʲ�
style3.setBorderRight(HSSFCellStyle.BORDER_THIN);//�k�ؽu�ʲ�
style3.setBorderTop(HSSFCellStyle.BORDER_THIN);//�W�ؽu�ʲ�
style3.setBottomBorderColor(HSSFColor.BLACK.index);//�U�ؽu�C��
style3.setLeftBorderColor(HSSFColor.BLACK.index);//���ؽu�C��
style3.setRightBorderColor(HSSFColor.BLACK.index);//�k�ؽu�C��
style3.setTopBorderColor(HSSFColor.BLACK.index);//�W�ؽu�C��
style3.setFont(font1);

try
{
		
	//�Ĥ@���ƪ��
	row = sheet.createRow(0);//�ЫزĤ@��A�����D�Aindex�q0�}�l
	cell = row.createCell(0);
	cell.setCellValue("�u��");
	cell.setCellStyle(style);
	cell = row.createCell(1);
	cell.setCellValue("���/�P��");
	cell.setCellStyle(style);

	for(i = 1; i <= maxDay;i++)
	{
		
		//��X����Ʀr
		c.set(Calendar.DATE,i);
		start = c.get(Calendar.DAY_OF_WEEK);
		if(week(start).equals("��")||week(start).equals("��"))
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

	row=sheet.createRow(1);//�ЫزĤT��
	cell = row.createCell(0);
	cell.setCellStyle(style);
	cell = row.createCell(1);
	cell.setCellValue("�m�W/�Z�O");
	cell.setCellStyle(style);
	for(i = 1; i <= maxDay;i++)
	{
		//��o1���O�P���X
		c.set(Calendar.DATE,i);
		start = c.get(Calendar.DAY_OF_WEEK);
		if(week(start).equals("��")||week(start).equals("��"))
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
			row=sheet.createRow(y+1);//�ЫزĤT��
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
				if(week(start).equals("��")||week(start).equals("��"))
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
			row=sheet.createRow(y+1);//�ЫزĤT��
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
				if(week(start).equals("��")||week(start).equals("��"))
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
		{ss+=rs1.getString("m019_code")+"("+rs1.getString("m019_hh1")+":"+String.format(formatStr, rs1.getInt("m019_mm1"))+"~"+rs1.getString("m019_hh2")+":"+String.format(formatStr, rs1.getInt("m019_mm2"))+")�C\r\n";}
		else 
		{ss+=rs1.getString("m019_code")+"("+rs1.getString("m019_hh1")+":"+String.format(formatStr, rs1.getInt("m019_mm1"))+"~"+rs1.getString("m019_hh2")+":"+String.format(formatStr, rs1.getInt("m019_mm2"))+")�C";}
		
	}
	
	//�X�֦�� �޼�1�G�渹 �޼�2�G�渹 �޼�3�G�_�l�C�� �޼�4�G�פ�C��
	sheet.addMergedRegion(new CellRangeAddress((y+1),(y+2),0,(maxDay+1)));
	row=sheet.createRow(y+1);//�Ыح˼ƲĤG��
	//�X���x�s��L�ؽu�A�ҥH�����C�@����쳣�]�w�ؽu
	for( i=0;i<=(maxDay+1);i++)
	{
	    cell = row.createCell(i);
		if(i == 0){cell.setCellValue(ss);}
		cell.setCellStyle(style);
	}
	row=sheet.createRow(y+2);//�Ыزĳ̫�@��
	//�X���x�s��L�ؽu�A�ҥH�����C�@����쳣�]�w�ؽu
	for( i=0;i<=(maxDay+1);i++)
	{
	    cell = row.createCell(i);
		cell.setCellStyle(style);
	}
	
	
	
	
	//�U�����
	response.addHeader("Content-Disposition", "attachment;filename*=utf-8'zh_tw'" +  URLEncoder.encode("�D��"+ (c.get(Calendar.MONTH)+1)+"����Z��.xlsx", "UTF-8"));
	response.setContentType("application/octet-stream");//�G�i��y�A�����D�U���ɮ�����
	workbook.write(response.getOutputStream());
}
catch(Exception e)
{
	out.println("�s�����~:" + e);
 
}

rs.close();rs=null;
rs1.close();rs1=null;
stmt.close();
conn.close();
closeConn(Data,Conn);



%>

</body>
</html>



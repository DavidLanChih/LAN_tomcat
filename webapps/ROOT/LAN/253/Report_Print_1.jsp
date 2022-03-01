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

//--------------------�Ы�EXCEL�u�@ï---------------------
XSSFWorkbook workbook = new XSSFWorkbook();

XSSFSheet sheet = workbook.createSheet("sheet1");                                 //�ͦ����(���W��)
//sheet.setColumnWidth( 0, 5000);                                                 //�Ĥ@�����e��
for(i = 0; i <= 20;i++)                                                           //��1-20�檺���e��
{
	sheet.setColumnWidth( i, 8000);
}
//sheet.addMergedRegion(new CellRangeAddress(0,1,0,0));                           //�X�֦C�� (�_�l�渹,�פ�渹,�_�l�C��,�פ�C��)


//------���C�L�]�w------
sheet.setFitToPage(false);                                                        //true:�C�L�ɷ|�N�u�@����b�P�@����
sheet.setHorizontallyCenter(true);//����                                          //�]�m�C�L���奻�����m
//sheet.setVerticallyCenter(true);//����
sheet.getPrintSetup().setLandscape(true);                                         //�]�m�C�L��V(true����V,false�����V)
sheet.getPrintSetup().setPaperSize(XSSFPrintSetup.A4_PAPERSIZE);                  //�]�m��A4�ȱi
sheet.setMargin(XSSFSheet.TopMargin, 0.24);                                       //�]�m�C�L�W�t�Z��
sheet.setMargin(XSSFSheet.BottomMargin, 0.24);                                    //�]�m�C�L�U�t�Z��
sheet.setMargin(XSSFSheet.LeftMargin, 0.24);                                      //�]�m�C�L���t�Z��
sheet.setMargin(XSSFSheet.RightMargin, 0.24);                                     //�]�m�C�L�k�t�Z��

//-----�Ĥ@�հt��]�p-----
XSSFColor color = new XSSFColor(new java.awt.Color(234, 234, 234));               //�C��]�w:(RGB�T����L: ����, ���, �Ŧ�)
XSSFColor color_underline = new XSSFColor(new java.awt.Color(0, 153, 255));

//�]�m�r��
Font font = workbook.createFont();
font.setFontHeightInPoints((short) 14);                                            //�r��j�p
font.setFontName("�s�ө���");                                                      //�r��˦�
font.setBoldweight(Font.BOLDWEIGHT_BOLD);                                          //�]�w������r
font.setColor(HSSFColor.BLACK.index);                                              //�r���C��

//font.setColor(color);                                                            //�r��M�Φ�L�C��
//font.setItalic(true);                                                            //����
//font.setBold(true);                                                              //�[��
//font.setColor(new XSSFColor(Color.decode("#7CFC00")));                           //�r��M�Φ�L�C��

//�]�w�˦�
XSSFCellStyle style = workbook.createCellStyle();
style.setWrapText(true);                                                           //�j���  
style.setFillForegroundColor(color);                                               //�M�Φ�L�C��
//style.setFillForegroundColor(HSSFColor.WHITE.index);                             //�]�w�I���C��]�զ�^
style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style.setAlignment(XSSFCellStyle.ALIGN_CENTER);                                    //�����m��
style.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);                         //�����m��
style.setBorderBottom(HSSFCellStyle.BORDER_THICK);                                 //�U�ؽu�ʲ� Thin;//�ӹ�u Thick;//�� Hair;//��u
style.setBorderLeft(HSSFCellStyle.BORDER_THIN);                                    //���ؽu�ʲ�
style.setBorderRight(HSSFCellStyle.BORDER_THIN);                                   //�k�ؽu�ʲ�
style.setBorderTop(HSSFCellStyle.BORDER_THIN);                                     //�W�ؽu�ʲ�
style.setBottomBorderColor(color_underline);                                       //�U�ؽu�C��
style.setLeftBorderColor(HSSFColor.BLACK.index);                                   //���ؽu�C��
style.setRightBorderColor(HSSFColor.BLACK.index);                                  //�k�ؽu�C��
style.setTopBorderColor(HSSFColor.BLACK.index);                                    //�W�ؽu�C��
style.setFont(font);


//-----�ĤG�հt��]�p-----
XSSFColor color1 = new XSSFColor(new java.awt.Color(65, 105, 225));

Font font1 = workbook.createFont();
font1.setFontHeightInPoints((short) 10);
font1.setFontName("�з���");
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


//-------------�����줺�e�]�w-------------
XSSFRow row = null;
XSSFCell cell = null;

//------------�ЫزĤ@��Ҧ����------------    
for(int s=1;s<=16;s++)
{
	fidelists.add("FF_F"+s+"_Name");                                                         //�Ҧ�FF_F"+s+"_Name�N���g�ifidelists�}�C[ , , , , , ]
}
String fidenumst=fidelists.toString();
String stringstat=fidenumst.replace("[","");
String stringstat2=stringstat.replace("]","");

SqlStr="select "+stringstat2+" FROM flow_formfieldinfo "+
"INNER JOIN flow_forminfo ON flow_forminfo.FI_RecId = flow_formfieldinfo.FF_FormRecId "+     //���XFF�����N��=FI�����N�����Ҧ����
"where flow_forminfo.FI_ID='"+Fcategory+"' order by flow_forminfo.FI_RecDate desc limit 1";  //����FI�̷s�o�G�����

rs=Data.getSmt(Conn,SqlStr);
if(rs.next())
{
	row=sheet.createRow(0);                                                                  //�Ы�EXCEL�Ĥ@��A�Ĥ@��Ѽ�=0...����
	int f=0;
	for(int m=1;m<=16;m++)                                                                   //�ЫزĤ@��m�����
	{
		if(!rs.getString("FF_F"+(m)+"_Name").trim().equals(""))
		{
			cell=row.createCell(f);                                                          //�ЫزĤ@�����A�Ѽ�=0...����
			cell.setCellValue(rs.getString("FF_F"+(m)+"_Name").trim());                      //��J���檺���e
			cell.setCellStyle(style);                                                        //�]�w���檺�~�ص��]�p
			f++;	                                                                         //���Ѽ�+1
		}		
	}	
}

//---------------�гy�h��+�h���------------
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

//-----------------�U�����-----------------
String Fcategoryname="";
if(Fcategory.equals("JFlow_Form_253"))
{
	 Fcategoryname="���Ⱦ��x�˴���";
}	
response.addHeader("Content-Disposition", "attachment;filename*=utf-8'zh_tw'" +  URLEncoder.encode(Fcategoryname+".xlsx", "UTF-8"));
response.setContentType("application/octet-stream");//�G�i��y�A�����D�U���ɮ�����
workbook.write(response.getOutputStream());

//-------------------����-------------------
if (rs != null) rs.close();rs=null;
if (rs1 != null) rs1.close();rs1=null;
Conn.close();

%>
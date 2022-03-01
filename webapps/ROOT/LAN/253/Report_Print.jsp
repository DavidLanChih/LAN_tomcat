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
	String [] w={"��","�@","�G","�T","�|","��","��"};
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

String[] months = {"�@��", "�G��", "�T��", "�|��",
                    "����", "����", "�C��", "�K��",
                    "�E��", "�Q��", "�Q�@��", "�Q�G��"};
String[] w1={"��","�@","�G","�T","�|","��","��"};
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
//��o��e�몺�̤j�����
maxDay = c.getActualMaximum(Calendar.DATE);
//��X�Ӥ뤤���Ҧ����

//�Ыؤu�@ï
XSSFWorkbook workbook = new XSSFWorkbook();
//�ͦ����
XSSFSheet sheet = workbook.createSheet("sheet1");
/*sheet.setColumnWidth( 0, 5000);//�Ĥ@�����e��
sheet.setColumnWidth( 1, 5000);
sheet.setColumnWidth( 2, 5000);
sheet.setColumnWidth( 3, 5000);*/
for(i = 0; i <= 100;i++)
{
	sheet.setColumnWidth( i, 5000);//�ĤT��H�����e��
}

//�X�֦C�� �޼�1�G�渹 �޼�2�G�渹 �޼�3�G�_�l�C�� �޼�4�G�פ�C��
//sheet.addMergedRegion(new CellRangeAddress(0,1,0,0));
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
//font.setColor(new XSSFColor(Color.decode("#7CFC00"))); 

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
	for(int m=1;m<=16;m++)
	{
		if(!rs.getString("FF_F"+(m)+"_Name").trim().equals(""))
		{
			cell=row.createCell(f);                                                          //�Ыؤ@��A�Ĥ@��Ѽ�=0...����
			cell.setCellValue(rs.getString("FF_F"+(m)+"_Name").trim());                      //��J���檺���e
			cell.setCellStyle(style);                                                        //�]�w���檺�~�ص��]�p
			f++;	                                                                         //��ưѼ�+1
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
		cell.setCellStyle(style);
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
if (rs2 != null) rs2.close();rs2=null;
Conn.close();
%>





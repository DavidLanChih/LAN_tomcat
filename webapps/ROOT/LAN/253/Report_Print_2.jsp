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
//-----------����ɹs--------------
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
//--------------------�Ы�EXCEL�u�@ï---------------------
XSSFWorkbook workbook = new XSSFWorkbook();
XSSFSheet sheet = workbook.createSheet("���Ⱦ��x�˴���");                         //�ͦ����(���W��)
for(i = 0; i <= 10;i++)                                                           //��1-10�檺���e��
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

//------���C�L�]�w------
sheet.setFitToPage(false);                                                        //true:�C�L�ɷ|�N�u�@����b�P�@����
sheet.setHorizontallyCenter(true);//����                                          //�]�m�C�L���奻�����m
sheet.getPrintSetup().setLandscape(true);                                         //�]�m�C�L��V(true����V,false�����V)
sheet.getPrintSetup().setPaperSize(XSSFPrintSetup.A4_PAPERSIZE);                  //�]�m��A4�ȱi
sheet.setMargin(XSSFSheet.TopMargin, 0.24);                                       //�]�m�C�L�W�t�Z��
sheet.setMargin(XSSFSheet.BottomMargin, 0.24);                                    //�]�m�C�L�U�t�Z��
sheet.setMargin(XSSFSheet.LeftMargin, 0.24);                                      //�]�m�C�L���t�Z��
sheet.setMargin(XSSFSheet.RightMargin, 0.24);                                     //�]�m�C�L�k�t�Z��

//-----�Ĥ@�հt��]�p-----
XSSFColor color = new XSSFColor(new java.awt.Color(234, 234, 234));               //�C��]�w:(RGB�T����L: ����, ���, �Ŧ�)

//�]�m�r��
Font font = workbook.createFont();
font.setFontHeightInPoints((short) 12);                                            //�r��j�p
font.setFontName("�з���");                                                        //�r��˦�
font.setBoldweight(Font.BOLDWEIGHT_BOLD);                                          //�]�w������r
font.setColor(HSSFColor.BLACK.index);                                              //�r���C��

//�]�w�˦�
XSSFCellStyle style = workbook.createCellStyle();
style.setWrapText(true);                                                           //�j���  
style.setFillForegroundColor(HSSFColor.WHITE.index);                               //�I���զ�
style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
style.setAlignment(XSSFCellStyle.ALIGN_CENTER);                                    //�����m��
style.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);                         //�����m��
style.setBorderBottom(HSSFCellStyle.BORDER_THIN);                                  //�U�ؽu�ʲ� Thin;//�ӹ�u Thick;//�� Hair;//��u
style.setBorderLeft(HSSFCellStyle.BORDER_THIN);                                    //���ؽu�ʲ�
style.setBorderRight(HSSFCellStyle.BORDER_THIN);                                   //�k�ؽu�ʲ�
style.setBorderTop(HSSFCellStyle.BORDER_THIN);                                     //�W�ؽu�ʲ�
style.setBottomBorderColor(HSSFColor.BLACK.index);                                 //�U�ؽu�C��
style.setLeftBorderColor(HSSFColor.BLACK.index);                                   //���ؽu�C��
style.setRightBorderColor(HSSFColor.BLACK.index);                                  //�k�ؽu�C��
style.setTopBorderColor(HSSFColor.BLACK.index);                                    //�W�ؽu�C��
style.setFont(font);

//-------------�����줺�e�]�w-------------
XSSFRow row = null;
XSSFCell cell = null;

//---------------���D�Ҧ����---------------    
for(int s=1;s<=10;s++)
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
	for(int m=1;m<=10;m++)                                                                   //�ЫزĤ@��m�����
	{
		if(m!=2 && !rs.getString("FF_F"+(m)+"_Name").trim().equals(""))
		{
			cell=row.createCell(f);                                                          //�ЫزĤ@�����A�Ѽ�=0...����
			cell.setCellValue(rs.getString("FF_F"+(m)+"_Name").trim());                      //��J���檺���e
			cell.setCellStyle(style);                                                        //�]�w���檺�~�ص��]�p
			f++;	                                                                         //���Ѽ�+1
		}		
	}	
}

//---------------�j�M��Ƥ��e---------------
SqlStr1+="select * from flow_formdata ";
SqlStr1+="INNER JOIN flow_form_rulestage ON flow_formdata.FD_RecId=flow_form_rulestage.FR_DataId ";
SqlStr1+="where flow_formdata.FD_FormId IN ('253','255','257','274') ";
//SqlStr1+="and (CONVERT(varchar(10),CONVERT(datetime,flow_formdata.FD_Data3,111),111)  BETWEEN  '"+d1+"/"+d2+"/"+d3+"' and '"+d4+"/"+d5+"/"+d6+"')";  //�Φ�SQL�]�i��
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
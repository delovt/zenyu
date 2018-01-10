package yssoft.impls;


import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import yssoft.daos.BaseDao;
import yssoft.utils.ToolUtil;

import java.io.File;
import java.io.FileInputStream;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 * 黄页客户
 *
 * @author Administrator
 */
public class MrCustomerImpl extends BaseDao {

    /**
     *
     */
    private static final long serialVersionUID = -4210306628088772197L;

    public MrCustomerImpl() {
    }


    @SuppressWarnings("rawtypes")
    public void onMrCustomerImport(HashMap params) {

        String filepath = "";//完整路径
        String filename = params.get("filename") + "";//文件名称
        String url = this.getClass().getResource("").getFile();

        url = url.replaceAll("%20", " ");

        File fpath = new File(url.substring(0, url.indexOf("WEB-INF")) + "/importdata/");
        if (fpath.exists() == false) {
            fpath.mkdir();
            System.out.println("路径不存在,但是已经成功创建了:->" + fpath);
            return;
        }

        filepath = fpath + "/" + filename;


        System.out.println(filepath + "  ---YJYJ");

        try {
            Workbook workbook = new HSSFWorkbook(new POIFSFileSystem(
                    new FileInputStream(filepath)));// 以文件流的方式读取文件
            Sheet sheet = workbook.getSheetAt(0);// 获取工作簿
            String sheetname = sheet.getSheetName();//工作簿名称

            //依据工作簿名称获取对应的字段信息
            List flist = onGetFieldsList(sheetname);
            if (flist.size() == 0) {
                System.out.println("数据字典无数据");
                return;
            }

            onExecDataImport(flist, sheet, sheetname, params.get("imaker") + "");
            onDelFile(filepath);

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {

        }

    }

    /**
     * 获取字段信息
     *
     * @param ctablename
     * @return
     */
    @SuppressWarnings("rawtypes")
    private List onGetFieldsList(String ctablename) {

        List list = null;
        String strsql = "";
        HashMap<String, Object> hm = new HashMap<String, Object>();

        try {

            strsql = "select cfield,ccaption from ac_fields where itable=(select iid from ac_table where ctable='" + ctablename + "')";
            hm.put("sqlValue", strsql);
            list = this.queryForList("MrCustomerDest.search", hm);

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            hm.clear();
            strsql = "";
        }

        return list;

    }

    /**
     * 执行数据导入
     *
     * @param list
     * @param sheet
     */
    @SuppressWarnings({"rawtypes"})
    private void onExecDataImport(List list, Sheet sheet, String ctablename, String imaker) {

        String strsql = "";
      //  HashMap<String, Object> hm = new HashMap<String, Object>();
        //获取第一行的单元格信息
        Row row = sheet.getRow(0);
        String fields = onGetStrFields(row, list);
        if (fields.equals("")) return;

        //获取导入数据库的字段信息,从第二行开始
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row rows = sheet.getRow(i);// 当前行

            // lr add 名称查重
            Cell firstcell = rows.getCell(0);
            boolean isHas = false;
            if (firstcell != null) {
                if (!firstcell.getStringCellValue().equals("")) {
                    String cname = firstcell.getStringCellValue().trim();
                    List catchList = this.queryForList("getCsAndMrCustomerByCname", cname);
                    if (catchList.size() > 0)
                        isHas = true;
                } else {
                    isHas = true;
                }

            }

            if (!isHas) {//不是已经存在的，才可以导入。
                String strvalue = "";
                strsql += " insert into " + ctablename + "(" + fields + ",imaker,dmaker) values (";
                for (int k = 0; k < sheet.getRow(0).getLastCellNum(); k++) {
                    Cell cell = rows.getCell(k);
                    if (null != cell) {
                        if (cell.getCellType() == Cell.CELL_TYPE_STRING) {
                            strvalue += "'" + cell.getStringCellValue() + "',";
                        } else if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
                            Double value = cell.getNumericCellValue();
                            BigDecimal bd = new BigDecimal(value);
                            strvalue += "'" + bd.toString() + "',";
                        } else {
                            strvalue += "'',";
                        }
                        
                    } else {
                        strvalue += "'',";
                    }

                }

                strsql += strvalue + imaker + ",'" + ToolUtil.formatDay(new Date(), null) + "');";
            }
        }

      
        //SZC 给每条记录插入负责人
        if("".equals(strsql)){
        	return;
        }
        String[] ac=strsql.split(";");
        
        for(int i=0;i<ac.length;i++){
        	  HashMap hm = new HashMap();
        	  System.out.println(strsql);
              hm.put("sqlValue", ac[i]);
        	int iid = (Integer) this.insert("MrCustomerDest.insert", hm);
            HashMap invocieuser = new HashMap();
            invocieuser.put("iinvoice", iid);
            invocieuser.put("ifuncregedit", 176);
            invocieuser.put("irole", 1);
            invocieuser.put("iperson", imaker);
            // invocieuser.put("iid", iid);
            this.insert("add_ab_invoiceuser", invocieuser);
        }
        //end
       /*
         System.out.println(strsql);
          hm.put("sqlValue", strsql);
         int iid = (Integer) this.insert("MrCustomerDest.insert", hm);
        HashMap invocieuser = new HashMap();
        invocieuser.put("iinvoice", iid);
        invocieuser.put("ifuncregedit", 176);
        invocieuser.put("irole", 1);
        invocieuser.put("iperson", imaker);
        // invocieuser.put("iid", iid);
        this.insert("add_ab_invoiceuser", invocieuser);*/
    }

    public boolean importInTable1(ArrayList<HashMap> al) {
        try {
            for (HashMap h : al) {
                int iid = (Integer) this
                        .insert("MrCustomerDest.insertTable1", h);
                HashMap invocieuser = new HashMap();
                invocieuser.put("iinvoice", iid);
                invocieuser.put("ifuncregedit", 176);
                invocieuser.put("irole", 1);
                int imaker = (Integer) h.get("imaker");
                invocieuser.put("iperson", imaker);
                // invocieuser.put("iid", iid);
                this.insert("add_ab_invoiceuser", invocieuser);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    @SuppressWarnings("rawtypes")
    private String onGetStrFields(Row row, List list) {

        String rvalue = "";
        String field = "";//临时记载字段

        try {

            for (int i = 0; i < row.getLastCellNum(); i++) {

                Cell cell = row.getCell(i);
                if (null == cell) {
                    break;
                }

                String fname = cell.getStringCellValue().trim();

                for (int j = 0; j < list.size(); j++) {

                    HashMap record = (HashMap) list.get(j);
                    String caption = (record.get("ccaption") + "").trim();
                    String cfield = (record.get("cfield") + "").trim();

                    if (caption.equals(fname)) {
                        field = cfield;
                        break;
                    }
                }

                if (field.equals("")) return "";
                rvalue += field + ",";

            }

            rvalue = rvalue.substring(0, rvalue.lastIndexOf(","));

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {

        }

        return rvalue;

    }


    private void onDelFile(String fpath) {
        try {

            File file = new File(fpath);
            file.delete();

        } catch (Exception ex) {
            System.out.println("文件删除失败");
            ex.printStackTrace();
        }

    }

    public ArrayList<HashMap> importData(HashMap params) {
        String filepath = "";//完整路径
        String filename = params.get("filename") + "";//文件名称
        String url = this.getClass().getResource("").getFile();

        url = url.replaceAll("%20", " ");

        File fpath = new File(url.substring(0, url.indexOf("WEB-INF")) + "/importdata/");
        if (fpath.exists() == false) {
            fpath.mkdir();
            System.out.println("路径不存在,但是已经成功创建了:->" + fpath);
            return null;
        }

        filepath = fpath + "/" + filename;

        try {
            Workbook workbook = new HSSFWorkbook(new POIFSFileSystem(
                    new FileInputStream(filepath)));// 以文件流的方式读取文件
            Sheet sheet = workbook.getSheetAt(0);
            ArrayList<HashMap> list = new ArrayList<HashMap>();

            int rowNum = sheet.getLastRowNum();
            for (int i = 1; i <= rowNum; i++) {
                Row row = sheet.getRow(i);
                int colNum = row.getLastCellNum();
                HashMap h = new HashMap();
                for (int j = 0; j < colNum; j++) {
                    if (row.getCell(j) == null) {
                        h.put(sheet.getRow(0).getCell(j).getStringCellValue(), "");
                    } else if (row.getCell(j).getCellType() == Cell.CELL_TYPE_STRING) {
                        String value = row.getCell(j).getStringCellValue().trim();
                        h.put(sheet.getRow(0).getCell(j).getStringCellValue(), value);
                    } else if (row.getCell(j).getCellType() == Cell.CELL_TYPE_NUMERIC) {
                        if (HSSFDateUtil.isCellDateFormatted(row.getCell(j))) {
                            Date d = row.getCell(j).getDateCellValue();
                            DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
                            h.put(sheet.getRow(0).getCell(j).getStringCellValue(), formater.format(d));
                        } else {
                            Double value = row.getCell(j).getNumericCellValue();
                            BigDecimal bd = new BigDecimal(value);
                            h.put(sheet.getRow(0).getCell(j).getStringCellValue(), bd.toString());
                        }
                    } else {
                        h.put(sheet.getRow(0).getCell(j).getStringCellValue(), "");
                    }

                }
                list.add(h);
            }

            //onDelFile(filepath);

            return list;

        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    public boolean importInTable(ArrayList<HashMap> al) {
        try {
            for (HashMap h : al) {
                int iid = (Integer) this
                        .insert("MrCustomerDest.insertTable", h);
                HashMap invocieuser = new HashMap();
                invocieuser.put("iinvoice", iid);
                invocieuser.put("ifuncregedit", 44);
                invocieuser.put("irole", 1);
                int imaker = (Integer) h.get("imaker");
                invocieuser.put("iperson", imaker);
                // invocieuser.put("iid", iid);
                this.insert("add_ab_invoiceuser", invocieuser);

                String iservicespersonS = h.get("iservicesperson") + "";
                if (iservicespersonS != null && !iservicespersonS.trim().equals("")) {
                    int iservicesperson = Integer.parseInt(iservicespersonS);
                    if (imaker != iservicesperson) {
                        invocieuser.put("irole", 2);
                        invocieuser.put("iperson", iservicesperson);
                        this.insert("add_ab_invoiceuser2", invocieuser);
                    }

                }

                String isalespersonS = h.get("isalesperson") + "";
                if (isalespersonS != null && !isalespersonS.trim().equals("")) {
                    int isalesperson = Integer.parseInt(isalespersonS);
                    if (imaker != isalesperson) {
                        invocieuser.put("irole", 1);
                        invocieuser.put("iperson", isalesperson);
                        this.insert("add_ab_invoiceuser2", invocieuser);
                    }
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
	public boolean importInCsPersonTable(ArrayList<HashMap> al) {
        try {
            for (int i=0;i<al.size();i++) {
            	HashMap h = (HashMap)al.get(i);
            	String bkeycontect = h.get("bkeycontect")+"";
            	int ikeycontent = 0;
            	if(!"".equals(bkeycontect) || bkeycontect != null || !bkeycontect.equals("null")) {
            		ikeycontent = 1;
            	}
            	if(ikeycontent==1){
            		HashMap hh=new HashMap();
            		hh.put("icustomer",Integer.parseInt(h.get("iid所属客户")+""));
            		int num=Integer.parseInt(queryForObject("selectBnum",hh)+"");
            		if(num>0){
            			h.put("bkeycontect", 0);
            			  int iid = (Integer) this
                                  .insert("MrCustomerDest.insertPerTable", h);
                          HashMap invocieuser = new HashMap();
                          invocieuser.put("iinvoice", iid);
                          invocieuser.put("ifuncregedit", 45);
                          invocieuser.put("irole", 1);
                          int imaker = (Integer) h.get("imaker");
                          invocieuser.put("iperson", imaker);
                          // invocieuser.put("iid", iid);
                          this.insert("add_ab_invoiceuser", invocieuser);
            		}else{
          			  int iid = (Integer) this
                                .insert("MrCustomerDest.insertPerTable", h);
                        HashMap invocieuser = new HashMap();
                        invocieuser.put("iinvoice", iid);
                        invocieuser.put("ifuncregedit", 45);
                        invocieuser.put("irole", 1);
                        int imaker = (Integer) h.get("imaker");
                        invocieuser.put("iperson", imaker);
                        // invocieuser.put("iid", iid);
                        this.insert("add_ab_invoiceuser", invocieuser);
                    	}
            	}else{            	
	                int iid = (Integer) this
	                        .insert("MrCustomerDest.insertPerTable", h);
	                HashMap invocieuser = new HashMap();
	                invocieuser.put("iinvoice", iid);
	                invocieuser.put("ifuncregedit", 45);
	                invocieuser.put("irole", 1);
	                int imaker = (Integer) h.get("imaker");
	                invocieuser.put("iperson", imaker);
	                // invocieuser.put("iid", iid);
	                this.insert("add_ab_invoiceuser", invocieuser);
            	}
            	//System.out.println("i   :"+i);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    
    @SuppressWarnings({ "unchecked", "rawtypes" })
   	public boolean importInSrKnowledgeTable(ArrayList<HashMap> al) {
           try {
               for (HashMap h : al) {
                   int iid = (Integer) this
                           .insert("SrKnowledgeDest.insertPerTable", h);
                   HashMap invocieuser = new HashMap();
                   invocieuser.put("iinvoice", iid);
                   invocieuser.put("ifuncregedit", 266);
                   invocieuser.put("irole", 1);
                   int imaker = (Integer) h.get("imaker");
                   invocieuser.put("iperson", imaker);
                   this.insert("add_ab_invoiceuser", invocieuser);
               }
               return true;
           } catch (Exception e) {
               e.printStackTrace();
               return false;
           }
       }

    @SuppressWarnings({ "unchecked", "rawtypes" })
	public boolean importInOaWorkdiary(ArrayList<HashMap> al) {
        try {
            for (HashMap h : al) {
                int iid = (Integer) this
                        .insert("importInOaWorkdiary", h);
                HashMap invocieuser = new HashMap();
                invocieuser.put("iinvoice", iid);
                invocieuser.put("ifuncregedit", 46);
                invocieuser.put("irole", 1);
                int imaker = (Integer) h.get("imaker");
                invocieuser.put("iperson", imaker);
                // invocieuser.put("iid", iid);
                this.insert("add_ab_invoiceuser", invocieuser);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    //wh add 导入资产
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public boolean importCscustproduct(ArrayList<HashMap> al) {
        try {
            int iid =0;
            for (HashMap h : al) {
                String sql1="";
                if(!(null==h.get("加密盒号")||""==h.get("加密盒号")||"null"==h.get("加密盒号"))){
                     sql1 = "select iid from cs_custproduct where icustomer = "+h.get("iid客户名称")+" and iproduct="+h.get("iid购买产品")+" and csn='"+h.get("加密盒号")+"'";
                }else if(!(null==h.get("产品CDK")||""==h.get("产品CDK")||"null"==h.get("产品CDK"))){
                    sql1 = "select iid from cs_custproduct where icustomer = "+h.get("iid客户名称")+" and iproduct="+h.get("iid购买产品")+" and cproductcdk='"+h.get("产品CDK")+"'";
                }else{
                    sql1 = "select iid from cs_custproduct where icustomer = "+h.get("iid客户名称")+" and iproduct="+h.get("iid购买产品");

                }
               HashMap<String, Object> hm = new HashMap<String, Object>();
                hm.put("sqlValue", sql1);
                List list = this.queryForList("selectCscustproduct", hm);
                //如果查询到存在主表信息
                if(list.size()>0){
                    iid = (Integer)(((HashMap)list.get(0)).get("iid"));
                }else {
                    iid = (Integer) this
                            .insert("importCscustproduct", h);
                }
                h.put("icustproduct",iid);//将主键放入map
                this.insert("importCscustproducts",h);
                HashMap invocieuser = new HashMap();
                invocieuser.put("iinvoice", iid);
                invocieuser.put("ifuncregedit", 216);
                invocieuser.put("irole", 1);
                int imaker = (Integer) h.get("imaker");
                invocieuser.put("iperson", imaker);
                // invocieuser.put("iid", iid);
                this.insert("add_ab_invoiceuser", invocieuser);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    //验证加密盒
    public List<HashMap> checkCsn(ArrayList<HashMap> al) {
        for(HashMap h: al){
            String sql1="select * from cs_custproduct where icustomer="+h.get("iid客户名称")+" and iproduct="+h.get("iid购买产品")+" and csn='"+h.get("加密盒号")+"'";

            HashMap<String, Object> hm = new HashMap<String, Object>();
            hm.put("sqlValue", sql1);
            List list1 = this.queryForList("selectWay2", hm);

            String sql2="select * from cs_custproduct where  csn='"+h.get("加密盒号")+"'";

            HashMap<String, Object> hm2 = new HashMap<String, Object>();
            hm2.put("sqlValue", sql2);
            List list2 = this.queryForList("selectWay3", hm2);
            if(list2.size()<1){
                h.put("CSNfalse","0");
            }
            else if(list1.size()>0&&((HashMap)list1.get(0)).get("iid").equals(((HashMap)list2.get(0)).get("iid"))){
                h.put("CSNfalse","0");
            }else{
                h.put("CSNfalse","1");
                h.put("msg","加密盒号重复，值：");
            }
        }
        return al;
        // String sql = "select iid,iproduct from sc_boms where ibom = (select iid from sc_bom where iproduct = "+h.get("iid购买产品")+") and iproduct="+h.get("iid产品模块")+"";


    }
    //验证模块
    public HashMap checkbom(HashMap params) {
        //diunilaomu
        List<HashMap> al=(List)params.get("aclist");
        for(HashMap h: al){
            if(h.get("iids")==null||((List)h.get("iids")).size()==0){
                ((List)h.get("iids")).add(0,"0");
            }

            String sql="select * from"+
                    " (select sc_product.ccode,sc_product.iid iproduct,sc_product.cname pname,sc_boms.iid,sc_boms.iproduct bomsproduct,sc_boms.fquantity,"+
                    " sc_boms.ipricetype,	sc_productbom.cname bomsname,(sc_product.cname+'-'+sc_productbom.cname) linkpname from ("+
                    "    select iproduct,iid from sc_bom union select iproduct,ibom as iid from sc_bomp"+
                    " ) sc_bom"+
                    " left join (select iid,ibom,iproduct,fquantity,ipricetype,iifuncregedit from sc_boms) sc_boms on sc_bom.iid=sc_boms.ibom"+
                    " left join (select iid,ccode,cname from sc_product) sc_product on sc_bom.iproduct=sc_product.iid"+
                    " left join (select iid,ccode,cname from sc_product) sc_productbom on sc_boms.iproduct=sc_productbom.iid"+
                    "  ) sc_bom"+
                    " where 1=1 and iproduct = "+h.get("iid购买产品")+" and bomsproduct in "+h.get("iids")+"";

            sql=sql.replace("[","(");
            sql=sql.replace("]",")");

            HashMap<String, Object> hm = new HashMap<String, Object>();
            hm.put("sqlValue", sql);
            List list = this.queryForList("MrCustomerDest.search", hm);
            //如果没查询到
            if(list.size()<1){
                h.put("false","1");
            }else{
                h.put("false","0");
                h.put("id产品模块",((HashMap)list.get(0)).get("iid"));

            }



            /*HashMap<String, Object> hm2 = new HashMap<String, Object>();
            hm2.put("sqlValue", sql2);
            List list2 = this.queryForList("selectWay3", hm2);
            if (list1.size()<1){
                if(list2.size()<1){
                    h.put("CSNfalse","0");
                }else{
                    h.put("CSNfalse","1");
                    h.put("msg","加密盒号已存在，值：");
                }
            } else if(list1.size()==1&&(((HashMap)list1.get(0)).get("csn").equals(h.get("加密盒号")))){
                h.put("CSNfalse","0");
            }else{
                h.put("CSNfalse","1");
                h.put("msg","加密盒号有误,值:");
            }
*/
            //验证加密盒号是否重复
            if(!(null==h.get("加密盒号")||""==h.get("加密盒号")||"null"==h.get("加密盒号"))){
                String sql1="select * from cs_custproduct where icustomer='"+h.get("iid客户名称")+"' and iproduct='"+h.get("iid购买产品")+"' and csn='"+h.get("加密盒号")+"'";

                HashMap<String, Object> hm1 = new HashMap<String, Object>();
                hm1.put("sqlValue", sql1);
                List list1 = this.queryForList("selectWay2", hm1);


                String sql2="select * from cs_custproduct where  csn='"+h.get("加密盒号")+"'";

                HashMap<String, Object> hm2 = new HashMap<String, Object>();
                hm2.put("sqlValue", sql2);
                List list2 = this.queryForList("selectWay3", hm2);
                if(list2.size()<1){
                    h.put("CSNfalse","0");
                }
                else if(list1.size()==1&&((HashMap)list1.get(0)).get("iid").equals(((HashMap)list2.get(0)).get("iid"))){
                    h.put("CSNfalse","0");
                }else{
                    h.put("CSNfalse","1");
                    h.put("msg","加密盒号重复,值:");
                }
            }else{
                h.put("CSNfalse","0");
            }
            //验证产品cdk是否重复
            if(!(null==h.get("产品CDK")||""==h.get("产品CDK")||"null"==h.get("产品CDK"))){
                String sql1="select * from cs_custproduct where icustomer='"+h.get("iid客户名称")+"' and iproduct='"+h.get("iid购买产品")+"' and cproductCDK='"+h.get("产品CDK")+"'";

                HashMap<String, Object> hm1 = new HashMap<String, Object>();
                hm1.put("sqlValue", sql1);
                List list1 = this.queryForList("selectWay2", hm1);


                String sql2="select * from cs_custproduct where  cproductCDK='"+h.get("产品CDK")+"'";

                HashMap<String, Object> hm2 = new HashMap<String, Object>();
                hm2.put("sqlValue", sql2);
                List list2 = this.queryForList("selectWay3", hm2);
                if(list2.size()<1){
                    h.put("CDKfalse","0");
                }
                else if(list1.size()==1&&((HashMap)list1.get(0)).get("iid").equals(((HashMap)list2.get(0)).get("iid"))){
                    h.put("CDKfalse","0");
                }else{
                    h.put("CDKfalse","1");
                    h.put("msg","产品CDK重复,值:");
                }
            }else{
                h.put("CDKfalse","0");
            }

        }
        params.put("aclist",al);
        return params;
       // String sql = "select iid,iproduct from sc_boms where ibom = (select iid from sc_bom where iproduct = "+h.get("iid购买产品")+") and iproduct="+h.get("iid产品模块")+"";


    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
	public boolean importInSrBill(ArrayList<HashMap> al) {
        try {
            for (HashMap h : al) {
                int iid = (Integer) this
                        .insert("importInSrBill", h);
                HashMap invocieuser = new HashMap();
                invocieuser.put("iinvoice", iid);
                invocieuser.put("ifuncregedit", 46);
                invocieuser.put("irole", 1);
                int imaker = (Integer) h.get("imaker");
                invocieuser.put("iperson", imaker);
                // invocieuser.put("iid", iid);
                this.insert("add_ab_invoiceuser", invocieuser);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @SuppressWarnings({ "unchecked", "rawtypes" })
   	public boolean importInSrKnpwledge(ArrayList<HashMap> al) {
           try {
               for (HashMap h : al) {
                   int iid = (Integer) this
                           .insert("importInSrKnpwledge", h);
                   HashMap invocieuser = new HashMap();
                   invocieuser.put("iinvoice", iid);
                   invocieuser.put("ifuncregedit", 46);
                   invocieuser.put("irole", 1);
                   int imaker = (Integer) h.get("imaker");
                   invocieuser.put("iperson", imaker);
                   // invocieuser.put("iid", iid);
                   this.insert("add_ab_invoiceuser", invocieuser);
               }
               return true;
           } catch (Exception e) {
               e.printStackTrace();
               return false;
           }
       }
    
    /**
     * 导入服务回访(主要用于上海诚道公司的金税业务的特殊处理，不具有通用性)
     * @param al
     * @return
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
	public boolean importInSrFeedBack(ArrayList<HashMap> al) {
        try {
            for (HashMap h : al) {
                int iid = (Integer) this
                        .insert("importInSrFeedBack", h);
                HashMap invocieuser = new HashMap();
                invocieuser.put("iinvoice", iid);
                invocieuser.put("ifuncregedit", 154);
                invocieuser.put("irole", 1);
                int imaker = (Integer) h.get("imaker");
                invocieuser.put("iperson", imaker);
                this.insert("add_ab_invoiceuser", invocieuser);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}

package yssoft.views;
/**
 * 
 * 项目名称：yssoft
 * 类名称：funauthView
 * 类描述：funauthView视图 
 * 创建人：刘磊
 * 创建时间：2011-10-13 9:41:13
 * 修改人：刘磊
 * 修改时间：2011-10-13 9:41:13
 * 修改备注：无
 * @version 1.0
 * 
 */

import flex.messaging.io.ArrayList;
import yssoft.services.IfunauthService;
import yssoft.utils.ToolUtil;

import java.util.HashMap;
import java.util.List;
public class funauthView {

	private IfunauthService i_funauthService;

	public void seti_funauthService(IfunauthService i_funauthService) {
        this.i_funauthService = i_funauthService;
	}

    public List<HashMap> get_funoperauthPerson(HashMap params) {
        try {
            return this.i_funauthService.get_funoperauthPerson(params);
        }
        catch(Exception e) {
            return null;
        }
    }
     public List<HashMap> get_funoperauth(HashMap params)
     {
           try
           {
               return this.i_funauthService.get_funoperauth(params);
           }
           catch(Exception e)
           {
               return null;
           }
     }

    public List<HashMap> get_fundataauth(HashMap params) {
        try {
            List<HashMap> list = new ArrayList();
            List<HashMap> list1 =  this.i_funauthService.get_fundataauth(params);
            List<HashMap> list2 =  this.i_funauthService.get_fundataauths(params);
            if(list1.size() > 0 && list2.size() > 0){
                for (HashMap hm1 : list1){
                    String ctable1 = ToolUtil.toString(hm1.get("ctable"));//表名
                    String dataauth1 = ToolUtil.toString(hm1.get("dataauth"));//数据权限值
                    String iid1 = ToolUtil.toString(hm1.get("iid"));//功能码
                    String sortid1 = ToolUtil.toString(hm1.get("sortid"));

                    for (HashMap hm2 : list2){
                        String ctable2 = ToolUtil.toString(hm2.get("ctable"));//表名
                        String dataauth2 = ToolUtil.toString(hm2.get("dataauth"));//数据权限值
                        String iid2 = ToolUtil.toString(hm2.get("iid"));//功能码
                        String sortid2 = ToolUtil.toString(hm2.get("sortid"));

                        if(sortid1.equals(sortid2) && sortid1.equals("1")){
                            hm1.put("sortid","1");
                            if(ctable1.equals(ctable2) && iid1.equals(iid2)){
                                hm1.put("ctable",ctable1);
                                hm1.put("iid",iid1);
                            }
                            if(dataauth1.equals(dataauth2)){
                                hm1.put("dataauth",dataauth1);
                            }else{
                                char[] a = dataauth1.toCharArray();
                                char[] b = dataauth2.toCharArray();
                                String newAuth = "";
                                int a1 = ToolUtil.toInt(a[0]);//启用组织权限
                                int b1 = ToolUtil.toInt(b[0]);
                                int a2 = ToolUtil.toInt(a[1]);//组织查询权限
                                int b2 = ToolUtil.toInt(b[1]);
                                int a3 = ToolUtil.toInt(a[2]);//组织修改权限
                                int b3 = ToolUtil.toInt(b[2]);
                                int a4 = ToolUtil.toInt(a[3]);//组织删除权限
                                int b4 = ToolUtil.toInt(b[3]);
                                int a5 = ToolUtil.toInt(a[4]);//启用客户权限
                                int b5 = ToolUtil.toInt(b[4]);
                                int a6 = ToolUtil.toInt(a[5]);//与客户权限关系
                                int b6 = ToolUtil.toInt(b[5]);
                                if(a1 == b1){
                                    newAuth += ToolUtil.toString(a1);
                                }
                                if(a2 == b2){
                                    newAuth += ToolUtil.toString(a2);
                                }else{
                                    if(a2 > b2){
                                        newAuth += ToolUtil.toString(a2);
                                    }else{
                                        newAuth += ToolUtil.toString(b2);
                                    }
                                }
                                if(a3 == b3){
                                    newAuth += ToolUtil.toString(a3);
                                }else{
                                    if(a3 > b3){
                                        newAuth += ToolUtil.toString(a3);
                                    }else{
                                        newAuth += ToolUtil.toString(b3);
                                    }
                                }
                                if(a4 == b4){
                                    newAuth += ToolUtil.toString(a4);
                                }else{
                                    if(a4 > b4){
                                        newAuth += ToolUtil.toString(a4);
                                    }else{
                                        newAuth += ToolUtil.toString(b4);
                                    }
                                }
                                if(a5 == b5){
                                    newAuth += ToolUtil.toString(a5);
                                }
                                if(a6 == b6){
                                    newAuth += ToolUtil.toString(a6);
                                }else{
                                    if(a6 > b6){
                                        newAuth += ToolUtil.toString(a6);
                                    }else{
                                        newAuth += ToolUtil.toString(b6);
                                    }
                                }

                                hm1.put("dataauth",newAuth);
                            }

                        }else if(sortid1.equals(sortid2) && sortid1.equals("2")){
                            hm1.put("sortid","2");
                            if(ctable1.equals(ctable2) && iid1.equals(iid2)){
                                hm1.put("ctable",ctable1);
                                hm1.put("iid",iid1);
                            }
                            if(dataauth1.equals(dataauth2)){
                                hm1.put("dataauth",dataauth1);
                            }else{
                                char[] a = dataauth1.toCharArray();
                                char[] b = dataauth2.toCharArray();
                                String newAuth = "";
                                int a1 = ToolUtil.toInt(a[0]);//启用组织权限
                                int b1 = ToolUtil.toInt(b[0]);
                                int a2 = ToolUtil.toInt(a[1]);//组织查询权限
                                int b2 = ToolUtil.toInt(b[1]);
                                int a3 = ToolUtil.toInt(a[2]);//组织修改权限
                                int b3 = ToolUtil.toInt(b[2]);
                                int a4 = ToolUtil.toInt(a[3]);//组织删除权限
                                int b4 = ToolUtil.toInt(b[3]);
                                int a5 = ToolUtil.toInt(a[4]);//启用客户权限
                                int b5 = ToolUtil.toInt(b[4]);
                                int a6 = ToolUtil.toInt(a[5]);//与客户权限关系
                                int b6 = ToolUtil.toInt(b[5]);
                                if(a1 == b1){
                                    newAuth += ToolUtil.toString(a1);
                                }
                                if(a2 == b2){
                                    newAuth += ToolUtil.toString(a2);
                                }else{
                                    if(a2 > b2){
                                        newAuth += ToolUtil.toString(a2);
                                    }else{
                                        newAuth += ToolUtil.toString(b2);
                                    }
                                }
                                if(a3 == b3){
                                    newAuth += ToolUtil.toString(a3);
                                }else{
                                    if(a3 > b3){
                                        newAuth += ToolUtil.toString(a3);
                                    }else{
                                        newAuth += ToolUtil.toString(b3);
                                    }
                                }
                                if(a4 == b4){
                                    newAuth += ToolUtil.toString(a4);
                                }else{
                                    if(a4 > b4){
                                        newAuth += ToolUtil.toString(a4);
                                    }else{
                                        newAuth += ToolUtil.toString(b4);
                                    }
                                }
                                if(a5 == b5){
                                    newAuth += ToolUtil.toString(a5);
                                }
                                if(a6 == b6){
                                    newAuth += ToolUtil.toString(a6);
                                }else{
                                    if(a6 > b6){
                                        newAuth += ToolUtil.toString(a6);
                                    }else{
                                        newAuth += ToolUtil.toString(b6);
                                    }
                                }

                                hm1.put("dataauth",newAuth);
                            }

                        }

                    }

                }
                list = list1;
            } else if(list1.size() <= 0 && list2.size() > 0){
                list = list2;
            }
            return list;
        }
        catch(Exception e) {
            return null;
        }
    }

    //lc add 2017年8月7日10:33:46 获取人员数据权限
    public List<HashMap> get_fundataauths(HashMap params) {
        try {
            return this.i_funauthService.get_fundataauths(params);
        }
        catch(Exception e) {
            return null;
        }
    }

     public int get_ifuncregedit(int iid)
     {
           try
           {
               return this.i_funauthService.get_ifuncregedit(iid);
           }
           catch(Exception e)
           {
               return 0;
           }
     }

     public int get_editinvoice(HashMap params)
     {
           try
           {
               return this.i_funauthService.get_editinvoice(params);
           }
           catch(Exception e)
           {
               return 0;
           }
     }

     public int get_delinvoice(HashMap params)
     {
           try
           {
               return this.i_funauthService.get_delinvoice(params);
           }
           catch(Exception e)
           {
               return 0;
           }
     }

     public List<HashMap> get_sqldata(String sql)
     {
           try
           {
               return this.i_funauthService.get_sqldata(sql);
           }
           catch(Exception e)
           {
               return null;
           }
     }
}
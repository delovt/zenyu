package yssoft.views;
/**
 * 
 * 项目名称：
 * 类名称：as_operauthView
 * 类描述：as_operauthView视图 
 * 创建人：刘磊
 * 创建时间：2011-10-5 16:28:29
 * 修改人：李聪
 * 修改时间：2017-8-4 09:00:29
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.services.Ias_operauthService;
import yssoft.vos.as_operauthVo;
import yssoft.vos.as_opersauthsVo;

import java.util.HashMap;
import java.util.List;

public class as_operauthView {

	private Ias_operauthService i_as_operauthService;

	public void seti_as_operauthService(Ias_operauthService i_as_operauthService) {
		this.i_as_operauthService = i_as_operauthService;
	}
     public boolean get_exists_as_operauth(int key)
     {
           try
           {
               return this.i_as_operauthService.get_exists_as_operauth(key);
           }
           catch(Exception e)
           {
               return false;
           }
     }
     public as_operauthVo get_bykey_as_operauth(int key)
     {
           try
           {
               return this.i_as_operauthService.get_bykey_as_operauth(key);
           }
           catch(Exception e)
           {
               return null;
           }
     }
     public List<as_operauthVo> get_bywhere_as_operauth(String condition)
     {
           try
           {
               return this.i_as_operauthService.get_bywhere_as_operauth(condition);
           }
           catch(Exception e)
           {
               return null;
           }
     }

     //删除当前角色权限，批量接收将插入权限数据，返回成功插入条数
     public int addAllOperauth(HashMap obj)
     {
         int count=0;
         int irole=Integer.valueOf(obj.get("irole").toString());

         List<HashMap> delvos = (List<HashMap>) obj.get("del");//未选中的集合，做删除操作
         for (HashMap delvo: delvos) {
             as_operauthVo opervo=new as_operauthVo();
             opervo.irole=irole;
             opervo.copercode=delvo.get("ccode").toString();//权限编码
             if (this.delete_bywhere_as_operauth("irole="+irole+" and copercode='"+opervo.copercode+"'"))
             {
                   count++;
             }
         }
         List<HashMap> addvos = (List<HashMap>) obj.get("add");//选择的计划，做新增操作
         for (HashMap addvo: addvos) {
             as_operauthVo opervo=new as_operauthVo();
             opervo.irole=irole;
             opervo.copercode=addvo.get("ccode").toString();//权限编码
             if (add_as_operauth(opervo)>0)
             {
                   count++;
             }
        }
        return count;
     }

     //插入操作权限
     public int add_as_operauth(as_operauthVo vo_as_operauth)
     {
           int iid=0;
           try
           {
               //判断当前此条权限是否已经存在
               int ct=this.get_bywhere_as_operauth("irole="+String.valueOf(vo_as_operauth.irole)+" and copercode='"+vo_as_operauth.copercode+"'").size();
               if (ct==0) {//不存在，插入记录
                   iid=this.i_as_operauthService.add_as_operauth(vo_as_operauth);
               }else {
                   iid=1; //vo_as_operauth.iid;
               }
               return iid;
           }
           catch(Exception e)
           {
               return iid;
           }
     }

     public boolean update_as_operauth(as_operauthVo vo_as_operauth)
     {
           try
           {
               return this.i_as_operauthService.update_as_operauth(vo_as_operauth);
           }
           catch(Exception e)
           {
               return false;
           }
     }
     public boolean delete_bykey_as_operauth(int key)
     {
           try
           {
               return this.i_as_operauthService.delete_bykey_as_operauth(key);
           }
           catch(Exception e)
           {
               return false;
           }
     }
     public boolean delete_bywhere_as_operauth(String condition)
     {
           try
           {
               this.i_as_operauthService.delete_bywhere_as_operauth(condition);
               return true;
           }
           catch(Exception e)
           {
               return false;
           }
     }

    /****************************************
     * lc add 20170804
     * 操作权限给予人员进行授权
     */
    //删除当前人员权限，批量接收将插入权限数据，返回成功插入条数
    public int addAllOperauthForPerson(HashMap obj) {
        int count = 0;
        int iperson = Integer.valueOf(obj.get("iperson").toString());

        List<HashMap> delvos = (List<HashMap>) obj.get("del");//未选中的集合，做删除操作
        for (HashMap delvo: delvos) {
            as_opersauthsVo opervo = new as_opersauthsVo();
            opervo.iperson = iperson;
            opervo.copercode = delvo.get("ccode").toString();//权限编码
            if (this.delete_bywhere_as_opersauths("iperson=" + iperson + " and copercode='" + opervo.copercode + "'")) {
                count++;
            }
        }
        List<HashMap> addvos = (List<HashMap>) obj.get("add");//选择的计划，做新增操作
        for (HashMap addvo: addvos) {
            as_opersauthsVo opervo = new as_opersauthsVo();
            opervo.iperson = iperson;
            opervo.copercode = addvo.get("ccode").toString();//权限编码
            if (add_as_opersauths(opervo) > 0) {
                count++;
            }
        }
        return count;
    }

    //删除操作权限
    public boolean delete_bywhere_as_opersauths(String condition) {
        try{
            this.i_as_operauthService.delete_bywhere_as_opersauths(condition);
            return true;
        }
        catch(Exception e){
            return false;
        }
    }

    //插入操作权限
    public int add_as_opersauths(as_opersauthsVo opervos) {
        int iid=0;
        try {
            //判断当前此条权限是否已经存在
            int ct = this.get_bywhere_as_opersauths("iperson=" + String.valueOf(opervos.iperson) + " and copercode='" + opervos.copercode + "'").size();
            if (ct == 0) {//不存在，插入记录
                iid = this.i_as_operauthService.add_as_opersauths(opervos);
            } else {
                iid = 1;
            }
            return iid;
        }
        catch(Exception e) {
            return iid;
        }
    }

    //判断当前此条权限是否已经存在
    public List<as_opersauthsVo> get_bywhere_as_opersauths(String condition) {
        try {
            return this.i_as_operauthService.get_bywhere_as_opersauths(condition);
        }
        catch(Exception e) {
            return null;
        }
    }


}
package yssoft.views;
/**
 * 
 * 项目名称：yssoft
 * 类名称：as_dataauthView
 * 类描述：as_dataauthView视图 
 * 创建人：刘磊
 * 创建时间：2011-10-12 17:45:28
 * 修改人：刘磊
 * 修改时间：2011-10-12 17:45:28
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.services.Ias_dataauthService;

import java.util.HashMap;
import java.util.List;
public class as_dataauthView {

	private Ias_dataauthService i_as_dataauthService;

	public void seti_as_dataauthService(Ias_dataauthService i_as_dataauthService) {
		this.i_as_dataauthService = i_as_dataauthService;
	}
     public List<HashMap> get_bywhere_as_dataauth(String condition)
     {
           try
           {
               return this.i_as_dataauthService.get_bywhere_as_dataauth(condition);
           }
           catch(Exception e)
           {
               return null;
           }
     }
     public String add_as_dataauth(HashMap vo_as_dataauth)
     {
           String result = "sucess";
           try
           {
              Object resultObj = this.i_as_dataauthService.add_as_dataauth(vo_as_dataauth);
              result = resultObj.toString();
           }
           catch(Exception e)
           {
              result = "fail";
           }
           return result;
     }

     public String update_all(List<HashMap> vos) {
         String result = "sucess";
         for (HashMap vo : vos) {
             if (this.update_as_dataauth(vo).equals("fail")) {
                 result="fail";
                 break;
             }
         }
         return result;
     }

     public String update_as_dataauth(HashMap vo_as_dataauth) {
           String result = "sucess";
           try {
               int count = this.i_as_dataauthService.update_as_dataauth(vo_as_dataauth);
               if(count!=1) {
                   result = "fail";
               }
           }
           catch(Exception e) {
               result = "fail";
           }
           return result;
     }
     public String delete_bywhere_as_dataauth(String condition)
     {
           String result = "sucess";
           try
           {
               int count = this.i_as_dataauthService.delete_bywhere_as_dataauth(condition);
               if(count!=1)
               {
                   result = "fail";
               }
           }
           catch(Exception e)
           {
               result = "fail";
           }
           return result;
     }
     public String add_Initdata(int irole)
     {
         String result = "sucess";
         try
         {
             if (!this.i_as_dataauthService.add_Initdata(irole))
             {
                 result = "fail";
             }
         }
         catch(Exception e)
         {
             result = "fail";
         }
         return result;
     }
     public String update_Initdata(int ifuncregedit)
     {
         String result = "sucess";
         try
         {
             if (!this.i_as_dataauthService.update_Initdata(ifuncregedit))
             {
                 result = "fail";
             }
         }
         catch(Exception e)
         {
             result = "fail";
         }
         return result;
     }

    public String add_Initdata1(int iperson) {
        String result = "sucess";
        try {
            if (!this.i_as_dataauthService.add_Initdata1(iperson)) {
                result = "fail";
            }
        }
        catch(Exception e) {
            result = "fail";
        }
        return result;
    }

    public List<HashMap> get_bywhere_as_dataauths(String condition) {
        try {
            return this.i_as_dataauthService.get_bywhere_as_dataauths(condition);
        }
        catch(Exception e) {
            return null;
        }
    }

    public String update_alls(List<HashMap> vos) {
        String result = "sucess";
        for (HashMap vo : vos) {
            if (this.update_as_dataauths(vo).equals("fail")) {
                result="fail";
                break;
            }
        }
        return result;
    }

    public String update_as_dataauths(HashMap vo_as_dataauths) {
        String result = "sucess";
        try {
            int count = this.i_as_dataauthService.update_as_dataauths(vo_as_dataauths);
            if(count!=1) {
                result = "fail";
            }
        }
        catch(Exception e) {
            result = "fail";
        }
        return result;
    }

}
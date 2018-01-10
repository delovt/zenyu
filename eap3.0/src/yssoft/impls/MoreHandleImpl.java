package yssoft.impls;
/**
 *
 * 项目名称：MoreHandleImpl
 * 类名称：MoreHandleImpl
 * 类描述：更多操作中的特殊业务处理
 * 创建人：YJ
 * 创建时间：2011-10-24
 * 修改人：
 * 修改时间：
 * 修改备注：
 * @version 1.0
 *
 */

import yssoft.daos.BaseDao;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@SuppressWarnings("serial")
public class MoreHandleImpl extends BaseDao {

    protected SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    protected String feedback = sdf.format(new Date());

    //审核操作
    @SuppressWarnings("unchecked")
    public List onCheck(HashMap paraMap){
        List list = null;
        String strsql = "";

        strsql = "update "+paraMap.get("tablename")+" set ifeedback="
                +paraMap.get("loginname")+",dfeedback='"+feedback+"' where iid in("+paraMap.get("condition")+")";

        paraMap.put("sqlValue", strsql);

        try{
            this.update("MoreHandleDest.onCheck",paraMap);

        }catch(Exception ex){
            System.out.println(ex.getMessage());
        }

        return list;
    }

    //更新出差
    @SuppressWarnings("unchecked")
    public String onTravel(HashMap paraMap){
        String result = "success";
        String strsql = "";

        strsql = "update oa_travel set dfbegin='"+paraMap.get("dfbegin")+"',dfend='"+paraMap.get("dfend")+"',ccompletion='"+paraMap.get("ccompletion")
                +"',ifeedback='"+paraMap.get("user")+"',dfeedback='"+feedback+"' where iid="+paraMap.get("iid");

        paraMap.put("sqlValue", strsql);

        try{
            this.update("MoreHandleDest.onCheck",paraMap);

        }catch(Exception ex){
            System.out.println(ex.getMessage());
            result = "fail";
        }

        return result;
    }
    //更新出差
    @SuppressWarnings("unchecked")
    public String onLeave(HashMap paraMap){
        String result = "success";
        String strsql = "";

        strsql = "update oa_leave set dfbegin='"+paraMap.get("dfbegin")+"',dfend='"+paraMap.get("dfend")+"',ffday="+paraMap.get("ffday")
                +",ifeedback='"+paraMap.get("user")+"',dfeedback='"+feedback+"' where iid="+paraMap.get("iid");

        paraMap.put("sqlValue", strsql);

        try{
            this.update("MoreHandleDest.onCheck",paraMap);

        }catch(Exception ex){
            System.out.println(ex.getMessage());
            result = "fail";
        }

        return result;

    }

    //YJ Add 客商并户
    public String onCusMerge(HashMap paraMap){
        String result = "success";
        try
        {
            this.queryForList("p_customermerge",paraMap);
        }
        catch(Exception err)
        {
            System.out.println(err.getMessage());
            result = err.getMessage();
        }
        //合并成功，则删除并入前的客户
        if(result.equals("success")){
            String sql = "delete from cs_customer where iid="+paraMap.get("bcustomer");
            this.delete("p_delete",sql);
        }
        return result;
    }

    //LZX Add 资产并户
    public String onProductMerge(HashMap paraMap){
        String result = "success";
        try
        {
            this.queryForList("p_custproductmerge",paraMap);
        }
        catch(Exception err)
        {
            System.out.println(err.getMessage());
            result = err.getMessage();
        }
        //合并成功，删除并入前的资产子表与主表
        if(result.equals("success")){
            String sql = "delete from cs_custproducts where icustproduct = " + paraMap.get("bcustproduct")+";delete from cs_custproduct where iid = " + paraMap.get("bcustproduct");
            this.delete("p_delete",sql);
        }
        return result;
    }

}
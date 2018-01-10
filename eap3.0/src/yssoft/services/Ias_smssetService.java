package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：Ias_smssetService
 * 类描述：Ias_smssetService接口 
 * 创建人：lzx
 * 创建时间：2012-9-28 
 * 修改人：
 * 修改时间：
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.vos.AsSmssetVO;

import java.util.HashMap;
import java.util.List;
public interface Ias_smssetService {
         public HashMap get_as_smsset_byiid(int iid);
         public List<HashMap> get_all_as_smsset();
         public Object add_as_smsset(AsSmssetVO asSmssetVO);
         public Object update_as_smsset(AsSmssetVO asSmssetVO);
         public Object delete_as_smsset_byiid(int iid) ;
         public List getFieldsByTable(String tablename) ;
}
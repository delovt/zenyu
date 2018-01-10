/**    
 *
 * 文件名：PageServiceImpl.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-24    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IPageService;

import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：PageServiceImpl    
 * 类描述：    
 * 创建人：zmm
 * 创建时间：2011-2011-8-24 下午10:02:43        
 *     
 */
public class PageServiceImpl extends BaseDao implements IPageService {

	/**
	 * page 获取数据集
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 参数：sqlid sqlid
	 * 参数：params 参数
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	@Override
	public List page(String sqlid,Object params) {
		// TODO Auto-generated method stub
		return this.queryForList(sqlid, params);
	}

	/**
	 * pageAllNum 获取数据集的个数
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 参数：sqlid sqlid
	 * 参数：params 参数
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	@Override
	public int pageAllNum(String sqlid,Object params) {
		return (Integer)this.queryForObject(sqlid+"_count",params);
	}

}

/**    
 *
 * 文件名：AsAuthcontentView.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-20    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.services.IAsAuthcontentService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.AsAuthcontentVo;

import java.util.HashMap;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：AsAuthcontentView    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-20 上午10:46:59        
 *     
 */
public class AsAuthcontentView {

	private IAsAuthcontentService iAsAuthcontentService;

	
	public void setiAsAuthcontentService(IAsAuthcontentService iAsAuthcontentService) {
		this.iAsAuthcontentService = iAsAuthcontentService;
	}

	/**
	 * 
	 * getAsAuthcontentVos(查询)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-20 上午09:00:09
	 * 修改者：Lenovo
	 * 修改时间：2011-8-20 上午09:00:09
	 * 修改备注：   
	 * @return List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	public String getAsAuthcontentVos() {
		HashMap paramHashMap = new HashMap();
		paramHashMap.put("isT", "");
		paramHashMap.put("buse", true);
		return ToXMLUtil.createTree(this.iAsAuthcontentService.getAsAuthcontentVos(paramHashMap), "iid", "ipid", "-1");
		 
	}
	
	/**
	 * 
	 * addAuthcontent(新增)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-20 上午08:58:17
	 * 修改者：Lenovo
	 * 修改时间：2011-8-20 上午08:58:17
	 * 修改备注：   
	 * @param asAuthcontentVo void
	 * @Exception 异常对象    
	 *
	 */
	public String addAuthcontent(AsAuthcontentVo asAuthcontentVo){
		// 默认声明结果集为成功
		String result = "sucess";
		try {
			// 插入角色
			Object resultObj = this.iAsAuthcontentService.addAuthcontent(asAuthcontentVo);
			result = resultObj.toString();
		} catch (Exception e) {
			e.printStackTrace();
			// 如抛异常，则插入失败
			result = "fail";
		}
		return result;
	}
	
	
	/**
	 * 
	 * 
	 * updateRole(修改角色)
	 * 
	 * @param roleVo
	 *            修改的内容
	 * 
	 * @return 是否保存成功
	 * 
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public String updateAsAuthcontentVo(AsAuthcontentVo asAuthcontentVo) {
		// 默认声明结果集为成功
		String result = "sucess";
		try {
			result = this.iAsAuthcontentService.updateAsAuthcontentVo(asAuthcontentVo);
		} catch (Exception e) {
			// 如抛异常，则修改失败
			result = "fail";
		}
		return result;
	}
	
	/**
	 * 
	 * romveAsAuthcontentVo(删除)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-20 上午10:22:02
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iid 编码
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public String romveAsAuthcontentVo(int iid) {
		// 默认声明结果集为成功
		String result = "sucess";
		try {
			result = this.iAsAuthcontentService.romveAsAuthcontentVo(iid);
		} catch (Exception e) {
			// 如抛异常，则删除失败
			result = "fail";
		}
		return result;
	}
}

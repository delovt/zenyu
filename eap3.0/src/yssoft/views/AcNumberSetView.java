/**
 * 模块名称：AcNumberSetView(单据编码)
 * 模块说明：单据编码相关业务操作
 * 创建人：YJ
 * 创建日期：20110828
 * 修改人：
 * 修改日期：
 *
 */
package yssoft.views;

import yssoft.services.IAcNumberSetService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.AcNumberSetVO;

import java.util.HashMap;
import java.util.List;

public class AcNumberSetView {
	private IAcNumberSetService iAcNumberSetService;

	public void setiAcNumberSetService(IAcNumberSetService iAcNumberSetService) {
		this.iAcNumberSetService = iAcNumberSetService;
	}
	
	/**
	 * 函数名称：getTreeMenuList
	 * 函数说明：获取菜单列表
	 * 函数参数：
	 * 函数返回：String
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public String getTreeMenuList(){
		//获取树对应的数据集
		List<HashMap> list = iAcNumberSetService.getMenuList();
		String treeXml = "";
		
		//转换为树结构
		if(list.size()>0){
			treeXml = ToXMLUtil.createTree(list, "iid", "ipid", "-1");
		}
		return treeXml;
	}
	
	
	/**
	 * 函数名称：addNumberSet
	 * 函数说明：添加
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public String addNumberSet(AcNumberSetVO acNumberSetVO){
		String result = "ok";
		try{
			
			Object obj = this.iAcNumberSetService.addNumberSet(acNumberSetVO);
			result = obj.toString();
			
		}
		catch(Exception ex){
			result = "no";
		}
		return result;	
	}
	
	
	/**
	 * 函数名称：updateNumberSet
	 * 函数说明：更新单据编码
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public String updateNumberSet(AcNumberSetVO acNumberSetVO){
		
		String result = "ok";
		try{
			
			this.iAcNumberSetService.updateNumberSet(acNumberSetVO);
			
		}
		catch(Exception ex){
			ex.printStackTrace();
			result = "no";
		}
		return result;	
	}
	
	
	/**
	 * 函数名称：getPreFixList
	 * 函数说明：获取编码前缀编码
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List getPreFixList(HashMap paramMap){
		return this.iAcNumberSetService.getPreFixList(paramMap);
	}

	
	/**
	 * 函数名称：getNumberSetListByIfid
	 * 函数说明：获取单据编码信息(注册编码主键)
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public HashMap getNumberSetListByIfid(HashMap paramMap){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try{
			int ifuncregedit = Integer.parseInt(paramMap.get("ifuncregedit").toString());
			
			List numberset_list = this.iAcNumberSetService.getNumberSetListByIfid(ifuncregedit);
			
			List prefix_list = this.iAcNumberSetService.getPreFixList(paramMap);
			
			//获取单据历史信息
			List number_history = this.iAcNumberSetService.getNumberHistory(ifuncregedit);
			
			resultMap.put("numberset_list", numberset_list);
			resultMap.put("prefix_list", prefix_list);
			resultMap.put("number_history", number_history);
		}
		catch(Exception ex){
			System.out.println(ex.getMessage());
		}
		
		return resultMap;
	}
	
	
	
	/**
	 * 函数名称：getNumberListByCtable
	 * 函数说明：依据表名获取单据编码(系统自动生成)
	 * 函数参数：paramMap HashMap对象，其包含内容如下：
	 * 		    cname:注册表功能模块名称
	 * 			ctable:程序对应主数据表
	 * 			cusdate:客户端日期
	 * 			billtype:单据类型,有可能是编码(ccode)或者主键
	 * 
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public HashMap showNumber(HashMap paramMap){
		return this.iAcNumberSetService.showNumber(paramMap);
	}
	
	
	/**
	 * 函数名称：saveNumber
	 * 函数说明：保存编码，将流水号更新至单据历史表中
	 * 函数参数：HashMap paramMap 包含的参数如下：
	 * 			cprefix:前缀类型
	 * 			cprefixvalue：前缀对应的值
	 * 			bprefixrule：是否参与流水依据
	 * 			list:参与单据编码的字段集合
	 * 
	 * 函数返回：String(前缀值)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110905
	 * 修改人：
	 * 修改日期：
	 */
	@SuppressWarnings("unchecked")
	public HashMap saveNumber(HashMap paramMap){
		return this.iAcNumberSetService.saveNumber(paramMap);
	}
	
	/**
	 * 函数名称：onUpdateNumber
	 * 函数说明：更新单据历史流水号
	 * 函数参数：HashMap paramMap 包含的参数如下：
	 * 			iid:内码
	 * 			inumber：流水号
	 * 
	 * 函数返回：HashMap (更新是否成功)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20111129
	 * 修改人：
	 * 修改日期：
	 */
	public HashMap onUpdateHistoryNumber(HashMap paramMap){
		
		return this.iAcNumberSetService.onUpdateHistoryNumber(paramMap);
	}
}

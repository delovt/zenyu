package yssoft.services;

import java.util.HashMap;
import java.util.List;

/**
 * 
 * 公共框架所需要的接口
 * 
 * @author zhong_jing
 * 
 */
public interface ICommonalityService {

	/**
	 * 判断数据类型
	 * 
	 * @param paramObj
	 *            包含字段，表名
	 * @return 数据类型
	 */
	public List getItype(HashMap paramObj);

	/**
	 * 
	 * 动态拼装查询语句 创建者：zhong_jing 创建时间：2011-8-16 下午05:26:43 修改者： 修改时间： 修改备注：
	 * 
	 * @param sql
	 *            SQL语句
	 * @return 查询值
	 * @throws Exception
	 *             List<HashMap>
	 * @Exception 异常对象
	 * 
	 */
	public List assemblyQuerySql(String sql) throws Exception;
	
	public Object executeSqlList(HashMap param) throws Exception;

	/**
	 * 查询单据信息
	 * 
	 * @param ifuncregedit
	 *            注册码信息
	 * @return 单据信息
	 */
	public HashMap queryVouch(HashMap param) throws Exception;

	public List queryVouchForm(HashMap paramObj);

	// 判断唯一性约束
	public String isUnique(HashMap param) throws Exception;

	// 保存录入信息
	public String addPm(HashMap param) throws Exception,RuntimeException;

	public String updatePm(HashMap param) throws Exception,RuntimeException;

	// 删除信息
	public String deletePm(HashMap paramObj) throws Exception,RuntimeException;

	public HashMap queryPm(HashMap paramObj) throws Exception;

	public List queryChild(HashMap param);

	public HashMap queryFun(HashMap paramMap);

	public List automaticallyGenerated(int ifuncregedit);

	public List queryFunTree();

	// 查询参照赋值公式
	public List querycfieldRelationship(int irelationship);

	public List queryTriggerbodyconsult(int iconsultConfiguration);

	// 查询参照赋值公式
	public List queryRelationship(HashMap param);
	
	public HashMap formula(HashMap funMap);
	
	//查询参照赋值公式
	public HashMap queryRelationshipByifuncregedit2(HashMap param);
	
	
	public List queryStatement(String sql);
	
	
	public List queryKnowledge();
	
	public List queryKnowledgeByCModer(HashMap param);
	
	
	public void updateSql(String sql);

    public void addinvoiceuser(HashMap param);

    public int addSql(HashMap param);


    boolean updateStatus(HashMap hm) throws Exception;

    boolean updateListStatus(List<HashMap> list) throws Exception;

    HashMap getStatus(HashMap hm) throws Exception;

}

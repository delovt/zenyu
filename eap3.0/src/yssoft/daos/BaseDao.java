/**    
 * 文件名：BaseDao.java    
 *    
 * 版本信息：    
 * 日期：2011-8-2    
 * Copyright 足下 Corporation 2011     
 * 版权所有    
 *    
 */
package yssoft.daos;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.engine.impl.SqlMapClientImpl;
import com.ibatis.sqlmap.engine.mapping.sql.Sql;
import com.ibatis.sqlmap.engine.mapping.statement.MappedStatement;
import com.ibatis.sqlmap.engine.scope.SessionScope;
import com.ibatis.sqlmap.engine.scope.StatementScope;
import flex.messaging.FlexContext;
import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import yssoft.utils.ToolUtil;
import yssoft.vos.HrPersonVo;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 * 
 * 项目名称：yscrm 类名称：BaseDao 类描述： 创建人：zmm 创建时间：2011-8-2 下午05:15:32 修改人：zmm
 * 修改时间：2011-8-2 下午05:15:32 修改备注：
 * 
 * @version
 * 
 */
public class BaseDao extends SqlMapClientDaoSupport implements
		java.io.Serializable {
	/**
	 * 
	 * @auth: zmm
	 * @date： 2011 2011-8-2 下午08:44:44
	 * @return: SqlMapClientTemplate
	 */
	public SqlMapClientTemplate getSqlTemplate() {
		return this.getSqlMapClientTemplate();
	}

	/**
	 * @auth: zmm
	 * @date： 2011 2011-8-2 下午08:44:55
	 * @return: SqlMapClient
	 */
	public SqlMapClient getSqlClient() {
		return this.getSqlMapClient();
	}

	/**
	 * 
	 * 
	 * @auth: zmm
	 * @date： 2011 2011-8-2 下午08:44:10
	 * @param: name
	 * @return: List
	 */
	public List queryForList(String id) {
		return this.getSqlMapClientTemplate().queryForList(id);
	}

	/**
	 * 
	 * @auth: zmm
	 * @date： 2011 2011-8-2 下午08:41:16
	 * @param: id
	 * @param： params
	 * @return: List
	 */
	@SuppressWarnings("unchecked")
	public List queryForList(String id, Object params) {
		return this.getSqlMapClientTemplate().queryForList(id, params);
	}

	/**
	 * 
	 * 
	 * @auth: zmm
	 * @date： 2011 2011-8-2 下午08:43:34
	 * @param: id
	 * @return: Object
	 */
	public Object queryForObject(String id) {
		return this.getSqlMapClientTemplate().queryForObject(id);
	}

	/**
	 * @auth: zmm
	 * @date： 2011 2011-8-2 下午08:43:34
	 * @param: id
	 * @return: Object
	 */
	public Object queryForObject(String id, Object params) {
		return this.getSqlMapClientTemplate().queryForObject(id, params);
	}

	/**
	 * @auth: zmm
	 * @date： 2011 2011-8-2 下午08:46:22
	 * @param:
	 * @return: int
	 */
	public int update(String id) {
		return this.getSqlMapClientTemplate().update(id);
	}

	/**
	 * @auth: zmm
	 * @date： 2011 2011-8-2 下午08:45:56
	 * @param: id
	 * @param: params
	 * @return: int
	 */
	public int update(String id, Object params) {
		return this.getSqlMapClientTemplate().update(id, params);
	}

	/**
	 * @auth: zmm
	 * @date： 2011 2011-8-2 下午08:46:34
	 * @param:
	 * @return: Object
	 */
	public Object insert(String id) {
		return this.getSqlMapClientTemplate().insert(id);
	}

	/**
	 * @auth: zmm
	 * @date： 2011 2011-8-2 下午08:46:27
	 * @param:
	 * @return: Object
	 */
	public Object insert(String id, Object params) {
		return this.getSqlMapClientTemplate().insert(id, params);
	}

	/**
	 * @auth: zmm
	 * @date： 2011 2011-8-2 下午08:47:02
	 * @param:
	 * @return: int
	 */
	public int delete(String id) {
		return this.getSqlMapClientTemplate().delete(id);
	}

	/**
	 * @auth: zmm
	 * @date： 2011 2011-8-2 下午08:46:39
	 * @param:
	 * @return: int
	 */
	public int delete(String id, Object params) {
		return this.getSqlMapClientTemplate().delete(id, params);
	}

	/**
	 * addLog 添加日志 创建者：zmm 创建时间：2011-2011-8-21 上午09:54:17 修改者：lovecd
	 * 修改时间：2011-2011-8-21 上午09:54:17 修改备注：
	 * 
	 * @param cnode
	 *            业务节点
	 * @param cfunction
	 *            操作功能
	 * @param cresult
	 *            操作结果
	 * @param iinvoice
	 *            单据id
	 * @return void
	 * @Exception 异常对象
	 */
	public void addLog(String cnode, String cfunction, String cresult,
			String iinvoice, String cplace) {
		HashMap params = new HashMap();
		HrPersonVo hrperson = (HrPersonVo) this
				.getAttributeFromSession("HrPerson");
		params.put("cip", hrperson.getCip());
		params.put("cworkstation", hrperson.getCworkstation());
		params.put("iperson", hrperson.getIid());
		params.put("doperate", ToolUtil.formatDay(new Date(), null));
		params.put("cnode", cnode);
		params.put("cfunction", cfunction);
		params.put("cresult", cresult);
		params.put("iinvoice", iinvoice);
		params.put("cplace", cplace);
		this.insert("system.addlog", params);
	}

	/**
	 * getAttributeFromSession(获取sesstion) 创建者：zmm 创建时间：2011-2011-8-21
	 * 上午10:05:57 修改者：zmm 修改时间：2011-2011-8-21 上午10:05:57 修改备注：
	 * 
	 * @param key
	 *            键 唯一标识
	 * @return Object
	 * @Exception 异常对象
	 */
	public Object getAttributeFromSession(String key) {
		return FlexContext.getFlexSession().getAttribute(key);
	}

	/**
	 * setAttributeToSession(设置session) 创建者：lovecd 创建时间：2011-2011-8-21
	 * 上午10:06:27 修改者：zmm 修改时间：2011-2011-8-21 上午10:06:27 修改备注：
	 * 
	 * @param key
	 *            键 唯一标识
	 * @param value
	 *            值
	 * @return void
	 * @Exception 异常对象
	 * 
	 */
	public void setAttributeToSession(String key, Object value) {
		FlexContext.getFlexSession().setAttribute(key, value);
	}

	// 获取 元数据 信息
	public List ShowFieldType(String sql) throws Exception {
		DataSource dataSource = this.getSqlClient().getDataSource();
		Connection con = dataSource.getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		List<HashMap> listmap=new ArrayList<HashMap>();
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(sql);
			ResultSetMetaData rsMetaData = rs.getMetaData();
			int columnCount = rsMetaData.getColumnCount();
			for (int i = 1; i <= columnCount; i++) {
				HashMap<String, Object> map=new HashMap<String, Object>();
				map.put("fieldname", rsMetaData.getColumnName(i));
				map.put("fieldtype", rsMetaData.getColumnTypeName(i));
				map.put("fieldsize", rsMetaData.getColumnDisplaySize(i));
				map.put("fieldtype", rsMetaData.getColumnTypeName(i));
				map.put("tablename", rsMetaData.getTableName(i));
				logger.info("field Name:[" + rsMetaData.getColumnName(i)
						+ "] field Type:[" + rsMetaData.getColumnTypeName(i)
						+ "] size:[" + rsMetaData.getColumnDisplaySize(i)
						+ "] tablename:["+rsMetaData.getTableName(i)
						+"] catalog:["+rsMetaData.getCatalogName(i)+"]");
				listmap.add(map);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			rs.close();
			stmt.close();
			con.close();
			return listmap;
		}
	}
	
	/**
	 * 获取SQL
	 * ibatais根据sqlMap的Id获取sql语句
	 * @param sqlId 是xml文件配置的ID
	 * @return sql语句  以“$”注入的会自动转换，“#”不会
	 */
	public String getSql(String sqlId,Object params){
		SqlMapClientImpl sqlclientImpl = (SqlMapClientImpl) this.getSqlClient();
		String sqlStr = "";
		/**获取隐身对象*/
		MappedStatement stmt = sqlclientImpl.getMappedStatement(sqlId); 
		Sql sql = stmt.getSql();
		/**获取规则*/
		SessionScope sessionScope = new SessionScope();   
		sessionScope.incrementRequestStackDepth();   
		StatementScope statementScope = new StatementScope(sessionScope);   
		stmt.initRequest(statementScope);   
		/**获取sql映射对象*/
		sqlStr = sql.getSql(statementScope, params);
		
		logger.info("sqlMap:"+sqlId);
		logger.info("sql:"+sqlStr);
		
		return sqlStr;
	}

}

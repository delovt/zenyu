package yssoft.utils;

import com.ibatis.sqlmap.engine.impl.SqlMapClientImpl;
import com.ibatis.sqlmap.engine.mapping.sql.Sql;
import com.ibatis.sqlmap.engine.mapping.statement.MappedStatement;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import yssoft.daos.BaseDao;

import java.util.ArrayList;
import java.util.List;

/**
 * SQL分页工具类
 * @author SDY
 *
 */
public class SQLPageUtil extends SqlMapClientDaoSupport {
	
	BaseDao baseDao =BeanFactoryUtil.getBean(BaseDao.class);
	
	public String getIbaitsSqlById(String id)
	{
		String sql = null;
		SqlMapClientImpl sqlmap = (SqlMapClientImpl)this.getSqlMapClient();
		//SqlMapExecutorDelegate delegate = sqlmap.getDelegate();  
		MappedStatement stmt = sqlmap.getMappedStatement(id);
		Sql sqll = (Sql)stmt.getSql();
		sql = sqll.getSql(null,null);
		return sql;
	}
	
	
	//获取拼接后分页
	@SuppressWarnings({ "unchecked", "unused" })
	private List mergePageSqlAndQuery(String sql,int pageSize,int currPageCount)
	{
		String majorkey = "iid";
		String sqlson = "";
		
		if(sql.indexOf("where") != -1){
			String[] sqlArr = sql.split("where");
			sqlson	= sql;
			sqlArr[0] += " where "+ majorkey +" not in ( ";
			sqlson.replace(pageSize+"", showSonPageSize(pageSize,currPageCount) );
			sql += sqlson + " ) " + sqlArr[1];
		}else{
			sqlson	= sql;
			sql += " where "+ majorkey +" not in ( ";
			sqlson.replace(pageSize+"", showSonPageSize(pageSize,currPageCount) );
			sql += sqlson +" ) ";
		}
		return baseDao.queryForList("select_page_sql",sql);
	}
	
	//获取子查询过滤数
	private String showSonPageSize(int pageSize,int currPageCount)
	{
		int count = pageSize * ( (currPageCount +1) -1);
		return count+"";
	}
	
	
	public static void main(String[] args) {
		
		List list = new ArrayList();
		list.add("A");list.add("B");list.add("C");list.add("D");list.add("E");list.add("F");list.add("G");list.add("O");
		
		
		try {
			for(Object obj:list){
				
				System.out.println(obj+"=========");
				for(Object o : list){
					
					if(o.equals("C") || o.equals("E")){
						list.remove(o);
					}
					
					System.out.println(o+"");
				}
			}
		} catch (Exception e) {
		}
		
		
	}
	
	
}

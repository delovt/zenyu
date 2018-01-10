/**
 * 系统初始化，公共参数加载，参照加载等
 * 
 * @author zmm
 * 
 */
package yssoft.env;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.InitializingBean;
import yssoft.cache.Cache;
import yssoft.cache.CacheManager;

import java.io.Serializable;
import java.util.HashMap;

public class InitEnv implements InitializingBean {
	

	@Override
	public void afterPropertiesSet() throws Exception {
		// TODO Auto-generated method stub
//		Assert.notNull(testDao);
//		Assert.notNull(cacheManager);
//		List testQuerey = this.testDao.testQuerey();
//		List<HashMap<Object, Object>> testDAOList=testQuerey;
//		HashMap<String, ArrayList<HashMap<Object, Object>>> result = new HashMap<String, ArrayList<HashMap<Object, Object>>>();
//		result.put("test", (ArrayList<HashMap<Object, Object>>) testDAOList);
//		cacheManager.getCache(SysConstant.YSCRM_CACHE).put(SysConstant.YSCRM_CACHE,result);
	}
	
	
	private Logger log = Logger.getLogger(this.getClass());
//	private TestDao testDao;
	
	/**
	 * @author zmm
	 * @param testDAO
	 */
//	public void setTestDao(TestDao testDAO){
//		this.testDao=testDAO;
//	}
	/**
	 * @author zmm
	 * @description 缓存管理类
	 */
	
	public static CacheManager<Cache<String, HashMap<? extends Serializable, ? extends Serializable>>> cacheManager;
	/**
	 * @author zmm
	 * @param cacheManager
	 */
	public void setCacheManager(CacheManager<Cache<String, HashMap<? extends Serializable, ? extends Serializable>>> cacheManager) {
		InitEnv.cacheManager = cacheManager;
	}

}

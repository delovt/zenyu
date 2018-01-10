package yssoft.cache.ehcache;

import net.sf.ehcache.Cache;
import yssoft.cache.CacheManager;
import yssoft.cache.CacheManagerFactory;

import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Ehcache实现的CacheManager
 * @author ndq
 */
public class EhcacheCacheManager extends CacheManagerFactory.Configuration
                                 implements CacheManager<EhcacheCache> {
	
	private net.sf.ehcache.CacheManager cacheManager;
	/**
	 * 存放已经创建的Ehcache的实例
	 */
	private Map<String, EhcacheCache> cacheMap;
	
	public EhcacheCacheManager(net.sf.ehcache.CacheManager cacheManager) {
		this.cacheManager = cacheManager;
		cacheMap = new ConcurrentHashMap<String, EhcacheCache>();
		setCacheManager(this);//对此可以通过Spring实现注入进来
	}

	@Override
	public EhcacheCache getCache(String cacheName) {
		EhcacheCache cache = cacheMap.get(cacheName);
		if(cache == null) {
			Cache c = cacheManager.getCache(cacheName);
			cache = new EhcacheCache(c, this);
			cacheMap.put(cacheName, cache);
		}
		return cache;
	}
	
	/**
	 * 销毁对已创建的Cache的引用。
	 * @param cache
	 */
	void destroyCache(EhcacheCache cache) {
		if(cacheMap.containsValue(cache)) {
			Iterator<String> keyItr = cacheMap.keySet().iterator();
			EhcacheCache tmpCache = null;
			while(keyItr.hasNext()) {
				tmpCache = cacheMap.get(keyItr.next());
				if(tmpCache.equals(cache)) {
					keyItr.remove();
				}
			}
		}
	}

	@Override
	public EhcacheCache refreshCache(String cacheName, String configInfo) {
		return null;
	}
}

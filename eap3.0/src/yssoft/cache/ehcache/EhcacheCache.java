package yssoft.cache.ehcache;

import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;
import org.apache.log4j.Logger;
import yssoft.cache.Cache;

import java.io.Serializable;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

/**
 * Ehcache的Cache实现类
 * 
 * @author
 */
public class EhcacheCache implements Cache<Serializable, Serializable> {
	
	private Ehcache ehcache; 
	private EhcacheCacheManager cacheManager;
	
	private Logger logger = Logger.getLogger(EhcacheCache.class);
	
	public EhcacheCache(Ehcache ehcache, EhcacheCacheManager cacheManager) {
		this.ehcache = ehcache;
		this.cacheManager = cacheManager;
	}

	@Override
	public boolean clear() {
		ehcache.removeAll();
		return true;
	}

	@Override
	public boolean containsKey(Serializable key) {
		return ehcache.isKeyInCache(key);
	}

	@Override
	public void destroy() {
		ehcache.dispose();
		cacheManager.destroyCache(this);
	}

	@Override
	public Serializable get(Serializable key) {
		Element ele = ehcache.get(key);
		if(ele != null) {
			return ele.getValue();
		} else {
			logger.info("未找到{}对象的缓存对象。");
			return null;
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public Set<Serializable> keySet() {
		return new HashSet<Serializable>(ehcache.getKeys());
	}

	@Override
	public Serializable put(Serializable key, Serializable value) {
		Element old = ehcache.get(key);
		Element ele = new Element(key, value);
		ehcache.put(ele);
		return old;
	}

	@Override
	public Serializable remove(Serializable key) {
		Element ele = ehcache.get(key);
		if(ele == null) {
			return null;
		} else {
			ehcache.remove(key);
			return ele.getValue();
		}
	}

	@Override
	public int size() {
		return ehcache.getSize();
	}

	@SuppressWarnings("unchecked")
	@Override
	public Collection<Serializable> values() {
		/***/
		return null;
//		Map<Serializable, Serializable> allCaches = ehcache.getAllWithLoader(ehcache.getKeys(), null);
//		return allCaches.values();
	}
}

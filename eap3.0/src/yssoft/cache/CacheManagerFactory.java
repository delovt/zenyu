package yssoft.cache;

/**
 * CacheManager的工厂类
 * 
 * @author ndq
 */
public class CacheManagerFactory {

	@SuppressWarnings("unchecked")
	private static CacheManager cacheManager;

	@SuppressWarnings("unchecked")
	public static CacheManager getCacheManager() {
		if (cacheManager == null) {
			throw new RuntimeException(
					"未初始化cacheManager。请通过实现CacheManagerFactory.Configuration类来实现对CacheManager进行实例化的方法。");
		}
		return cacheManager;
	}

	/**
	 * CacheManagerFactory的配置类，用于配置CacheManager的实例
	 * 
	 * 
	 */
	public static class Configuration {
		@SuppressWarnings("unchecked")
		protected void setCacheManager(CacheManager cacheManager) {
			if (cacheManager == null) {
				throw new RuntimeException("不能使用null来初始化CacheManager。");
			}
			if (CacheManagerFactory.cacheManager == null) {
				CacheManagerFactory.cacheManager = cacheManager;
			} else {

			}
		}
	}
}
